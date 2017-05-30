terraform apply
packer build -var-file=variables.json jupyter_ami.json
terraform destroy -force
