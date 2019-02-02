#!/usr/bin/env python

DOCUMENTATION = """
---
module: docker_info_facts
short_description:
    - A module for injecting Docker info as facts.
description:
    - A module for injecting Docker info as facts.
author: kedwards <kedwards@kevinedwards.ca"
"""

EXAMPLES = """
- name: load docker info facts
  docker_info_facts:
"""

try:
    import docker
except:
    docker_lib_missing = True
else:
    docker_lib_missing = False


def _get_docker_info():
    try:
        cli = docker.from_env()
        return cli.info(), False
    except Exception as e:
        return {}, e.message

def main():
    module = AnsibleModule(
        argument_spec=dict(),
        supports_check_mode=False
    )

    if docker_lib_missing:
        msg = "Could not load docker python library"
        module.fail_json(msg=msg)

    info, err = _get_docker_info()

    if err:
        module.fail_json(msg=e.message)

    module.exit_json(
        changed=True,
        ansible_facts={'docker_info': info})


from ansible.module_utils.basic import *
if __name__ == '__main__':
    main()
