class acme::www_node($tomcat_host = 'tomcat1.local') {
  include apache::mod::proxy_http

  # create a virtualhost that will proxy the tomcat server
  apache::vhost::proxy { "${::hostname}.local":
    port => 80,
    dest => "http://${tomcat_host}:8080",
  }

  firewall { '100 allow apache':
    proto       => 'tcp',
    port        => '80',
    action      => 'accept',
  }

}
