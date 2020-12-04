// PARAMS
param vmOS string {
  default: '2019-Datacenter'
  allowed: [
      '2016-Datacenter'
      '2016-Datacenter-Server-Core'
      '2016-Datacenter-Server-Core-smalldisk'
      '2019-Datacenter'
      '2019-Datacenter-Server-Core'
      '2019-Datacenter-Server-Core-smalldisk'
    ] 
}
param localAdminPassword string {
  secure: true
  metadata: {
      description: 'password for the windows VM'
  }
}

// VAR

var defaultVmName = '${vmPrefix}-${environmentName}'


// RESOURCES

resource vmDataDisk 'Microsoft.Compute/disks@2019-07-01' = {
  name: '${defaultVmName}-vhd'
  location: defaultLocation
  sku: {
      name: 'Premium_LRS'
  }
  properties: {
      diskSizeGB: 32
      creationData: {
          createOption: 'empty'
      }
  }

  

  // OUTPUT 

  output vnetID string = 'XXXX'