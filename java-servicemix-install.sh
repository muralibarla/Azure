# Install Java
sudo yum install -y updates
sudo yum install -y java-1.7.0-openjdk

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