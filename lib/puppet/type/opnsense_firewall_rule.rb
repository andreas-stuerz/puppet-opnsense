# frozen_string_literal: true

require 'puppet/resource_api'

Puppet::ResourceApi.register_type(
  name: 'opnsense_firewall_rule',
  docs: <<-EOS,
  @summary
    Manage opnsense firewall rules
  @see:
    https://docs.opnsense.org/manual/firewall.html
  @example
    opnsense_firewall_rule { 'minimal example':
      device      => 'opnsense-test.device.com',
      sequence    => 1,
      action      => 'pass',
      interface   => ['lan', 'wan'],
      description => 'allow any from any to lan and wan',
      ensure      => 'present',
    }

    opnsense_firewall_rule { 'full example':
      device           => 'opnsense-test.device.com',
      sequence         => 2,
      action           => 'pass',
      direction        => 'in',
      ipprotocol       => 'inet',
      interface        => ['lan', 'wan'],
      source_net       => 'any',
      source_port      => '',
      source_not       => false,
      protocol         => 'any',
      destination_net  => 'any',
      destination_port => '',
      destination_not  => false,
      description      => 'allow any from any to lan and wan',
      gateway          => '',
      quick            => true,
      log              => false,
      enabled          => true,
      ensure           => 'present',
    }

  This type provides Puppet with the capabilities to manage opnsense firewall rules.

EOS
  features: ['simple_get_filter'],
  title_patterns: [
    {
        pattern: %r{^(?<name>.*[^-])@(?<device>.*)$},
        desc: 'Where the name of the rule and the device are provided with a @',
    },
    {
        pattern: %r{^(?<name>.*)$},
        desc: 'Where only the name is provided',
    },
  ],
  attributes: {
    ensure: {
      type: 'Enum[present, absent]',
      desc: 'Whether this resource should be present or absent on the target system.',
      default: 'present',
    },
    name: {
      type: 'String',
      desc: 'The name of the firewall rule you want to manage.',
      behaviour: :namevar,
    },
    device: {
      type: 'String',
      desc: 'The name of the opnsense_device type you want to manage.',
      behaviour: :namevar,
    },
    uuid: {
      type: 'String',
      desc: 'The uuid of the rule.',
      behaviour: :init_only,
    },
    sequence: {
      type: 'Integer',
      desc: 'The sequence number of this rule.',
    },
    action: {
      type: 'Enum["pass", "block", "reject"]',
      desc: 'Choose what to do with packets that match the criteria specified.',
    },
    interface: {
      type: 'Array[String]',
      desc: 'The network interface(s).',
    },
    description: {
      type: 'String',
      desc: 'The rule description.',
    },
    direction: {
      type: 'Enum["in", "out"]',
      desc: 'Direction of the traffic.',
      default: 'in'
    },
    quick: {
      type: 'Boolean',
      desc: 'If a packet matches a rule specifying quick, then that rule is considered the last matching rule.',
      default: true
    },
    ipprotocol: {
      type: 'Enum["inet", "inet6"]',
      desc: 'IP Version',
      default: 'inet'
    },
    protocol: {
      type: "Enum[
          'any', 'ICMP', 'IGMP', 'GGP', 'IPENCAP', 'ST2', 'TCP', 'CBT', 'EGP', 'IGP', 'BBN-RCC', 'NVP', 'PUP',
          'ARGUS', 'EMCON', 'XNET', 'CHAOS', 'UDP', 'MUX', 'DCN', 'HMP', 'PRM', 'XNS-IDP', 'TRUNK-1', 'TRUNK-2',
          'LEAF-1', 'LEAF-2', 'RDP', 'IRTP', 'ISO-TP4', 'NETBLT', 'MFE-NSP', 'MERIT-INP', 'DCCP', '3PC', 'IDPR',
          'XTP', 'DDP', 'IDPR-CMTP', 'TP++', 'IL', 'IPV6', 'SDRP', 'IDRP', 'RSVP', 'GRE', 'DSR', 'BNA', 'ESP',
          'AH', 'I-NLSP', 'SWIPE', 'NARP', 'MOBILE', 'TLSP', 'SKIP', 'IPV6-ICMP', 'CFTP', 'SAT-EXPAK', 'KRYPTOLAN',
          'RVD', 'IPPC', 'SAT-MON', 'VISA', 'IPCV', 'CPNX', 'CPHB', 'WSN', 'PVP', 'BR-SAT-MON', 'SUN-ND', 'WB-MON',
          'WB-EXPAK', 'ISO-IP', 'VMTP', 'SECURE-VMTP', 'VINES', 'TTP', 'NSFNET-IGP', 'DGP', 'TCF', 'EIGRP', 'OSPF',
          'SPRITE-RPC', 'LARP', 'MTP', 'AX.25', 'IPIP', 'MICP', 'SCC-SP', 'ETHERIP', 'ENCAP', 'GMTP', 'IFMP', 'PNNI',
          'PIM', 'ARIS', 'SCPS', 'QNX', 'A/N', 'IPCOMP', 'SNP', 'COMPAQ-PEER', 'IPX-IN-IP', 'CARP', 'PGM', 'L2TP',
          'DDX', 'IATP', 'STP', 'SRP', 'UTI', 'SMP', 'SM', 'PTP', 'ISIS', 'CRTP', 'CRUDP', 'SPS', 'PIPE', 'SCTP',
          'FC', 'RSVP-E2E-IGNORE', 'UDPLITE', 'MPLS-IN-IP', 'MANET', 'HIP', 'SHIM6', 'WESP', 'ROHC',
          'PFSYNC', 'DIVERT'
        ]",
      desc: 'The Protocol that is used.',
      default: 'any'
    },
    source_net: {
      type: 'String',
      desc: 'The source eg. any, ip address, network or alias.',
      default: 'any'
    },
    source_port: {
      type: 'String',
      desc: 'Source port number or well known name (imap, imaps, http, https, ...), for ranges use a dash.',
      default: ''
    },
    source_not: {
      type: 'Boolean',
      desc: 'Source port number or well known name (imap, imaps, http, https, ...), for ranges use a dash.',
      default: false
    },
    destination_net: {
      type: 'String',
      desc: 'The destination eg. any, ip address, network or alias.',
      default: 'any'
    },
    destination_port: {
      type: 'String',
      desc: 'Destination port number or well known name (imap, imaps, http, https, ...), for ranges use a dash.',
      default: ''
    },
    destination_not: {
      type: 'Boolean',
      desc: 'Use this option to invert the sense of the match for the destination.',
      default: false
    },
    gateway: {
      type: 'String',
      desc: 'Leave as default to use the system routing table. Or choose a gateway to utilize policy based routing.',
      default: ''
    },
    log: {
      type: 'Boolean',
      desc: 'Log packets that are handled by this rule.',
      default: false
    },
    enabled: {
      type: 'Boolean',
      desc: 'Enable or disable this rule.',
      default: true
    },
  },
)
