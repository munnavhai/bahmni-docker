# Bahmni-docker
Docker setup for Bahmni

Create the target directory in `/opt`:
```
sudo mkdir -p /opt/bahmni
```

Give permissions to the required users:
```
sudo setfacl -m "u:<username>:rwX" /opt/bahmni
sudo setfacl -m "d:u:<username>:rwX" /opt/bahmni
```

Clone this repo:
```
git clone https://github.com/MSF-OCB/Bahmni-docker/ /opt/bahmni
```

If you have trouble login in, you can also copy your (passphrase protected!!) ssh key to the server, add it to your github account and clone via ssh:
```
git clone git@github.com:MSF-OCB/Bahmni-docker.git /opt/bahmni/
```

Clone the playbooks repo:
```
git clone -b docker-dev-0.xx https://github.com/MSF-OCB/bahmni-playbooks /opt/bahmni/bahmni/artifacts/bahmni-playbooks
```
or
```
git clone -b docker-dev-0.xx git@github.com:MSF-OCB/bahmni-playbooks.git /opt/bahmni/bahmni/artifacts/bahmni-playbooks
```

# Copy the docker image by rsync

Use the script `transfer.sh` from the bahmni-docker-compose repo, on the build machine you run:
```
./transfer.sh <img name> <version> <host>
```

On the receiving machine (called "target_host" above): (in /opt)
```
cd /opt
7za x -so <img name>-<version>.tar.7z | docker load
```

To copy between the active and the passive, copy your (passphrase protected!!) private key onto the sending server and run:
```
rsync --partial --delay-updates --progress --rsync-path="sudo rsync" -e "ssh -i ${HOME}/.ssh/id_ec" /opt/<img name>-<version>.tar.7z bahmni-passive.msf.org:/opt/
```
Or use `bahmni.msf.org` as host name for the other direction.
