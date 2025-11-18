# Capstone Project:

## 1. Containerizing the application and pushing to dockerhub
The first thing that starts this project is to create a Dockerfile that is used to build the image 'tanvirj9/journal-app:1.0'. <br>
`docker build -t tanvirj9/journal-app:1.0` <br>

The app is tested locally using the `compose.yaml` file. <br>
`docker-compose -f compose.yaml up` <br>
Following curl command are used to test if the app and postgres is working properly.
1. Create a post:  
   ```bash
   curl -X POST http://host.docker.internal:8000/entries \
   -H "Content-Type: application/json" \
   -d '{
      "work": "Kubernetes", 
      "struggle": "learning",
      "intention": "To build something" 
   }'

2. Get the post:
   ```bash
   curl -X GET http://host.docker.internal:8000/entries

Once the test succeeds, this image is pushed to the public dockerhub repository <br>
`docker push tanvirj9/journal-app:1.1` <br>
### If the above commands work, continue to the next step. 

## 2. Setting uf the Kubernetes Manifests for the app and the database.
There are two main deployments, i.e. the app-deployment and the postgres-deployment. The services of both of these deployments are written in the same file for convenience. In addition to these, two configmaps have been defined, 'db-configmap' contains the name of the database that will be used and 'db-init-configMap' contains an initial script that will be run for creating required tables if the database is empty and run for the first time. Lastly, a secrets file, 'db-secret' contains the username, password and the URL of the database that will be used by both the previously mentioned deployments.

The manifests are tested locally in minikube for ensuring proper configuration and if the configurations work properly, we move on to the next step.
   
## 3. Setting up Jenkinsfile skeleton for build, test and deploy
In this project, Jenkins will be run locally within a docker container and to run commands within the pipeline, certain installations need to be performed. 

### Setup Docker within Jenkins continer
The Jenkins container needs to be run with the `docker.sock` file attached from the host machine to the container through volumes. <br/>
1. Docker command for starting the container with attached volumes:
   ```bash
   docker run -p 8080:8080 -p 50000:50000 -d \
    --name jenkins
    -v jenkins_home:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins:lts

2. Next the permissions of the Jenkins container needs to be fixed by entering the container CLI as the root user:
   ```bash
   docker exec -u 0 -it jenkins /bin/bash

3. The permissions need to be fixed in the following way:
   ```bash 
   chmod 666 /var/run/docker.sock

Now the permissions are set properly for Jenkins to run the docker commands within  the pipeline.

### Setup Terraform within Jenkins Container

First install some dependencies before installing Terraform.
1. Login to the container as root user:
   ```bash
   docker exec -u 0 -it jenkins /bin/bash

2. Install the following:
   ```bash
   apt-get update
   apt-get install -y \
   wget \
   curl

3. Install Terraform:
   ```bash
   wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg 
   source /etc/os-release
   CODENAME=$VERSION_CODENAME
   echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] \
   https://apt.releases.hashicorp.com $CODENAME main" \
   > /etc/apt/sources.list.d/hashicorp.list
   wget -O- https://apt.releases.hashicorp.com/gpg | \
   gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg
   apt-get install -y terraform

4. Check if the installation was done correctly:
   ```bash
   terraform version

### Install AWS CLI V2

Run the following command for installing AWS CLI V2:
   `curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"`
   `unzip awscliv2.zip && ./aws/install`

Check the installation:
   `aws --version`

### Install kubectl

Run the following command for installing kubectl:
   `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
   `chmod +x kubectl && mv kubectl /usr/local/bin/`

As for this project, jenkins is being run locally in docker containers, a tunneling service, ngrok will be setup for exposing local port (like 8080) to a public HTTPS URL.

### Setup ngrok for GitHub’s webhook:
1. Install ngrok:
   ```bash
   sudo apt install snapd
   sudo snap install ngrok

The above commands are run in WSL.

2. Setup webhook in github:
   In github, settings/webhooks, the Jenkins URL should be given in the following format: "https://(path_to_jenkins)/github-webhook/".

   In Jenkins, in settings/CSRF protection, the 'Enable Proxy Compatibility' is enabled for webhooks to access Jenkins.
