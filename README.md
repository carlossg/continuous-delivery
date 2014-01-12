# Continuous Delivery with Maven, Puppet and Tomcat 

Examples of setting up a continuous delivery process using Maven, Tomcat, Puppet, Vagrant, Jenkins,
Cucumber and other helpful tools for my talk
[Continuous Delivery with Maven, Puppet and Tomcat](http://blog.csanchez.org/2013/11/12/continuous-delivery-with-maven-puppet-and-tomcat-video-from-apachecon-na-2013/)
at ApacheCon 2013 and
[Infrastructure testing with Jenkins, Puppet and Vagrant](http://blog.csanchez.org/2013/10/29/infrastructure-testing-with-jenkins-puppet-and-vagrant-at-agile-testing-days/)
at Agile Testing Days 2013.

* [Vagrant](http://vagrantup.com) for VM creation and provisioning
* [librarian-puppet](http://librarian-puppet.com/) for automatic module installation
* [puppet-rspec](http://rspec-puppet.com) for puppet manifest testing
* [Capybara](https://github.com/jnicklas/capybara) and [Cucumber](http://cukes.info/) for acceptance tests


    Continuous Integration, with Apache Continuum or Jenkins, can be extended to fully manage deployments and production environments, running in Tomcat for instance, in a full Continuous Delivery cycle using infrastructure-as-code tools like Puppet, allowing to manage multiple servers and their configurations.

This project is a fork of [Puppet for Java Developers](https://github.com/carlossg/puppet-for-java-devs) created for my talk at JavaZone Oslo 2012.


## Installation


Install all required gems

    bundle install

Change the $repo var in `mymodules/acme/manifests/tomcat_node.pp` to the location of a repository where you can deploy the Maven builds, accessible from the vagrant vms

    $repo = 'http://carlos-mbook-pro.local:8000/repository/all/'

Install all Puppet modules with Puppet Librarian

    librarian-puppet install

Run the specs with puppet-rspec

    bundle exec rake

Start the "production" vms with Vagrant. We assume they are up all the time

    vagrant up db tomcat1 www


## Continuous integration jobs

Building these jobs in jenkins. Each job triggers the next. The production updates can run in parallel.

### [appfuse](https://github.com/carlossg/appfuse)

Use your repository url instead of localhost.

    clean deploy -DaltDeploymentRepository=maestro-archiva::default::http://localhost:8000/repository/appfuse -P h2

### [appfuse QA](https://github.com/carlossg/continuous-delivery)

    bundle exec rake spec
    bundle exec librarian-puppet install
    vagrant destroy --force qa
    vagrant up qa
    bundle exec rake qa && vagrant destroy --force qa

### Production boxes updates

Checkout this project and create jobs to run in parallel and update with Puppet. Could ssh into the boxes and run `puppet agent --test` too.

    cd ~/continuous-delivery && vagrant provision db

    cd ~/continuous-delivery && vagrant provision tomcat1

    cd ~/continuous-delivery && vagrant provision www
