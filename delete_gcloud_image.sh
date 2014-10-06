#!/bin/bash
source vars.sh
gcloud compute firewall-rules delete ${VM_NAME}-www
gcloud compute instances delete ${VM_NAME} --zone ${ZONE}
