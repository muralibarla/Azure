
# Install Java
sudo yum install -y updates
sudo yum install -y java-1.7.0-openjdk

# Install Tomcat
sudo yum install wget
sudo wget https://www.dropbox.com/s/wh9wz41rrtw90eq/apache-tomcat-8.5.23.zip 
sudo unzip apache-tomcat-8.5.23.zip 
sudo mv apache-tomcat-8.5.23 /srv/ 
sudo ln -s /srv/apache-tomcat-8.5.23 /srv/tomcat 
sudo chown -R neurostar:neurostar /srv/tomcat 

sudo sh /srv/tomcat/bin/startup.sh

if netstat -tulpen | grep 8080
then
	exit 0
fi

