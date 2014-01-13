class acme::tomcat_node(
  $db_host = 'db.local',
  $repo = 'https://repo.maestrodev.com/archiva/repository/all/',
  $appfuse_version = '2.2.2-SNAPSHOT',
  $service = 'tomcat-appfuse',
  $app_name = 'appfuse',
  $tomcat_root = '/srv/tomcat') {

  # install java
  class { 'java': }

  # install tomcat
  class { 'tomcat': } ->

  # create a tomcat server instance for appfuse
  # It allows having multiple independent tomcat servers in different ports
  tomcat::instance { 'appfuse':
    ensure    => present,
    http_port => 8080,
  }

  # where the war needs to be installed
  $webapp = "${tomcat_root}/${app_name}/webapps/ROOT"

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
    require => File["${tomcat_root}/${app_name}/webapps"],
    notify  => Service[$service],
  } ->

  # unzip the war file, needed to customize the database
  file { $webapp:
    ensure => directory,
  }

  package { 'unzip':
    ensure => present,
  } ->
  exec { 'unzip-war':
    command => "unzip ${webapp}.war",
    cwd     => $webapp,
    creates => "${webapp}/WEB-INF",
    require => [Maven["${webapp}.war"], File[$webapp]],
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
    notify  => Service[$service],
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
    notify    => Service[$service],
  } ->

  # Create a folder needed by appfuse
  file { "${tomcat_root}/${app_name}/target":
    owner  => 'tomcat',
    ensure => 'directory',
    before => Service[$service],
  }

  firewall { '100 allow tomcat':
    proto  => 'tcp',
    port   => '8080',
    action => 'accept',
  }

}
