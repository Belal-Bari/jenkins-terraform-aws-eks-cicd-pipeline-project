pipeline {
  agent any
  stages {
    stage ('Build') {
      steps {
        script {
          echo "Building the app and testing..."
          sh '''
            docker compose -f compose.yaml up -d
            sleep 5
            curl -X GET http://host.docker.internal:8000/entries
            docker compose -f compose.yaml down -d
          '''
        }
      }
    }
    stage ("Test") {
      steps {
        echo "Testing"
        // script {
        //   sh '''
        //     node app.js &
        //     sleep 5
        //     curl http://localhost:3001/
        //   '''
        // }
      }
    }
    stage ('Build Image') {
      steps {
        echo "building image..."
        // script {
        //   echo "Building the docker image..."
        //   withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        //     sh '''
        //       docker build -t tanvirj9/test-app:1.0 .
        //       echo "$PASS" | docker login -u $USER --password-stdin
        //       docker push tanvirj9/test-app:1.0
        //     '''
        //   } 
        // }
      }
    }
    stage ('Deploy') {
      steps {
        script {
          echo "Deploying..."
        }
      }
    }
  }
}
