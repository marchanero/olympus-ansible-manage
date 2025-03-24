#!/bin/bash

# Definir colores para los mensajes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Mostrar un encabezado informativo
echo -e "${GREEN}=== Iniciando automatización de actualización del sistema ===${NC}"

# Cargar variables de entorno desde el archivo .env
echo -e "${YELLOW}Cargando variables de entorno...${NC}"
if [ -f "/home/robert/olympus-ansible-manage/.env" ]; then
    export $(grep -v '^#' /home/robert/olympus-ansible-manage/.env | xargs)
    echo -e "${GREEN}Variables de entorno cargadas. ANSIBLE_SSH_PASS=$ANSIBLE_SSH_PASS${NC}"
else
    echo -e "${YELLOW}¡Advertencia: Archivo .env no encontrado!${NC}"
    exit 1
fi

# Verificar que la variable esté definida
if [ -z "$ANSIBLE_SSH_PASS" ]; then
    echo -e "${YELLOW}¡Error: ANSIBLE_SSH_PASS no está definida!${NC}"
    exit 1
fi

# Ejecutar el playbook de Ansible
echo -e "${GREEN}Ejecutando playbook de actualización...${NC}"
ansible-playbook -i /home/robert/olympus-ansible-manage/hosts /home/robert/olympus-ansible-manage/playbooks/update.yml

# Verificar el resultado
if [ $? -eq 0 ]; then
    echo -e "${GREEN}¡Actualización completada con éxito!${NC}"
else
    echo -e "${YELLOW}¡La actualización encontró errores!${NC}"
    exit 1
fi

echo -e "${GREEN}=== Fin del proceso de actualización ===${NC}"
