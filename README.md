# Olympus Ansible Manage

Repositorio para gestionar y actualizar servidores Olympus mediante Ansible.

## Resumen
Este repositorio contiene playbooks y scripts para realizar tareas de mantenimiento
en los servidores del grupo `Olympus`, incluyendo un playbook de actualización y
despliegue de servicios como Uptime Kuma.

## Estructura principal
- `ansible.cfg` — configuración base de Ansible.
- `hosts` — inventario (por seguridad, evita almacenar contraseñas en texto claro).
- `playbooks/` — playbooks de Ansible (p. ej. `update.yml`, `ping.yml`, `uptime_kuma/`).
- `run_update.sh`, `load_env.sh` — scripts helper para cargar `.env` y lanzar el playbook de actualización.
- `.ansible-lint` — configuración para `ansible-lint`.
- `.github/workflows/ansible-ci.yml` — workflow de CI que ejecuta lint y syntax-check.

## Requisitos
- Controlador con Ansible instalado (local o en CI).
- Acceso SSH a los hosts (recomendado: claves SSH, no contraseñas en inventario).

## Seguridad: secretos y mejores prácticas
- No guardes `ansible_ssh_pass` en `hosts`. El workflow falla si detecta `ansible_ssh_pass`.
- Usa claves SSH y `ssh-agent`, o guarda secretos con `ansible-vault`.
- Si usas `.env`, mantenlo con permisos 600 y evita imprimir variables sensibles en scripts.

Ejemplo para proteger `.env`:

```bash
chmod 600 .env
```

Y para cargarlo de forma segura en scripts:

```bash
set -o allexport
# shellcheck source=/dev/null
. .env
set +o allexport
```

No hagas `echo "$ANSIBLE_SSH_PASS"` en scripts ni logs.

## Cómo ejecutar (local)

1. Instala dependencias (Python, Ansible, ansible-lint):

```bash
python -m pip install --upgrade pip
pip install ansible ansible-lint
```

2. Ejecutar ansible-lint en los playbooks:

```bash
find playbooks -type f \( -name "*.yml" -o -name "*.yaml" \) -print | xargs ansible-lint
```

3. Comprobar sintaxis de los playbooks:

```bash
find playbooks -type f \( -name "*.yml" -o -name "*.yaml" \) -print0 | while IFS= read -r -d '' file; do
  echo "-- syntax check: $file --"
  ansible-playbook -i hosts --syntax-check "$file"
done
```

4. Ejecutar el playbook de actualización (desde la raíz del repo):

```bash
./run_update.sh
```

Nota: `run_update.sh` carga `.env` y llama a `ansible-playbook -i hosts playbooks/update.yml`.

## GitHub Actions (CI)

Se añadió el workflow `.github/workflows/ansible-ci.yml` que:
- Instala Ansible y `ansible-lint`.
- Ejecuta `ansible-lint` sobre los playbooks.
- Ejecuta `ansible-playbook --syntax-check` por playbook.
- Falla si detecta `ansible_ssh_pass` en `hosts` (evita contraseñas en texto claro).

Si la CI falla por `ansible-lint` o `--syntax-check`, corrige los errores localmente y haz un commit.

## Cómo ajustar reglas de lint
Edita `.ansible-lint` para añadir `skip_list` (reglas a ignorar) o `warn_list` (reglas tratadas como advertencia). También puedes añadir plugins en `rulesdir`.

## Siguientes pasos recomendados
- Migrar secrets a `ansible-vault` o configurar claves SSH.
- Corregir el playbook `uptime_kuma` (hay rutas y opciones que revisar).
- Añadir `ansible-lint` y `syntax-check` en PRs de ramas y proteger la rama `main` con la CI.

Si quieres, puedo:
- Crear un branch con la eliminación de contraseñas del inventario y ejemplos para `ansible-vault`.
- Corregir el playbook `uptime_kuma` y hacerlo idempotente usando módulos Docker.

---
Archivo generado automáticamente: instrucciones básicas y seguridad.
