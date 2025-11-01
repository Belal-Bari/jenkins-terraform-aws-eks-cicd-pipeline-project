# Capstone Project:

## 1. Containerizing the application and pushing to dockerhub
The first thing that starts this project is to create a Dockerfile that is used to build the image 'tanvirj9/journal-app:1.0'. <br>
`docker build -t tanvirj9/journal-app:1.0` <br>

The app is tested locally using the `compose.yaml` file. <br>
`docker-compose -f compose.yaml up` <br>
Following curl command are used to test if the app and postgres is working properly.
1. Create a post:  
   ```bash
   curl -X POST http://localhost:8000/entries \
   -H "Content-Type: application/json" \
   -d '{
      "work": "Kubernetes", 
      "struggle": "learning",
      "intention": "To build something" 
   }'

2. Get the post:
    ```bash
    curl -X GET http://localhost:8000/entries

Once the test succeeds, this image is pushed to the public dockerhub repository <br>
`docker push tanvirj9/journal-app:1.1` <br>
### If the above commands work, continue to the next step. 

## 2. Setting uf the Kubernetes Manifests for the app and the database.
There are two main deployments, i.e. the app-deployment and the postgres-deployment. The services of both of these deployments are written in the same file for convenience. In addition to these, two configmaps have been defined, 'db-configmap' contains the name of the database that will be used and 'db-init-configMap' contains an initial script that will be run for creating required tables if the database is empty and run for the first time. Lastly, a secrets file, 'db-secret' contains the username, password and the URL of the database that will be used by both the previously mentioned deployments.

The manifests are tested locally in minikube for ensuring proper configuration and if the configurations work properly, we move on to the next step.
   
## 3. Setting up Jenkinsfile skeleton for build, test and deploy
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
