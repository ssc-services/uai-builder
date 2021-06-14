{%- from "build.sls" import extraction_dir, ubuntu_release, ubuntu_arch %}
# add a Salt Minion to the ISO and prepare it to connect to a Master, allowing
# for a zero-touch bootstrapping of a new system which is immediately under
# control of a SaltStack infrastructure

{%- if ubuntu_release.startswith('20.04') is sameas true %}
  {%- set short_ubuntu_release = '20.04' %}
{%- endif %}

saltstack-apt-repo-gpg-key:
  file.managed:
    - name:   {{ salt['file.join'](extraction_dir, 'SALTSTACK-GPG-KEY.pub') }}
    - source: https://repo.saltproject.io/py3/ubuntu/{{ short_ubuntu_release }}/{{ ubuntu_arch }}/latest/SALTSTACK-GPG-KEY.pub
    - skip_verify: true
    - require:
      - extract-iso
      - extracted-iso-permissions
    - onchanges_in:
      - generate-custom-iso
