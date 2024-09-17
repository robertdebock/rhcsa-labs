[servers]
%{ for server in servers ~}
${ server }
%{ endfor ~}

[server_0]
${ servers[0] }

[server_1]
${ servers[1] }
