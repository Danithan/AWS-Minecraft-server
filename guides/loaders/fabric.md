# 🧵 Mod Loader: Fabric

Fabric é um mod loader leve e modular, popular em modpacks mais recentes (Cobblemon/Cobbleverse, por exemplo). A diferença mais importante em relação a Forge/NeoForge: **a maioria dos modpacks Fabric não vem com um "server pack" pronto** — você monta o servidor manualmente. Este guia documenta esse processo.

## Requisito de Java

| Versão MC | Java necessário |
|---|---|
| 1.17.2 | Java 16 |
| 1.18.2 – 1.20.4 | Java 17 |
| 1.20.5+ | Java 21 |

```bash
sudo apt update
sudo apt install -y openjdk-21-jdk   # ajuste a versão conforme a tabela
java -version
```

## Por que não tem um `.jar` de servidor dentro do modpack que eu baixei?

O `.zip` que você baixa do CurseForge/Modrinth para o **cliente** contém só `mods/`, `config/`, `resourcepacks/` (e às vezes `datapacks/`) — nunca o executável do servidor. Isso é esperado: o servidor Fabric é baixado separadamente, igual em qualquer projeto Fabric, modpack ou não.

## Instalação do servidor Fabric

### Opção A — Manual, via site oficial

1. Acesse [fabricmc.net/use/server](https://fabricmc.net/use/server/)
2. Selecione a versão do Minecraft do seu modpack (ex: `1.21.1`)
3. Copie o comando `curl` exibido na página e rode dentro da pasta do servidor no EC2
4. Rode o comando de inicialização exibido na mesma página

### Opção B — Script automatizado (recomendado, usa a API da Fabric)

```bash
./scripts/install-fabric.sh 1.21.1
```

O script consulta a [Fabric Meta API](https://meta.fabricmc.net/) para descobrir automaticamente a versão mais recente do loader e do installer compatíveis com a versão do Minecraft informada, baixa o `.jar` do servidor já compilado (`server/jar`), aceita a EULA e cria os scripts `start.sh`/`stop.sh`. Veja o código em [`scripts/install-fabric.sh`](../../scripts/install-fabric.sh).

### Definir RAM

```bash
nano start.sh
```
Ajuste `-Xmx` e `-Xms` conforme o [guia de dimensionamento](../02-sizing-guide.md) (o script já cria isso parametrizado).

### Iniciar com `screen`

```bash
screen -dmS minecraft ./start.sh
```

## Copiando mods, config e datapacks do cliente

1. No CurseForge App: **My Modpacks** → selecione o pack → menu de três pontinhos → **Open Folder**
2. Dentro dessa pasta, localize `mods/`, `config/` e (se existir) `datapacks/`
3. Transfira essas pastas via SFTP/SCP para o servidor, nos mesmos nomes, na raiz da pasta do servidor

```bash
# Exemplo via scp, do seu computador local
scp -i game-server-key.pem -r mods config ubuntu@<ip>:~/minecraft-server/
```

⚠️ **Fabric API é obrigatório** para a maioria dos mods — mas como ele já vem dentro do `mods/` do modpack, copiar a pasta inteira já resolve isso. Não é necessário baixar o Fabric API separadamente.

⚠️ Assim como em Forge/NeoForge, cliente e servidor precisam ter os **mesmos mods**, exceto os puramente visuais do lado cliente (shaders, sound mods, alguns minimapas).

## Atualizações de versão

Como não existe um `.jar` único e estável (o nome do arquivo muda conforme a versão do loader/installer), depois de qualquer atualização do Fabric Loader confirme que o nome do `.jar` referenciado no `start.sh` ainda corresponde ao arquivo presente na pasta — esse é o erro mais comum ao reusar scripts antigos.

## Problemas comuns

Veja [`05-troubleshooting.md`](../05-troubleshooting.md), seção "Fabric". Os mais frequentes: nome do `.jar` não bate com o script de start, Java incompatível com a versão do MC, e mods ausentes no servidor (mesmo erro de "rejection" que ocorre em Forge/NeoForge, mas com mensagens de log diferentes).
