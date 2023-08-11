# SonarQube Integration With Jenkins:

In this phase, we will learn how to install SonarQube and How to integrate with Jenkins.

This phase includes installation and integration.

### SonarQube:

SonarQube is a self-managed, automatic code review tool that systematically helps you deliver clean code. SonarQube integrates into your existing workflow and detects issues in your code to help you perform continuous code inspections of your projects. Organizations start off with a default set of rules and metrics called the Sonar Way Quality Profile. This can be customized per project to satisfy different technical requirements. Issues raised in the analysis are compared against the conditions defined in the quality profile to establish your quality gate.

A Quality Gate is an indicator of code quality that can be configured to give a go/no-go signal on the current release-worthiness of the code. It indicates whether your code is clean and can move forward.

A passing (green) quality gate means the code meets your standard and is ready to be merged.

A failing (red) quality gate means there are issues to address.

      
      


## Prerequisites
* An AWS T2.Medium EC2 instance (Ubuntu).

* Open port 9000 in the security group.

## Installation

* Login to the instance as a Ubuntu user.

 * Using docker we have to install the SonarQube.

* Install Docker in the instance.


```bash
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo usermod -aG docker ubuntu
sudo systemctl status docker

```
* Install docker-compose
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
* Change permission and check the version of docker.

```bash
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```
* Install SonarQube

```bash
sudo sysctl -w vm.max_map_count=262144
mkdir sonar
cd sonar
vim docker-compose.yml
sudo docker–compose up
docker ps
```
* update docker-compose.yml
```bash
version: '2'
services:
  sonarqube:
    image: sonarqube
    ports:
      - '9000:9000'
    networks:
      - sonarnet
    environment:
      - sonar.jdbc.username=sonar
      - sonar.jdbc.password=sonar
      - sonar.jdbc.url=jdbc:postgresql://db:5432/sonar
    volumes:
      - sonarqube_conf:/opt/sonarqube/conf
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
    ulimits:
      nofile:
       soft: 65536
       hard: 65536
  db:
    image: postgres
    networks:
      - sonarnet
    environment:
      - POSTGRES_USER=sonar
      - POSTGRES_PASSWORD=sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data

networks:
  sonarnet:
    driver: bridge

volumes:
  sonarqube_conf:
  sonarqube_data:
  sonarqube_extensions:
  postgresql:
  postgresql_data:
```
After Setup the SonarQube, You can get the sonarqube login page on http://IP-ADDRESS:9000

![App screenshot](https://snipboard.io/wvnPhL.jpg)

> **Use admin as USER and admin as PASSWORD for Initial login.**
## INTEGRATION OF SONARQUBE WITH JENKINS:
Install suitable plugins for the Sonarqube server and scanner.

Restart the Jenkins server.

From the Jenkins Dashboard, navigate to Manage Jenkins > Manage Plugins and install the SonarQube Scanner plugin.

Back at the Jenkins Dashboard, navigate to Credentials > System from the left navigation.

Click the Global credentials (unrestricted) link in the System table.

Click Add credentials in the left navigation and add the following information:

Use secret text.

Secret: Generate a token at User > My Account > Security in SonarQube, and copy and paste it here.

You will find the token in the SonarQube Settings.

![App Screenshot](https://snipboard.io/l8hg0K.jpg)

From the Jenkins Dashboard, navigate to Manage Jenkins > Configure System.

From the SonarQube Servers section, click Add SonarQube.

> Name: Give a unique name to your SonarQube instance.

> Server URL: Your SonarQube instance URL.

> Credentials: Select the credentials created for Sonarqube.

![App Screenshot](https://snipboard.io/rlL7Sa.jpg)




Then you need to update the SonarQube Scanner in Jenkins Tools.

![App Screenshot](https://snipboard.io/xhNWPR.jpg)



Once you Configure these things, you can create the pipeline for the SonarQube Integration with Jenkins.





You can refer to this link for creating the pipeline [sonar documentation](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/jenkins-extension-sonarqube)

> **Once you build the code and run the pipeline. If your file contains any bugs or any other issues you can find in your sonarqube server.** 

![App Screenshot](https://snipboard.io/0OJ6yr.jpg)
# JFrog Integration With Jenkins

In this phase, we will learn how to install SonarQube and How to integrate with Jenkins.

This phase includes installation and integration.


### JFrog:

JFrog Artifactory is a universal DevOps solution providing end-to-end automation and management of binaries and artifacts through the application delivery process that improves productivity across your development ecosystem.

It enables freedom of choice supporting 25+ software build packages, all major CI/CD platforms, and DevOps tools you already use.

Artifactory is Kubernetes ready supporting containers, Docker, Helm Charts, and is your Kubernetes and Docker registry and comes with full CLI and REST APIs customizable to your ecosystem.
## Pre-requisites

* Choose at least medium instance type (4GB RAM)

* Ports 8081 and 8082 needs to be opened.

* 8081 for Artifactory REST APIs.

* 8082 for everything else (UI, and all other product’s APIs).
## Installation
* Install Docker on Ubuntu

```bash
sudo apt-get update && sudo apt install docker.io -y
sudo usermod -aG docker $USER
docker --version
```
* Download Artifactory Docker image


```bash
sudo docker pull docker.bintray.io/jfrog/artifactory-oss:latest
sudo docker images
```
* Create Data Directory

```bash 
sudo mkdir -p /jfrog/artifactory
sudo chown -R 1030 /jfrog/
```
* Start JFrog Artifactory container
```bash
sudo docker run --name artifactory -d -p 8081:8081 -p 8082:8082 \ -v /jfrog/artifactory:/var/opt/jfrog/artifactory \docker.bintray.io/jfrog/artifactory-oss:latest
```
* Run Artifactory as a service
```bash
sudo vi /etc/systemd/system/artifactory.service
```
* Add the file to /etc/systemd/system/artifactory.service
```bash
[Unit]
Description=Setup Systemd script for Artifactory Container
After=network.target
[Service]
Restart=always
ExecStartPre=-/usr/bin/docker kill artifactory
ExecStartPre=-/usr/bin/docker rm artifactory
ExecStart=/usr/bin/docker run --name artifactory -p 8081:8081 -p 8082:8082 \-v /jfrog/artifactory:/var/opt/jfrog/artifactory \docker.bintray.io/jfrog/artifactory-oss:latest
ExecStop=-/usr/bin/docker kill artifactory
ExecStop=-/usr/bin/docker rm artifactory
[Install]
WantedBy=multi-user.target
```
* Reload Systemd
```bash
sudo systemctl daemon-reload
```
* Then start Artifactory container with systemd.
```bash
sudo systemctl start artifactory

```
* Enable it to start at system boot.
```bash
sudo systemctl enable artifactory
```
* Check whether Artifactory is running? 
```bash
sudo systemctl status artifactory
```

 After Setup the JFrog Artifactory, You can get the JFrog Artifactory login page in your screen on http://yourinstanceip:8081

 ![App Screenshot](https://snipboard.io/SIrGyd.jpg)

> **Use admin as User and admin as passowrd for login afterthat you can change the password.**
### INTEGRATE ARTIFACTORY WITH JENKINS

You can now login to a Jenkins instance. Install the Artifactory plug-in with the help of the below path Manage Jenkins ->Jenkins Plugins->available ->artifactory.

![App Screenshot](https://miro.medium.com/v2/resize:fit:828/0*uiENl_EZn_0Dv7vI)


To create a token in Jfrog , Go to Jfrog Platform -> Administration -> User Management -> Access Tokens -> Add Description and add username through which you login into jfrog account and add the Expiration time and Generate Token.

![App Screenshot](https://snipboard.io/tBgfCN.jpg)

Go to Manage Jenkins-> Manage Credentials-> Choose Secret Text type credential and add the token and  add ID and Description.


Configure the JFrog Artifactory with username and password.

![App Screenshot](https://snipboard.io/Gtmf74.jpg)

You need to add Jfrog URL & Deployer Credentials in System Configuration with the help of the below path: Manage Jenkins -> System Configuration -> JFrog Platform Instances.

![App Screenshot](https://snipboard.io/CgwrZj.jpg)



In Jfrog Platform , we will now create different repositories ( Go to Administration -> Repositories -> Create a Local Generic Repository. 

Mention this Repository to the upload the artifacts that are created in the jenkins pipeline.

![App Screenshot](https://snipboard.io/HGDXEl.jpg)

You can refer this link to install the plugins and set the Artifactory in Jenkins:  [JFrog Plugins](https://plugins.jenkins.io/jfrog/)



You can Refer the link to build the declarative pipeline:
[pipeline documentation](https://jfrog.com/help/r/jfrog-integrations-documentation/working-with-pipeline-jobs-in-jenkins)

**Once you build the code and run the pipeline. You will find the file in your JFrog Artifactory.** 

![App Screenshot](https://snipboard.io/FZqSpC.jpg)
