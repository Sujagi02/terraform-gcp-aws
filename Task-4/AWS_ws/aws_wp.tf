resource "aws_instance" "wp" {
	ami = "ami-06a0b4e3b7eb7a300"
    key_name = "task-2" 
	instance_type = "t2.micro"

	tags = {
	    Name = "Wordpress_task4"
          }

connection {
	type = "ssh"
	user = "ec2-user"
	private_key = file("C:/Users/sujag/Downloads/task-2.pem")
	host = aws_instance.wp.public_ip   
    }

provisioner "remote-exec" {
	inline = [
	    "sudo yum install httpd php php-mysqlnd php-json wget -y", 
		"sudo wget https://wordpress.org/latest.tar.gz",
		"tar -xzvf latest.tar.gz",
		"sudo mv wordpress/* /var/www/html/",
		"sudo chown -R apache.apache /var/www/html",
		"sudo setenforce 0",
		"sudo systemctl start httpd"
           ]
       }
}

output "wp_public_ip" {
    value = aws_instance.wp.public_ip
}