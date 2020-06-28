{%- from "build.sls" import iso_output_dir %}

{{ iso_output_dir }}:
  file.absent
