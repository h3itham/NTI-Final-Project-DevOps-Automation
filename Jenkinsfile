pipeline {
    agent any
    environment {
        REPOSITORY_URI = ''
    }

    stages {
        stage('Build Dockerfile') {
            steps {
                // CHANGE USERNAME AND PASSWORD IN SETTINGS.PY FILE 
                withCredentials([usernamePassword(credentialsId: 'DATABASE', passwordVariable: 'DB_PASS', usernameVariable: 'DB_USER')]) {
                    script {
                        sh "sed -i \"s/DB_PASSWORD/${env.DB_PASS}/\" django/config/settings.py"
                        sh "sed -i \"s/DB_USERNAME/${env.DB_USER}/\" django/config/settings.py"
                        echo "Database Credential Changed!"
                    }
                }
                // BUILD THE DOCKER IMAGE
                sh 'docker build -t app  .'
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
                    sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $REPOSITORY_URI"
                }
            }
        }
        stage('Tag and Push Image to ECR') {
            steps {
                script {
                    // TAG THE NGINX IMAGE WITH THE REPOSITORY URI AND BUILD NUMBER 
                    sh "docker tag app:latest $REPOSITORY_URI:$BUILD_NUMBER"
                    // PUSH THE TAGGED IMAGE TO OUR ECR REPOSITORY
                    sh "docker push $REPOSITORY_URI:$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // CHANGING IMAGE TO IMAGE ASSOCIATED TO THE CURRENT BUILD NUMBER 
             sh "sed -i \"s|IMAGE|$REPOSITORY_URI:$BUILD_NUMBER|\" k8s/deployment.yaml"
                // AUTHENTICATE OUR CLUSTER WITH JENKINS MACHINE
                sh 'aws eks update-kubeconfig --name NTI-Cluster'
                // APPLY DEPLOYMENT AND SERVICE
                sh 'kubectl apply -f ./k8s/deployment.yaml'
                sh 'kubectl apply -f ./k8s/service.yaml'
                sh 'kubectl get svc'
            }
        }
    }
    post {
        // ALWAYS SEND AN EMAIL TO DEVELOPER WHICH CONTAIN VITAL INFORMATION SUCH AS THE BUILD STATE, 
        // BUILD NUMBER AND TIME OF PIPELINE EXECUTION 
        always {
            emailext(
                subject: "Pipeline status: ${currentBuild.result}",
                body: """<html>
                        <body>
                            <p> Build Number: ${BUILD_NUMBER} </p>
                            <p> Date and time of pipeline execution: ${BUILD_TIMESTAMP} </p>
                        </body>
                        </html>""",
                to: 'haithamelabd@outlook.com',
                from: 'jenkins@haitham.com',
                replyTo: 'jenkins@haitham.com',
                mimeType: 'text/html'
            )
        }
    }
}
