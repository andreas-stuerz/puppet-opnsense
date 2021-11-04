require 'puppet/resource_api/simple_provider'
require 'fileutils'
require 'json'

# A base provider for all opnsense providers
class Puppet::Provider::OpnsenseProvider < Puppet::ResourceApi::SimpleProvider
  # writer for testing
  attr_writer :resource_list

  # @return [void]
  def initialize
    super
    @config_basedir = '~/.puppet-opnsense'
    @config_suffix = '-config.yaml'
    @resource_list = []
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _fetch_resource_list(device_names)
  end

  # @param [Array<Hash<Symbol>>] filter
  # @return [Array]
  def get_device_names_by_filter(filter)
    if filter.is_a?(Array)
      device_names = filter.map { |item|
        item[:device] if item.is_a?(Hash) && item.include?(:device)
      }.compact.uniq
    end

    if device_names.empty?
      device_names = get_configured_devices
    end

    device_names
  end

  # @return [Array]
  def get_configured_devices
    devices = []
    Dir.glob(_get_config_glob_pattern).each do |path|
      device_name = File.basename(path).gsub(%r{#{_get_suffix}$}, '')
      devices.push(device_name)
    end
    devices
  end

  # @return [String]
  def _get_config_glob_pattern
    "#{get_config_basedir}/*#{_get_suffix}"
  end

  # @return [String]
  def get_config_basedir
    File.expand_path(@config_basedir)
  end

  # @return [String]
  def _get_suffix
    @config_suffix
  end

  # @param [Array<String>] device_names
  # @return [void]
  def _fetch_resource_list(device_names)
    @resource_list = _get_resources_from_devices(device_names)
    @resource_list
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_resources_from_devices(devices)
    result = []
    devices.each do |device|
      json_list = get_opn_cli_json_list(device, @group, @command)
      json_list.each do |json_list_item|
        result.push(_translate_json_list_item_to_puppet_resource(device, json_list_item))
      end
    end
    result
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    args = _translate_puppet_resource_to_command_args('create', should[@create_key], should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args, '-o', 'json')
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, name, should)
    uuid = _find_uuid_by_namevars(name, @find_uuid_by_column)
    args = _translate_puppet_resource_to_command_args('update', uuid, should)
    device_name = should[:device].to_s
    opn_cli_base_cmd(device_name, args)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    uuid = _find_uuid_by_namevars(name, @find_uuid_by_column)
    device_name = name.fetch(:device).to_s
    opn_cli_base_cmd(device_name, [@group, @command, 'delete', uuid, '-o', 'json'])
  end

  # @param [hash] namevars
  # @param [String] by_column
  # @return [String] uuid
  def _find_uuid_by_namevars(namevars, by_column)
    resource_found = @resource_list.find do |resource|
      resource[:device] == namevars[:device] && resource[by_column] == namevars[by_column]
    end
    unless resource_found
      raise Puppet::ResourceError, "Could not find uuid for #{namevars}"
    end
    resource_found[:uuid]
  end

  # @param [String] device_name
  # @param [Array] args
  # @return [Puppet::Util::Execution::ProcessOutput]
  def opn_cli_base_cmd(device_name, *args)
    config_path = get_config_path(device_name)
    args.unshift(
        'opn-cli',
        '-c',
        config_path,
      )
    begin
      output = Puppet::Util::Execution.execute(
          args, failonfail: true, combine: true, custom_environment: { 'LC_ALL' => 'en_US.utf8' }
        )
      output
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, e.message.to_s
    end
  end

  # @param [String] device_name
  # @return [String]
  def get_config_path(device_name)
    File.join(get_config_basedir.to_s, "#{File.basename(device_name)}#{_get_suffix}")
  end

  # @param [String, Integer, Boolean] value
  # @return [FalseClass, TrueClass]
  def bool_from_value(value)
    case value
    when true, 'true', 1, '1' then
      true
    when false, 'false', nil, '', 0, '0' then
      false
    else
      raise ArgumentError, 'invalid value for Boolean()'
    end
  end

  # @param [String] value
  # @return [Array]
  def array_from_value(value)
    value == [] ? value : value.split(',')
  end

  # @param [Object] device_name
  # @param [Object] group
  # @param [Object] command
  # @return [Object]
  def get_opn_cli_json_list(device_name, group, command)
    json_output = opn_cli_base_cmd(device_name, [group, command, 'list', '-o', 'json'])
    JSON.parse(json_output)
  end

  #
  private :_get_config_glob_pattern, :get_config_basedir, :_get_suffix
end
