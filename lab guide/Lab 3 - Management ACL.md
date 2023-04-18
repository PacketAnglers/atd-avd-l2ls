# **Lab 3 - Management ACLs**

This lab will again show the power of AVD and automating something standard that could apply to all devices in a fabric.  In this lab, you will be creating a standard management plane ACL which restricts SSH access.  The changes for this configuration only need to be completed in one place.

The below code shows the AVD data model for access-lists, as well as how to apply them to the ssh management plane.  Use the following data model for your congfiguration:

```yaml
ip_access_lists:
- name: "< access list name as string >"
  entries:
    - sequence: < acl entry sequence number >
      action: "< permit | deny >"  # required
      protocol: "< ip | tcp | udp | icmp | other protocol name or number >"  # required
      # NOTE: A.B.C.D without a mask means host
      source: "< any | A.B.C.D/E | A.B.C.D >"  # required
      # NOTE: A.B.C.D without a mask means host
      destination: "< any | A.B.C.D/E | A.B.C.D >"  # required

management_ssh:
  access_groups:
    - name: <acl name>
```

<br>

The below variables show what is to be configured for the management ACL.  Use the above data model, replaced with the desired ACL configuration below, and enter it in the ***site1.yml*** file.

**Hint:** You can put this anywhere in the datacenter.yml file, however, it would probably make the most sense right after the OOB management interface configuration section.

```yaml
ACL Name: mgmt_access

sequences:
    10
        action: permit
        proto: ip
        source: 192.168.0.0/16
        dest: any
    20
        action: permit
        proto: ip
        source: 172.16.0.0/12
        dest: any
    30
        action: permit
        proto: ip
        source: 10.0.0.0/8
        dest: any
```

After modifying and saving the VARs file, complete the following steps to deploy the changes.


1) Issue `make build` to generate the new structured and device configurations.

2) Review the configurations in the ***intended/configs*** directory and verify the changes are correct.

3) Review the changes to the documentation that is auto-created.

4) Issue `make deploy_cvp`, review the created change controls in CVP, and approve.

5) Login to spine 1 and 2, and leaf switches 1 and 2 and verify the new configurations are present.