# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require 'yaml'
require 'fileutils'
require 'puppet/provider/opnsense_device/sensitive'

# Implementation for the opnsense_device type using the Resource API.
class Puppet::Provider::OpnsenseDevice::OpnsenseDevice < Puppet::ResourceApi::SimpleProvider
  def get_config_basedir
    File.expand_path('~/.puppet-opnsense')
  end

  def get_suffix
    '-config.yaml'
  end

  def gen_pw(pw)
    Puppet::Provider::OpnsenseDevice::Sensitive.new(pw)
  end

  def extract_pw(sensitive)
    sensitive.unwrap
  end

  def get_config_path(device_name)
    File.join(get_config_basedir.to_s, "#{File.basename(device_name)}#{get_suffix}")
  end

  def write_yaml(path, data)
    # ensure config directory exists
    File.open(path, 'w') do |file|
      file.write(YAML.dump(data))
      file.chmod(0o600)
    end
  end

  def read_yaml(path)
    YAML.safe_load(File.read(path))
  end

  def delete_config(name)
    path = get_config_path(name)
    FileUtils.rm(path, force: true)
  end

  def write_config(name, should)
    basedir = get_config_basedir
    path = get_config_path(name)
    yaml_data = {
      'api_key' => should[:api_key],
        'api_secret' => extract_pw(should[:api_secret]),
        'url' => should[:url],
        'timeout' => should[:timeout],
        'ssl_verify' => should[:ssl_verify],
        'ca' => should[:ca],
    }
    Dir.mkdir(basedir, 0o700) unless File.exist?(basedir)
    write_yaml(path, yaml_data)
  end

  def get(_context, filter_names = [])
    result = []
    names = filter_names.empty? ? [] : filter_names

    if filter_names.empty?
      basedir = get_config_basedir
      Dir.glob("#{basedir}/*#{get_suffix}").each do |path|
        name = File.basename(path).gsub(%r{#{get_suffix}$}, '')
        names.push(name)
      end
    end

    names.each do |name|
      path = get_config_path(name)

      next unless File.readable?(path)
      data = read_yaml(path)
      result.push(
          ensure: 'present',
          name: name,
          api_key: data['api_key'],
          api_secret: gen_pw(data['api_secret']),
          url: data['url'],
          timeout: data['timeout'],
          ssl_verify: data['ssl_verify'],
          ca: data['ca'].nil? ? nil : data['ca'],
        )
    end
    result
  end

  def create(_context, name, should)
    write_config(name, should)
  end

  def update(_context, name, should)
    write_config(name, should)
  end

  def delete(_context, name)
    delete_config(name)
  end

  def canonicalize(_context, resources)
    resources.each do |r|
      if r.key?(:api_secret) && r[:api_secret].is_a?(Puppet::Pops::Types::PSensitiveType::Sensitive)
        r[:api_secret] = gen_pw(extract_pw(r[:api_secret]))
      end
    end
  end
end
