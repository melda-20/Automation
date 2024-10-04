#!/bin/bash
# Set the path to the tracking file
TRACKING_FILE="used_vm_names.txt"

# Create the tracking file if it does not exist
if [ ! -f "$TRACKING_FILE" ]; then
  touch "$TRACKING_FILE"
fi

# Loop through potential VM names and find the first available one
for i in {1..100}; do
  VM_NAME="webserver$i"
  
  # Check if the VM name is in the tracking file
  if ! grep -qx "$VM_NAME" "$TRACKING_FILE"; then
    echo "Selected name: $VM_NAME"
    echo "$VM_NAME" >> "$TRACKING_FILE"
    echo "{\"name\": \"$VM_NAME\"}"
    exit 0
  fi
done

echo "{\"error\": \"No available VM names\"}"
exit 1
