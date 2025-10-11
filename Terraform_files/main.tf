resource "aws_instance" "test-server" {
  ami = "ami-0360c520857e3138f"
  instance_type = "t2.micro"
  key_name = "bank"
  vpc_security_group_ids = ["sg-00fc35b46c299fc5b"]
  connection {
     type = "ssh"
     user = "ubuntu"
     private_key = file("./bank.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/financeme/Terraform_files/ansibleplaybook.yml"
     }
  }
