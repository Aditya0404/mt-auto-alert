#!/bin/bash

#terraform init

abc=us-east-1

sed "s/folder/$abc/g" template/main.tf > main.tf

TERRAFORM_RUN=$(expect -c "
spawn terraform apply
expect \"Enter a value\"
send \"$abc\r\"
set timeout 10
expect \"Enter a value\"
send \"yes\r\"
set timeout 30
expect eof
")

echo "$TERRAFORM_RUN"
