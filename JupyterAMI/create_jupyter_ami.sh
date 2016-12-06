terraform remote config -backend=s3 -backend-config="bucket=jupyter-sync" -backend-config="key=tfstate/packer.tfstate" -backend-config="region=us-east-1"

terraform get
terraform apply
packer build -var-file=variables.json jupyter_ami.json
terraform destroy -force