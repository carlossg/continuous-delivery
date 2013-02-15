import 'nodes/*.pp'

node 'parent' {
  Exec { 
    path => ['/bin', '/usr/bin'],
  }

  class { 'epel': } ->
  class { 'avahi':
    firewall => true
  }

  # Always persist firewall rules
  exec { 'persist-firewall':
    command     => $operatingsystem ? {
      'debian'          => '/sbin/iptables-save > /etc/iptables/rules.v4',
      /(RedHat|CentOS)/ => '/sbin/iptables-save > /etc/sysconfig/iptables',
    },
    refreshonly => true,
  }

  # These defaults ensure that the persistence command is executed after
  # every change to the firewall.
  Firewall {
    notify  => Exec['persist-firewall'],
  }
  Firewallchain {
    notify  => Exec['persist-firewall'],
  }
}
