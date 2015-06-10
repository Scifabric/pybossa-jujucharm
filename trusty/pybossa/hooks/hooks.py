#!/usr/bin/env python
from ansiblecharm.runner import AnsibleHooks
import sys
import os


def main(args=sys.argv):
    hooks = AnsibleHooks(playbook_path='playbooks/site.yml',
                         hook_dir=os.path.dirname(__file__),
                         default_hooks=['install'])
    hooks.execute(args)

if __name__ == "__main__":
    main()
