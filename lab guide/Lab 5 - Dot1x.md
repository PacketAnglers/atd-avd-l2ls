# **Lab 5 - dot1x**

This lab will cover how to configure dot1x enabled connected endpoints in your fabric using AVD.  This is similar to Lab 4, except the data model is different to accommodate all the dot1x parameters.  

All changes for this lab will be completed in the `site1_fabric_ports.yml` file under the `port_profiles:` subsection.

First you will configure the port profiles.  We will create two profiles, both dot1x enabled, one being a phone/pc profile, and the other a standard access profile.  The data model to be used for these port profiles is shown below.

```yaml
# The port profiles for a voice port vs access port are slightly different, so they are both shown here.

# This is the data model for a voice port
    <name>:
        mode: < access | trunk | "trunk phone" > 
        spanning_tree_portfast: < edge | network >
        spanning_tree_bpduguard: < "enabled" | true | "disabled" >
        native_vlan: < native vlan number >
        structured_config:
            phone:
                trunk: untagged
                vlan: <vlan id>
        dot1x:
            port_control: < "auto" | "force-authorized" | "force-unauthorized" >
            reauthentication: < true | false >
            pae:
                mode: authenticator
            host_mode:
                mode: < "multi-host" | "single-host" >
                multi_host_authenticated: < true | false >
            mac_based_authentication:
                enabled: < true | false >
            timeout:
                reauth_period: < 60-4294967295 | server >
                tx_period: < 1-65535 >
            reauthorization_request_limit: < 1-10 >
            authentication_failure:
                action: < "allow" | "drop" >
                allow_vlan: < 1-4094 >
        
# This is the data model for an access port        
    <name>:
        mode: < access | trunk | "trunk phone" > 
        spanning_tree_portfast: < edge | network >
        spanning_tree_bpduguard: < "enabled" | true | "disabled" >
        vlans: <access vlan>
        dot1x:
            port_control: < "auto" | "force-authorized" | "force-unauthorized" >
            reauthentication: < true | false >
            pae:
                mode: authenticator
            mac_based_authentication:
                enabled: < true | false >
            timeout:
                reauth_period: < 60-4294967295 | server >
                tx_period: < 1-65535 >
            reauthorization_request_limit: < 1-10 >
            authentication_failure:
                action: < "allow" | "drop" >
                allow_vlan: < 1-4094 >
```

Using the above data model, configure the following port profiles in the yaml file:

```yaml
    v30_phone_dot1x:
        mode: "trunk phone" 
        spanning_tree_portfast: edge
        spanning_tree_bpduguard: "enabled"
        native_vlan: 30
        structured_config:
            phone:
                trunk: untagged
                vlan: 40
        dot1x:
            port_control: "auto"
            reauthentication: true
            pae:
                mode: authenticator
            host_mode:
                mode: "multi-host"
                multi_host_authenticated: true
            mac_based_authentication:
                enabled: true
            timeout:
                reauth_period: server
                tx_period: 3
            reauthorization_request_limit: 3
            authentication_failure:
                action: allow
                allow_vlan: 999

    v40_access_dot1x:
        mode: access
        spanning_tree_portfast: edge
        spanning_tree_bpduguard: "enabled"
        vlans: 40
        dot1x:
            port_control: "auto"
            reauthentication: true
            pae:
                mode: authenticator
            mac_based_authentication:
                enabled: true
            timeout:
                reauth_period: server
                tx_period: 3
            reauthorization_request_limit: 3
            authentication_failure:
                action: "allow"
                allow_vlan: 999
```

Now that you have configured the port profiles, we will specify which interfaces on which device we want configured.  The data model for this is the same as from Lab 4, and shown below.

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
    switch_ports: Ethernet37,39,41,43,45,47
    profile: v30_phone_dot1x

Switches: leaf1/2
    switch_ports: Ethernet38,40,42,44,46,48
    profile: v40_access_dot1x
```

After modifying and saving the VARs file, complete the following steps to make the changes.

`***Note:***` Since the ATD environment devices only have 6 ethernet ports, you will not be able to deploy any changes since any interfaces above 6 don't exist.  Therefore, you will just build the configs, and view the final configuration output to see how the interface configurations are automated.

1) Issue `make build` to generate the new structured and device configurations.

2) Review the configurations in the ***intended/configs*** directory and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.