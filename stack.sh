#!/bin/bash

STACK_SCRIPT='vpc-cf-stack.yaml'
STACK_NAME='vpc-cf-stack'

case $1 in
  create)
    aws cloudformation create-stack --stack-name $STACK_NAME\
     --template-body file://$STACK_SCRIPT\
     --parameters ParameterKey=EnvironmentName,ParameterValue=Dev
  ;;
  update)
    aws cloudformation update-stack --stack-name $STACK_NAME\
     --template-body file://$STACK_SCRIPT\
     --parameters ParameterKey=EnvironmentName,ParameterValue=Dev
  ;;
  delete)
    aws cloudformation delete-stack --stack-name $STACK_NAME
  ;;
  status)
    aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -cr '.Stacks[]?.StackStatus'
  ;;
  outputs)
    aws cloudformation describe-stacks --stack-name $STACK_NAME | jq -cr '.Stacks[]?.Outputs[]?'
  ;;
  events)
    aws cloudformation describe-stack-events --stack-name $STACK_NAME |\
      jq -c '.StackEvents[] | to_entries | map(select(.key | match("^ResourceType$|^ResourceStatus$"))) | from_entries | .ResourceType+":"+.ResourceStatus'
  ;;
  *)
    echo "Usage: stack.sh [create|update|delete|status|outputs|events]"
    exit 1
  ;;
esac
