#!/bin/bash


echo "Enter the region in which you want to deploy this Solution or enter All to deploy in all regions: "  
read region

case $region in

  ALL|all|All)
    declare -a arr=("ap-northeast-1" "ap-northeast-2" "ap-northeast-3" "ap-south-1" "ap-southeast-1" "ap-southeast-2" "ca-central-1" "eu-central-1" "eu-north-1" "eu-west-1" "eu-west-2" "eu-west-3" "sa-east-1" "us-east-1" "us-east-2" "us-west-1" "us-west-2")
    for i in "${arr[@]}"
    do

    sed "s/folder/$i/g" template/main.tf > main.tf

    TERRAFORM_INIT=$(expect -c "
    spawn terraform init
    expect \"Enter a value\"
    send \"no\r\"
    set timeout 15
    expect eof
    ")

    TERRAFORM_RUN=$(expect -c "
    spawn terraform apply
    expect \"Enter a value\"
    send \"$i\r\"
    set timeout 10
    expect \"Enter a value\"
    send \"yes\r\"
    set timeout 100
    expect eof
    ")

    echo "$TERRAFORM_INIT"
    echo "$TERRAFORM_RUN"

    done

    ;;
 


  *)
    sed "s/folder/$region/g" template/main.tf > main.tf
    TERRAFORM_INIT=$(expect -c "
    spawn terraform init
    expect \"Enter a value\"
    send \"no\r\"
    set timeout 15
    expect eof
    ")

    TERRAFORM_RUN=$(expect -c "
    spawn terraform apply
    expect \"Enter a value\"
    send \"$region\r\"
    set timeout 20
    expect \"Enter a value\"
    send \"yes\r\"
    set timeout 100
    expect eof
    ")

   echo "$TERRAFORM_INIT"
   echo "$TERRAFORM_RUN"
    ;;


esac

