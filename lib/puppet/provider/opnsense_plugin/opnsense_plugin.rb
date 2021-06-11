# frozen_string_literal: true

require_relative '../opnsense_provider'

# Implementation for the opnsense_plugin type using the Resource API.
class Puppet::Provider::OpnsensePlugin::OpnsensePlugin < Puppet::Provider::OpnsenseProvider
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    get_plugins_from_devices(device_names)
  end

  def get_device_names_by_filter(filter)
    filter.empty? ? get_configured_devices : filter.map { |item| item[:device] }.compact.uniq
  end

  def get_plugins_from_devices(devices)
    result = []
    devices.each do |device|
      plugins = plugin_list(device)
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

  def plugin_list(device_name)
    result = opn_cli_base_cmd(device_name, ['plugin', 'installed', '-c', 'name'])
    result.split("\n")
  end

  def create(_context, _name, should)
    plugin_install(should[:device].to_s, should[:name].to_s)
  end

  def plugin_install(device_name, plugin_name)
    opn_cli_base_cmd(device_name, ['plugin', 'install', plugin_name.to_s])
  end

  def update(_context, _name, should)
    plugin_install(should[:device].to_s, should[:name].to_s)
  end

  def delete(_context, name)
    plugin_name = name.fetch(:name).to_s
    device = name.fetch(:device).to_s
    plugin_uninstall(device, plugin_name)
  end

  def plugin_uninstall(device_name, plugin_name)
    opn_cli_base_cmd(device_name, ['plugin', 'uninstall', plugin_name.to_s])
  end
end
