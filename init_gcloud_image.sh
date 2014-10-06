#!/bin/bash
source vars.sh
gcloud compute firewall-rules create ${VM_NAME}-www\
  --allow tcp:80 --target-tags ${VM_NAME}

gcloud compute instances create ${VM_NAME} \
  --tags ${VM_NAME} \
  --zone ${ZONE}\
  --machine-type f1-micro \
  --image container-vm-v20140826\
  --image-project google-containers\
  --metadata-from-file google-container-manifest=container_manifest.yaml

echo ''
echo 'You should be able to connect to the container at the externalIP'
gcloud compute instances list
