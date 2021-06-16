Vagrant.configure("2") do |config|
  config.vm.box = 'andeman/opnsense'
  config.vm.boot_timeout = 600

  # sepecial configurations for bsd shell / opnsense stuff
  config.ssh.sudo_command = "%c"
  config.ssh.shell = "/bin/sh"
  config.ssh.username = "root"
  config.ssh.password = "opnsense"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.network :forwarded_port, guest: 22, host: 3333, id: "ssh"
  config.vm.network :forwarded_port, guest: 443, host: 10443, auto_correct: true

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2

    v.customize ['modifyvm',:id, '--nic1', 'nat', '--nic2', 'intnet']
  end
end
