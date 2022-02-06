#!/usr/bin/env bash

# ##Ready
# identifierUris=("api64872e8b-a211-4773-9034-73716950ac93" "Two")
# identifierUrisJson=$( jq -n --argjson v "$(printf '%s\n' "${identifierUris[@]}" | jq -R . | jq -s .)" '{"identifierUris": $v}' )
# echo "${identifierUrisJson}"

function ToJsonStringArray(){
	local roles=("$@")
	shift
	rolesJson="$(printf '%s\n' "${roles[@]}" | jq -R . | jq -s .)"
	echo "${rolesJson[@]}"
}

function allowedMemberTypesToJson(){
	local allowedMemberTypes="$1"
	local description="$2"
	local displayName="$3"
	local isEnabled="$4"
	local value="$5"

	allowedmembertypesjson=$(jq -n 	--argjson allowedMemberTypes "$allowedMemberTypes" \
					--arg description  "$description" \
					--arg displayName "$displayName" \
					--arg isEnabled $isEnabled \
					--arg value "$value" '$ARGS.named')
					
	echo "${allowedmembertypesjson}"
}

function appRolesToJsonArray(){
	local appRoles=("$@")
	shift
	# ${appRoles[@]} | | jq -R . | jq -s .
	appRolesJson=$(jq -n --arg appRoles "$appRoles" '$ARGS.named')
	echo "${rolesJson[@]}"
}

roleSales=("User" "Application")
roleSalesJson=$(ToJsonStringArray "${roleSales[@]}")
# echo "${rolesJson}"
salesAppRole=$(allowedMemberTypesToJson "${roleSalesJson}" "Sales User List" "Sales" true "Sales")
# echo "${salesAppRole}"

roleTrader=("Application")
roleTraderJson=$(ToJsonStringArray "${roleTrader[@]}")
traderAppRole=$(allowedMemberTypesToJson "${roleTraderJson}" "Trader User List" "Trader" true "Trader")
# echo "${traderAppRole}"

appRoles=("${salesAppRole}" "${traderAppRole}")

printf -v joined '%s,' "${appRoles[@]}"

"${joined%,}" | jq ".[]"

# echo "${appRoles[@]}"

# "$(printf "${appRoles[@]}"| jq -R . | jq -s .)"

# "${appRoles}" | jq -R . | jq -s .

# appRolesToJsonArray "${appRoles[@]}"

exit 0

description="TraderApp to read commodity list"
displayName="TraderApp"
isEnabled=true
value="TraderApp" 

rolesJson="$(printf '%s\n' "${roles[@]}" | jq -R . | jq -s .)"

allowedmembertypesjson=$(jq -n 	--argjson allowedMemberTypes "$rolesJson" \
				--arg description  "$description" \
				--arg displayName "$displayName" \
				--arg isEnabled $isEnabled \
				--arg value "$value" '$ARGS.named')
				
echo "${allowedmembertypesjson}"




# allowedmembertypesjson=$( jq -n --argjson v "$rolesJson" '"allowedmembertypes": $v'  \
								# --arg description "traderapp to read commodity list" \
								# '$args.named')

# echo "${allowedmembertypesjson}"

# allowedMemberTypesJson=$( jq -n --argjson v "${rolesJson}" '{"allowedMemberTypes": $v}' \
								# --arg description "TraderApp to read commodity list" \
								# '$ARGS.named')

# echo "${allowedMemberTypesJson}"

# final=$(jq -n 	--argjson appRoles "[$allowedMemberTypesJson]" \
				# --arg description "TraderApp to read commodity list" \
				# --arg displayName "TraderApp" \
				# --arg isEnabled true \
				# --arg value "TraderApp" \
              # '$ARGS.named'
# )

# echo "$final"