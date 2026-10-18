# Déploiement de GitLab sur AWS avec Ansible & Terraform

## Aller sur le dossier terraform

```bash
terraform init
terraform apply
```
## Recuperer l'ip public du vm

## Aller sur le dossier ansible

## Aller sur hosts.ini et changer l'ip puis

```bash
ansible-playbook  install_gitlab.yml
```

## puis se rendre sur http://PUBLIC_IP
## parfois rien ne s'affiche 
## il faut verifier que le port 80 est ouvert en faisant un ssh dans le vm puis sudo ss -tulnp | grep :80
## si rien ne s'affiche, il faut faire un reboot du serveur: sudo gitlab-ctl reconfigure

## maintenant se connecter avec root et le mot de passe on le recupere en faisant sudo cat /etc/gitlab/initial_root_password

## productionn id 3.92.206.44
## staging id 52.23.253.203