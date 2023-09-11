param(
  [string]$subscriptionId,
  [string]$resourceProviders,
  [string]$resourceProvidersFeatures
)

$ErrorActionPreference = "SilentlyContinue"
# Selecting the right subscription
Select-AzSubscription -SubscriptionId $subscriptionId

# Defining variables
$providers = $resourceProviders | ConvertFrom-Json
$features = $resourceProvidersFeatures | ConvertFrom-Json
$failedProviders = ""
$failedFeatures = ""
$DeploymentScriptOutputs = @{}

#########################################
## Registering the resource providers
#########################################

foreach ($provider in $providers ) {
  try {
    $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $provider).registrationState
    # Check if the providered is registered
    if ($providerStatus -ne 'Registered') {
      Write-Output "`n Registering the '$provider' provider"
      if (Register-AzResourceProvider -ProviderNamespace $provider) {
        Write-Output "`n The '$provider' has been registered successfully"
      }
      else {
        Write-Output "`n The '$provider' provider has not been registered successfully"
        $failedProviders += ",$provider"
      }
    }
    if ($failedProviders.length -gt 0) {
      $output = $failedProviders.substring(1)
    }
    else {
      $output = "N/A"
    }
    $DeploymentScriptOutputs["failedProviderRegistrations"] = $output
  }
  catch {
    Write-Output "`n There was a problem registering the '$provider' provider. Please make sure this provider namespace is valid"
  }
}

##################################################
## Registering the resource providers features
##################################################

if ($features.length -gt 0) {
  foreach ($feature in $features) {
    # Define variables
    try {
      $feature = (Get-AzProviderFeature -ListAvailable | Where-Object FeatureName -eq $feature)
      $featureName = $feature.FeatureName
      $featureStatus = $feature.RegistrationState
      $featureProvider = $feature.ProviderName
      # Check if the feature is registered
      if ($featureStatus -eq 'NotRegistered') {
        Write-Output "`n Registering the '$featureName' feature"
        # Check if the feature's resource provider is registered, if not then register first
        $providerStatus = (Get-AzResourceProvider -ListAvailable | Where-Object ProviderNamespace -eq $featureProvider).RegistrationState
        if ($providerStatus -ne 'Registered') {
          if (Register-AzResourceProvider -ProviderNamespace $featureProvider) {
            Write-Output "`n The '$featureProvider' has been registered successfully"
            Register-AzProviderFeature -FeatureName $featureName -ProviderNamespace $featureProvider
          }
          else {
            Write-Output "`n The '$featureName' feature has not been registered successfully"
            $failedFeatures += ",$featureName"
          }
        }
      }
      if ($failedFeatures.length -gt 0) {
        $output = $failedFeatures.substring(1)
      }
      else {
        $output = "N/A"
      }
      $DeploymentScriptOutputs["failedFeaturesRegistrations"] = $output
    }
    catch {
      Write-Output "`n There was a problem registering the '$featureName' feature. Please make sure this feature name is valid"
    }
  }
}
