class { 'opnsense':
  devices => {
    "localhost" => {
      "url"        => 'https://127.0.0.1/api',
      "api_key"    => '3T7LyQbZSXC/WN56qL0LyvLweNICeiTOzZ2JifNAvlrL+BW8Yvx7WSAUS4xvmLM/BE7xVVtv0Mv2QwNm',
      "api_secret" => '2mxXt++o5Mmte3sfNJsYxlm18M2t/wAGIAHwmWoe8qc15T5wUrejJQUd/sfXSGnAG2Xk2gqMf8FzHpT2',
      "ssl_verify" => true,
      "timeout"    => 60,
      "ca"         => '~/.opn-cli/ca.pem',
      "plugins"    => {
        "os-helloworld" => {}
      }
    }
  },
  aliases => {
    "my_http_ports_local" => {
      "devices"     => ["localhost"],
      "type"        => "port",
      "content"     => ["80", "443"],
      "description" => "example local http ports",
      "enabled"     => true
    },
  },
  rules => {
    "allow all from lan and wan" => {
      "devices"   => ["localhost"],
      "sequence"  => "1",
      "action"    => "pass",
      "interface" => ["lan", "wan"]
    }
  }
}

