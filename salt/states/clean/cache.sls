# completely removes all files locally cached by SaltStack
{{ opts['cachedir'] }}:
  file.absent
