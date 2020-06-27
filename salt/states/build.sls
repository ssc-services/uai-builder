{%- set cache_dir = salt['file.join'](opts['cachedir'], 'uai-builder') %}
{%- set mount_dir = salt['file.join'](cache_dir, 'mount') %}
{%- set ubuntu_release = '20.04' %}
{%- set ubuntu_arch = 'amd64' %}
{%- set iso_name = 'ubuntu-' ~ ubuntu_release ~ '-live-server-' ~ ubuntu_arch ~ '.iso' %}

cache-directory:
  file.directory:
    - name: {{ cache_dir }}

provide-iso:
  file.managed:
    - name: {{ salt['file.join'](cache_dir, iso_name) }}
    - source: https://releases.ubuntu.com/{{ ubuntu_release }}/{{ iso_name }}
    - source_hash: https://releases.ubuntu.com/{{ ubuntu_release }}/SHA256SUMS
    - require:
      - cache-directory

mount-directory:
  file.directory:
    - name: {{ mount_dir }}
    - require:
      - cache-directory
