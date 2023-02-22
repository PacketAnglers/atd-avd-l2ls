# **Lab 4 - Port Profiles**

This lab will cover how to configure connected endpoints in your fabric using AVD.  A connected endpoint is simmply any device connected at the access layer, such as user machines, servers, firewalls, etc.  The port profile section within AVD is fairly in-depth, however, in this lab we will cover simple use cases to show how large amounts of port configurations can be automated.

All changes for this lab will be completed in the `datacenter_fabric_ports.yml` file, under the `port_profiles:` sub-section.

First you will configure the port profiles.  We will create a profile for each one of the access vlans.  The data model to be used for these port profiles is shown below.

```yaml
    <name>:    #This is the name you would give this port profile
        mode: < access | trunk | "trunk phone" >   # This specifies how the port operates, the options available are listed between < >.
        vlans: "str here"  # This specifies which VLANs the port or ports have access to.  It must be entered in quotes, and can be a single VLAN for access ports, or multiple VLANs for trunk ports written out with commas and dashes, IE, "140-141", or "110-111,120-121".
        spanning_tree_portfast: < edge | network >  # This specifies the STP portfast type for the device connected with the options listed between < >.
```

Using the above data model, configure the following port profiles in the yaml file:

```yaml
name: v10_port
    mode: access
    vlans: 10
    portfast: edge

name: v20_port
    mode: access
    vlans: 20
    portfast: edge

name: server_trunk
    mode: trunk
    vlans: 10,20,30,40
    portfast: edge
```

Now that you have configured the port profiles, we will specify which interfaces on which device we want configured.  The data model for this is shown below.

```yaml
    - switches:
      # Switches can be a regex match.  IE.  switchname[12] where 1 and 2 are switchname1 and switchname2 respectively.
        - <switches>
      # Switch_ports is a list of ranges using AVD range_expand syntax (see link below).
      # Ex Ethernet1-48 or Ethernet2-3/1-48
      switch_ports:
        - <switch_ports>
      # Port-profile name, to inherit configuration.
      profile: <port profile name>
```

Using the above data model, enter the configuration to accomplish the port configuration requirements listed below.  Within the yaml file, this is configured under the `network_ports:` sub-section.  

```yaml
Switches: leaf1/2
    switch_ports: Ethernet12-24
    profile: v10_port

Switches: leaf1/2
    switch_ports: Ethernet25-36
    profile: v20_port

Switches: leaf3/4
    switch_ports: Ethernet12-48
    profile: server_trunk
```

After modifying and saving the VARs file, complete the following steps to make the changes.

`***Note:***` Since the ATD environment devices only have 6 ethernet ports, you will not be able to deploy any changes since any interfaces above 6 don't exist.  Therefore, you will just build the configs, and view the final configuration output to see how the interface configurations are automated.

1) Issue `make build` to generate the new structured and device configurations.

2) Review the configurations in the ***intended/configs*** directory and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.
