node /db\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "db server\n"
  }

  class { 'postgresql::server':
    config_hash => {
      'ip_mask_allow_all_users' => '192.168.0.0/0',
      'listen_addresses'        => '*',
      'manage_redhat_firewall'  => true,
      'postgres_password'       => 'postgres',
    },
  }

  postgresql::db { 'appfuse':
    user     => 'appfuse',
    password => 'appfuse',
    grant    => 'all',
  }
}
