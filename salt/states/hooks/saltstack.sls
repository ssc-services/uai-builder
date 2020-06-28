{%- from "build.sls" import extraction_dir, ubuntu_release, ubuntu_arch %}
# add a Salt Minion to the ISO and prepare it to connect to a Master, allowing
# for a zero-touch bootstrapping of a new system which is immediately under
# control of a SaltStack infrastructure

saltstack-apt-repo-gpg-key:
  file.managed:
    - name:   {{ salt['file.join'](extraction_dir, 'SALTSTACK-GPG-KEY.pub') }}
    - source:      https://repo.saltstack.com/py3/ubuntu/{{ ubuntu_release }}/{{ ubuntu_arch }}/latest/SALTSTACK-GPG-KEY.pub
    - skip_verify: true
    - require:
      - extract-iso
    - require_in:
      - generate-custom-iso
