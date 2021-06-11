require 'puppet/resource_api/simple_provider'
require 'fileutils'

# A base provider for all opnsense providers
class Puppet::Provider::OpnsenseProvider < Puppet::ResourceApi::SimpleProvider
  def initialize
    @config_basedir = '~/.puppet-opnsense'
    @config_suffix = '-config.yaml'
    super
  end

  def get_configured_devices
    devices = []
    Dir.glob(get_config_glob_pattern).each do |path|
      device_name = File.basename(path).gsub(%r{#{get_suffix}$}, '')
      devices.push(device_name)
    end
    devices
  end

  def opn_cli_base_cmd(device_name, *args)
    config_path = get_config_path(device_name)
    args.unshift(
        'opn-cli',
        '-c',
        config_path,
      )
    Puppet::Util::Execution.execute(args, failonfail: true, custom_environment: { 'LC_ALL' => 'en_US.utf8' })
  end

  private

  def get_config_path(device_name)
    File.join(get_config_basedir.to_s, "#{File.basename(device_name)}#{get_suffix}")
  end

  def get_config_glob_pattern
    "#{get_config_basedir}/*#{get_suffix}"
  end

  def get_config_basedir
    File.expand_path(@config_basedir)
  end

  def get_suffix
    @config_suffix
  end
end
