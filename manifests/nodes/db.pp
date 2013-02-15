# Database node
node /db\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "db server: ${::hostname}\n"
  }

  class { 'acme::db_node': }
}
