#!/bin/sh

# check that the server name has been defined
if [ -z $SCHEDULER_DOMAIN ] ; then
	echo "The domain name of the scheduler is missing"; exit 1
fi

# Modify etc hosts if an ip is given in parameters
if [ ! -z $SCHEDULER_IP ] ; then
	echo "$SCHEDULER_IP $SCHEDULER_DOMAIN" >> /etc/hosts
fi

# download the certificate from the server
echo "Downloading certificate from scheduler..."
echo -n | openssl s_client -connect $SCHEDULER_DOMAIN:443 | sed -ne "/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p" > /iexec/certificate/xwscheduler.crt
echo "Converting downloaded certificate to x509 DER..."
openssl x509 -outform der -in /iexec/certificate/xwscheduler.crt -out /iexec/certificate/xwscheduler.pem
sed -i "s/^DISPATCHERS=.*/DISPATCHERS=$SCHEDULER_DOMAIN/g" /iexec/conf/xtremweb.worker.conf

# import the server certificate into the container keystore
keytool -import -alias localhost -file /iexec/certificate/xwscheduler.pem -trustcacerts -keystore /etc/ssl/certs/java/cacerts -storepass changeit -v -noprompt

# update the SSLKEYSTORE to point to the container's keystore
sed -i "s/^SSLKEYSTORE=.*/SSLKEYSTORE=\/etc\/ssl\/certs\/java\/cacerts/g" /iexec/conf/xtremweb.worker.conf
sed -i "s/^SSLKEYPASSWORD=.*/SSLKEYPASSWORD=changeit/g" /iexec/conf/xtremweb.worker.conf

# add the TMPDIR variable if defined
if [ ! -z $TMPDIR ] ; then
	sed -i "s/^#TMPDIR=.*/TMPDIR=$TMPDIR/g" /iexec/conf/xtremweb.worker.conf
fi

# Add defined SHAREDAPPS variable if defined, otherwise use a default value
if [ ! -z $SHAREDAPPS ] ; then
	sed -i "s/^#SHAREDAPPS=.*/SHAREDAPPS=$SHAREDAPPS/g" /iexec/conf/xtremweb.worker.conf
else sed -i "s/^#SHAREDAPPS=.*/SHAREDAPPS=docker/g" /iexec/conf/xtremweb.worker.conf
fi

# Add SHAREDPACKAGES only if it is given in parameters
if [ ! -z $SHAREDPACKAGES ] ; then
	sed -i "s/^#SHAREDPACKAGES=.*/SHAREDPACKAGES=$SHAREDPACKAGES/g" /iexec/conf/xtremweb.worker.conf
fi

# Set default value for Login
if [ ! -z $LOGIN ] ; then
	sed -i "s/^LOGIN=.*/LOGIN=$LOGIN/g" /iexec/conf/xtremweb.worker.conf
else sed -i "s/^LOGIN=.*/LOGIN=vworker/g" /iexec/conf/xtremweb.worker.conf
fi

# Set default value for Password
if [ ! -z $PASSWORD ] ; then
	sed -i "s/^PASSWORD=.*/PASSWORD=$PASSWORD/g" /iexec/conf/xtremweb.worker.conf
else sed -i "s/^PASSWORD=.*/PASSWORD=vworkerp/g" /iexec/conf/xtremweb.worker.conf
fi

# Set the LoggerLevel
if [ ! -z $LOGGERLEVEL ] ; then
	sed -i "s/^LOGGERLEVEL=.*/LOGGERLEVEL=$LOGGERLEVEL/g" /iexec/conf/xtremweb.worker.conf
fi

# Set the flag for sandboxing
if [ ! -z $SANDBOXENABLED ] ; then
	sed -i "s/^SANDBOXENABLED=.*/SANDBOXENABLED=$SANDBOXENABLED/g" /iexec/conf/xtremweb.worker.conf
fi

cat /etc/hosts

# Start the worker
/iexec/bin/xtremweb.worker console
