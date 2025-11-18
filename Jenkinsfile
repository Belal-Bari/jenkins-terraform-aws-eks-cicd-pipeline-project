pipeline {
  agent any
  triggers {
    githubPush()
  }
  environment {
    BUILD_NUMBER = "${env.BUILD_NUMBER}" 
  }
  stages {
    stage ('Build & Test') {
      steps {
        script {
          echo "Building the app and testing..."
          sh "docker build -t tanvirj9/journal-app:1.0.${BUILD_NUMBER}"
          sh '''
            docker compose -f compose.yaml up -d
            sleep 5
            curl -X POST http://host.docker.internal:8000/entries \
            -H "Content-Type: application/json" \
            -d '{
                "work": "Kubernetes", 
                "struggle": "learning",
                "intention": "To build something" 
            }'
            curl -X GET http://host.docker.internal:8000/entries
            echo "test successful" 
            
          '''
        }
      }
    }
    stage ("Docker push") {
      steps {
        script {
          echo "Pushing to Docker Registry"
          def version = "1.0.${BUILD_NUMBER}"
          sh "docker push tanvirj9/journal-app:${version}"
          sh "docker compose -f compose.yaml down"
        }
      }
    }
    stage ("Provisioning") {
      steps {
        script {
          withCredentials([
            string(credentialsId: 'vpc_cidr_block', variable: 'VPC_CIDR'),
            string(credentialsId: 'private_subnet_cidr_blocks', variable: 'PRIVATE_SUBNETS'),
            string(credentialsId: 'public_subnet_cidr_blocks', variable: 'PUBLIC_SUBNETS')
          ]) {
                sh """
                    terraform plan -auto-approve \
                      -var "vpc_cidr_block=${VPC_CIDR}" \
                      -var "private_subnet_cidr_blocks=${PRIVATE_SUBNETS}" \
                      -var "public_subnet_cidr_blocks=${PUBLIC_SUBNETS}"
                  """
                // sh """
                //     terraform apply -auto-approve \
                //       -var "vpc_cidr_block=${VPC_CIDR}" \
                //       -var "private_subnet_cidr_blocks=${PRIVATE_SUBNETS}" \
                //       -var "public_subnet_cidr_blocks=${PUBLIC_SUBNETS}"
                //   """
          }
        }
      }
    }
    // stage ('Build Image') {
    //   steps {
    //     echo "building image..."
    //     // script {
    //     //   echo "Building the docker image..."
    //     //   withCredentials([usernamePassword(credentialsId: 'docker_hub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
    //     //     sh '''
    //     //       docker build -t tanvirj9/test-app:1.0 .
    //     //       echo "$PASS" | docker login -u $USER --password-stdin
    //     //       docker push tanvirj9/test-app:1.0
    //     //     '''
    //     //   } 
    //     // }
    //   }
    // }
    stage ('Deploy') {
      steps {
        script {
          echo "Deploying..."
        }
      }
    }
  }
}
