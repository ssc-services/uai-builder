# Ubuntu Auto Install Builder

Builds customizable ISOs for fully automated Ubuntu Server installations

## Requirements
This tools uses SaltStack's `salt-call` to handle the build process and requires `mkisofs`.
The following packages need to be installed for running it on Ubuntu:
- `salt-minion` (see: https://repo.saltstack.com/#ubuntu)
- `genisoimage`

## Usage
After cloning this repository either copy the contents of ``hooks-samples`` to ``hooks`` (necessary because of https://github.com/saltstack/salt/issues/6237) and customize it to your liking or checkout the custom states that should be applied to your image from a different repo into ``hooks``.

Finally change to the root directory of it (the same as the one containing this README) and execute:
```bash
sudo salt-call state.sls build
```
The resulting ISO file will be located in `output/`

## Cleanup
To remove any generated data, use the `clean` state:
```bash
salt-call state.sls clean
```
It also allows for finer-grained control over the cleanup, e.g.

Remove generated ISO files:
```bash
salt-call state.sls clean.output
```

Remove cached data, such as the original ISO file:
```bash
salt-call state.sls clean.cache
```

Remove the working directory containing the extracted ISO:
```bash
salt-call state.sls clean.workdir
```
