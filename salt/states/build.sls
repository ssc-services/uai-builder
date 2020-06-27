{%- set ubuntu_release = '20.04' %}
{%- set ubuntu_arch = 'amd64' %}
{%- set iso_name = 'ubuntu-' ~ ubuntu_release ~ '-live-server-' ~ ubuntu_arch ~ '.iso' %}
{%- set iso_url = 'https://releases.ubuntu.com/' ~ ubuntu_release ~ '/' ~ iso_name %}
{%- set cache_dir = salt['file.join'](opts['cachedir'], 'uai-builder') %}
{%- set extraction_dir = salt['file.join'](cache_dir, 'iso_extracted', iso_name) %}

cache-iso:
  file.cached:
    - name: https://releases.ubuntu.com/{{ ubuntu_release }}/{{ iso_name }}
    - source_hash: https://releases.ubuntu.com/{{ ubuntu_release }}/SHA256SUMS

extraction-directory:
  file.directory:
    - name: {{ extraction_dir }}
    - makedirs: true
    - require:
      - cache-directory

install-bsdtar:
  pkg.installed:
    - name: libarchive-tools

extract-iso:
  cmd.run:
    - name: /bin/bash -c "bsdtar --uname ${USER} -xf - < {{ salt['cp.is_cached'](iso_url) }}"
    - cwd:  {{ extraction_dir }}
    - creates:
      # don't list all top-level directories of the ISO, but only a few key items
      # indicative of the ISO being properly unpacked
      - {{ salt['file.join'](extraction_dir, '.disk') }}
      - {{ salt['file.join'](extraction_dir, 'boot') }}
      - {{ salt['file.join'](extraction_dir, 'install') }}
      - {{ salt['file.join'](extraction_dir, 'isolinux') }}
    - require:
      - install-bsdtar
      - extraction-directory
      - cache-iso
