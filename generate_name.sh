#!/bin/bash
export GOVC_URL="$VSPHERE_URL"
export GOVC_USERNAME="$VSPHERE_USERNAME"
export GOVC_PASSWORD="$VSPHERE_PASSWORD"
export GOVC_INSECURE=true

for i in {1..100}; do
  if ! govc vm.info "webserver$i" &> /dev/null; then
    echo "{\"name\": \"webserver$i\"}"
    exit 0
  fi
done
