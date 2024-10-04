#!/bin/bash
export GOVC_URL="$VSPHERE_URL"
export GOVC_USERNAME="$VSPHERE_USERNAME"
export GOVC_PASSWORD="$VSPHERE_PASSWORD"
export GOVC_INSECURE=true

# Specify the folder where you want to search for existing VMs
# Replace "YourFolderPath" with the actual path to your folder in vSphere, e.g., "/datacenter/vm/your-folder"
FOLDER_PATH="/Netlab-DC/vm/_Courses/I3-DB01/I483725/Automation"

for i in {1..100}; do
  # Check if a VM with the name exists in the specified folder
  if ! govc vm.info -folder "$FOLDER_PATH" "webserver$i" &> /dev/null; then
    # Output the result in JSON format required by Terraform's external data source
    echo "{\"name\": \"webserver$i\"}"
    exit 0
  fi
done

# In case no name is available, return an error
echo "{\"error\": \"No available VM names in folder $FOLDER_PATH\"}"
exit 1
