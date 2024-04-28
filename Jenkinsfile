pipeline {
    agent any

    environment {
        REPOSITORY_URI = ''
    }

    stages {
        stage('Build Dockerfile') {
            steps {
                // BUILD THE DOCKER IMAGE
                sh 'cd django/'
                sh 'docker build -t app .'
            }
        }
        stage('Get Repository URI') {
            steps {
                script {
                    // GET THE REPOSITORY URI AND STORE IT IN AN ENVIRONMENT VARIABLE
                    REPOSITORY_URI = sh(
                        script: 'aws ecr describe-repositories --repository-names nti-project --query "repositories[0].repositoryUri" --output text',
                        returnStdout: true
                    ).trim()
                }
            }
        }
        stage('Authenticate with AWS ECR') {
            steps {
                script {
                    // USE THE REPOSITORY URI FROM THE ENVIRONMENT VARIABLE
                    sh "aws ecr get-login-password --region us-east-1 \
                     | docker login --username AWS --password-stdin $REPOSITORY_URI"
                }
            }
        }
        stage('Tag and Push Image to ECR') {
            steps {
                script {
                    // Tag the nginx image with the repository URI
                    sh "docker tag app:latest $REPOSITORY_URI:$BUILD_NUMBER"
                    // Push the tagged image to our ECR repository
                    sh "docker push $REPOSITORY_URI:$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // AUTHENTICATE OUR CLUSTER WITH JENKINS MACHINE 
                sh 'aws eks update-kubeconfig --name NTI-Cluster'
                // APPLY DEPLOYMENT AND SERVICE 
                sh 'kubectl apply -f ./k8s/deployment.yaml'
                sh 'kubectl apply -f ./k8s/service.yaml'
                sh 'kubectl get svc'
            }
        }
    }
}
