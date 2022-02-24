#!/bin/env bash

set -e

objectId=<objectId>
tenantId=<tenantId>

set -vx

echo Inefficient option to find ObjectId belongs to SP, Group or User
az ad sp  show --id $objectId --query "displayName" -o tsv --only-show-errors
az ad group list --filter "(objectId eq '"$objectId"')" --query "[].displayName" -o tsv --only-show-erros
az ad user show --id $objectId --query "displayName" -o tsv --only-show-errors
After calls, you can decide, ObjectId is valid or not.

echo Efficient option to find ObjectId belongs to SP, Group or User
graphUrl='https://graph.windows.net/'"$tenantId"'/directoryObjects/'$objectId
dirObject=$(az rest --method GET --uri $graphUrl --uri-parameters 'api-version=1.6' -o json 2>/dev/null)

if [ -z "$dirObject" ]; then

	objectType=$(echo $dirObject | jq -r '. | .objectType')
	if [ "$objectType" == 'ServicePrincipal'  ]; then
		echo $(echo $dirObject | jq -r '. | [.displayName] | @tsv '), 'Application'
	elif [ "$objectType" == 'User'  ]; then
		echo $(echo $dirObject | jq -r '. | [.displayName, .userType] | @tsv ')
	elif [ "$objectType" == 'Group'  ]; then
		echo $(echo $dirObject | jq -r '. | [.displayName, .userType] | @tsv ')
	elif
		echo $(echo $dirObject | jq -r '. | [.displayName] | @tsv '), $objectType
	fi
else
	echo Unknown objectId : $objectId
fi