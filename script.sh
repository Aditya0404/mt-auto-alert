#!/bin/bash


echo "Enter the region in which you want to deploy this Solution or enter All to deploy in all regions: "  
read region

case $region in

  ALL|all|All)
    declare -a arr=("us-east-1" "ap-south-1" )
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

