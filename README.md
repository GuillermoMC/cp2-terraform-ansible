# Azure

## Logearse en Azure mediante AZ CLI

>az login

>az account show

## En Windows con PowerShell (mi caso)

Ejecutar los siguientes comandos con el id y tenant_id que devuelve "az account show"

> $Env:ARM_SUBSCRIPTION_ID = ""

> $Env:ARM_TENANT_ID = ""


# Terraform

## Crear infraestructura

> terraform init -upgrade

> terraform plan -out infra.tfplan

> terraform apply infra.tfplan


## Destruir infraestructura

> terraform plan -destroy -out infra.destroy.tfplan

> terraform apply infra.destroy.tfplan


# Ansible

## Clave para acceso ssh

Tal y como indica el fichero "host" que es nuestro inventory para acceder a la maquina se guarda la clave en el fichero "~/.ssh/azure_vm.pem"

* Este fichero se crea a mano una vez terminada la creación de la infraestructura con terraform, ya que te muestra por pantalla dicha clave


## Almacen de credenciales

Para hacer login con Azure y el ACR se puede utilizar Ansible Vault

Un fichero "azure_vault.yml" que se utilizará en los playbooks de ansible con la siguiente estructura:

> ACR_USR: ""

> ACR_PASS: ""

Donde los valores vienen dados por el comando de Azure CLI visto previamente.

Encriptar datos utilizando :

> ansible-vault encrypt azure_vault.yml

Luego lanzar el playbook con el flag "--ask-vault-pass"

* Por seguridad en este repositorio el fichero azure_vault.yml estará ignorado en GIT

## Kubernetes
Antes de lanzar el playbook de K8S hay que obtener las credenciales con:

> az aks get-credentials --resource-group rg-cp2rg --name cp2aks

* Devolvera una ruta y es la que hay que indicarla en el playbook de AKS

## Orden de ejecución de los playbooks

> ansible-playbook -i hosts --ask-vault-pass preparacion-playbook.yml

> ansible-playbook -i hosts --ask-vault-pass podman-playbook.yml

> ansible-playbook -i hosts --ask-vault-pass k8s-playbook.yml