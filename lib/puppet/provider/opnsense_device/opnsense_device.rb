# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_sensitive'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'opnsense_provider'))

require 'yaml'
require 'fileutils'

# Implementation for the opnsense_device type using the Resource API.
class Puppet::Provider::OpnsenseDevice::OpnsenseDevice < Puppet::Provider::OpnsenseProvider
  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>]
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    _get_devices(device_names)
  end

  # @param [Array<Hash<Symbol>>] filter
  # @return [Array<Hash<Symbol>>, Array<String>]
  def get_device_names_by_filter(filter)
    if filter.empty?
      return get_configured_devices
    end
    filter
  end

  # @param [Array<Hash<Symbol>> | Array<String>] device_names
  # @return [Array<Hash<Symbol>>]
  def _get_devices(device_names)
    result = []
    device_names.each do |device_name|
      config_path = get_config_path(device_name)
      next unless File.exist?(config_path)
      data = _read_yaml(config_path)
      device_resource = _create_opnsense_device(device_name, data)
      result.push(device_resource)
    end
    result
  end

  # @param [String] device_name
  # @param [Array<Hash<String>>] data
  # @return [Hash{Symbol->Hash<String>}]
  def _create_opnsense_device(device_name, data)
    {
      ensure: 'present',
        name: device_name,
        api_key: data['api_key'],
        api_secret: _gen_pw(data['api_secret']),
        url: data['url'],
        timeout: data['timeout'],
        ssl_verify: data['ssl_verify'],
        ca: data['ca'].nil? ? nil : data['ca'],
    }
  end

  # @param [String] path
  # @return [Psych::Exception, nil]
  def _read_yaml(path)
    YAML.safe_load(File.read(path))
  end

  # @param [String] pw
  # @return [Puppet::Provider::OpnsenseSensitive]
  def _gen_pw(pw)
    Puppet::Provider::OpnsenseSensitive.new(pw)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @param [Hash<Symbol>] should
  # @return [File]
  def create(_context, name, should)
    _write_config(name, should)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  # @param [Hash<Symbol>] should
  def update(_context, name, should)
    _write_config(name, should)
  end

  # @param [String] name
  # @param [Hash<Symbol>] should
  # @return [File]
  def _write_config(name, should)
    basedir = get_config_basedir
    _ensure_dir(basedir)
    config_path = get_config_path(name)
    yaml_data = {
      'api_key' => should[:api_key],
        'api_secret' => _extract_pw(should[:api_secret]),
        'url' => should[:url],
        'timeout' => should[:timeout],
        'ssl_verify' => should[:ssl_verify],
        'ca' => should[:ca],
    }
    _write_yaml(config_path, yaml_data)
  end

  # @param [String] path
  # @param [Integer] mode
  # @return [Integer]
  def _ensure_dir(path, mode = 0o700)
    Dir.mkdir(path, mode) unless File.exist?(path)
  end

  # @param [Puppet::Provider::OpnsenseSensitive] sensitive
  # @return [String]
  def _extract_pw(sensitive)
    sensitive.unwrap
  end

  # @param [String] path
  # @param [Hash] data
  # @param [Integer] mode
  # @return [Integer]
  def _write_yaml(path, data, mode = 0o600)
    File.open(path, 'w') do |file|
      file.write(YAML.dump(data))
      file.chmod(mode)
    end
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [String] name
  def delete(_context, name)
    path = get_config_path(name)
    FileUtils.rm(path, force: true)
  end

  # @param [Puppet::ResourceApi::BaseContext] _context
  # @param [Hash] resources
  def canonicalize(_context, resources)
    resources.each do |r|
      if r.key?(:api_secret) && r[:api_secret].is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
        r[:api_secret] = _gen_pw(_extract_pw(r[:api_secret]))
      end
    end
  end
  #
  private :_write_config, :_ensure_dir, :_write_yaml, :_extract_pw, :_gen_pw,
          :_create_opnsense_device, :_get_devices, :_read_yaml
end
