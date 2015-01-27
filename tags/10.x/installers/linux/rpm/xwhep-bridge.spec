# Copyrights     : CNRS
# Author         : Oleg Lodygensky
# Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
# Web            : http://www.xtremweb-hep.org
# 
#      This file is part of XtremWeb-HEP.
#
#    XtremWeb-HEP is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    XtremWeb-HEP is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with XtremWeb-HEP.  If not, see <http://www.gnu.org/licenses/>.


%define _unpackaged_files_terminate_build 0

%define	name	xwhep-bridge
%define version	@XWVERSION@
%define release 1

Summary: XTEMWEB-HEP is a platform for Global and Peer-to-Peer Computing, based on XtremWeb.
Name: %{name}
Version: %{version}
Release: %{release}
License: GPL
Group: Applications/Distributed Computing
Source: %{name}-%{version}.tar.gz
URL: http://www.xtremweb-hep.org
Vendor: Laboratoire de l Accelerateur Lineaire (http://www.lal.in2p3.fr)
Packager: Oleg Lodygensky <lodygens@lal.in2p3.fr>
#Requires: j2sdk
Provides: %{name}-%{version}
BuildArch: noarch
Distribution: whatever


BuildRoot: %{_builddir}/%{name}-%{version}
# rpm -q --whatprovides /etc/rc.d/init.d/httpd
# AutoReqProv: no

%define XWSCRIPT xwhep.bridgedg2sg
%define XW_INSTALLDIR /opt/%{name}-%{version}
%define XW_BINDIR %{XW_INSTALLDIR}/bin
%define XW_CONFDIR %{XW_INSTALLDIR}/conf
%define XW_KEYDIR %{XW_INSTALLDIR}/keystore
%define XW_DOCDIR %{XW_INSTALLDIR}/doc
%define XW_LIBDIR %{XW_INSTALLDIR}/lib
%define XWSCRIPT_PATH %{XW_BINDIR}/%{XWSCRIPT}
%define INITD /etc/init.d
%define INITDSCRIPT %{INITD}/%{XWSCRIPT}
%define SYSLOGIN @SYSTEMUSER@
%define LOG /var/log/xwhep-bridgedg2sg.log


%description
XTEMWEB-HEP is a Distributed Computing Plateform. It allows to set up
Global and Peer-to-Peer applications. The software is composed of
a server, a worker (the computing element) and a client (the user
interface element) parts.
On the other hand, XTEMWEB-HEP integrates inter grid facilities in order
to interconnect them. For example XTEMWEB-HEP can be interconnected with EGEE.
This interconnection facilities are called the bridge.
They have been developped in the context of the EDGeS project
(http://www.edges-grid.eu)

This package installs the XTEMWEB-HEP->EGEE bridge (DesktopGrid to Service Grid).

%prep
echo "[`date`] [%{name}] RPM prep nothing to do" >> %{LOG} 2>&1

%setup
touch %{LOG}
echo "[`date`] [%{name}] RPM setup" >> %{LOG}  2>&1 
echo "[`date`] [%{name}] SETUP _tmppath = "%{_tmppath} >> %{LOG}  2>&1 
echo "[`date`] [%{name}] SETUP _builddir = "%{_builddir} >> %{LOG}  2>&1 
#rm -Rf %{XW_INSTALLDIR} >> %{LOG}  2>&1 
mkdir -p  %{XW_INSTALLDIR} >> %{LOG}  2>&1 
cp -rf %{_builddir}/%{name}-%{version}/* %{XW_INSTALLDIR} >> %{LOG}  2>&1 

echo "[`date`] [%{name}] RPM setup done" >> %{LOG}  2>&1 


%pre
# this is done when installing the RPM
echo "[`date`] [%{name}] RPM pre nothing to do" >> %{LOG} 2>&1


%install
# this is done when creating the RPM
echo "[`date`] [%{name}] INSTALL XW_INSTALLDIR = %{XW_INSTALLDIR}" >> %{LOG}  2>&1 


%post
# this is done when installing the RPM


touch %{LOG}
echo "[`date`] [%{name}] RPM post" >> %{LOG}  2>&1 
rm -f %{INITDSCRIPT} >> %{LOG}  2>&1 
ln -s %{XWSCRIPT_PATH} %{INITDSCRIPT} >> %{LOG}  2>&1 

if [ "X%{SYSLOGIN}" != "X" ] ; then 
    groupadd %{SYSLOGIN} >> %{LOG}  2>&1 
    useradd -d /home/%{SYSLOGIN} -s /bin/bash -g %{SYSLOGIN} %{SYSLOGIN} -m >> %{LOG}  2>&1 
    chown -R %{SYSLOGIN}.%{SYSLOGIN} %{XW_INSTALLDIR} >> %{LOG}  2>&1 
else
    echo "[`date`] [%{name}] SYSLOGIN variable is not set; this package will run as root, this is not a good idea" >> %{LOG}  2>&1 
fi

/sbin/service %{XWSCRIPT} stop >> %{LOG}  2>&1 
/sbin/chkconfig --del %{XWSCRIPT} >> %{LOG}  2>&1 
/sbin/chkconfig --add %{XWSCRIPT} >> %{LOG}  2>&1 
/sbin/service %{XWSCRIPT} start >> %{LOG}  2>&1 


echo "[`date`] [%{name}] RPM post done" >> %{LOG}  2>&1 

%clean
# this is called at the end of the rpmbuild

touch %{LOG}
echo "[`date`] [%{name}] RPM clean" >> %{LOG}  2>&1  >> %{LOG}  2>&1 

rm -Rf %{XW_INSTALLDIR}/opt >> %{LOG}  2>&1 
[ -d ${XW_BINDIR} ] || rm -Rf %{XW_INSTALLDIR} >> %{LOG}  2>&1

echo "[`date`] [%{name}] RPM clean done" >> %{LOG}  2>&1  >> %{LOG}  2>&1 


###########################################################
# The RPM upgrading first installs new version, then remove older one
# Scripts have one argument (known as $1) containing count the number of versions of the package that are installed
# This argument is as follow
#  first installation, $1 == 1
#  upgrade             $1 >  1
#  remove              $1 == 0
# See:
# http://docs.fedoraproject.org/en-US/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch09s04s05.html
###########################################################
%preun
touch %{LOG}
echo "[`date`] [%{name}] RPM preun ($1)" >> %{LOG}  2>&1  >> %{LOG}  2>&1 

if [ $1 = 0 ] ; then 
	echo "[`date`] [%{name}] RPM preun is unistalling" >> %{LOG} 2>&1

	/sbin/service %{XWSCRIPT} stop >> %{LOG}  2>&1 
	/sbin/chkconfig --del %{XWSCRIPT} >> %{LOG}  2>&1 

	rm -Rf %{XW_INSTALLDIR} >> %{LOG}  2>&1 
	ls -l %{INITDSCRIPT} | grep %{version} 2>&1
	[ $? -eq 0 ] && rm -f %{INITDSCRIPT} >> %{LOG}  2>&1 

	rm -Rf /tmp/xwhep.bridge*
	rm -Rf /tmp/XW.BRIDGE*
else
	echo "[`date`] [%{name}] RPM preun does nothing" >> %{LOG} 2>&1
fi

echo "[`date`] [%{name}] RPM preun done" >> %{LOG}  2>&1  >> %{LOG}  2>&1 


%files
%defattr(-,root,root)
%{XW_BINDIR}/
%{XW_LIBDIR}/
%{XW_KEYDIR}/
%config %{XW_CONFDIR}/
%doc %{XW_DOCDIR}/


%changelog