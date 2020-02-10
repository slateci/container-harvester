#!/bin/bash
source bin/activate
source etc/sysconfig/panda_harvester

# Generate the DB
python lib/python*/site-packages/pandaharvester/harvestertest/basicTest.py

# Stage in/out tests
python lib/python*/site-packages/pandaharvester/harvestertest/stageInTest.py UCHICAGO_RIVER
python lib/python*/site-packages/pandaharvester/harvestertest/stageOutTest.py UCHICAGO_RIVER

# Start Harvester
python lib/python*/site-packages/pandaharvester/harvesterbody/master.py --pid $PWD/tmp.pid
