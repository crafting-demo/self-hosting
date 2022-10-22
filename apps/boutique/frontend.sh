#!/bin/bash

. "${BASH_SOURCE[0]%/*}/functions.sh"

while true; do
    kubectl -n "$NAMESPACE" port-forward --address 0.0.0.0 svc/frontend 8000:80
    sleep 1
done