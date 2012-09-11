# Start avahi services for mdns

class avahi {

  package { ['avahi', 'avahi-autoipd', 'avahi-compat-libdns_sd', 'avahi-glib', 'avahi-gobject', 'avahi-tools', 'nss-mdns']:
    ensure  => present,
    before  => Service['avahi-daemon'],
  }
  
  exec { 'dbus-daemon --system':
    path   => '/bin',
    unless => 'ps -C dbus-daemon -F | grep dbus-daemon',
  } ->
  service { 'avahi-daemon':
    hasstatus  => true,
    hasrestart => true,
    ensure     => running,
  }

  # iptables -A INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT
  # iptables -A OUTPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT

  firewall { '100 allow avahi':
    chain       => ['INPUT', 'OUTPUT'],
    proto       => 'udp',
    dport       => '5353',
    destination => '224.0.0.251',
    action      => 'accept',
  }

}
