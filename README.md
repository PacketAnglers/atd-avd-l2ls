# Deploy L2LS using AVD and CVP
This PoC will allow you to use Arista's AVD automation framework to deploy a single datacenter, layer 2 leaf spine fabric with MLAG and vARP.  Additionally, it incorporates CVP into the CI/CD pipeline for configuration change management and auditing.  The PoC will have you modifying configuration files and implementing the changes yourself using AVD.

## Datacenter Fabric Topology
Below is a network diagram of the datacenter topology you will be working with.  

![Topology](images/atd-l3ls-topo.png)

## Directory Structure and Layout
Since this topology is for two datacenters, the vars and inventory directories and files are broken out per datacenter.  This means there is an inventory file and group_vars directory for each datacenter.  Additionally, since some things are standard across both datacenters, there is a global_vars directory and file.  Finally, the playbooks for building and deploying changes are also split between the datacenters.  The tree structure below outlines all of these items:

### Directory and File Structure
```bash
|---playbooks
    |---build_dc1.yml
    |---deploy_dc1.yml
|---sites
    |---dc1 [Inventory and VARs for DC1 only]
    |   |---dci_configs [Non AVD Configs for Topology]
    |   |   |---s1-core1.cfg
    |   |   |---s1-core2.cfg
    |   |---groups_vars
    |   |   |---dc1_fabric_ports.yml
    |   |   |---dc1_fabric_services.yml
    |   |   |---dc1_fabric.yml
    |   |   |---dc1_hosts.yml
    |   |   |---dc1_leafs.yml
    |   |   |---dc1_spines.yml
    |   |   |---dc1.yml
    |   |---inventory.yml
    |---dc2 [Inventory and VARs for DC2 only]
    |   |---dci_configs [Non AVD Configs for Topology]
    |   |   |---s2-core1.cfg
    |   |   |---s2-core2.cfg
    |   |---groups_vars
    |   |   |---dc2_fabric_ports.yml
    |   |   |---dc2_fabric_services.yml
    |   |   |---dc2_fabric.yml
    |   |   |---dc2_hosts.yml
    |   |   |---dc2_leafs.yml
    |   |   |---dc2_spines.yml
    |   |   |---dc2.yml
    |   |---inventory.yml
|---ansible.cfg
|---Makefile
|---README.md
```

# Getting AVD going in the ATD programmability IDE
From your ATD environment, launch the programmability IDE, enter the password, and launch a new terminal:

![Topo](images/programmability_ide.png)

## STEP #1 - Install deepmerge

- From the terminal session, run the following command.

``` bash
pip install deepmerge
```

## STEP #2 - Clone Necessary Repos

- Change working directory. The following commands will be executed from here.

``` bash
cd labfiles
```

- Install the AVD devel collection

``` bash
ansible-galaxy collection install git+https://github.com/aristanetworks/ansible-avd.git#/ansible_collections/arista/avd/,devel
```

- Clone the POC Repo

``` bash
git clone https://github.com/PacketAnglers/atd-avd-l2ls.git
```

- At this point you should see the `atd-avd-l2ls` directory under the labfiles directory.

## STEP #3 - Update Passwords and SSH Keys

The ATD Lab switches are preconfigured with MD5 encrypted passwords.  AVD uses sha512 passwords so we need to convert the current MD5 password to sha512.  **You will need to login to a switch to do this step.**

From the Programmibility IDE Explorer:

- Navigate to the `labfiles/atd-avd-l2ls/group_vars` folder.
- Double click on the **group_vars/datacenter.yml** file to open an editor tab.
- Update lines 4, 48, and 49.  **Follow** instructions per line below.

### Update Line 4

- Update `ansible_password` key (line 4) with your unique lab password found on the **Usernames and Passwords** section of your lab topology screen.

``` yaml
# group_vars/datacenter.yml
#
# Credentials for CVP and EOS Switches
ansible_password: XXXXXXXXXXX
```

### Update Lines 48 & 49

- First, convert the current `arista` username type 5 password to a sha512 by running the following commands on one of your switches. Substitute XXXXXXX with your Lab's unique password.

``` bash
config
username arista privilege 15 role network-admin secret XXXXXXXX
```

- Retrieve password and ssh key for user `arista`.

``` bash
show run section username | grep arista
```

- Update the sha512_password and ssh_key with the above values. _Remember to keep the double quotes and DO NOT REMOVE `ssh-rsa` from the ssh_key._

- line 49 - `sha512_password:`
- line 50 - `ssh_key:`

Your file should look similar to below.  Use values your show command output above, as they are unique to your switches.

``` yaml
# group_vars/datacenter.yml
#
# local users to be configured on switch
local_users:
  arista:
    sha512_password: "XXXXXXXXXXXXXX"
    ssh_key: "ssh-rsa XXXXXXXXXXXXXXXXXXX"
```

## Change directory to the actual repo
``` bash
cd atd-avd-l2ls
```

## Now You're Ready To Rock
