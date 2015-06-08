```ruby
Vagrant.configure(2) do |config|
	# 仮想環境のもとになるBoxの情報 - https://atlas.hashicorp.com/search
	config.vm.box = "centos65"
	config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box"
	# 仮想環境のホスト名
	config.vm.hostname = "vagranthost"
	# ポートのフォワード設定
	config.vm.network "forwarded_port", guest: 80, host: 8080
	# プライベートネットワークの設定
	config.vm.network "private_network", ip: "192.168.33.10"
	# パブリックネットワークの設定
	config.vm.network "public_network"
	# provider 設定
	config.vm.provider "virtualbox" do |v|
		v.name = "VM名"
		v.cpus = 2 # CPU数
		v.memory = 1024 # メモリサイズ
		# VBoxManage list ostypes
		v.customize ["modifyvm", :id, "--ostype", "RedHat_64"] # Ubuntu/Ubuntu_64/RedHat/RedHat_64
	end
	# provisioner - http://docs.vagrantup.com/v2/provisioning/index.html
	config.vm.provision "docker" do |p|
		d.run "ubuntu",
			cmd: "bash -l",
			args: "-v '/vagrant:/var/www'"
	end
	config.vm.provision "ansible" do |ansible|
		ansible.playbook = "playbook.yml"
	end
	# vagrant omnibus
	# config.omnibus.chef_version = :latest
	# synced folder
	config.vm.synced_folder "src/", "/srv/website"
end
```
