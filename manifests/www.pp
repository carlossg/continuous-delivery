node /www\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "web server\n"
  }

  # class { 'apache': } ->
  apache::vhost::proxy { 'www.acme.com':
    port => 80,
    dest => 'http://tomcat1.local:8080',
  }

  # apache::proxypass {"myapp":
  #   ensure   => present,
  #   location => "/",
  #   vhost    => "www.acme.com",
  #   url      => "ajp://localhost:8000",
  # }

  firewall { '100 allow apache':
    proto       => 'tcp',
    port        => '80',
    action      => 'accept',
  }
}
