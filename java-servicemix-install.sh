# Install Java
sudo wget https://www.dropbox.com/s/5bgxbt7hcs9lo5o/jdk-7u79-linux-x64.gz
sudo tar -xvzf jdk-7u79-linux-x64.gz
sudo mkdir /usr/local/java
sudo mv jdk1.7.0_79 /usr/local/java/
sudo ln -s /usr/local/java/jdk1.7.0_79 /usr/local/java/jdk
	
sudo cat > /etc/profile.d/java.sh << EOF-01
	
export PATH="$PATH:/usr/local/java/jdk/bin"
export JAVA_HOME=/usr/local/java/jdk

EOF-01

source /etc/profile.d/java.sh 

# Install ServiceMix
sudo wget http://archive.apache.org/dist/servicemix/servicemix-4/4.5.2/apache-servicemix-4.5.2.tar.gz
sudo tar -xzvf apache-servicemix-4.5.2.tar.gz
sudo mv apache-servicemix-4.5.2 /srv
sudo ln -s /srv/apache-servicemix-4.5.2 /srv/servicemix
sudo chown -R neurostar:neurostar /srv/servicemix
sudo chown -R neurostar:neurostar /srv/servicemix/
sudo chmod -R 777 /srv/servicemix
sudo chmod -R 777 /srv/servicemix/

# Setting Time Zone to EST
sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Creating ServiceMix service 
sudo cat > /etc/systemd/system/servicemix.service << EOF1

[Unit]
Description=ServiceMix service
After=network.target

[Service]
Type=forking
ExecStart=/srv/servicemix/bin/start
ExecStop=/srv/servicemix/bin/stop
User=neurostar
Group=neurostar
Restart=always
RestartSec=9
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=servicemix

[Install]
WantedBy=multi-user.target

EOF1

sudo systemctl daemon-reload
sudo systemctl start servicemix
sudo systemctl enable servicemix