#!/bin/bash

# This script takes a txt file with names of new things that
# the user want to create in AWS-IOT.

# Also adds a default payload to the DESIRED state of the shadow of each thing
# from the file of things.

# Requirements
# - Install awscli (sudo apt install aws-cli)
# - Configure awscli (aws configure)
#   - Add AWS API KEY/SECRET/REGION/JSON
# - Create a txt file with names of new things
# - Check permissions to the script (chmod +x create-batch-things.sh)
# - Run the script (sh create-batch-things.sh)

file="list-things.txt"

while IFS= read -r thing
do

  printf '%s\n' "Creating Thing $thing"
  aws iot create-thing --thing-name "$thing"

  printf '%s\n' "Adding default shadow to thing $thing"
  aws iot-data update-thing-shadow --thing-name "$thing" --payload '{"state":{"desired":{"data":"1000000000000000"}}}' /tmp/output.json
  cat /tmp/output.json

done <"$file"
