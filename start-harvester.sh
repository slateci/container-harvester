#!/bin/bash
source bin/activate
source etc/sysconfig/panda_harvester

# Generate the DB
python lib/python*/site-packages/pandaharvester/harvestertest/basicTest.py

# Communication test
python lib/python*/site-packages/pandaharvester/harvestertest/testCommunication.py
