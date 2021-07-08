# frozen_string_literal: true

require_relative '../opnsense_provider'

# Implementation for the opnsense_plugin type using the Resource API.
class Puppet::Provider::OpnsensePlugin::OpnsensePlugin < Puppet::Provider::OpnsenseProvider
  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _get_plugins_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Array<Hash<Symbol>>]
  def _get_plugins_from_devices(devices)
    result = []
    devices.each do |device|
      plugins = _plugin_list(device)
      plugins.each do |plugin|
        result.push(
            title: plugin + '@' + device,
            ensure: 'present',
            name: plugin,
            device: device,
          )
      end
    end
    result
  end

  # @param [String] device_name
  # @return [Array<String>]
  def _plugin_list(device_name)
    result = opn_cli_base_cmd(device_name, ['plugin', 'installed', '-c', 'name'])
    result.split("\n")
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    _plugin_install(should[:device].to_s, should[:name].to_s)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, _name, should)
    _plugin_install(should[:device].to_s, should[:name].to_s)
  end

  # @param [String] device_name
  # @param [String] plugin_name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def _plugin_install(device_name, plugin_name)
    opn_cli_base_cmd(device_name, ['plugin', 'install', plugin_name.to_s])
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def delete(_context, name)
    plugin_name = name.fetch(:name).to_s
    device = name.fetch(:device).to_s
    _plugin_uninstall(device, plugin_name)
  end

  # @param [String] device_name
  # @param [String] plugin_name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def _plugin_uninstall(device_name, plugin_name)
    opn_cli_base_cmd(device_name, ['plugin', 'uninstall', plugin_name.to_s])
  end

  private :_get_plugins_from_devices, :_plugin_list, :_plugin_install, :_plugin_uninstall
end
