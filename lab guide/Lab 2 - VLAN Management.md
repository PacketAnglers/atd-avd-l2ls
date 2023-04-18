# **Lab 2 - VLAN Management**

This lab will show you how simple day 2 operations are for creating new VLANs for your fabric.  In an environent without automation, scaling VLANs is an arduous process.  AVD allows us to make a few small modifications, and scales the VLANs to the applicable devices.  During this lab, you will modify the `site1_fabric_services.yml` and the `site1_fabric.yml`.

Modify the ***fabric_services*** vars file to add the following VLANs, following the syntax of the existing VLAN defintions.

```yaml
svi: 20
    name: twenty
    tag: 20 
    subnet: 10.20.20.0/24
        spine1: 10.20.20.2
        spine2: 10.20.20.3
        vip: 10.20.20.1

svi: 30
    name: thirty
    tag: 30
    subnet: 10.30.30.0/24
        spine1: 10.30.30.2
        spine2: 10.30.30.3
        vip: 10.30.30.1

svi: 40
    name: forty
    tag: 40
    subnet: 10.40.40.0/24
        spine1: 10.40.40.2
        spine2: 10.40.40.3
        vip: 10.40.40.1

l2vlan: 999
    name: black_hole
    tag: 999
```

After modifying and saving the VARs file, modify the ***site1_fabric.yml*** file, and add the VLAN tags where necessary to ensure all the newly created VLANs are tied to both leaf pairs.  Once finished, save the ***site1_fabric.yml*** file and complete the following steps to deploy the changes.


1) Issue `make build` to generate the new structured and device configurations.

2) Review the configurations in the ***intended/configs*** directory and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.

4) Issue `make deploy_cvp`, review the created change controls in CVP, and approve.

5) Login to spine 1 and 2, and leaf switches 1 and 2 and verify the new configurations are present.