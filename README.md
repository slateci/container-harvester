# Build this container
```
   docker build . --tag harvester
```

# Running this container

You will need to have the cert and key in current directory, and then launch it like so:
```
   docker run -v $(pwd)/usathpc-usercert-2019.pem:/opt/harvester/etc/panda/usathpc-usercert-2019.pem -v $(pwd)/usathpc-userkey-2019.pem:/opt/harvester/etc/panda/usathpc-userkey-2019.pem harvester ./start-harvester.sh
```
