FROM centos:7
LABEL maintainer="lincolnb@uchicago.edu"

# Setup EPEL
RUN yum install epel-release -y

# Python dependencies, build tools
RUN yum install -y python-devel python-setuptools python-pip git gcc voms-clients-cpp python-virtualenv

# Install and set up kubectl
COPY kubernetes.repo /etc/yum.repos.d/kubernetes.repo
RUN yum install -y kubectl

# Create directories needed 
RUN mkdir -p /var/log/panda
RUN mkdir -p /data/atlpan/harvester_wdris

# Create a Harvester user 
RUN adduser harvester
RUN chown harvester: /opt 
RUN chown harvester: /var/log/panda

# Create the VirtualEnv
RUN cd /opt && virtualenv harvester && cd harvester && source bin/activate && \
    pip install pip --upgrade && \
    pip install --upgrade setuptools>=39.0.1 && \
    pip install git+git://github.com/HSF/harvester.git@k8s_analysis && \
    pip install kubernetes

# Copy Harvester templates into place
WORKDIR /opt/harvester

RUN mv etc/sysconfig/panda_harvester.rpmnew.template  etc/sysconfig/panda_harvester
#RUN mv etc/panda/panda_common.cfg.rpmnew.template etc/panda/panda_common.cfg
#RUN mv etc/panda/panda_harvester.cfg.rpmnew.template etc/panda/panda_harvester.cfg

COPY panda_common.cfg etc/panda/panda_common.cfg
COPY panda_harvester.cfg etc/panda/panda_harvester.cfg
COPY panda_queueconfig.json etc/panda/panda_queueconfig.json
COPY htcondor_grid_submit_p1.sdf htcondor_grid_submit_p1.sdf
COPY runpilot3-wrapper.sh runpilot3-wrapper.sh
COPY x509up_u13214 /tmp/x509up_u13214
COPY usathpc-robot-gridproxy etc/panda/usathpc-robot-gridproxy
COPY usathpc-robot-vomsproxy etc/panda/usathpc-robot-vomsproxy
COPY config /home/harvester/.kube/config
COPY atlas_job.yaml atlas_job.yaml
COPY k8s_secret_cred_manager_config.json k8s_secret_cred_manager_config.json

# CERN CA Bundle
COPY CERN-bundle-3.pem etc/pki/tls/certs/CERN-bundle-3.pem

ENV PANDA_HOME=/opt/harvester
ENV PYTHONPATH=/opt/harvester/lib/python2.7/site-packages/pandacommon:/opt/harvester/lib/python2.7/site-packages

# If we need to drop privileges, we need to copy in the cert at build time and
# chown it

COPY usathpc-usercert-2019.pem /opt/harvester/etc/panda/usathpc-usercert-2019.pem
COPY usathpc-userkey-2019.pem /opt/harvester/etc/panda/usathpc-userkey-2019.pem

RUN chown harvester: /opt/harvester/etc/panda/usathpc-usercert-2019.pem
RUN chown harvester: /opt/harvester/etc/panda/usathpc-userkey-2019.pem
RUN chown -R harvester: /opt/harvester

USER harvester

CMD "/bin/env"
COPY start-harvester.sh start-harvester.sh
#ENTRYPOINT ./start-harvester.sh
