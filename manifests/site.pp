import 'nodes/*.pp'

node 'parent' {
  Exec { 
    path => ['/bin', '/usr/bin'],
  }

  class { 'epel': } ->
  class { 'avahi':
    firewall => true
  }

}
