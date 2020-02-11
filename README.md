# Build this container
```
   docker build . --tag harvester
```

# Running this container

You will need to have the cert and key in current directory, and then launch it like so:
```
    sudo docker run \
        -v $(pwd)/config:/home/harvester/.kube/config \
        -v $(pwd)/usathpc-robot-gridproxy:/opt/harvester/etc/panda/usathpc-robot-gridproxy \
        -v $(pwd)/usathpc-robot-vomsproxy:/opt/harvester/etc/panda/usathpc-robot-vomsproxy \
        -v $(pwd)/usathpc-usercert-2019.pem:/opt/harvester/etc/panda/usathpc-usercert-2019.pem \
        -v $(pwd)/usathpc-userkey-2019.pem:/opt/harvester/etc/panda/usathpc-userkey-2019.pem \
        -it harvester bash
```
