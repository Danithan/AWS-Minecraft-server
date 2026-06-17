# 📦 Case Study: COBBLEVERSE - Pokemon Adventure [Cobblemon]

Terceira fase do projeto, e a primeira a usar **Fabric** em vez de Forge/NeoForge — uma mudança de paradigma na forma de montar o servidor, já que não existe um "server pack" oficial pronto para este modpack.

## Ficha técnica

```
Modpack:    COBBLEVERSE - Pokemon Adventure [Cobblemon]
Loader:     Fabric
Versão MC:  1.21.1
Java:       21
Base:       Cobblemon 1.7.3
RAM mínima: 4 GB
RAM recom.: 6 GB+
Instância:  t3.large (8 GB RAM, 2 vCPUs)
Foco:       Aventura Pokémon (captura, treino, batalhas, ginásios)
```

Fonte: [página oficial do modpack no CurseForge](https://www.curseforge.com/minecraft/modpacks/cobbleverse-cobblemon).

## A diferença fundamental em relação aos casos anteriores

Forge e NeoForge têm um installer que já gera o `.jar` do servidor com `--installServer`. **Fabric não funciona assim para este modpack** — o `.zip` que você baixa para o cliente contém só `mods/`, `config/` e eventualmente `datapacks/`; o executável do servidor é baixado separadamente, direto da Fabric, e os mods são copiados manualmente.

## Passo a passo aplicado

### 1. Dimensionar a instância
RAM recomendada pelo publisher é 6 GB+. Com margem para o sistema operacional, isso aponta para uma instância com pelo menos 8 GB total — t3.large, igual ao usado em Better MC 5. Veja [`02-sizing-guide.md`](../guides/02-sizing-guide.md).

### 2. Instalar o servidor Fabric
```bash
sudo apt install -y openjdk-21-jdk
./scripts/install-fabric.sh 1.21.1
```
O script consulta a Fabric Meta API, identifica a versão mais recente do loader/installer compatível com `1.21.1`, baixa o `.jar` do servidor e cria `start.sh`/`stop.sh` já configurados.

### 3. Obter mods/config/datapacks do cliente
1. No CurseForge App: **My Modpacks** → Cobbleverse → menu de três pontinhos → **Open Folder**
2. Copiar `mods/`, `config/` e `datapacks/` (se existir) para o servidor via SFTP/SCP

```bash
scp -i game-server-key.pem -r mods config ubuntu@<ip>:~/minecraft-server/
```

### 4. Definir RAM e iniciar
```bash
nano start.sh   # confirmar -Xmx6G -Xms6G (ou ajustar conforme a instância)
screen -dmS minecraft ./start.sh
```

### 5. Security Group
Porta `TCP 25565`, igual a qualquer servidor Minecraft Java — sem diferença aqui em relação aos casos anteriores.

## Particularidades deste modpack

- O publisher recomenda explicitamente desabilitar mobs vanilla (já vem assim por padrão) — não é um bug, é intencional
- Estruturas de Pokémon Lendários/Míticos de algumas regiões só geram depois que a região anterior é desbloqueada por algum jogador no mundo/servidor — comportamento esperado, não erro de instalação
- Como não há server pack oficial, **atualizações do modpack exigem repetir a etapa 3** (copiar mods atualizados do cliente) manualmente — não há um botão de "update" no lado do servidor

## Aplicando este caso

Guia completo do loader: [`guides/loaders/fabric.md`](../guides/loaders/fabric.md). Script de instalação: [`scripts/install-fabric.sh`](../scripts/install-fabric.sh). Para troubleshooting específico de Fabric, veja a seção dedicada em [`guides/05-troubleshooting.md`](../guides/05-troubleshooting.md).
