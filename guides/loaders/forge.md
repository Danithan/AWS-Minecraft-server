# 🔨 Mod Loader: Forge

Forge é o mod loader mais antigo e com maior base de mods para Minecraft. A maioria dos modpacks de Minecraft 1.7 até 1.20.1 ainda usa Forge.

## Requisitos de Java por versão do Minecraft

| Versão MC | Java necessário |
|---|---|
| até 1.16.5 | Java 8 |
| 1.17 | Java 16 |
| 1.18 – 1.20.1 | Java 17 |

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version   # confirme a versão
```

## Instalação

### 1. Baixar o installer (no seu computador local)

Acesse [files.minecraftforge.net](https://files.minecraftforge.net/), escolha a versão do Minecraft do seu modpack e baixe o **Installer** (não o universal/client).

### 2. Transferir para o servidor

```bash
# Linux/Mac (scp)
scp -i game-server-key.pem forge-<versao>-installer.jar ubuntu@<ip>:~/minecraft-server/

# Windows: use a aba SFTP do Bitvise, arrastando o arquivo
```

### 3. Instalar no servidor

```bash
cd ~/minecraft-server
java -jar forge-<versao>-installer.jar --installServer
```

Isso gera o `.jar` do servidor, a pasta `libraries/` e o `user_jvm_args.txt`.

### 4. Aceitar a EULA

```bash
echo "eula=true" > eula.txt
```

### 5. Definir RAM

```bash
nano user_jvm_args.txt
```
```
-Xmx6G -Xms6G
```
Use o valor recomendado pelo [guia de dimensionamento](../02-sizing-guide.md).

### 6. Iniciar com `screen`

```bash
screen -dmS minecraft java -jar forge-<versao>.jar nogui
```
- Acessar console: `screen -r minecraft`
- Sair sem parar: `Ctrl+A` depois `D`

💡 Também há um script pronto em [`scripts/install-forge.sh`](../../scripts/install-forge.sh) que automatiza os passos 3–6.

## Instalando o modpack (mods)

1. No seu computador, abra a pasta de instalação do modpack (no launcher CurseForge: três pontinhos → **Open Folder**)
2. Copie **todo o conteúdo** de `mods/` (e `config/`, se existir) para `~/minecraft-server/mods/` e `~/minecraft-server/config/` no servidor
3. Cliente e servidor precisam ter exatamente os mesmos mods, exceto os client-only (shaders como Optifine/Iris, alguns mods de minimapa/UI)

## Problemas comuns

Veja a lista completa em [`05-troubleshooting.md`](../05-troubleshooting.md). Os mais frequentes com Forge: "Mod Rejections" (mods dessincronizados entre cliente/servidor) e `OutOfMemoryError` (RAM insuficiente para o pack).
