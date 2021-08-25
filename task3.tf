provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAW75OPNA5SQ3QHBZW"
  secret_key = "Tw1bSFjmL9QYQ"
}


resource "aws_db_instance" "mydb3" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  identifier           = "testinstance"
  instance_class       = "db.t2.micro"
  name                 = "mysqldb"
  username             = "himani"
  password             = "himani2424"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_instance" "task3" {
  ami           = "ami-00bf4ae5a7909786c"
  instance_type = "t2.micro"
  key_name = "my_privatekey"
  security_groups= ["default"]
  tags= {
    Name = "OS2"
  }

 connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/YASH RAUT/Documents/Terraform/my_privatekey.pem")
    host        = aws_instance.task3.public_ip
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install mysql -y", 
      "sudo amazon-linux-extras install php7.2 -y", 
      "sudo yum install httpd -y", #webserver
      "sudo wget https://wordpress.org/latest.tar.gz", 
      "sudo cp latest* /var/www/html", #copy the file in /var/www/html
      "sudo tar -xvf latest.tar.gz", # untar file
      "sudo cp -r wordpress* /var/www/html",
      "sudo systemctl enable httpd --now", # restart and enable httpd
      "sudo mysql -h ${aws_db_instance.mydb3.address} -u himani -phimani2424 -e 'CREATE DATABASE db1;'"
       ]
  }
}