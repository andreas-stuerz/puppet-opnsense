Vagrant.configure("2") do |config|
  config.vm.box = 'andeman/opnsense'
  config.vm.boot_timeout = 600

  # sepecial configurations for bsd shell / opnsense stuff
  config.ssh.sudo_command = "%c"
  config.ssh.shell = "/bin/sh"
  config.ssh.password = "opnsense"
  config.ssh.username = "root"

  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |v|

    v.memory = 2048
    v.cpus = 2
    v.customize ['modifyvm',:id, '--nic1', 'intnet', '--nic2', 'nat']
    v.customize ['modifyvm', :id, '--natpf2', "ssh,tcp,127.0.0.1,3333,,22" ]
    v.customize ['modifyvm', :id, '--natpf2', "https,tcp,,10443,,443" ]
  end
end
