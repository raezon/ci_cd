java -Djenkins.install.runSetupWizard=false -jar jenkins.war

# install jenkins cli
JENKINS_PUBLIC_IP=$(terraform output -raw jenkins_public_id)
wget http://your-jenkins-server/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s $JENKINS_PUBLIC_IP:8080/ help


ExecStart=/usr/bin/java -Djava.awt.headless=true -jar /usr/lib/jenkins/jenkins.war
sudo systemctl daemon-reload