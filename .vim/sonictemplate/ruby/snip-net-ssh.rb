require 'net/ssh'
require 'net/scp'

host = 'localhost'
username = ENV[:USER]
ssh_attr = {
  # :port => 22,
  # :password => "",
  # :keys => ['~/.ssh/id_rsa'],
  # :passpharase => "",
}

Net::SSH.start(host, username, ssh_attr) do |ssh|
  ssh.exec!("echo hello")
  # ssh.scp.download! "/local/path", "/remote/path"
  # ssh.scp.upload! "/local/path", "/remote/path"
  # scp.upload! StringIO.new("some data to upload"), "/remote/path"

  # d1 = scp.download("/remote/path", "/local/path")
  # d2 = scp.download("/remote/path2", "/local/path2")
  # [d1, d2].each { |d| d.wait }
end
