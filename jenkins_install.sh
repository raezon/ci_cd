#!/bin/bash
sudo yum update -y
# Install OpenJDK 11
sudo amazon-linux-extras install java-openjdk11 -y
# Install wget
sudo yum -y install wget
# Install Jenkins
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
amazon-linux-extras install epel -y
sudo yum update -y
sudo yum install jenkins -y
# Start Jenkins service

# Install git
sudo yum install git -y
# Install php
sudo yum install -y php
# Install maven
cd /opt
wget https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
tar -xzvf apache-maven-3.9.4-bin.tar.gz
mv apache-maven-3.9.4 maven 

# Notice to check why user_data did not finished /var/log/cloud-init-output.log

# ./home/ec2-user/.jenkins/workspace/php/hello.php
# to find file  sudo find . -name "hello.php"
# Setup Jenkins to start at boot
chkconfig jenkins on
sudo systemctl start jenkins

#
# install jenkins cli
JENKINS_PUBLIC_IP=$(terraform output -raw jenkins_public_id)
wget http://your-jenkins-server/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s $JENKINS_PUBLIC_IP:8080/ help