#!/usr/bin/env bash

env=dev03

displayName=myApp-$env

echo $displayName

appId=$(az ad app create --display-name $displayName --native-app --required-resource-accesses '[]' --query "appId" -o tsv)

echo AppId : $appId

spObjectId=$(az ad sp show --id 'fe4e3281-7256-473e-8cd1-9b8f9345c565' --query "objectId" -o tsv)

if [ -z "$spObjectId" ]; then
	Creating Service Principal
	spObjectId=$(az ad sp create --id $appId --query "objectId" -o tsv)
fi

# Retrieve the id of the permissions to grant
groupReadAllId=$(az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "appRoles[?value=='Group.Read.All'].id" --output tsv)
userReadId=$(az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "oauth2Permissions[?value=='User.Read'].id" --output tsv)
userReadAllId=$(az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "appRoles[?value=='User.Read.All'].id" --output tsv)
msGraphResourceId=$(az ad sp show --id 00000003-0000-0000-c000-000000000000 --query "objectId" --output tsv)

echo groupReadAllId : $groupReadAllId
echo userReadId : $userReadId
echo userReadAllId : $userReadAllId
echo msGraphResourceId : $msGraphResourceId

exit 0

# Add the permissions required to the definition of the application (optional as it is just a declaration of the permissions needed)

echo az ad app update --id $appId --required-resource-accesses manifest2.json
echo az ad app update --id $appId --required-resource-accesses "[{
        \"resourceAppId\": \"00000003-0000-0000-c000-000000000000\",
        \"resourceAccess\": [{
                        \"id\": \"$userReadAllId\",
                        \"type\": \"Scope\"
                },
                {
                        \"id\": \"$userReadId\",
                        \"type\": \"Scope\"
                }
        ]
        }]"
		
		exit 0;
		
echo "Grant permissions Group.Read.All (id '$groupReadAllId') and User.Read.All (id '$userReadAllId') on resource Microsoft Graph with id '$msGraphResourceId' to service principal '$spObjectId'..."
# Wait before granting the permissions to avoid error "Request_ResourceNotFound" on the service principal just created
sleep 20
# Grant permissions to the service principal of the application
az rest --method POST \
        --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$spObjectId/appRoleAssignments" \
        --body "{
        \"principalId\": \"$spObjectId\",
        \"resourceId\": \"$msGraphResourceId\",
        \"appRoleId\": \"$userReadAllId\"
        }"

az rest --method POST \
        --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$spObjectId/appRoleAssignments" \
        --body "{
        \"principalId\": \"$spObjectId\",
        \"resourceId\": \"$msGraphResourceId\",
        \"appRoleId\": \"$groupReadAllId\"
        }"
		
		
		
az ad app update --id fe4e3281-7256-473e-8cd1-9b8f9345c565 --required-resource-accesses '[{"resourceAppId": "00000003-0000-0000-c000-000000000000","resourceAccess": [{ "id": "df021288-bdef-4463-88db-98f22de89214", "type": "Role" },{"id": "5b567255-7703-4780-807c-7be8301ae99b","type": "Role"}]}]'

