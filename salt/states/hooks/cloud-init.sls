{%- from "build.sls" import extraction_dir %}

{%- set user_data_file = salt['file.join'](extraction_dir, 'user-data') %}
cloud-init-user-data:
  file.managed:
    - name: {{ user_data_file }}
    - contents: |
        identity:
          hostname: test-01234
    - require:
      - extract-iso
      - extracted-iso-permissions
    - onchanges_in:
      - generate-custom-iso

set-cloud-init-cmdline-param:
  file.managed:
    - name: {{ salt['file.join'](extraction_dir, 'isolinux/txt.cfg') }}
    - mode: 0660
    - contents: |
        default auto
        label auto
          menu label ^Auto Install Ubuntu Server
          kernel /casper/vmlinuz
          append initrd=/casper/initrd quiet ---
    - require:
      - extract-iso
      - extracted-iso-permissions
    - onchanges_in:
      - generate-custom-iso
