{%- set ubuntu_release = '20.04' %}
{%- set ubuntu_arch = 'amd64' %}
{%- set iso_name_base = 'ubuntu-' ~ ubuntu_release ~ '-live-server-' ~ ubuntu_arch %}
{%- set iso_name = iso_name_base ~ '.iso' %}
{%- set iso_url = 'https://releases.ubuntu.com/' ~ ubuntu_release ~ '/' ~ iso_name %}
{%- set cache_dir = salt['file.join'](opts['cachedir'], 'uai-builder') %}
{%- set extraction_dir = salt['file.join'](cache_dir, 'iso_extracted', iso_name) %}
{%- set build_timestamp = salt['status.time']('%FT%T')|replace(':', '-') %}
{%- set iso_output_dir = salt['file.join'](grains['cwd'], 'output') %}
{%- set iso_output_name = iso_name_base ~ '-' ~ build_timestamp ~ '.iso' %}
{%- set iso_output_path = salt['file.join'](iso_output_dir, iso_output_name) %}

cache-iso:
  file.cached:
    - name: https://releases.ubuntu.com/{{ ubuntu_release }}/{{ iso_name }}
    - source_hash: https://releases.ubuntu.com/{{ ubuntu_release }}/SHA256SUMS

cache-directory:
  file.directory:
    - name: {{ cache_dir }}
    - makedirs: true

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

{%- set user_data_file = salt['file.join'](extraction_dir, 'user-data') %}
cloud-init-user-data:
  file.managed:
    - name: {{ user_data_file }}
    - contents: |
        identity:
          hostname: test-01234
    - require:
      - cache-directory

install-genisoimage:
  pkg.installed:
    - name: genisoimage

output-directory:
  file.directory:
    - name: {{ iso_output_dir }}

boot-image-file-writable:
  file.managed:
    - name: {{ salt['file.join'](extraction_dir, 'isolinux/isolinux.bin') }}
    - mode: 0660

generate-custom-iso:
  cmd.run:
    - name: >
        /bin/bash -c '
        mkisofs -r -quiet
        -V "Ubuntu Server {{ ubuntu_release }} Custom"
        -cache-inodes
        -J -l -b isolinux/isolinux.bin
        -c isolinux/boot.cat -no-emul-boot
        -boot-load-size 4 -boot-info-table
        -o {{ iso_output_path }}
        {{ extraction_dir }}
        '
    - cwd: {{ extraction_dir }}
    - creates:
      - {{ iso_output_path }}
    - require:
      - install-genisoimage
      - output-directory
      - boot-image-file-writable
