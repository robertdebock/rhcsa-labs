[servers]
%{ for server in servers ~}
${ server }
%{ endfor ~}

[server-0]
${ servers[0] }

[server-1]
${ servers[1] }
