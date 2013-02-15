class acme::tomcat_node(
  $db_host = 'db.local',
  $repo = 'http://carlos-mbook-pro.local:8000/repository/all/',
  $appfuse_version = '2.2.2-SNAPSHOT') {

  # install java
  class { 'java': distribution => 'java-1.6.0-openjdk' }

  # install tomcat
  class { 'tomcat': } ->

  # create a tomcat server instance for appfuse
  # It allows having multiple independent tomcat servers in different ports
  tomcat::instance { 'appfuse':
    ensure    => present,
    http_port => 8080,
  }    

  # where the war needs to be installed
  $webapp = '/srv/tomcat/appfuse/webapps/ROOT'

  # install maven and download appfuse war file from our archiva instance
  class { 'wget': } ->
  class { 'maven::maven' :
    version => '3.0.4',
  } ->
  # clean up to deploy the next snapshot
  exec { "rm -rf ${webapp}*": } ->
  maven { "${webapp}.war":
    id      => "org.appfuse:appfuse-spring:${appfuse_version}:war",
    repos   => [$repo],
    require => File['/srv/tomcat/appfuse/webapps'],
    notify  => Service['tomcat-appfuse'],
  } ->

  # unzip the war file, needed to customize the database
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

  # configure appfuse to use postgres database. Download jdbc driver and change jdbc properties
  maven { "${webapp}/WEB-INF/lib/postgresql-9.1-901.jdbc4.jar":
    id    => 'postgresql:postgresql:9.1-901.jdbc4',
    repos => [$repo],
  } ->
  file { "${webapp}/WEB-INF/classes/jdbc.properties":
    ensure  => present,
    content => "jdbc.driverClassName=org.postgresql.Driver
jdbc.url=jdbc:postgresql://${db_host}/appfuse
jdbc.username=appfuse
jdbc.password=appfuse
hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect",
    notify  => Service['tomcat-appfuse'],
  } ->

  # change appfuse index directory to /tmp/index, otherwise will try to write to tomcat dirs
  # use augeas to change that line only

  # Until Augeas has the properties files fixes, use a custom version
  # Just a basic approach - for more complete management of lenses consider https://github.com/camptocamp/puppet-augeas
  file { "/tmp/properties.aug":
    source => "puppet:///modules/acme/properties.aug"
  } ->
  # Adjust hibernate.properties
  augeas { 'update-hipernate-properties':
    lens      => 'Properties.lns',
    incl      => "${webapp}/WEB-INF/classes/hibernate.properties",
    changes   => "set app.search.index.basedir /tmp/index",
    load_path => '/tmp',
    notify    => Service['tomcat-appfuse'],
  } ->

  # Create a folder needed by appfuse
  file { '/srv/tomcat/appfuse/target':
    owner  => 'tomcat',
    ensure => 'directory',
    before => Service['tomcat-appfuse'],
  }

  firewall { '100 allow tomcat':
    proto  => 'tcp',
    port   => '8080',
    action => 'accept',
  }

}
