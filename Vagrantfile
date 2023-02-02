Vagrant.configure("2") do |config|
  config.vm.box = 'andeman/opnsense'
  config.vm.box_version = "23.1.6"
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

  $auto_update_script = <<-'SCRIPT'
    # get opnsense versions
    version_local=$(opnsense-version -v)
    version_remote=$(configctl firmware remote | grep -e "^opnsense||" | awk -F '\\|\\|\\|' '{ print $2 }')

    # Auto Patching
    # patch haproxy for OPNsense version 21.7.4
    # See: https://github.com/opnsense/plugins/issues/2616
    if [ "$version_local" = "21.7.4" ]; then
      configctl firmware install os-haproxy
      sleep 10
      opnsense-patch -c plugins 31b82cd 18cd9f6
    fi

    # auto-update to latest minor version
    echo "installed version: $version_local"
    echo "remote version: $version_remote"
    if [ "$version_local" != "$version_remote" ]; then
      echo "New opnsense version ${version_remote} is available."
      echo "Updating..."
      configctl firmware flush
      configctl firmware update
      sleep 1
      timeout 4m tail -f /tmp/pkg_upgrade.progress
      exit 0
    fi
  SCRIPT

  config.vm.provision 'shell', inline: $auto_update_script


end
