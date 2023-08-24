# aspace-containerization
Containerization of ArchivesSpace for Kubernetes deployment

## GitHub Workflows
| Workflow                  | YAML                         | Image       |
|---------------------------|------------------------------|-------------|
| Build app image           | build-app-image.yml          | aspace-app  |
| Build solr image          | build-solr-image.yml         | aspace-solr |
| Delete old workflow runs  | delete-old-workflow-runs.yml | n/a         |

## Running Locally
### Configure Environment
The images are configured through environment variables. The docker compose yaml file expects `.env` files to exist in the `app` and `db` directories. Copy the `env.example` file to `.env` in each of the directories.
```shell
cp ./app/env.example ./app/.env
cp ./db/env.example ./db/.env
```
### Build Images
```shell
docker-compose build --build-arg ASPACE_VERSION=v3.3.1
```
NOTE: `ASPACE_VERSION=latest` is the default but `v3.3.1` is known to work with this containerization a.k.a. newer versions of ArcivhesSpace may require changes to the Dockerfiles and/or configuration files.


### Launch Application
```shell
docker-compose up -d
```
The app container may initial exit because the db and/or solr wasn't responding fast enough (ye olde start up race condition).  If that happens just chill for a bit and then restart the app:
```shell
docker-compose restart app
```
  The first time it starts, the system will take a minute or so to start up. Once it is ready, confirm that ArchivesSpace is running correctly by accessing the following URLs in your browser:

| URL                                                                                                      | Service                                                  |
|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------|
| [http://localhost:8080/](http://localhost:8080/)                                                         | the staff interface                                      |
| [http://localhost:8081/](http://localhost:8081/)                                                         | the public interface                                     |
| [http://localhost:8082/](http://localhost:8082/)                                                         | the [OAI-PMH](https://www.openarchives.org/pmh/) server  |
| [http://localhost:8089/](http://localhost:8089/)                                                         | the backend                                              |
| [~~http://localhost:8090/~~](http://localhost:8090/)                                                     | ~~the internal Solr admin console~~                      |
| [http://localhost:8091/aspace-indexer/](http://localhost:8091/aspace-indexer/)                           | the indexer                                              |
| [http://localhost:8888/archivesspace/api/](http://localhost:8888/archivesspace/api/)                     | the API documentation                                    |
| [http://localhost:8983/solr/#/](http://localhost:8983/solr/#/)                                           | the external Solr admin console                          |

To start using the Staff interface application, log in using the adminstrator account:
* Username: admin
* Password: admin

Then, you can create a new repository by selecting “System” -> “Manage repositories” at the top right hand side of the screen. From the “System” menu, you can perform a variety of administrative tasks, such as creating and modifying user accounts. Be sure to change the “admin” user’s password at this time.
### List all environment variables
```shell
docker-compose exec -- app env
docker-compose exec -- db env
docker-compose exec -- solr env
```
### Bring it all down and up again
```shell
docker-compose down
docker-compose up -d
```
Since docker-compose.yml mapping app data, db data, and solr data to volumes data is not lost between the docker ups and downs. If you wish to start from a clean slate just bring down, remove the volumes, and bring it back up again.
```shell
docker-compose down
docker volume ls
docker volume rm aspace-containerization_app-data
docker volume rm aspace-containerization_app-logs
docker volume rm aspace-containerization_db-data
docker volume rm aspace-containerization_solr-data
docker volume ls
docker-compose up -d
```
## Volumes
| Volume                             | Container | Mount               |
|------------------------------------|-----------|---------------------|
| aspace-containerization_app-data   | app       | /archivesspace/data |
| aspace-containerization_app-logs   | app       | /archivesspace/logs |
| aspace-containerization_db-data    | db        | /var/lib/mysql      |
| aspace-containerization_solr-data  | solr      | /var/solr           |
## [ArchivesSpace technical documentation](https://archivesspace.github.io/tech-docs/)
Highlights
* [Configuring ArchivesSpace](https://archivesspace.github.io/tech-docs/customization/configuration.html)
* [Serving ArchivesSpace over subdomains](https://archivesspace.github.io/tech-docs/provisioning/domains.html)
* [Running ArchivesSpace under a prefix](https://archivesspace.github.io/tech-docs/provisioning/prefix.html)
* [Serving ArchivesSpace user-facing applications over HTTPS](https://archivesspace.github.io/tech-docs/provisioning/https.html)
* [Application monitoring with New Relic](https://archivesspace.github.io/tech-docs/provisioning/newrelic.html)
## [Hello World Plug-in](https://github.com/archivesspace/archivesspace/blob/82c4603fe22bf0fd06043974478d4caf26e1c646/plugins/hello_world/README.md)

