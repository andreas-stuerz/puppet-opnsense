# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))


# Implementation for the opnsense_nodeexporter_config type using the Resource API.
class Puppet::Provider::OpnsenseNodeexporterConfig::OpnsenseNodeexporterConfig < Puppet::Provider::OpnsenseProvider
  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _get_nodeexporter_config_from_devices(device_names)
  end

  # @param [Array<String>] devices
  # @return [Hash<Symbol>]
  def _get_nodeexporter_config_from_devices(devices)
    result = []
    devices.each do |device|
      nodeexporter_config = _nodeexporter_config_object(device)
      result.push({
          title: device,
          enabled: bool_from_value(nodeexporter_config['enabled']),
          listen_address: nodeexporter_config['listenaddress'],
          listen_port: nodeexporter_config['listenport'],
          cpu: bool_from_value(nodeexporter_config['cpu']),
          exec: bool_from_value(nodeexporter_config['exec']),
          filesystem: bool_from_value(nodeexporter_config['filesystem']),
          loadavg: bool_from_value(nodeexporter_config['loadavg']),
          meminfo: bool_from_value(nodeexporter_config['meminfo']),
          netdev: bool_from_value(nodeexporter_config['netdev']),
          time: bool_from_value(nodeexporter_config['time']),
          devstat: bool_from_value(nodeexporter_config['devstat']),
          interrupts: bool_from_value(nodeexporter_config['interrupts']),
          ntp: bool_from_value(nodeexporter_config['ntp']),
          zfs: bool_from_value(nodeexporter_config['zfs']),
          ensure: 'present',
          device: device,
        }
      )
    end
    result
  end

  # @param [String] device_name
  # @return [Hash<String>]
  def _nodeexporter_config_object(device_name)
    json_output = opn_cli_base_cmd(device_name, ['nodeexporter', 'config', 'show', '-o', 'json'])
    JSON.parse(json_output)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def create(_context, _name, should)
    _nodeexporter_config_install(should[:device].to_s, should[:name].to_s)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] _name
  # @param [Hash<Symbol>] should
  # @return [Puppet::Util::Execution::ProcessOutput]
  def update(_context, _name, should)
    _nodeexporter_config_install(should[:device].to_s, should[:name].to_s)
  end

  # @param [String] device_name
  # @param [String] nodeexporter_config_name
  # @return [Puppet::Util::Execution::ProcessOutput]
  def _nodeexporter_config_install(device_name, nodeexporter_config_name)
    opn_cli_base_cmd(device_name, ['nodeexporter', 'config', 'install', nodeexporter_config_name.to_s, '-o', 'json'])
  end
end
