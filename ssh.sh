#!/bin/bash
source vars.sh
gcloud compute ssh --zone ${ZONE} ${VM_NAME}
