# Install Java
sudo yum install -y updates
sudo yum install -y java-1.7.0-openjdk

sudo echo "JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")" | sudo tee -a /etc/profile
source /etc/profile

# Setting Time Zone to EST
sudo mv /etc/localtime /etc/localtime.bak
sudo ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Install ServiceMix
sudo wget http://archive.apache.org/dist/servicemix/servicemix-4/4.5.2/apache-servicemix-4.5.2.tar.gz
sudo tar -xzvf apache-servicemix-4.5.2.tar.gz
sudo mv apache-servicemix-4.5.2 /srv
sudo ln -s /srv/apache-servicemix-4.5.2 /srv/servicemix
sudo chown -R neurostar:neurostar /srv/servicemix
sudo chown -R neurostar:neurostar /srv/servicemix/
sudo chmod -R 777 /srv/servicemix
sudo chmod -R 777 /srv/servicemix/

# Creating ServiceMix service 
sudo cat > /etc/init.d/servicemix << EOF1
#!/bin/bash
#===============================================================================
#
#         FILE: servicemix
#
#        USAGE: /sbin/service servicemix  {start|stop|status|restart} 
#
#  DESCRIPTION: Apache Servicemix RedHat initscript that respects all
#               signals including a "status" request to determine
#               whether the Java engine is running,  ignoring JMX
#               sessions and utilizing only the main application JVM.
#
#      OPTIONS: {start|stop|status|restart}
# REQUIREMENTS: Redhat functions in /etc/init.d/functions
# ORGANIZATION: Accelarad, Inc.
#      VERSION: 1.0 - 64-bit Platforms
#      CREATED: 12/12/2013 20:59:36
#     REVISION: ---
#               01/17/2014 -- Jason Day <jday@accelarad.com>
#               Run as neurostar user
###########################=====================================================
# RedHat Required Section #
###########################
# servicemix This starts and stops the Service Mix Process
# chkconfig: 345 98 11
# description: Start/Stop the ServiceMix Process
# processname: java
# pidfile:     /var/run/servicemix.pid

# Instanitiate RedHat functions and ${JAVA_HOME}
. /etc/init.d/functions
. /etc/profile.d/java.sh

# Source locations of important ServiceMix Components
SERVICEMIX_HOME="/srv/apache-servicemix-4.5.2"
SERVICEMIX="${SERVICEMIX_HOME}/bin/start"
LOCKFILE="/var/lock/subsys/servicemix"
PIDFILE="/var/run/servicemix.pid"
PATH=$PATH:/bin:/usr/bin # For su
RETVAL=0

# Subroutine that defines the proper start routine for ServiceMix
start(){
  umask 077
  echo -n $"Starting Apache ServiceMix: "
    daemon --check java --user=neurostar $SERVICEMIX
    touch /var/lock/subsys/servicemix
  RETVAL=$?
    echo
      [ $RETVAL -eq 0 ] && touch $LOCKFILE
  return $RETVAL
}

# Subroutine that defines the proper stop routine for ServiceMix
stop(){
  echo -n $"Stopping ServiceMix: "
    killproc -p ${PIDFILE}
  RETVAL=$?
    sleep 20
  echo
    if [ $RETVAL -eq 0 ]; then
      rm -f ${LOCKFILE}
      rm -f ${PIDFILE}
        echo "Stopped ServiceMix"
    else
      echo "ALERT: Stopping ServiceMix Failed"
    fi  
  return $RETVAL
}

# Subroutine that sets the PID of the main application JVM
setpid(){
  /srv/java/bin/jps |grep Main |awk '{print $1}' > /var/run/servicemix.pid
}

# Execute Proper routines based on command line arguments
case "$1" in
  start)
    start
    sleep 20 && echo_success || echo_failure
    setpid
    ;;
  stop)
    stop && echo_success || echo_failure
    ;;
  restart)
    stop
    start
    ;;
  status)
    status -p /var/run/servicemix.pid
    RETVAL=$?
    ;;
  *)
  echo $"Usage: $0 {start|stop|status|restart}"
  exit 2
esac
exit $RETVAL

EOF1

sudo chkconfig servicemix on