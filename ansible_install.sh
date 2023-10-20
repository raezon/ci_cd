#!/bin/bash
sudo yum update -y
sudo yum install python -y 
sudo amazon-linux-extras install ansible2
sudo  install ansible2
sudo yum install docker -y
sudo su -
user="ansibleuser"
password="amar500G"
adduser $user
echo $password | passwd --stdin $user
sudo su - ansibleuser
logout
sudo usermod -aG docker ansibleuser
# to grant ansibleuser permissions
line_number=101 
 # Change this to the desired line number

# Define the code you want to insert
new_code="ansibleuser ALL=(ALL) ALL"  # Change this to your desired code

# Use the 'sed' command to insert the code at the specified line number
sudo sed -i "${line_number}i${new_code}" /etc/sudoers

# Save the changes
echo "Code inserted at line $line_number in /etc/sudoers"
# to update PasswordAuthentication no to PasswordAuthentication yes 
sudo sed -i 's/^#*PasswordAuthentication[[:space:]]no/PasswordAuthentication yes/' /etc/ssh/sshd_config
# comment password no and uncomment password yes
service sshd reload
sudo service docker start