#!/usr/bin/env python
# coding: utf-8

import signal, os, sys, re
import socket
from optparse import OptionParser

class DNSQuery:
    def __init__(self, data):
        self.data=data
        self.dominio=''

        tipo = (ord(data[2]) >> 3) & 15   # Opcode bits
        if tipo == 0:                     # Standard query
            ini=12
            lon=ord(data[ini])
            while lon != 0:
                self.dominio+=data[ini+1:ini+lon+1]+'.'
                ini+=lon+1
                lon=ord(data[ini])

    def respuesta(self, ip):
        packet=''
        if self.dominio:
            packet+=self.data[:2] + "\x81\x80"
            packet+=self.data[4:6] + self.data[4:6] + '\x00\x00\x00\x00'   # Questions and Answers Counts
            packet+=self.data[12:]                                         # Original Domain Name Question
            packet+='\xc0\x0c'                                             # Pointer to domain name
            packet+='\x00\x01\x00\x01\x00\x00\x00\x3c\x00\x04'             # Response type, ttl and resource data length -> 4 bytes
            packet+=str.join('',map(lambda x: chr(int(x)), ip.split('.'))) # 4bytes of IP
        return packet

class DNSResolverMaker:
    def __init__(self, domains, port):
        self.is_mac = (os.name == "posix" and re.match(r"^Darwin", os.uname()[3]))
        self.domains = domains
        self.port = port
        self.registered = False

    def register(self):
        if not self.is_mac:
            return False

        port = self.port
        for domain in self.domains:
            fp = open("/etc/resolver/" + domain, "w")
            fp.write("nameserver 127.0.0.1\n")
            fp.write("port %d\n" % port)
            fp.close()
        self.registered = True
        return True

    def release(self):
        if not self.registered:
            return False
        for domain in self.domains:
            fpath = "/etc/resolver/" + domain
            if os.path.isfile(fpath):
                os.remove(fpath)
        self.registered = False


class DNSQueryUtil:
    @classmethod
    def find_free_port(cls, addr):
        serversock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        serversock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        serversock.bind((addr,0))
        address, port = serversock.getsockname()
        serversock.close()
        return port

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-i", "--ip", dest="ip", help="response ip addr")
    parser.add_option("-p", "--port", dest="port", help="dns port")

    listen_ip = '0.0.0.0'

    (options, argv) = parser.parse_args()
    ip = options.ip
    port = options.port
    if not ip:
        ip = "127.0.0.1"
    if not port:
        port = DNSQueryUtil.find_free_port(listen_ip)
    else:
        port = int(options.port)

    argc = len(argv)
    handler = None

    if argc > 0:
        handler = DNSResolverMaker(argv, port)
        handler.register()
        signal.signal(signal.SIGTERM, handler.release)
    print 'dns.py:: dom.query. 60 IN A %s' % ip

    udps = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    udps.bind((listen_ip, port))

    try:
        while 1:
            data, addr = udps.recvfrom(1024)
            p=DNSQuery(data)
            udps.sendto(p.respuesta(ip), addr)
            print 'Respuesta: %s -> %s' % (p.dominio, ip)
    except KeyboardInterrupt:
        print 'Finalizando'
        udps.close()
    finally:
        if handler:
            handler.release()

