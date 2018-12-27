# Install Required packages Java unzip wget
sudo yum install -y updates
sudo yum install -y java-1.8.0-openjdk unzip wget

# Get Consul executable
wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip

# Unzip consul binary zip
unzip consul_1.4.0_linux_amd64.zip

#Create Required Directories
sudo mkdir /srv/consul
sudo mkdir /srv/consul/bin
sudo mkdir /srv/consul/data
sudo mkdir /srv/consul/log

# Change the Ownership of folders to current user account to have proper permissions
sudo chown -R nuance:nuance /srv/consul

# Copy Consul Executable to bin directory
cp consul /srv/consul/bin/

# Set Path Variable
export PATH=$PATH:/srv/consul/bin
source ~/.bashrc

# After setting PATH variable, check consul executable is accessible from terminal.
consul -v

# Create folder to save configuration information
sudo mkdir /etc/consul.d/server
