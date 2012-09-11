import 'avahi.pp'
import 'db.pp'
import 'tomcat.pp'
import 'www.pp'

node 'parent' {
  Exec { 
    path => ['/bin', '/usr/bin'],
  }

  class { 'epel': } ->
  class { 'avahi': }
}
