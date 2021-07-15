resource "google_compute_instance" "wordpress" {
  name         = "wordpress"
  machine_type = "e2-micro"
  zone = "us-central1-a"
  

  tags = ["wp-db"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

resource "google_compute_firewall" "wp-db" {
  name    = "wp-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
   
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["wp-db"]
}

resource "null_resource" "conf_wp"{
    connection{
        type = "ssh"
        user = "sujagi_v"
        private_key = file("C:/Users/sujag/Downloads/sujagi_v.pem")
        host = google_compute_instance.wordpress.network_interface.0.access_config.0.nat_ip
    }

    provisioner "remote-exec" {
    inline = [
		"sudo yum install httpd php php-mysqlnd php-json wget -y", 
		"sudo wget https://wordpress.org/latest.tar.gz",
		"tar -xzf latest.tar.gz",
		"sudo mv wordpress/* /var/www/html/",
		"sudo chown -R apache.apache /var/www/html",
		"sudo setenforce 0",
        "sudo systemctl stop firewalld",
		"sudo systemctl start httpd"
		
	    ]
  }
}

output "ip" {
    value = google_compute_instance.wordpress.network_interface.0.access_config.0.nat_ip
}
