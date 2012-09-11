# Tomcat nodes tomcat1, tomcat2, tomcat3,...
node /tomcat\d\..*/ inherits 'parent' {

  file { '/etc/motd':
    content => 'tomcat server\n'
  }

  class { 'java': distribution => 'java-1.6.0-openjdk' }

  class { 'tomcat': } ->

  tomcat::instance { 'appfuse':
    ensure    => present,
    http_port => 8080,
  }    

  $webapp = '/srv/tomcat/appfuse/webapps/ROOT'

  class { 'wget': } ->
  class { 'maven::maven' :
    version => '3.0.4',
  } ->
  maven { "${webapp}.war":
    id      => 'org.appfuse:appfuse-spring:2.1.0:war',
    require => File['/srv/tomcat/appfuse/webapps'],
    notify  => Service['tomcat-appfuse'],
  }

  # unzip the war file
  file { $webapp:
    ensure => directory,
  } ->
  package { 'unzip':
    ensure => installed,
  } ->
  exec { 'unzip-war':
    command => "unzip ${webapp}.war",
    cwd     => $webapp,
    creates => "${webapp}/WEB-INF",
    require => Maven["${webapp}.war"],
  } ->

  # postgres configuration
  maven { "${webapp}/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar":
    id => 'postgresql:postgresql:9.1-901.jdbc4',
  } ->
  file { "${webapp}/WEB-INF/classes/jdbc.properties":
    ensure  => present,
    content => 'jdbc.driverClassName=org.postgresql.Driver
jdbc.url=jdbc:postgresql://db.local/appfuse
jdbc.username=appfuse
jdbc.password=appfuse
hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect',
    notify  => Service['tomcat-appfuse'],
  }

  firewall { '100 allow tomcat':
    proto  => 'tcp',
    port   => '8080',
    action => 'accept',
  }

}
