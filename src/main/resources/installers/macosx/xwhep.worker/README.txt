
# Copyrights     : CNRS
# Author         : Oleg Lodygensky
# Acknowledgment : XtremWeb-HEP is based on XtremWeb 1.8.0 by inria : http://www.xtremweb.net/
# Web            : http://www.xtremweb-hep.org
# 
#      This file is part of XtremWeb-HEP.
#
# Copyright [2018] [CNRS]
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


#  ******************************************************************
#  File    : installers/macosx/xwhep.worker/README.txt
#  Date    : Dec 15th, 2011
#  Author  : Oleg Lodygensky
# 
#  OS      : Apple Mac OS X
# 
#  ******************************************************************

This directory contains files to generate an Apple Mac OS X package to install the XWHEP worker


++ Note : Aug 23rd, 2012

Since Mac OS 10.8, XCode and PackageMaker are not in /Developer folder.
Hence the xwconfigure script may be unable to automatically build Mac OS X installation package

To create Mac OS X installation packages:
- install PackageMaker
- use it as follows
 $> PackageMaker -d installers/macosx/xwhep.worker/installer/xwhep-worker.pmdoc -o installers/macosx/xwhep.worker/installer/xwhep-worker.mpkg

