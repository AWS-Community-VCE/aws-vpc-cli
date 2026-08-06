#!/bin/bash

source resources.sh

echo "Deleting Route Table..."

aws ec2 delete-route --route-table-id $PUBLIC_RT --destination-cidr-block 0.0.0.0/0 --region $REGION
    
for ASSOC in $(aws ec2 describe-route-tables --route-table-ids $PUBLIC_RT --query "RouteTables[0].Associations[?Main==\`false\`].RouteTableAssociationId" --output text --region $REGION)
do
    aws ec2 disassociate-route-table --association-id $ASSOC --region $REGION
done

aws ec2 delete-route-table --route-table-id $PUBLIC_RT --region $REGION

echo "Deleting Subnets..."

aws ec2 delete-subnet --subnet-id $PUB1 --region $REGION
aws ec2 delete-subnet --subnet-id $PUB2 --region $REGION
aws ec2 delete-subnet --subnet-id $PRI1 --region $REGION
aws ec2 delete-subnet --subnet-id $PRI2 --region $REGION

echo "Deleting Internet Gateway..."

aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --region $REGION

aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region $REGION

echo "Deleting VPC..."

aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION

echo "All resources deleted."
