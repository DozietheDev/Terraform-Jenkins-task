pipeline {
  agent any

  environment {
    AWS_REGION       = 'us-east-1'
    ECR_REPO_PREFIX  = 'myorg'
    CLUSTER_NAME     = 'notify-cluster'
    AWS_CREDENTIALS  = credentials('aws-credentials-id') // Jenkins IAM user with least privilege
    AWS_ACCOUNT_ID   = '123456789012' // replace with your AWS Account ID or inject as a secret/env var
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Detect Services') {
      steps {
        script {
          services = sh(script: "find . -type f -name 'Dockerfile' | sed 's|/Dockerfile||' | sed 's|^./||'", returnStdout: true).trim().split('\n')
          echo "Detected services: ${services}"
        }
      }
    }

    stage('Build, Scan, and Push Images') {
      steps {
        script {
          services.each { service ->
            def imageName = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_PREFIX}/${service}"
            def imageTag = "latest"

            sh """
              set -e

              # Create ECR repo if not exists
              if ! aws ecr describe-repositories --repository-names ${ECR_REPO_PREFIX}/${service} --region ${AWS_REGION} > /dev/null 2>&1; then
                aws ecr create-repository --repository-name ${ECR_REPO_PREFIX}/${service} --region ${AWS_REGION}
              fi

              # Authenticate Docker to ECR
              aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

              # Build Docker image
              docker build -t ${imageName}:${imageTag} ${service}

              # Scan image for vulnerabilities (requires trivy installed on Jenkins agent)
              trivy image --exit-code 1 --severity HIGH,CRITICAL ${imageName}:${imageTag} || (echo "Vulnerabilities found, failing build." && exit 1)

              # Push image to ECR
              docker push ${imageName}:${imageTag}
            """
          }
        }
      }
    }

    stage('Deploy to ECS') {
      steps {
        script {
          services.each { service ->
            def imageUri = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_PREFIX}/${service}:latest"

            sh """
              set -e

              # Fetch existing task definition JSON
              TASK_DEF_JSON=$(aws ecs describe-task-definition --task-definition ${service} --region ${AWS_REGION} --query 'taskDefinition' | jq '.containerDefinitions[0].image="${imageUri}"')

              # Save modified task definition to a temp file
              echo "${TASK_DEF_JSON}" > task-def.json

              # Register new task definition revision
              NEW_TASK_DEF_ARN=$(aws ecs register-task-definition --cli-input-json file://task-def.json --region ${AWS_REGION} --query 'taskDefinition.taskDefinitionArn' --output text)

              # Update ECS service to use new task definition
              aws ecs update-service --cluster ${CLUSTER_NAME} --service ${service} --task-definition ${NEW_TASK_DEF_ARN} --region ${AWS_REGION}
            """
          }
        }
      }
    }
  }

  post {
    failure {
      mail to: 'devops@dozie.com',
           subject: "Build Failed in Jenkins: ${env.JOB_NAME}",
           body: "Check Jenkins for details: ${env.BUILD_URL}"
    }
  }
}
