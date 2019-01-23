# Ansible Roles

This designates the following behaviors, for each role ‘x’:

* If roles/x/tasks/main.yml exists, tasks listed therein will be added to the play
* If roles/x/handlers/main.yml exists, handlers listed therein will be added to the play
* If roles/x/vars/main.yml exists, variables listed therein will be added to the play
* If roles/x/defaults/main.yml exists, variables listed therein will be added to the play
* If roles/x/meta/main.yml exists, any role dependencies listed therein will be added to the list of roles (1.3 and later)

* If roles/x/files/*.* files to be moved from localhost to remote server
* If roles/x/templates/*.* templates

Any copy, script, template or include tasks (in the role) can reference files in roles/x/{files,templates,tasks}/ (dir depends on task) without having to path them relatively or absolutely
