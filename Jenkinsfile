pipeline {
    agent any

    stages {
        stage('Build Dockerfile') {
            steps {
                sh 'sudo docker build -t app .'
            }
        }

        stage('Push image to ECR') {
            steps {
                // EXPORT ECR REPO URI IN THE TERMINAL TO USE IT IN ALL FOLLOWING STEPS 
                sh "repo_uri=\$(aws ecr describe-repositories --repository-names nti-project --query 'repositories[0].repositoryUri' --output text)"
                // AUTHENTICATE WITH AWS ECR WITH AWS CLI CREDENTIAL 
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $repo_uri'
                // TAG IMAGE WITH THE ECR REPO URI AND NAME 
                sh 'docker tag nginx:latest $repo_uri'
                // PUSH IMAGE TO OUR ECR 
                sh 'docker push $repo_uri' 
    }
}


        stage('Deploy to Kubernetes') {
            steps {
                // AUTHENTICATE OUR CLUSTER WITH JENKINS MACHINE 
                sh 'aws eks update-kubeconfig --name NTI-Cluster'
                // CHANGE IMAGES IN SIDE DEPLOYMENT MAINFEST FILE 
                sh 'sed -i "s/IMAGE/${repo_uri}/g" ./k8s/deployment.yaml'
                // APPLY DEPLOYMENT AND SERVICE 
                sh 'kubectl apply -f ./k8s/deployment.yaml'
                sh 'kubectl apply -f ./k8s/service.yaml'
            }
        }
    }
}
