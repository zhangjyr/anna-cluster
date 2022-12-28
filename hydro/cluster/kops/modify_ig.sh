#!/bin/bash

#  Copyright 2019 U.C. Berkeley RISE Lab
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

if [ -z "$1" ] && [ -z "$2" ]; then
  echo "Usage: ./add_servers.sh node-type instance-count"
  echo "Valid node types are memory, ebs, benchmark, and routing."
  echo "If number of previous instances is not specified, it is assumed to be 0."
  exit 1
fi

YML_FILE=yaml/igs/$1-ig.yml

sed "s|CLUSTER_NAME|$HYDRO_CLUSTER_NAME|g" $YML_FILE > tmp.yml
sed -i "s|MAX_DUMMY|$2|g" tmp.yml
sed -i "s|MIN_DUMMY|$2|g" tmp.yml

kops replace -f tmp.yml --force >> ${HYDRO_HOME}/log 2>&1
rm tmp.yml

kops update cluster --name ${HYDRO_CLUSTER_NAME} --yes >> ${HYDRO_HOME}/log 2>&1
