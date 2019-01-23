install
================

Installation of the most current Enbridge Openlink Endur CTRM Software.

Requirements
------------

Web / FTP server to host repository
Product bainaries

Role Variables
--------------

vendor: Openlink															= Vendor Name
product_name: Endur															= Product Name
product_build_id: V14_0_08082015ENBR_03162017_1115							= Product Build Id
product_executable: V14_0_08082015ENBR_03162017_BUILD_1115					= Product executable name <product_executable>.exe
install_state: present														= Install or Uninstall [ present | absent ]
root: D:\automation															= Root directory for required temp tools
repository: 'http://mrmwebp.enbridge.com/OLFShare'							= Path to product repositories
automation_path: '{{ root }}\{{ product_build_id }}'						= Generated path to version specific tools
file_repository: '{{repository }}/{{ product_build_id }}'					= Generated downloaf url to version specific repository
product_path: 'D:\{{ vendor }}\{{ product_name }}\{{ product_build_id }}'	= Generated iproduct install path


Dependencies
------------

No dependencies

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - name: Openlink Installation
	  hosts: vp_all,ew_all
	  gather_facts: false
	  roles:
		- install

Cmd
    > ansible-playbook path/to/play.yml --limit VPWV0480AP01
		
License
-------

BSD

Author Information
------------------

Author:		Kevin Edwards
Email: 		kevin.edwards@enbridge.com
			kedwards@livity.consulting
Support:	mrm.systems@enbridge.com