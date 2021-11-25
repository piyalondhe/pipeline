resource "aws_instance" "Ansible-master" {
  count = "${var.instance_count}"
  ami = "ami-058e6df85cfc7760b"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.ingress-all-test.id}"]
  subnet_id = "${aws_subnet.subnet-connect.id}"
  user_data =file("keys.sh")
  associate_public_ip_address = true
   key_name = "ssh-connect"
  tags = {
    Name = "TerraformOS -${var.instance_name}"
  }
}



resource "null_resource" "RemoteHoststoAnsiblehosts" {
  count = "${var.instance_count}"
  connection {
    type = "ssh"
    user = "${var.ssh_user_name}"
    host = "${element(aws_instance.Ansible-master.*.public_ip, count.index)}"
    private_key = "${file("${var.ssh_key_path}")}"
  }
  provisioner "local-exec" {
    command = "echo ${element(aws_instance.Ansible-master.*.public_ip, count.index)} >> hosts" #Generating inventory file
  }
}

#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote1" {
depends_on=[null_resource.RemoteHoststoAnsiblehosts]
count = "${var.instance_count}"
  connection {
    type = "ssh"
    user = "${var.ssh_user_name}"
    host = "${element(aws_instance.Ansible-master.*.public_ip, count.index)}"
    private_key = "${file("${var.ssh_key_path}")}"
  }
#copying the hosts/inventory file to the Ansible hosts from local system
provisioner "file" {
    source      = "hosts"
    destination = "/home/ec2-user/hosts"
                   }
}


#connecting to the Ansible control node using SSH connection
resource "null_resource" "nullremote2" {
count = "${var.instance_count}"
  connection {
    type = "ssh"
    user = "${var.ssh_user_name}"
    host = "${element(aws_instance.Ansible-master.*.public_ip, count.index)}"
    private_key = "${file("${var.ssh_key_path}")}"
  }
#copying the ip.txt file to the Ansible control node from local system
provisioner "file" {
    source      ="./instance.yml"
    destination = "/home/ec2-user/instance.yml"
                   }

provisioner "file" {
    source      ="./ansible.cfg"
    destination = "/home/ec2-user/ansible.cfg"
                   }

provisioner "file" {
    source      ="./index.html"
    destination = "/home/ec2-user/index.html"
                   }


depends_on = [null_resource.RemoteHoststoAnsiblehosts]
}

resource "null_resource" "RunAnsible" {
count = "${var.instance_count}"
  connection {
    type = "ssh"
    user = "${var.ssh_user_name}"
    host = "${element(aws_instance.Ansible-master.*.public_ip, count.index)}"
    private_key = "${file("${var.ssh_key_path}")}"
  }
provisioner "remote-exec" {

    inline= ["sudo yum update -y",
             "sudo amazon-linux-extras install ansible2 -y",
             "sudo  ansible-playbook -i /home/ec2-user/hosts --private-key=/home/ec2-user/sshkey -u root  /home/ec2-user/instance.yml"]
on_failure= continue
}

}


