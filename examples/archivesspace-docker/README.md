ArchivesSpace Docker
======================
Repository containing the Docker setup and configuration for the ArchivesSpace
application. It includes CI/CD that will automatically build and deploy the Docker
image to the application servers depending on the branch of this repository.

Contents
--------
* [Setup](#setup)
* [Updating the ArchivesSpace Version](#updating-the-archivesspace-version)
* [Resetting the Solr Index](#resetting-the-solr-index)
* [Backup and Restore](#backup-and-restore)
* [Developer Notes](#developer-notes)
* [Troubleshooting](#troubleshooting)

Setup
---------------------

### Install docker
Follow the [official documentation](https://docs.docker.com/engine/install/) to install
Docker on your system.

# Initialize the swarm
docker swarm init

### Setup UFW
The local firewall needs to be updated to include the IP ranges you 
want to restrict 80/443 access to, but additionally the docker 
internal nonroutable range as well.
```
# Restricted example. Include other IP restrictions as relavent
ufw allow from 192.168.0.0/16 to any port  80,443 proto tcp

# Public example
ufw allow http
ufw allow https
```

### SSL setup
In order to use SSL, you will need to obtain an SSL certificate and 
provide the relavent files to the docker instance via a volume.  
```
# create the combined ssl certificate
cat archivesspace_interm.cer >> archivesspace_cert.cer
# create the volume
docker volume create archivesspace-docker_ssl
docker volume inspect archivesspace-docker_ssl
# copy the ssl cert files to the volume
cp archivesspace.key [volume path]/
cp archivesspace_cert.cer [volume path]/
```

### Local customizations

#### Settings
Search this repository for references of `TODO` to see all the places 
recommended for customizations.

#### config.rb
We have included a sample `config.patch` file that can be used, but for any 
additional changes you would liek to make to the `config.rb` in the image you 
can do the following: 
```
# Make updates in this file as compared to original config in the release (using a tool like vimdiff)
vim config.rb
vimdiff config.rb config.rb.orig
# Make a new patch file
./make_patch
./make_patch
```

### (Optional) Database setup
If you want to load the instance with an initial set of data, you can import from
a dump file.  
```
cat archivesspace.sql | docker exec -i $(docker ps -q -f name=as_db) mysql -u as --password=as123 archivesspace
```

### Option 1: CI/CD Setup

#### Create a deploy user
Create a user that will have read-only access to the repository to 
pull changes.  

```
adduser deploy
passwd -l deploy
sudo -Hu deploy ssh-keygen -o -t ed25519 -C deploy@archivesspace
```

Now add that as a deploy key to the git repository providing the public key
```
cat /home/deploy/.ssh/id_ed25519.pub
```
#### Have a sysadmin create a Group CI/CD variable with the encoded deploy ssh key

### Option 2: Local Setup

#### Deploy the swarm
```
docker swarm deploy --with-registry-auth -c docker-compose.yml as
```

#### Log rotation
```
cp etc/logrotate.d/archivesspace-docker /etc/logrotate.d/
```

Updating the ArchivesSpace Version
----------------------------------

### Config file changes
This repository contains a [patch file](config.patch) that will apply our local changes 
to the defaul configuration file. It is possible that there are new changes to the config 
that we will want applied, in that case you will need to generate a new patch file. Here 
are the steps to re-generate one:  
```
# Example contains both the AS default config and our local copy with latest changes
diff -u config.rb.orig config.rb > config.patch
```

### Backup the database
Prior to running the upgrade, take a dump of the current database state. You can get the 
command from the cron entry, or from the [backup and restore](#backup-and-restore) section. 

### Updating the version
To increase the version number installed, update the `.gitlab-ci.yml` with the version in the `AS_VERSION` argument. 
If you want to increase the version only on one environment, you can update it for only the `_TEST` containers.

Additionally, you probably will want to [reset the Solr index](#resetting-the-solr-index) to apply the lastest schema changes.  


Resetting the Solr Index
----------------------------------
Resetting the Solr index can help resolve search related issues such as records not appearing after they have 
been successfully created. It should also be used after updating the ArchivesSpace version to apply the latest 
schema changes. 

```
docker exec $(docker ps -q f name=as_solr) curl -s http://localhost:8983/solr/archivesspace/update --data-binary '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
docker exec $(docker ps -q f name=as_archivesspace) rm -rf /archivesspace/data/*
docker stop $(docker ps -q f name=as_archvesspace) # this essentially "restarts" AS
```

**Note**: It takes hours to do a full re-index, so ideally time this at the end of the day so it can complete 
overnight.  

Backup and Restore
--------------------
The only portion that should require backups is the database. This is because everything 
else can be generated from that data. The software and configs are all stored in the GitLab 
container registry and can be restored from there if needed. 

Here are example commands to backup and restore the database data:  
```
# Backup
docker exec $(docker ps -q f name=as_db) mysqldump -u as --password=as123 archivesspace > archivesspace.sql

# Restore
cat archivesspace.sql | docker exec -i $(docker ps -q f name=as_db) mysql -u as --password=as123 archivesspace
```

Developer Notes
---------------------
For local debugging you can override the `command` in the `docker-compose.yml` file
for the `archivesspace` service and set it to `sleep inf` and re-redeploy the stack:  
```
docker stack deploy --with-registry-auth -c docker-compose.yml docker-compose.yml
docker exec -it $(docker ps -q f name=as_archivesspace) bash
# to start the AS process within the container if you need to:
/archivesspace/archivesspace.sh
```

Troubleshooting
---------------------
### General Tips
You can check which docker containers are running by executing:  
```
docker ps
docker service ls
```

To see which ports the server is listening on run:  
```
sudo lsof -i -P -n | grep LISTEN
```

To identify all of the data volumes used by the images:
```
docker volume ls
```

To identify the server location of the volume data:  
```
docker volume inspect [volume name]
docker volume inspect as_nginx_logs
```

To see the logs for a container, given the container name (from `docker ps`):  
```
docker logs CONTAINER [-f]
docker logs archivesspace -f
# to follow the logs for the service, which generally you'd want to do:
docker service logs -f as_archivesspace -n100
```

### java.lang.IllegalArgumentException: HOUR_OF_DAY: 2 -> 3:Java::JavaLang::IllegalArgumentException:
This error will apear in the logs when trying to start ArchivesSpace after daylight savings time.
Reference: http://lyralists.lyrasis.org/mailman/htdig/archivesspace_users_group/2019-March/006652.html

Basically, the indexer user (or other user, but the indexer is the most likely culprit at 2am)
is being updated in the database with a time that does not exist due to daylight savings time.

To verify query for users with an `mtime` in the most recent
[daylight savings date](https://en.wikipedia.org/wiki/Daylight_saving_time_in_the_United_States):  
```
SELECT * FROM user WHERE (user_mtime >= '2022-03-13 02:00:00' and user_mtime <= '2022-03-13 03:00:00') OR (system_mtime >= '2022-03-13 02:00:00' and system_mtime <= '2022-03-13 03:00:00');
```
The record that should come back is the `search_indexer` user, but could come back with others too.

To resolve update that user (and/or others) with a valid timestamp:  
```
UPDATE user set user_mtime = NOW(), system_mtime=NOW() where username='search_indexer';
```
