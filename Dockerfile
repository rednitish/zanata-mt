#
# DATASOURCE IS BEING CONFIGURED USING ENVIRONMENT VARIABLES IN OPENSHIFT INSTANCE
#
# Required file in same directory:
# - target/deployments/ROOT.war - packaged war file
# - docker/certs/ - all required certificates
#
# https://access.redhat.com/containers/?tab=overview#/registry.access.redhat.com/jboss-eap-7/eap71-openshift
#
FROM registry.access.redhat.com/jboss-eap-7/eap71-openshift:1.3-8.1533128020

MAINTAINER "Alex Eng" <aeng@redhat.com>
MAINTAINER "Patrick Huang" <pahuang@redhat.com>

EXPOSE 8080
EXPOSE 5432
EXPOSE 8787


USER root

# copy all certs from certs/ directory
COPY docker/certs/ /etc/pki/ca-trust/source/anchors/
COPY docker/res/ /opt/eap/bin/

RUN update-ca-trust extract

# need to use numeric uid so it's more suitable in Openshift
# 185 is used in parent image and it's reserved for jboss as
USER 185

# copy war file
COPY target/deployments/ROOT.war $JBOSS_HOME/standalone/deployments/ROOT.war
