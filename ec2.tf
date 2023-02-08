module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  #version = "~> 3.0"

  name = "TeamPass"

  ami                    = var.ami_id #amazon linux 2
  instance_type          = var.instance_type
  depends_on = [null_resource.save_key_pair]
  #key_name               = var.key_pair
  key_name = "efs-key"
  availability_zone      = var.avail_zone
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = "somente-ssm"
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Volume      = "${var.env_prefix}-server"
  }
  # provisioner "local-exec" {
  #   command = "echo ${aws_instance.web.public_ip} > publicIP.txt"
  # }


  user_data = <<EOF
#!/bin/bash

##### codigo oficial, mount efs and install docker #####

## atualizar o linux
sudo yum update -y

# Mounting Efs 
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html

# Making Mount Permanent
echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab

# Permission
sudo chmod 755 /var/www/html

# Install docker
sudo amazon-linux-extras install docker
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
docker run -d --name meucontainer -v /var/www/html:/var/www/html nginx

#



## alteracao regiao horario
sudo timedatectl set-timezone America/Sao_Paulo

## crontab para desligar todos os dias as 22h
echo "00 22    * * *      root	/sbin/shutdown -h now" >> /etc/crontab

## no final resetar
sudo shutdown -r now








#### teste
# #sudo yum update -y
# #sudo yum install httpd -y
# sudo yum install php -y 
# sudo yum install git -y
# sudo systemctl start httpd
# sudo systemctl enable httpd
# #sudo apt install nfs-utils -y  # Amazon ami has pre installed nfs utils
# # git clone https://github.com/aws/efs-utils
# # sudo apt install make
# # sudo apt install binutils -y
# # cd efs-utils
# # ./build-deb.sh
# # sudo apt install ./build/amazon-efs-utils*deb -y
# # Mounting Efs 
# sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html
# # Making Mount Permanent
# echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab
# sudo chmod 755 /var/www/html
# #sudo chown www-data:www-data /var/www/html
# #sudo rm /var/www/html/index.html
# sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html





######
#sudo apt-get update -y
# sudo apt-get amazon-efs-utils -y
# #echo "Mount NFS"
# #sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-31337er3.efs.us-east-1.amazonaws.com:/ /mnt/efs
# sudo apt-get update -y
# sudo apt-get install apache2 apache2-utils mariadb-client php7.4 libapache2-mod-php7.4 php7.4-mysql -y 
# sudo apt-get install php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline -y 
# sudo apt-get install php7.4-bcmath php7.4-curl php7.4-fpm php7.4-gd php7.4-xml php7.4-mbstring -y
# sudo systemctl enable apache2.service
# sudo chmod 777 /etc/php/7.4/apache2/php.ini 
# ##
# #max_execution_time = 60
# #;date.timezone = America/Sao_Paulo
# sudo chmod 644 /etc/php/7.4/apache2/php.ini 
# sudo systemctl restart apache2
# sudo wget https://github.com/nilsteampassnet/TeamPass/archive/refs/tags/3.0.0.21.zip
# sudo apt-get install zip unzip
# sudo unzip 3.0.0.21.zip -d  /var/www/html/
# sudo mv /var/www/html/TeamPass-3.0.0.21 /var/www/html/teampass
# sudo mkdir /var/www/html/teampass/includes/libraries/csrfp/log
# sudo mkdir /var/www/html/teampass/backups
# sudo chmod -R 0777 /var/www/html/teampass/includes/
# sudo chmod -R 0777 /var/www/html/teampass/includes/config
# sudo chmod -R 0777 /var/www/html/teampass/includes/avatars
# sudo chmod -R 0777 /var/www/html/teampass/includes/libraries/csrfp/libs
# sudo chmod -R 0777 /var/www/html/teampass/includes/libraries/csrfp/log
# sudo chmod -R 0777 /var/www/html/teampass/includes/libraries/csrfp/js
# sudo chmod -R 0777 /var/www/html/teampass/backups
# sudo chmod -R 0777 /var/www/html/teampass/files
# sudo chmod -R 0777 /var/www/html/teampass/install
# sudo chmod -R 0777 /var/www/html/teampass/upload


EOF


  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum install httpd php git -y -q ",
  #     "sudo systemctl start httpd",
  #     "sudo systemctl enable httpd",
  #     "sudo yum install nfs-utils -y -q ", # Amazon ami has pre installed nfs utils
  #     # Mounting Efs 
  #     "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs.dns_name}:/  /var/www/html",
  #     # Making Mount Permanent
  #     "echo ${aws_efs_file_system.efs.dns_name}:/ /var/www/html nfs4 defaults,_netdev 0 0  | sudo cat >> /etc/fstab ",
  #     "sudo chmod go+rw /var/www/html",
  #     "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html",
  #   ]
  # }
}



