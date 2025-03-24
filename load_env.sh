#!/bin/bash
export $(grep -v '^#' /home/robert/olympus-ansible-manage/.env | xargs)
echo "Variables de entorno cargadas. ANSIBLE_SSH_PASS=$ANSIBLE_SSH_PASS"
