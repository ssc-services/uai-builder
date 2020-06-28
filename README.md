# Ubuntu Auto Install Builder

Builds customizable ISOs for fully automated Ubuntu Server installations

## Requirements
This tools uses SaltStack's `salt-call` to handle the build process and requires `mkisofs`.
The following packages need to be installed for running it on Ubuntu:
- `salt-minion` (see: https://repo.saltstack.com/#ubuntu)
- `genisoimage`

## Usage
After cloning this repository, change to the root directory of it (the same as the one containing this README) and execute:
```bash
salt-call state.sls build
```
