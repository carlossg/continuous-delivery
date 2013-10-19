class acme::db_node {

  # install postgres server
  class { 'postgresql::server':
    ip_mask_allow_all_users => '192.168.0.0/0',
    listen_addresses        => '*',
    postgres_password       => 'postgres',
  } ->

  # create appfuse database
  postgresql::server::db { 'appfuse':
    user     => 'appfuse',
    password => 'appfuse',
    grant    => 'all',
  } ->

  # Create database tables from sql dump
  file { '/tmp/dump.sql':
    ensure => present,
    source => 'puppet:///modules/acme/dump.sql',
  } ->
  exec { 'appfuse-db':
    user    => 'postgres',
    command => 'psql appfuse -f /tmp/dump.sql && touch /tmp/dump.sql.done',
    creates => '/tmp/dump.sql.done',
  }

  firewall { '100 allow postgres':
    proto  => 'tcp',
    port   => '5432',
    action => 'accept',
  }

}
