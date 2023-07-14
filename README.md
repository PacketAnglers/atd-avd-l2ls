# Deploy L2LS using AVD and CVP
This PoC will allow you to use Arista's AVD automation framework to deploy a single datacenter, layer 2 leaf spine fabric with MLAG and vARP.  Additionally, it incorporates CVP into the CI/CD pipeline for configuration change management and auditing.  The PoC will have you modifying configuration files and implementing the changes yourself using AVD. 

***Note:*** This PoC is built to work with AVD 3.8.  Work is currently in progress to update everything to support AVD 4.0.

## Datacenter Fabric Topology
Below is a network diagram of the portion of the dual datacenter topology you will be working with.  This will include the spines, leafs, and hosts, but not the Brdr and Core leafs.

![Topology](images/atd-topo-l2ls.png)

## Directory Structure and Layout
While this topology is for two datacenters, since we are deploying a simple layer 2 leaf spine fabric, we will only be using the Site 1 nodes.  Even though we are just using Site 1, we still locate the vars and inventory files under the site they are in.  The tree structure below outlines all of these items:

### Directory and File Structure
```bash
|---sites
    |---site1
	|---groups_vars
	    |---site1_fabric_ports.yml
	    |---site1_fabric_services.yml
	    |---site1_fabric.yml
	    |---site1_hosts.yml
	    |---site1_leafs.yml
	    |---site1_spines.yml
	    |---site1.yml
    |---inventory.yml
|---lab guide
    |---Lab 1 - Leaf Onboarding.md
    |---Lab 2 - VLAN Management.md
    |---Lab 3 - Management ACL.md
    |---Lab 4 - Port Profiles.md
    |---Lab 5 - Dot1x.md
|---playbooks
    |---build.yml
    |---deploy_cvp.yml
    |---deploy_eapi.yml
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

- Install the AVD 3.8.0 collection

``` bash
ansible-galaxy collection install arista.avd:==3.8.0
```

- Clone the POC Repo

``` bash
git clone https://github.com/PacketAnglers/atd-avd-l2ls.git
```

- At this point you should see the `atd-avd-l2ls` directory under the labfiles directory.

### STEP #3 - Setup Lab Password Environment Variable

Each lab comes with a unique password. We set an environment variable called `LABPASSPHRASE` with the following command. The variable is later used to generate local user passwords and connect to our switches to push configs.

``` bash
export LABPASSPHRASE=`cat /home/coder/.config/code-server/config.yaml| grep "password:" | awk '{print $2}'`
```

You can view the password is set. This is the same password displayed when you click the link to access your lab.

``` bash
echo $LABPASSPHRASE
```

## STEP #4 - Change directory to the actual repo
``` bash
cd atd-avd-l2ls
```

## Building/Deploying Configurations & Labs Info

<br>

This AVD topology includes three labs, with tasks that show Day 2 operations using AVD on a L2LS fabric.  These labs are located in the **lab guide** directory, in the files starting with `Lab 1 - 3`.  You can view these labs in the easily readable MarkDown format within the IDE by right clicking the lab file, and clicking **Open Preview**.  You can also view them natively in github.

Prior to working on these labs, you will need to deploy the initial data center fabric, after you have modified the `ansible_password` as shown above.  The deployment of fabric, both initially, and of any changes, are all performed via running the appropriate ansible playbook, against the correct site inventory file.  To ease this process, alias commands are available to use via the included Makefile, which run the correct ansible playbook against the correct inventory file, using an abbreviated `make command`.

Below is a description of all the available make file commands, what their purpose is, as well as which ansible playbook and inventory file they control.  

<br>


**Command:**  `make build`

```bash
build: ## Build AVD Configs
	ansible-playbook playbooks/build.yml
```
**Playbook Called:**  `build.yml`

**Inventory File:**  `inventory.yml`

**Description:** This command invokes AVD to build the device configurations for all devices in the fabric.  The playbook ingests everything defined in the various yml files in the group_vars directory.  It then creates the `intended/configs`, `intended/structured_configs`, and `documentation` directories.  Finally, it generates the all device configs, structured configs, and markdown documentation files.

<br>
<br>


**Command:**  `make deploy_cvp`

```bash
deploy_cvp: ## Build AVD Configs
	ansible-playbook playbooks/deploy_cvp.yml
```
**Playbook Called:**  `deploy_cvp.yml`

**Inventory File:**  `inventory.yml`

**Description:** This command invokes AVD to deploy the created configurations, and make the necessary container changes in CVP.  The playbook calls the deploy_cvp role, modifying the CVP container structure if necessary, uploading the created configuration to CVP as configlets, and deploying those configlets to the relevant devices in datacenter1.  The playbook also has a flag called `execute_tasks: true`, which tells CVP to automatically create a change control for the created tasts, and execute them without user intervention.

<br>
<br>


**Command:**  `make deploy_eapi`

```bash
deploy_eapi: ## Deploy AVD configs via eAPI
	ansible-playbook playbooks/deploy_eapi.yml
```
**Playbook Called:**  `deploy_eapi.yml`

**Inventory File:**  `inventory.yml`

**Description:** This command invokes the eos_config module to deploy the created configurations only on applicable devices in the fabric, bypassing CVP and using the device eAPIs.  This playbook show an alternative way to use automation and AVD, without CVP for managing configurations.


<br>
<br>

### Initial Configuration Build & Deployment

Follow the below steps of which make commands to run to build the initial fabric using AVD.

1) Build datacenter configs:  `make build`
5) Deploy datacenter configs via CVP:  `make deploy_cvp`
    1) login to cvp and watch the tasks and change control screens to see the tasks auto-created and executed.
7) Login to switch CLIs and verify configs and operation.
8) Continue on with labs in the `lab guide` directory.
