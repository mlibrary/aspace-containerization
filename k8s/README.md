# [MITS Container Service](https://its.umich.edu/computing/virtualization-cloud/container-service/)
## k8s folder
### database_url_secret.yml
You'll need to modify this file locally to replace the `<archivesspace_password>` placeholder with the actually password for the database user `archivesspace`.

Be careful not to commit the `database_url_secret.yml` file to the repository with the **actual plain text password**.
### deployment.yml
This file is dependent upon on the above database URL secret. It will deploy the archivesspace *vanilla* application and its supporting external Solr service.
## Deploy to [Red Hat OpenShift Service on AWS](https://containers.aws.web.umich.edu/)
### +Add Secret
From the `Developer` view click `+Add` in the left menu and select `Import YAML` under `From Local Machine`. Copy and paste the contents of `database_url_secret.yml` and click the `Create` button.
### +Add Deployment
From the `Developer` view click `+Add` in the left menu and select `Import YAML` under `From Local Machine`. Copy and paste the contents of `deployment.yml` and click the `Create` button.
### Create Routes
From the `Administrator` view under `Networking` click `Routes`. Click the `Create Route` button to add routes to the service `aspace`.
### Verify Deployment
From the `Developer` view click `Topology`. Select the `app` which is listed under `Deployment` which should reveal a right side panel. In the right click the links under `Routes` to verify archivesspace is running.
