# **Lab 1 - New Leaf Pair Onboarding**

This lab will show you the simplicity in adding additional leaf pairs to your existing Layer 2 leaf/spines topology.  In a non-automated topology, when deploying new leafs, you would need to duplicate or create the base configs for the new leafs, and then modify the configurations of the existing devices.  For this lab, you will be adding leafs 3 and 4 in the datacenter into the network topology by following the below steps.

1. The first step is to add the new leafs into the inventory file:

You will modify:  `inventory.yml`

Add the following switches into the correct location in the file:

```yaml
leaf3
leaf4
```

2. To enable AVD to generate all the required configuration changes, you will only need to modify the ***datacenter_fabric.yml*** file. Follow the YAML file structure for the existing leaf pairs, 1 and 2, and enter the required changes using the parameters below:

```yaml
group name: RACK2
      mlag: true
      filter:
        tags: tag all vlans

leaf3:
    id: 5
    mgmt_ip: 192.168.0.14/24
    uplink_switch_interfaces: [Ethernet4, Ethernet4]
leaf4:
    id: 6
    mgmt_ip: 192.168.0.15/24
    uplink_switch_interfaces: [Ethernet5, Ethernet5]
```

After modifying and saving the VARs file, complete the following steps to deploy the changes.


1) Issue `make build` to generate the new structured and device configurations.

2) Review the configurations in the ***intended/configs*** directory and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.

4) Issue `make deploy_cvp`, review the created change controls in CVP, and approve.

5) Login to spine 1 and 2, and leaf switches 1 and 2 and verify the new configurations are present.