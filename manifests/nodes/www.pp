# www node to use Apache as tomcat proxy
node /www\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "web server: ${::hostname}\n"
  }

  class { 'acme::www_node': }
}
