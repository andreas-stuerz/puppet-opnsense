require 'puppet/resource_api/simple_provider'
require 'fileutils'

# A base provider for all opnsense providers
class Puppet::Provider::OpnsenseProvider < Puppet::ResourceApi::SimpleProvider
  def initialize
    @config_basedir = '~/.puppet-opnsense'
    @config_suffix = '-config.yaml'
    super
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

  def get_config_path(device_name)
    File.join(get_config_basedir.to_s, "#{File.basename(device_name)}#{_get_suffix}")
  end

  def get_configured_devices
    devices = []
    Dir.glob(_get_config_glob_pattern).each do |path|
      device_name = File.basename(path).gsub(%r{#{_get_suffix}$}, '')
      devices.push(device_name)
    end
    devices
  end

  def _get_config_glob_pattern
    "#{get_config_basedir}/*#{_get_suffix}"
  end

  def _get_suffix
    @config_suffix
  end

  def get_config_basedir
    File.expand_path(@config_basedir)
  end

  def bool_from_value(value)
    case value
    when true, 'true', 1, '1' then
      true
    when false, 'false', nil, '', 0, '0' then
      false
    else
      raise ArgumentError, "invalid value for Boolean(): \"#{value.inspect}\""
    end
  end

  def get_device_names_by_filter(filter)
    filter.empty? ? get_configured_devices : filter.map { |item| item[:device] }.compact.uniq
  end

  def get_names_by_filter(filter)
    filter.empty? ? [] : filter.map { |item| item[:name] }.compact.uniq
  end

  private :_get_config_glob_pattern, :get_config_basedir, :_get_suffix
end
