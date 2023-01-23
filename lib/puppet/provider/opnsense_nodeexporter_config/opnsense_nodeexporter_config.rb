# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

# Implementation for the opnsense_nodeexporter_config type using the Resource API.
class Puppet::Provider::OpnsenseNodeexporterConfig::OpnsenseNodeexporterConfig < Puppet::Provider::OpnsenseProvider
  # @return [void]
  def initialize
    super
    @group = 'nodeexporter'
    @command = 'config'
    @resource_type = 'single'
  end

  # @param [String] device
  # @param [Hash] json_object
  def _translate_json_object_to_puppet_resource(device, json_object)
    {
      title: device,
      enabled: bool_from_value(json_object['enabled']),
      listen_address: json_object['listenaddress'],
      listen_port: json_object['listenport'],
      cpu: bool_from_value(json_object['cpu']),
      exec: bool_from_value(json_object['exec']),
      filesystem: bool_from_value(json_object['filesystem']),
      loadavg: bool_from_value(json_object['loadavg']),
      meminfo: bool_from_value(json_object['meminfo']),
      netdev: bool_from_value(json_object['netdev']),
      time: bool_from_value(json_object['time']),
      devstat: bool_from_value(json_object['devstat']),
      interrupts: bool_from_value(json_object['interrupts']),
      ntp: bool_from_value(json_object['ntp']),
      zfs: bool_from_value(json_object['zfs']),
      ensure: 'present',
      device: device,
    }
  end

  # @param [Integer] mode
  # @param [String] id
  # @param [Hash<Symbol>] puppet_resource
  # @return [Array<String>]
  def _translate_puppet_resource_to_command_args(mode, puppet_resource)
    args = [@group, @command, mode]
    args.push('--enabled') if bool_from_value(puppet_resource[:enabled]) == true
    args.push('--no-enabled') if bool_from_value(puppet_resource[:enabled]) == false
    args.push('--listenaddress', puppet_resource[:listen_address])
    args.push('--listenport', puppet_resource[:listen_port])
    args.push('--cpu') if bool_from_value(puppet_resource[:cpu]) == true
    args.push('--no-cpu') if bool_from_value(puppet_resource[:cpu]) == false
    args.push('--exec') if bool_from_value(puppet_resource[:exec]) == true
    args.push('--no-exec') if bool_from_value(puppet_resource[:exec]) == false
    args.push('--filesystem') if bool_from_value(puppet_resource[:filesystem]) == true
    args.push('--no-filesystem') if bool_from_value(puppet_resource[:filesystem]) == false
    args.push('--loadavg') if bool_from_value(puppet_resource[:loadavg]) == true
    args.push('--no-loadavg') if bool_from_value(puppet_resource[:loadavg]) == false
    args.push('--meminfo') if bool_from_value(puppet_resource[:meminfo]) == true
    args.push('--no-meminfo') if bool_from_value(puppet_resource[:meminfo]) == false
    args.push('--netdev') if bool_from_value(puppet_resource[:netdev]) == true
    args.push('--no-netdev') if bool_from_value(puppet_resource[:netdev]) == false
    args.push('--time') if bool_from_value(puppet_resource[:time]) == true
    args.push('--no-time') if bool_from_value(puppet_resource[:time]) == false
    args.push('--devstat') if bool_from_value(puppet_resource[:devstat]) == true
    args.push('--no-devstat') if bool_from_value(puppet_resource[:devstat]) == false
    args.push('--interrupts') if bool_from_value(puppet_resource[:interrupts]) == true
    args.push('--no-interrupts') if bool_from_value(puppet_resource[:interrupts]) == false
    args.push('--ntp') if bool_from_value(puppet_resource[:ntp]) == true
    args.push('--no-ntp') if bool_from_value(puppet_resource[:ntp]) == false
    args.push('--zfs') if bool_from_value(puppet_resource[:zfs]) == true
    args.push('--no-zfs') if bool_from_value(puppet_resource[:zfs]) == false
    args
  end

  #
  private :_translate_json_object_to_puppet_resource, :_translate_puppet_resource_to_command_args
end
