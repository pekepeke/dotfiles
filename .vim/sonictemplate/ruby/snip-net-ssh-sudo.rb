requre 'net/ssh'

class Net::SSH::Connection::Session
  def sudo(password, cmd)
    stdout = ""
    stderr = ""

    ch = self.open_channel do |channel|
      channel.request_pty

      channel.exec("sudo -S #{cmd}");

      channel.on_close do
        #puts "shell terminated"
      end
      channel.on_eof do |ch|
        #puts "remote end is done sending data"
      end
      channel.on_extended_data do |ch, type, data|
        stderr << data
        #puts "got stderr: #{data.inspect}"
      end
      channel.on_data do |channel, data|
        if data =~ /^\[sudo\] password for USER:/i
          # puts "data works"
          channel.send_data password + "\n"
        else
          #puts "OUTPUT NOT MATCHED: #{data}"
          stdout << data
        end
      end
      channel.on_process do |ch|
      end
      self.loop
    end
    ch.wait

    stdout + stderr
  end
end
