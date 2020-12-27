#!/bin/bash

ssh geli@192.168.0.14 << EOF
docker stop $( docker ps | grep buildfarm | awk '{print $1}' )
EOF

ssh geli@192.168.0.15 << EOF
docker stop $( docker ps | grep buildfarm | awk '{print $1}' )
EOF