Facter.add(:opnsense) do
  confine kernel: 'FreeBSD'
  setcode do
    opnsense_version = Facter::Util::Resolution.which('opnsense-version')
    if opnsense_version.nil?
      next nil
    end

    facts = {}
    opn_ver = Facter::Util::Resolution.exec("#{opnsense_version} -NAVvfH")
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

    pluginctl = Facter::Util::Resolution.which('pluginctl')
    if pluginctl
      opn_plugins = Facter::Util::Resolution.exec("#{pluginctl} -g system.firmware.plugins")
      facts['plugins'] = opn_plugins.split(',').map(&:chomp) if opn_plugins
    end

    facts
  end
end
