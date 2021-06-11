# frozen_string_literal: true

# require 'puppet/resource_api/simple_provider'
require_relative '../opnsense_provider'
require 'yaml'
require 'fileutils'
require 'puppet/provider/opnsense_device/sensitive'

# Implementation for the opnsense_device type using the Resource API.
class Puppet::Provider::OpnsenseDevice::OpnsenseDevice < Puppet::Provider::OpnsenseProvider
  def get(_context, filter)
    device_names = get_device_names_by_filter(filter)
    get_devices(device_names)
  end

  def get_device_names_by_filter(filter)
    if filter.empty?
      return get_configured_devices
    end
    filter
  end

  def get_devices(device_names)
    result = []
    device_names.each do |device_name|
      config_path = get_config_path(device_name)
      next unless File.exist?(config_path)
      data = read_yaml(config_path)
      device_resource = create_opnsense_device(device_name, data)
      result.push(device_resource)
    end
    result
  end

  def create_opnsense_device(device_name, data)
    {
      ensure: 'present',
        name: device_name,
        api_key: data['api_key'],
        api_secret: gen_pw(data['api_secret']),
        url: data['url'],
        timeout: data['timeout'],
        ssl_verify: data['ssl_verify'],
        ca: data['ca'].nil? ? nil : data['ca'],
    }
  end

  def read_yaml(path)
    YAML.safe_load(File.read(path))
  end

  def gen_pw(pw)
    Puppet::Provider::OpnsenseDevice::Sensitive.new(pw)
  end

  def create(_context, name, should)
    write_config(name, should)
  end

  def update(_context, name, should)
    write_config(name, should)
  end

  def ensure_dir(path, mode = 0o700)
    Dir.mkdir(path, mode) unless File.exist?(path)
  end

  def write_config(name, should)
    basedir = get_config_basedir
    ensure_dir(basedir)
    config_path = get_config_path(name)
    yaml_data = {
      'api_key' => should[:api_key],
        'api_secret' => extract_pw(should[:api_secret]),
        'url' => should[:url],
        'timeout' => should[:timeout],
        'ssl_verify' => should[:ssl_verify],
        'ca' => should[:ca],
    }
    write_yaml(config_path, yaml_data)
  end

  def extract_pw(sensitive)
    sensitive.unwrap
  end

  def write_yaml(path, data, mode = 0o600)
    File.open(path, 'w') do |file|
      file.write(YAML.dump(data))
      file.chmod(mode)
    end
  end

  def delete(_context, name)
    delete_config(name)
  end

  def delete_config(name)
    path = get_config_path(name)
    FileUtils.rm(path, force: true)
  end

  def canonicalize(_context, resources)
    resources.each do |r|
      if r.key?(:api_secret) && r[:api_secret].is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
        r[:api_secret] = gen_pw(extract_pw(r[:api_secret]))
      end
    end
  end
end
