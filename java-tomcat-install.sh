
# Install Java
sudo apt-get -y update
sudo apt-get install -y openjdk-7-jdk
sudo apt-get -y update --fix-missing
sudo apt-get install -y openjdk-7-jdk

# Install Tomcat
sudo wget http://apache.osuosl.org/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz
tar -xzvf  apache-tomcat-8.5.23.tar.gz 
sudo mv apache-tomcat-8.5.23 /srv/
sudo ln -s /srv/apache-tomcat-8.5.23 /srv/tomcat
sudo chown -R neurostar:neurostar /srv/tomcat

