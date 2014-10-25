FROM devopsil/puppet:3.5.1

COPY modules/ /etc/puppet/modules/
COPY manifests/ /etc/puppet/manifests/

RUN puppet apply /etc/puppet/manifests/ --verbose --detailed-exitcodes --certname tomcat1.acme.com || [ $? -eq 2 ]
