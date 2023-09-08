try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}
# Define the tags and their values
$tagsToAdd = @(
    @{
        Key = 'owner'
        Value = 'Who is the owner' # Change this to the email address of the product owner
    },
    @{
        Key = 'team'
        Value = 'what team created this resource' # Change this to the name of the team
    },
    @{
        Key = 'createdby'
        Value = 'who created it (can be an email)' # Change this to the email address of the team
    },
    @{
        Key = 'environment'
        Value = 'Dev/Test/Prod' # Change this to the environment name
    }
)

<# copy this code but change the key and value to add more tags and add it to $tagsToAdd above!
,
    @{
        Key = 'extratag'
        Value = 'extravalue'
    }
#>

# Get all Azure subscriptions without displaying errors and warnings
$subscriptions = Get-AzSubscription -ErrorAction SilentlyContinue

# Iterate through each subscription
foreach ($subscription in $subscriptions) {
    if ($null -ne $subscription) {
        # Select the current subscription
        Set-AzContext -SubscriptionId $subscription.Id

        # Get all resource groups in the current subscription without displaying errors and warnings
        $resourceGroups = Get-AzResourceGroup -ErrorAction SilentlyContinue

        if ($null -ne $resourceGroups) {
            # Iterate through each resource group
            foreach ($resourceGroup in $resourceGroups) {
                if ($null -ne $resourceGroup) {
                    # Iterate through each tag to add
                    foreach ($tagToAdd in $tagsToAdd) {
                        $tagKey = $tagToAdd.Key
                        $tagValue = $tagToAdd.Value

                        # Check if the tag already exists in the resource group
                        if ($null -ne $resourceGroup.Tags -and -not $resourceGroup.Tags.ContainsKey($tagKey)) {
                            # Add the tag to the resource group
                            $resourceGroup.Tags[$tagKey] = $tagValue

                            # Update the resource group with the new tag without displaying errors and warnings
                            Set-AzResourceGroup -ResourceGroupName $resourceGroup.ResourceGroupName -Tag $resourceGroup.Tags -ErrorAction SilentlyContinue
                        }
                    }
                }
            }
        }
    }
}