# ssh of jenkins is on /root/.ssh
# we need to think about a way to automate the jenkins via cli to install plugin
# we need to think for a way to automate the creation of hostname
# we need to think for a way to automate the authorized_key for uniderictional connection
# we need to think for a way to create a pipeline via sh
vi ci_playbook.yml
cd /etc/ansible
sudo vi hosts
ssh-copy-id ansibleuser@localhost
cd /home

ansible-playbook cd_playbook.yml

