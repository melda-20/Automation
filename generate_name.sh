#!/bin/bash

# Set the path to a persistent tracking file
TRACKING_FILE="/var/lib/jenkins/used_vm_names.txt"

# Create the tracking file if it does not exist
if [ ! -f "$TRACKING_FILE" ]; then
  touch "$TRACKING_FILE"
fi

# Loop through potential VM names and find the first available one
for i in {1..100}; do
  VM_NAME="webserver$i"
  
  # Check if the VM name is in the tracking file
  if ! grep -qx "$VM_NAME" "$TRACKING_FILE"; then
    # Output the selected VM name in JSON format for Terraform
    echo "{\"name\": \"$VM_NAME\"}"
    
    # Append the selected name to the tracking file to mark it as used
    echo "$VM_NAME" >> "$TRACKING_FILE"
    
    # Exit after assigning the name
    exit 0
  fi
done

# If no available names are found, output an error message in JSON format
echo "{\"error\": \"No available VM names\"}"
exit 1
