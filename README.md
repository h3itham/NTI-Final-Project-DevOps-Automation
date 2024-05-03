## Table of Contents

1. [Project Architecture](#project-architecture)
2. [Introduction](#introduction)
3. [Project Features](#project-features)
4. [Infrastructure Overview](#infrastructure-overview)
5. [Ansible Playbooks](#ansible-playbooks)
6. [Jenkins CI/CD Pipelines](#jenkins-cicd-pipelines)
7. [Docker Compose](#docker-compose)
8. [Screenshots](#screenshots)

## 1. Project Architecture <a name="project-architecture"></a>
here the project image will be here and terraform graph i will add it also

## 2. Introduction <a name="introduction"></a>
This project is the final project for the DevOps and Automation track at the National Telecommunication Institute [NTI](https://www.nti.sci.eg/), under the supervision of the Ministry of Communications and Information Technology. The track started in February 2024, and this project aims to apply the knowledge, tools, and practices learned during the initiative. 

## 3. Project Features <a name="project-features"></a>
* **End-to-end automation** is key in ensuring smooth software delivery from development to deployment. By automating tasks like building, testing, and deploying code, updates are delivered quickly and consistently with little manual effort

* **Infrastructure as Code (IaC)** principles are employed to manage and provision infrastructure resources efficiently and effectively. I use terraform to achive this. 
* **Continuous Integration and Continuous Delivery (CI/CD)** practices are integral components of my project, enabling early detection of issues. CD automates the deployment process, facilitating frequent and reliable releases of software updates to production environments.


## 4. Infrastructure Overview <a name="infrastructure-overview"></a>
In building Project infrastructure, I adopt a modular approach to ensure scalability, flexibility, and ease of management. Each module serves a specific function and contributes to the overall architecture of our system.

#### VPC Module

The Virtual Private Cloud (VPC) module establishes a virtual network environment in the AWS cloud, providing isolated resources. Additionally, an internet gateway is created within the VPC module to enable communication between the VPC and the internet, allowing for seamless access to external resources.

#### Subnets Module
 I have established six subnets: two public subnets for hosting Jenkins and a bastion host, two private subnets for the Elastic Kubernetes Service (EKS), and two private subnets for Amazon RDS instances. 

#### srv Module

 Within this module, I have created two instances: one for Jenkins and another for the bastion host. Additionally, a local file resource has been configured to generate the inventory file, facilitating seamless management and configuration of our infrastructure components.
#### Database Module
In This module I use MySQL RDS instances to securely store and manage application data.

#### ECR Module

The Elastic Container Registry module creates repositories for storing Docker images, facilitating efficient distribution and deployment of containerized applications.

#### EKS Module
IN This Module I provisioned EKS Additionally, a node group with auto-scaling capabilities is created within this module. All necessary roles required for the EKS cluster to operate seamlessly are also assigned, optimizing the performance and reliability of the cluster.

#### Backup Module

This module crate cron job  to take a backup of the Jenkins server every workday, with the following schedule: cron(0 5 ? * SUN-THU *). This ensures that regular backups are taken during weekdays.
## 5. Ansible Playbooks <a name="ansible-playbooks"></a>
In this section, I use Ansible playbooks to automate the installation and configuration of Jenkins and Cloud Watch agent. 
* **Jenkins Installation Playbook** This playbook  is responsible for installing and configuring Jenkins on the designated EC2 instance. It automates the setup process, ensuring that Jenkins is provisioned with configurations to facilitate continuous integration and deployment workflows.
* **CloudWatch Agent Installation Playbook** This playbook automates the installation and configuration of the CloudWatch agent on Jenkins and bastion host. It enables the monitoring of system metrics and log files, providing valuable insights into the health and performance of our environment.
## 6. Jenkins CI/CD Pipelines <a name="jenkins-cicd-pipelines"></a>
I create jenkins pipeline with the following stages 
1. **Build Dockerfile**:
   - This step prepares our application by configuring database credentials and building the Docker image.
   - It ensures that the necessary credentials are securely embedded within the application.

2. **Get Repository URI**:
   - This step retrieves the URI of the Amazon ECR repository where the Docker image will be stored.
   - It prepares for the authentication and pushing of the Docker image to the repository.

3. **Authenticate with AWS ECR**:
   - This step authenticates Jenkins with AWS ECR using the retrieved repository URI.
   - It enables Jenkins to push the Docker image to the repository securely.

4. **Tag and Push Image to ECR**:
   - This step tags the Docker image with the build number and pushes it to the specified repository in AWS ECR.
   - It ensures that the latest version of the application is stored in the repository for deployment.

5. **Deploy to Kubernetes**:
   - This step updates the Kubernetes deployment YAML file with the latest image tag.
   - It authenticates Jenkins with the Amazon EKS cluster and applies the updated deployment and service configurations.
   - It ensures that the latest version of the application is deployed and accessible within the Kubernetes cluster.

6. **Post-build Actions (Email Notification)**:
   - This step sends an email notification to the developer with vital information about the pipeline's execution.
   - It provides visibility into the pipeline's status, build number, and execution time, allowing for effective monitoring and communication.

## 7. Docker Compose <a name="docker-compose"></a>

1. **nginx Service**
 This service builds the nginx container using the Dockerfile located in the ./nginx directory. It exposes port 80 for HTTP traffic and depends on the django_app service.

2. **django_app Service** This service uses the django_app image and builds the container using the Dockerfile located in the ./django directory. It exposes port 8001 for Django application traffic and runs the Gunicorn server to serve the Django application. It depends on the db service and loads environment variables from the .env file located in the ./django directory.

3. **db Service** In this services I use the mysql image to run the MySQL database container. It sets the root password and defines the database name. It mounts a volume to persist the database data in the ./data/mysql/db directory.


