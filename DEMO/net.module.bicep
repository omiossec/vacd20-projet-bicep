// Param Section
param  vnetName string
param  vnetPrefix string
param vnetLocation string = resourceGroup().location

// VNET 
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: vnetLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnemt'
        properties: {
          addressPrefix: vnetPrefix
          networkSecurityGroup: {
            id: subnetNSG.id
          }
        }
      }
    ]
  }
}

resource subnetNSG 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: '${vnetName}-nsg'
  location: vnetLocation
  properties: {
    securityRules: [
      {
        name: 'allow-web'
        properties: {
          priority: 1000
          sourceAddressPrefix: '*'
          protocol: 'Tcp'
          destinationPortRange: '80'
          access: 'Allow'
          direction: 'Inbound'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

output vnetID string = vnet.id