{%- from "build.sls" import extraction_dir %}

# only apply those states, if `extraction_dir` exists,
# otherwise it will be just created and removed again
{%- if salt['file.directory_exists'](extraction_dir) %}
# files and directories extracted from the ISO will be read-only,
# thereby causing a failure removing them.
# Change permissions before removing them.
# See also: https://github.com/saltstack/salt/issues/57830
file-and-directory-permissions:
  file.directory:
    - name:     {{ extraction_dir }}
    - makedirs: true
    - recurse:
      - mode
    - dir_mode:  0770
    - file_mode: 0660

remove-extraction-dir:
  file.absent:
    - name: {{ extraction_dir }}
    - require:
      - file-and-directory-permissions
{%- endif %}
