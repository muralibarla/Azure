
# Install Java
sudo yum install -y updates
sudo yum install -y java-1.7.0-openjdk

# Install Tomcat
sudo yum install wget
sudo wget https://www.dropbox.com/s/mgjaixl3vlhd0vk/apache-tomcat-8.5.23.zip 
sudo unzip apache-tomcat-8.5.23.zip 
sudo mv apache-tomcat-8.5.23 /srv/ 
sudo ln -s /srv/apache-tomcat-8.5.23 /srv/tomcat 
sudo chown -R neurostar:neurostar /srv/tomcat
sudo chown -R neurostar:neurostar /srv/tomcat/

sudo chmod -R 777 /srv/tomcat
sudo chmod -R 777 /srv/tomcat/

sudo cat > /etc/systemd/system/tomcat.service << EOF1

# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_PID=/srv/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/srv/tomcat
Environment=CATALINA_BASE=/srv/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/srv/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=neurostar
Group=neurostar
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOF1

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

if netstat -tulpen | grep 8080
then
	exit 0
fi

