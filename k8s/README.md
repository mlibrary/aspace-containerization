## Deployment

This documents how to deploy ArchivesSpace using the 
[MITS Container Service](https://its.umich.edu/computing/virtualization-cloud/container-service/).
Perform the steps described in the sections below in order.
You can access the [Red Hat OpenShift Service on AWS here](https://containers.aws.web.umich.edu/).
### Create `.env.deployment` file
Create a `.env.deployment` file using `env.example` as a template and place it in `k8s`.
Modify values as needed for the OpenShift project you are setting up.
```shell
cp app/env.example k8s/.env.deployment
open k8s/.env.deployment
```
### Create OpenShift resources using the OpenShift CLI
After updating the database secret, you can use a single command to create resources in OpenShift
based on the Kubernetes objects in the `app` and `solr` directories.
The [`oc` command line interface](https://docs.openshift.com/container-platform/4.13/cli_reference/openshift_cli/getting-started-cli.html#installing-openshift-cli) is required.
For MacOS users, installation using [Homebrew](https://formulae.brew.sh/formula/openshift-cli) is recommended.

Once the CLI is installed, follow these steps.
1. Login in on the command line.
    1. From the OpenShift GUI, click on the dropdown with your username in the top-right hand corner of the window, and then select "Copy Login Command".
    1. Select the "umich-openid" button.
    1. Select the "Display Token" link.
    1. Copy the command beginning with `oc login --token=...`.
    1. Paste and run the command in your terminal.
1. Switch to the correct OpenShift project.
    ```shell
    oc project archivesspace
    ```
1. Create a secret based on the previously created `.env.deployment` file.
    ```shell
    oc create secret generic app-secret --from-env-file=k8s/.env.deployment
    ```
1. Issue the following command from the root of the repository.
    ```shell
    oc apply -f k8s -R --validate
    # Note you can add --dry-run=client to test how the command would affect the project.
    ```
### Create Routes
From the `Administrator` view under `Networking` click `Routes`. Click the `Create Route` button to add routes to the service `aspace`.
### Verify Deployment
From the `Developer` view click `Topology`. Select the `app` which is listed under `Deployment` which should reveal a right side panel. In the right click the links under `Routes` to verify archivesspace is running.
