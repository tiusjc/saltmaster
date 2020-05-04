# Saltstack Dockerfiles

# Introdução

## Este repositório possui dois dockerfiles do Salt:

salt-master: Este contêiner configura uma instância de salt-master, a configuração já aceita automaticamente os minions que apontarem para o ip do servidor Salt e também já habilita a API do salt na porta 8000.

## Uso

### Iniciando o container **salt-master**

```bash
$ docker run --net dockerTI --ip 172.20.0.26 --hostname saltmaster --name saltmaster -v /etc/salt/master.d:/etc/salt/masterd.d -v /srv/salt:/srv/salt -p 8000:8000 -ti tiusjc/saltmaster:buster /bin/bash
```
### Executando comando no contêiner via linha de comando (docker exec)


```
$ docker exec saltmaster /bin/bash -c "salt-run salt.cmd test.ping"
```
### Executando API do salt

1. Gerar um token 

```
# curl -sS http://localhost:8000/login -c ~/cookies.txt -H 'Accept: application/json' \ 
-d username=saltdev -d password=saltdev -d eauth=pam
```
```
{
  "return": [
  {
    "perms": [
    ".*"
    ],
    "start": 1446379166.406894,
    "token": "4072d45939ad1a33ffbe0565ec7d15d0cf2e24c2",
    "expire": 1446422366.406895,
    "user": "saltdev",
    "eauth": "pam"
  }
  ]
}
```

2. Executando comandos via API do Salt.
```
$ curl -sS http://localhost:8000 -b ~/cookies.txt -H 'Accept: application/json' -d client=local \
-d tgt='*' -d fun=cmd.run -d arg="uptime"
```

## Advertências e segurança

- saltstack-master: Expõe a porta 8000/tcp ( SEM SSL ) para consumir salt-api através de sua interface HTTP.

  AVISO : suas credenciais viajam em texto sem formatação.

- salt-master: funciona com o módulo de autenticação PAM. Um usuário **saltdev** e senha **saltdev** foi adicionado ao contêiner.

## Arquivos de States
Você deve gravar arquivos de states no **/srv/salt** no host do contêiner.
