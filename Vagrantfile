# -*- mode: ruby -*-
# vi: set ft=ruby :
# v2.0
# Author: Joe Axberg
# Author: Alex Siryy

DB_USER='user123'
DB_PASS='pass123'

Vagrant.configure("2") do |config|

  #define a  do block for the web server 
  config.vm.define "web" do |web|

   web.vm.box = "ubuntu/focal64"

   web.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
    v.name = "lamp-web"
  end

   # setup networking
   web.vm.network "forwarded_port", guest: 80, host: 80
   web.vm.network "private_network", ip: "192.168.56.10"
      
   #copy any needed files out to the vm
   web.vm.synced_folder "./shared", "/vagrant"

   #set up a provision block to install and configure the apache/php server
   web.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y apache2
    apt-get install -y php libapache2-mod-php php-mysql
    systemctl restart apache2.service
    mv /var/www/html/index.html /var/www/html/_index.html
    cp /vagrant/index.php /var/www/html/index.php
   SHELL

  end
  
  #define a  do block for the database
  config.vm.define "db" do |db|

    db.vm.box = "ubuntu/focal64"

    db.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 1
      v.name = "lamp-db"
    end

   # setup networking
    db.vm.network "private_network", ip: "192.168.56.11"

    # copy any needed files out to the vm
    db.vm.synced_folder "./shared", "/vagrant"

    # set up a provision block to install and configure the DB
    db.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y mariadb-server

      cp /vagrant/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
      systemctl restart mariadb

      /vagrant/setup_mysql.sh
      /vagrant/add_user.sh #{DB_USER} #{DB_PASS}
      
      git clone https://github.com/datacharmer/test_db.git
      cd /home/vagrant/test_db
      mysql -t < employees.sql
    SHELL

  end

end