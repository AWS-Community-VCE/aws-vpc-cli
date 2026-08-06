#!/bin/bash

REGION = "us-east-1"

echo "creating vpc: "

VPC_ID = $(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text --region $REGION)

echo "VPC: $VPC_ID"

echo "creating internet gateway: "

IGW_ID = $(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --region $REGION)

echo "IGW: $IGW_ID"

aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION

echo "creating public subnets: "

PUB1 = $(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text --region $REGION
PUB2 = $(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text --region $REGION

echo "creating private subnets: "

PRI1 = $(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.11.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text --region $REGION
PRI2 = $(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.12.0/24 --availability-zone us-east-1a --query 'Subnet.SubnetId' --output text --region $REGION

aws ec2 modify-subnet-attribute --subnet-id $PUB1 --map-customer-owned-ip-on-launch --region $REGION
aws ec2 modify-subnet-attribute --subnet-id $PUB2 --map-customer-owned-ip-on-launch --region $REGION

echo "creating route table: "

$PUBLIC_RT = $(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text --region $REGION

aws ec2 create-route --route-table-id $PUBLIC_RT --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION

aws ec2 associate-route-table --subnet-id $PUB1 --route-table-id $PUBLIC_RT --region $REGION
aws ec2 associate-route-table --subnet-id $PUB2 --route-table-id $PUBLIC_RT --region $REGION


echo "VPC created: "
echo "VPC: $VPC_ID"
echo "IGW: $IGE_ID"
echo "Public subnet1: $PUB1"
echo "PUblic subnet2: $PUB2"
echo "Private subnet1: $PRI1"
echo "Private subnet2: $PRI2"
echo "Route table: $PUBLIC_RT"

export VP_ID=$VPC_ID
export IGW_ID=$IGW_ID
export PUB1=$PUB1
export PUB2=$PUB2
export PRI1=$PRI1
export PUBLIC_RT=$PUBLIC_RT
