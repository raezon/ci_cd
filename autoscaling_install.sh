#!/bin/bash
sudo yum update -y
sudo yum install python -y 
sudo amazon-linux-extras install ansible2
sudo  install ansible2
sudo yum install docker -y
sudo yum install -y php
sudo su -
user="ansibleuser"
password="amar500G"
adduser $user
echo $password | passwd --stdin $user
sudo su - ansibleuser
logout
sudo usermod -aG docker ansibleuser
# add this after 

line_number=4 
 # Change this to the desired line number

# Define the code you want to insert
new_code="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa+mnH+j0PRpwztoYxZpB5xfmmSY+u3V1pWX1liEs7OxaqWBcFCcZeMOh3Ce3nWANjyUw6rUFZCg3RHXme7ZH2ZgOhWL5fhsyC1PPO8S9yeQWDsGkGV0RANzxYlNghmFjuFDMv3Wh5+GL9xOgxho2oe3EpJ64thF9cGhhRtRiEBZo+XN1BwIFl17HZavw45GTIzNLVvf1JsrBcSfiSkgTu5rperyxaBiT6wPOsPupquy/wlxL+gobFkU+ltm9r3guCMTOhjSNkphjzswSFXWGRNiPJpeWlNCJmqusRublxosKBbcbu5qOS7G6tgAwUqz6j0fUe8kriBxInBh/e9qUp ansibleuser@ansible"  # Change this to your desired code

authorized_keys_file="/root/.ssh/authorized_keys"

# Define the SSH key you want to update (replace with your SSH key)
ssh_key="no-port-forwarding,no-agent-forwarding,no-X11-forwarding,command=\"echo 'Please login as the user \\\"ec2-user\\\" rather than the user \\\"root\\\".';echo;sleep 10;exit 142\" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIt6QR+zU0rcdB/v5RLKIoqj2pHP3eucWvMKBI1i5BtvYF4ncAnKQVdED2E7TXrrDNQTD8jy6iBTIQMAVh9d/uY7aqMbqtkLJWskSEfu9J0tGCupSS8jCju5kTPzvPTXGJc42nJmPFKGXhuZjPwZc3zHflTHHTY5BZfzdwdFPJhqIlP/a4eGnqvwZUMB1dl7yGJx6pT/1ZtWOGC+UTzUtj7G/0u2xYrBD8gAV93157PDqCGG6r5j0rlZmBEXu2Cio9l+WgT66rPOr37G/WUtEcEQapI0Nrb7g9U1wI7d6C+4iI6VpopRsayHPjGGDIPJWa/B7crhcSPQNaKihgzkrx api_auth"

# think on making it dynamic
sudo sh -c "echo '$new_code' >> authorized_keys"
echo "New command inserted for the SSH key."


#start docker
sudo service docker start
# configure aws cli

# Set AWS access key ID
AWS_ACCESS_KEY_ID="AKIAUCSQQOVVGULITLEI"
# Set AWS secret access key
AWS_SECRET_ACCESS_KEY="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"
# Set AWS default region
AWS_DEFAULT_REGION="eu-central-1"
# Set AWS CLI output format
AWS_OUTPUT_FORMAT="json"
# Configure AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION
aws configure set default.output $AWS_OUTPUT_FORMAT

cd /home/ansibleuser
# Create an empty file named "example.txt"
touch cd_playbook.yml

# Append more text to the file
echo "
- name: Push a php app to ecr
  hosts: all
  #become: yes  # This will run the tasks with sudo or root privileges
  
  tasks:
    - name: stop running container if existent
      command: docker stop application_container
      ignore_errors: yes
      
    - name: remove stopped container
      command: docker rm application_container
      ignore_errors: yes

    - name: remove docker images
      command: docker rmi 280415466858.dkr.ecr.eu-central-1.amazonaws.com/docker_repository:latest docker_repository -f
      ignore_errors: yes

    - name: pull images from ecr
      command: docker pull  280415466858.dkr.ecr.eu-central-1.amazonaws.com/docker_repository:latest

    - name: docker run new container
      command: docker run -d --name application_container -p 8080:8080  280415466858.dkr.ecr.eu-central-1.amazonaws.com/docker_repository:latest
" >> cd_playbook.yml

touch index.php

echo "
<?php
echo 'ya hamid';
" >> index.php

sudo php -S "0.0.0.0:80"