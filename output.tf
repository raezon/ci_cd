output "jenkins_public_id" {
    description = "Public Ip of jenkins instance"
    value= aws_instance.jenkins.public_ip
}