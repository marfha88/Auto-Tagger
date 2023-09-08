# Prerequisites
# 1. install-Module -name az

$sub = "yoursubscription" # Change this to the subscription ID to use to deploy the resource group and Automation Account.
$rgName = "auto-tagger-aa" # Change this to the name of the resource group to be created.
$aaName = "auto-tagger" # Change this to the name to the name of the Automation Account to be created.
$location = "westeurope" # Change this to the location to deploy the resource group and Automation Account to.

connect-AzAccount
Set-AzContext $sub

New-AzResourceGroup -Name $rgName -Location $location

$automationAccount = New-AzAutomationAccount -Name $aaName -ResourceGroupName $rgName -Location $location -AssignSystemIdentity

# Wait for the Automation Account to be created
Start-Sleep 30

# Define the RBAC role to assign to the Automation Account
$rbacRole = "Tag Creator"

# Assign the RBAC role to the Automation Account
New-AzRoleAssignment -RoleDefinitionName $rbacRole -ObjectId $automationAccount.Identity.PrincipalId -Scope "/subscriptions/$sub" 

# Output information about the created Automation Account and RBAC assignment
$automationAccount