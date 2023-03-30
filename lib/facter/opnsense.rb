Facter.add(:opnsense) do
  confine kernel: 'FreeBSD'
  setcode do
    opnsense_version = Facter::Core::Execution.which('opnsense-version')
    if opnsense_version.nil?
      next
    end

    facts = {}
    opn_ver = Facter::Core::Execution.exec("#{opnsense_version} -NAVvfH")
    if opn_ver
      facts['name'] = opn_ver.split(' ')[0]
      facts['architecture'] = opn_ver.split(' ')[1]
      release = {}
      release['major'] = opn_ver.split(' ')[2]
      release['full'] = opn_ver.split(' ')[3]
      release['minor'] = opn_ver.split(' ')[3].split('.')[2]
      release['flavour'] = opn_ver.split(' ')[4]
      release['hash'] = opn_ver.split(' ')[5]
      facts['release'] = release if release
    end

    pluginctl = Facter::Core::Execution.which('pluginctl')
    if pluginctl
      opn_plugins = Facter::Core::Execution.exec("#{pluginctl} -g system.firmware.plugins")
      facts['plugins'] = opn_plugins.split(',').map(&:chomp) if opn_plugins
    end

    facts
  end
end
