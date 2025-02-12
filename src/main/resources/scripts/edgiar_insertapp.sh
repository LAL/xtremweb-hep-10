#!/bin/sh

# Copyright [2018] [CNRS] Simon Dadoun
# Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
# Web            : http://www.xtremweb-hep.org
#
#      This file is part of XtremWeb-HEP.
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#



#  ******************************************************************
#  File    : edgi_insertapp.sh
#  Date    : Dec 9th, 2011
#  Author  : Simon Dadoun
# 
#  OS      : Linux
# 
#  Purpose : this script creates a new LiveCD
# 
#  !!!!!!!!!!!!!!!!    DO NOT EDIT    !!!!!!!!!!!!!!!!
#  Remarks : this script is auto generated by install process
#  ******************************************************************


app_name=$1
if [ "$app_name" == "" ]; then echo "Need one argument (app's name)"; exit 0; fi

echo "App : "$app_name

rm -rf arapp; mkdir arapp; cd arapp

xwapps | grep $app_name
if [ $? -eq 0 ]; then echo "App "$app_name" is already present"; exit 0; fi

#-- dart123 ----------------
if [ $app_name == "dart123" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1229\&filename=dart_1.00.tar.gz
  mv download\?impid\=1229\&filename\=dart_1.00.tar.gz dart_1.00.tar.gz
  tar zxf dart_1.00.tar.gz

  xwsendapp dart123 JAVA ./dart_1.00/binaries/java/Dart.jar
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
fi

#-- guineapig --------------
if [ $app_name == "guineapig123" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1256\&filename=guineapig_xwhep_1.1.1.tar.gz
  mv download\?impid\=1256\&filename\=guineapig_xwhep_1.1.1.tar.gz guineapig_xwhep_1.1.1.tar.gz
  tar zxf guineapig_xwhep_1.1.1.tar.gz

  xwsendapp guineapig123 ix86 linux ./guineapig++_xwhep_1.1.1/binaries/i686-pc-linux-gnu/guineapig++.exe
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
  xwsendapp guineapig123 amd64 linux ./guineapig++_xwhep_1.1.1/binaries/i686-pc-linux-gnu/guineapig++.exe
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
fi

#-- bnbss ------------------
if [ $app_name == "bnbss" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1235\&filename=bnbss_2011.03.01.05.51.tar.gz
  mv download\?impid\=1235\&filename\=bnbss_2011.03.01.05.51.tar.gz bnbss_2011.03.01.05.51.tar.gz
  tar zxf bnbss_2011.03.01.05.51.tar.gz

  xwsendapp bnbss ix86 linux ./bnbss_2011.03.01.05.51/binaries/i686-pc-linux-gnu/bnbss.exe
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
  xwsendapp bnbss amd64 linux ./bnbss_2011.03.01.05.51/binaries/i686-pc-linux-gnu/bnbss.exe
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
fi

#-- correlizer -------------
if [ $app_name == "correlizer" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1233\&filename=correlizer_2011.05.24.tar.gz
  mv download\?impid\=1233\&filename\=correlizer_2011.05.24.tar.gz correlizer_2011.05.24.tar.gz
  tar zxf correlizer_2011.05.24.tar.gz
                                    
  xwsendapp correlizer ix86 linux ./correlizer_2011.05.24/binaries/i686-pc-linux-gnu/correlizer_x86_32
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
  xwsendapp correlizer amd64 linux ./correlizer_2011.05.24/binaries/i686-pc-linux-gnu/correlizer_x86_32
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
fi

#-- larbin-crawler ---------
if [ $app_name == "larbin-crawler" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1302\&filename=larbin-crawler_xwhep_1.00.tar.gz
  mv download\?impid\=1302\&filename\=larbin-crawler_xwhep_1.00.tar.gz larbin-crawler_xwhep_1.00.tar.gz
  tar zxf larbin-crawler_xwhep_1.00.tar.gz
                                    
  xwsendapp larbin-crawler ix86 linux ./larbin-crawler_xwhep_1.00/binaries/i686-pc-linux-gnu/larbin
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
  xwsendapp larbin-crawler amd64 linux ./larbin-crawler_xwhep_1.00/binaries/i686-pc-linux-gnu/larbin
  if [ $? -ne 0 ]; then echo "Error inserting "$app_name; exit 0; fi
fi

#-- phog -------------------
if [ $app_name == "phog" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1303\&filename=phog_xwhep_1.00.tar.gz
  mv download\?impid\=1303\&filename\=phog_xwhep_1.00.tar.gz phog_xwhep_1.00.tar.gz
  tar zxf phog_xwhep_1.00.tar.gz

  login=`xwversion --xwverbose | grep login | awk '{print $3}'`
  userUID=`xwusers | grep $login | awk '{print $1}' | sed "s/UID='//"  | sed "s/',//"`  
  echo $userUID
  
  usecasedir="phog_xwhep_1.00/usecasefiles/"
  phog_basedirinuri=`xwsenddata phog_basedirinuri ${usecasedir}phog_basedirinuri.zip`
  echo $phog_basedirinuri
  phog_sh=`xwsenddata phog.sh ${usecasedir}phog.sh`
  echo $phog_sh
  
  cp ${usecasedir}xwsendapp_phog.xml-template ${usecasedir}xwsendapp_phog.xml
  my_cmd="sed -i 's|REPLACE_BY_OWNER_UID|"$userUID"|' "$usecasedir"xwsendapp_phog.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_BASEDIRIN_URI|"$phog_basedirinuri"|' "$usecasedir"xwsendapp_phog.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_LINUX_IX86_URI|"$phog_sh"|' "$usecasedir"xwsendapp_phog.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_LINUX_AMD64_URI|"$phog_sh"|' "$usecasedir"xwsendapp_phog.xml"
  echo $my_cmd; eval $my_cmd
  phog_uid=`xwsendapp --xwxml ${usecasedir}xwsendapp_phog.xml`
  echo $phog_uid
fi

#-- autodock305 ------------
if [ $app_name == "autodock305" ]; then
  wget http://dev17-portal.cpc.wmin.ac.uk:8080/repository/download?impid=1252\&filename=autodock305_xwhep_1.00.tar.gz
  mv download\?impid\=1252\&filename\=autodock305_xwhep_1.00.tar.gz autodock305_xwhep_1.00.tar.gz
  tar zxf autodock305_xwhep_1.00.tar.gz

  login=`xwversion --xwverbose | grep login | awk '{print $3}'`
  userUID=`xwusers | grep $login | awk '{print $1}' | sed "s/UID='//"  | sed "s/',//"`  
  echo $userUID
  
  usecasedir="autodock305_xwhep_1.00/usecasefiles/"
  autodock305_basedirinuri=`xwsenddata autodock305_basedirinuri ${usecasedir}autogrid_and_dock3_basedirinuri.zip`
  echo $autodock305_basedirinuri
  autodock305_sh=`xwsenddata autogrid_and_dock3.sh ${usecasedir}autogrid_and_dock3.sh`
  echo $autodock305_sh
  
  cp ${usecasedir}xwsendapp_autogrid_and_dock3.xml-template ${usecasedir}xwsendapp_autogrid_and_dock3.xml
  my_cmd="sed -i 's|REPLACE_BY_OWNER_UID|"$userUID"|' "$usecasedir"xwsendapp_autogrid_and_dock3.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_BASEDIRIN_URI|"$phog_basedirinuri"|' "$usecasedir"xwsendapp_autogrid_and_dock3.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_LINUX_IX86_URI|"$phog_sh"|' "$usecasedir"xwsendapp_autogrid_and_dock3.xml"
  echo $my_cmd; eval $my_cmd
  my_cmd="sed -i 's|REPLACE_BY_LINUX_AMD64_URI|"$phog_sh"|' "$usecasedir"xwsendapp_autogrid_and_dock3.xml"
  echo $my_cmd; eval $my_cmd
  autodock305_uid=`xwsendapp --xwxml ${usecasedir}xwsendapp_autogrid_and_dock3.xml`
  echo $autodock305_uid
fi
