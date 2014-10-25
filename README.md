# Continuous Delivery with Maven, Puppet and Tomcat 

Examples of setting up a continuous delivery process using Maven, Tomcat, Docker, Puppet, Vagrant, Jenkins,
Cucumber, Beaker and other helpful tools for my talks.
Evolved through the different talks, unsing latest tools.

* Agile Testing Days 2014: [Continuous Delivery, the Next Frontier](http://www.agiletestingdays.com/session/continuous-delivery-the-next-frontier/) (git tag `agiletestingdays2014`).
* Agile Testing Days 2013: [Infrastructure testing with Jenkins, Puppet and Vagrant](http://blog.csanchez.org/2013/10/29/infrastructure-testing-with-jenkins-puppet-and-vagrant-at-agile-testing-days/) (git tag `agiletestingdays2013`).
* ApacheCon 2013: [Continuous Delivery with Maven, Puppet and Tomcat](http://blog.csanchez.org/2013/11/12/continuous-delivery-with-maven-puppet-and-tomcat-video-from-apachecon-na-2013/) (git tag `apachecon2013`)
* JavaZone 2012: [Puppet for Java Developers](https://github.com/carlossg/puppet-for-java-devs) (forked repo)

> Continuous Integration, with Apache Continuum or Jenkins, can be extended to fully manage deployments and production environments, running in Tomcat for instance, in a full Continuous Delivery cycle using infrastructure-as-code tools like Puppet, allowing to manage multiple servers and their configurations.


## Tools

* [Docker](http://docker.io) for containerized deployments and tests
* [Vagrant](http://vagrantup.com) for VM creation and provisioning
* [librarian-puppet](http://librarian-puppet.com/) for automatic module installation
* [puppet-rspec](http://rspec-puppet.com) for puppet manifest testing
* [Capybara](https://github.com/jnicklas/capybara) and [Cucumber](http://cukes.info/) for acceptance tests
* [Beaker](https://github.com/puppetlabs/beaker) for deployment tests



## Installation

[Install Docker](https://docs.docker.com/installation).

Install all required gems

    bundle install

Change the $repo var in `mymodules/acme/manifests/tomcat_node.pp` to the location of a repository where you can deploy the Maven builds, accessible from the vagrant vms

    $repo = 'http://carlos-mbook-pro.local:8000/repository/all/'

Install all Puppet modules with Puppet Librarian

    librarian-puppet install

Run the specs with puppet-rspec

    bundle exec rake

Run the Puppet system specs with beaker

    bundle exec rake beaker

Build the Docker Tomcat image, change the REPO environment in `docker/tomcat/Dockerfile` with the location of your repo.

    docker build -t csanchez/appfuse-tomcat docker/tomcat

Start the stack containers. We assume they are up all the time
Create a host entry `docker.local` pointing to your Docker host.

    docker run -d --name db -p 5432:5432 postgres:8.4.22
    docker run -d --name nginx -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy
    docker run -d --name tomcat -e TOMCAT_PASS=admin -p 8080:8080 --link db:db -e VIRTUAL_HOST=docker.local -e VIRTUAL_PORT=8080 csanchez/appfuse-tomcat

The app should be available at [http://docker.local](http://docker.local).

## Integration tests

To run the integration tests you can start the containers and run the cucumber tests with rake

    rake integration

To run the cucumber step that accesses the login page you will need to have [phantomjs](http://phantomjs.org/) installed. To install in OS X with homebrew

    brew install phantomjs


## Continuous integration jobs

Building these jobs in jenkins. Each job triggers the next. The production updates can run in parallel.

### [appfuse](https://github.com/carlossg/appfuse)

Maven job building `continuous-delivery` branch of `https://github.com/carlossg/appfuse`.
Use your repository url instead of localhost.

    clean deploy -DaltDeploymentRepository=maestro-archiva::default::http://localhost:8000/repository/snapshots -DskipTests=true -P h2

### [appfuse QA](https://github.com/carlossg/continuous-delivery)

Job building `https://github.com/carlossg/continuous-delivery`.

    bundle exec rake spec
    docker build -t csanchez/appfuse-tomcat docker/tomcat
    docker rm --force db tomcat nginx
    docker run -d --name db -p 5432:5432 postgres:8.4.22
    docker run -d --name nginx -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock jwilder/nginx-proxy
    docker run -d --name tomcat -e TOMCAT_PASS=admin -p 8080:8080 --link db:db -e VIRTUAL_HOST=docker.local -e VIRTUAL_PORT=8080 csanchez/appfuse-tomcat
    bundle exec rake qa
    docker rm --force db tomcat nginx
