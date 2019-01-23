Role Name
=========

Service Manager for Openlink services

Requirements
------------

Service MUST be pre-installed.

Role Variables
--------------

service_mode: auto
service_password: Op3nl1nk
service_env: {{ NO DEFAULT THIS MUST BE ENTERED FROM COMAND LINE }}
service_state: {{ NO DEFAULT THIS MUST BE ENTERED FROM COMAND LINE }}

Dependencies
------------

N/A

Example Playbook
----------------

- name: Openlink Services 
  hosts: vpwv0281ap01.cnpl.enbridge.com
  gather_facts: False
  vars_prompt:
    - name: service_env
      prompt: 'Enter value for Service'
      private: no
      confirm: yes
  tasks:
    - local_action: debug var=service_env
  roles:
    - services

--

ansible-playbook file.yml -i inventory/ -a "service_env=DailyDev service_password=Override"
	
License
-------

BSD

Author Information
------------------

Kevin Edwards <kevin.edwards@enbridge.com>
