param vmName string = 'linuxvm'
param networkInterfaces_linuxvm720_name string = 'linuxvm720'
param vnetName string = '01-bicep-decompile-vnet'

var nicName_var = '${vmName}-nic'
var osVhdName = '${vmName}-nic'

resource vnetName_resource 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: vnetName
  location: 'francecentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.5.0/24'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '172.16.5.0/24'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource vmName_resource 'Microsoft.Compute/virtualMachines@2019-07-01' = {
  name: vmName
  location: 'francecentral'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: osVhdName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: resourceId('Microsoft.Compute/disks', osVhdName)
        }
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'omiossec'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicName.id
        }
      ]
    }
  }
}

resource nicName 'Microsoft.Network/networkInterfaces@2020-05-01' = {
  name: nicName_var
  location: 'francecentral'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '172.16.5.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnetName_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource vnetName_default 'Microsoft.Network/virtualNetworks/subnets@2020-05-01' = {
  name: '${vnetName_resource.name}/default'
  properties: {
    addressPrefix: '172.16.5.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}