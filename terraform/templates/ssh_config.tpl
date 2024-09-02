Host ${workstation}
  User ${ssh_user}
  IdentityFile ${ssh_key_path}
  StrictHostKeyChecking no

%{ for server in servers ~}
Host ${server}
  User ${ssh_user}
  IdentityFile ${ssh_key_path}
  StrictHostKeyChecking no
  ProxyJump ${workstation}

%{ endfor ~}
