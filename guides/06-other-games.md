# 🕹️ Aplicando o Mesmo Padrão a Outros Jogos

A arquitetura deste repositório (EC2 + Security Group + processo persistente em `screen`/`systemd`) não é exclusiva de Minecraft. A diferença entre hospedar Minecraft e qualquer outro jogo dedicado é, na prática, só três coisas: **a porta**, **o método de instalação do servidor**, e **o tanto de RAM**. Tudo do resto — Etapas 1 a 4 do [`01-aws-academy-setup.md`](01-aws-academy-setup.md) — é igual.

Este guia não é um passo a passo completo por jogo (isso ficaria desatualizado rápido); é um ponto de partida para adaptar o padrão.

## 🔧 A diferença principal: SteamCMD em vez de `.jar`

Minecraft roda em Java, então o "instalador" é sempre um `.jar`. A maioria dos outros jogos dedicados distribui o servidor via **SteamCMD**, a ferramenta de linha de comando da Steam:

```bash
# Dependências (Ubuntu)
sudo apt update
sudo dpkg --add-architecture i386
sudo apt install -y steamcmd

# Padrão geral de instalação
steamcmd +login anonymous +force_install_dir <pasta> +app_update <APP_ID> validate +quit
```

## 📋 Referência rápida por jogo

| Jogo | App ID (SteamCMD) | Porta(s) padrão | RAM aproximada |
|---|---|---|---|
| Valheim | 896660 | 2456-2458 UDP | 4–8 GB |
| Palworld | 2394010 | 8211 UDP (+ 27015 p/ Steam queries) | 8–16 GB |
| Terraria | 105600 | 7777 TCP | 1–2 GB |
| Counter-Strike 2 | 730 | 27015 TCP/UDP (+ 27016) | 4–8 GB, ~60 GB de disco |
| Rust | 258550 | 28015 TCP/UDP | 8–16 GB |

⚠️ App IDs e portas mudam raramente, mas confirme na documentação oficial do jogo antes de montar a regra do Security Group — não confie só nesta tabela para um deploy em produção.

## 🔒 O que muda no Security Group

Mesma lógica do Minecraft: abra só a porta necessária, com a origem mais restrita possível.

```
Tipo: Custom UDP (ou TCP, conforme o jogo)
Porta: <porta do jogo>
Origem: 0.0.0.0/0
```

Alguns jogos (CS2, por exemplo) também exigem um token de autenticação do próprio fornecedor (GSLT, no caso da Valve) — isso é específico do jogo, não da AWS, e fica documentado na configuração do servidor, não no Security Group.

## 🖥️ Mantendo o processo rodando

Mesmo princípio dos guias de Minecraft — `screen` para uso simples, `systemd` para um setup mais robusto que sobrevive a reboots:

```bash
screen -dmS gameserver ./start_server.sh
```

## 🎯 Resumo do que generaliza e do que não generaliza

**Generaliza (igual para qualquer jogo):**
- Lançar e dimensionar a instância EC2 ([`01-aws-academy-setup.md`](01-aws-academy-setup.md), [`02-sizing-guide.md`](02-sizing-guide.md))
- Configurar o Security Group
- Manter o processo rodando em background
- Estratégia de backup ([`scripts/backup-world.sh`](../scripts/backup-world.sh) serve de modelo, adaptando os caminhos)

**Não generaliza (específico de cada jogo):**
- Método de instalação (Java/`.jar` para Minecraft, SteamCMD para a maioria dos outros)
- Porta e protocolo (TCP vs UDP)
- Arquivo de configuração do servidor
- Requisitos de RAM/CPU
