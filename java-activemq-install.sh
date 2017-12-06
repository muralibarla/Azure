
# Install Java
sudo yum install -y updates
sudo yum install -y java-1.8.0-openjdk

sudo echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile

# Install ActiveMQ
sudo yum install wget
sudo wget https://archive.apache.org/dist/activemq/5.15.2/apache-activemq-5.15.2-bin.tar.gz
sudo tar -xzvf apache-activemq-5.15.2-bin.tar.gz -C /srv/
sudo ln -s /srv/apache-activemq-5.15.2 /srv/activemq 
sudo chown -R neurostar:neurostar /srv/activemq
sudo chown -R neurostar:neurostar /srv/activemq/
sudo chmod -R 777 /srv/activemq
sudo chmod -R 777 /srv/activemq/

# Setting Time Zone to EST
sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Creating service 
sudo cat > /etc/systemd/system/activemq.service << EOF1

[Unit]
Description=ActiveMQ service
After=network.target

[Service]
Type=forking
ExecStart=/srv/activemq/bin/activemq start
ExecStop=/srv/activemq/bin/activemq stop
User=neurostar
Group=neurostar
Restart=always
RestartSec=9
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=activemq

[Install]
WantedBy=multi-user.target

EOF1

sudo systemctl daemon-reload
sudo systemctl start activemq
sudo systemctl enable activemq