# www node to use Apache as tomcat proxy
node /www\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "web server\n"
  }

  include apache::mod::proxy_http
  apache::vhost::proxy { 'www.acme.com':
    port => 80,
    dest => 'http://tomcat1.local:8080',
  }

  firewall { '100 allow apache':
    proto       => 'tcp',
    port        => '80',
    action      => 'accept',
  }
}
