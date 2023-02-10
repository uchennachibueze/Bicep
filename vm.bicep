resource group MyResourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
    name: 'myresourcegroup'
    location: 'westus'
};

resource virtualMachine MyVM 'Microsoft.Compute/virtualMachines@2020-06-01' = {
    name: 'myvm'
    location: MyResourceGroup.location
    properties: {
        hardwareProfile: {
            vmSize: 'Standard_D2s_v3'
        }
        storageProfile: {
            imageReference: {
                publisher: 'Canonical'
                offer: 'UbuntuServer'
                sku: '20.04-LTS'
                version: 'latest'
            }
        }
        osProfile: {
            computerName: 'myvm'
            adminUsername: 'adminuser'
            adminPassword: 'adminpassword'
        }
        networkProfile: {
            networkInterfaces: [
                {
                    id: MyNIC.id
                }
            ]
        }
    }
};

resource networkInterface MyNIC 'Microsoft.Network/networkInterfaces@2020-06-01' = {
    name: 'mynic'
    location: MyResourceGroup.location
    properties: {
        ipConfigurations: [
            {
                name: 'myipconfig'
                properties: {
                    privateIPAllocationMethod: 'Dynamic'
                    subnet: {
                        id: MySubnet.id
                    }
                }
            }
        ]
    }
};

resource virtualNetwork MyVNET 'Microsoft.Network/virtualNetworks@2020-06-01' = {
    name: 'myvnet'
    location: MyResourceGroup.location
    properties: {
        addressSpace: {
            addressPrefixes: ['10.0.0.0/16']
        }
        subnets: [
            {
                name: 'mysubnet'
                properties: {
                    addressPrefix: '10.0.0.0/24'
                }
            }
        ]
    }
};

resource subnet MySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
    name: 'mysubnet'
    properties: {
        addressPrefix: MyVNET.properties.addressSpace.addressPrefixes[0]
    }
};
