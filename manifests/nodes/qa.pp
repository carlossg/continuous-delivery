# QA node with all the stack in one server
node /qa\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "QA server: ${::hostname}\n"
  }

  class { 'acme::db_node': } ->
  class { 'acme::tomcat_node':
    db_host => 'localhost',
  } ->
  class { 'acme::www_node':
    tomcat_host => 'localhost'
  }
}
