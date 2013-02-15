# Tomcat nodes tomcat1, tomcat2, tomcat3,...
node /tomcat\d\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => "tomcat server: ${::hostname}\n"
  }

  class { 'acme::tomcat_node': }
}
