
# Install Java
sudo yum install -y updates
sudo yum install -y $1

# Install Tomcat
wget http://apache.osuosl.org/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz 
tar -xzvf  apache-tomcat-8.5.23.tar.gz  
sudo mv apache-tomcat-8.5.23 /srv/ 
sudo ln -s /srv/apache-tomcat-8.5.23 /srv/tomcat 
sudo chown -R neurostar:neurostar /srv/tomcat 

