FROM centos:7
LABEL maintainer="lincolnb@uchicago.edu"

# Setup EPEL
RUN yum install epel-release -y

# Python dependencies, build tools
RUN yum install -y python-devel python-setuptools python-pip git gcc voms-clients-cpp python-virtualenv

# Create directories needed 
RUN mkdir -p /var/log/panda

# Create a Harvester user and then drop privileges
RUN adduser harvester
RUN chown harvester: /opt 
RUN chown harvester: /var/log/panda
USER harvester

# Create the VirtualEnv
RUN cd /opt && virtualenv harvester && cd harvester && source bin/activate && \
    pip install pip --upgrade && \
    pip install --upgrade setuptools>=39.0.1 && \
    pip install git+git://github.com/PanDAWMS/panda-harvester.git

# Copy Harvester templates into place
WORKDIR /opt/harvester

RUN mv etc/sysconfig/panda_harvester.rpmnew.template  etc/sysconfig/panda_harvester
#RUN mv etc/panda/panda_common.cfg.rpmnew.template etc/panda/panda_common.cfg
#RUN mv etc/panda/panda_harvester.cfg.rpmnew.template etc/panda/panda_harvester.cfg

COPY panda_common.cfg etc/panda/panda_common.cfg
COPY panda_harvester.cfg etc/panda/panda_harvester.cfg
COPY panda_queueconfig.json etc/panda/panda_queueconfig.json

# CERN CA Bundle
COPY CERN-bundle-3.pem etc/pki/tls/certs/CERN-bundle-3.pem

ENV PANDA_HOME=/opt/harvester
ENV PYTHONPATH=/opt/harvester/lib/python2.7/site-packages/pandacommon:/opt/harvester/lib/python2.7/site-packages

CMD "/bin/env"
