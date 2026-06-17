# 🆕 Mod Loader: NeoForge

NeoForge é um fork moderno do Forge (criado em 2023), mantendo grande parte da compatibilidade de mods enquanto evolui mais rápido. Vários modpacks "kitchen sink" recentes (Better MC 5, por exemplo) migraram para ele.

## Requisito de Java

NeoForge para Minecraft 1.20.1+ requer **Java 21**:

```bash
sudo apt update
sudo apt install -y openjdk-21-jdk
sudo update-alternatives --config java   # se houver mais de uma versão instalada
java -version
```

## Instalação

### 1. Baixar o installer (no seu computador local)

Acesse [neoforged.net](https://neoforged.net/) e baixe o installer da versão correspondente ao seu modpack.

### 2. Transferir e instalar

```bash
cd ~/minecraft-server
java -jar neoforge-<versao>-installer.jar --installServer
```

### 3. Aceitar a EULA

```bash
echo "eula=true" > eula.txt
```

### 4. Definir RAM

```bash
nano user_jvm_args.txt
```
```
-Xmx6G -Xms6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200
```

### 5. Iniciar com `screen`

```bash
screen -dmS minecraft java -jar neoforge-<versao>.jar nogui
```

💡 Script pronto: [`scripts/install-neoforge.sh`](../../scripts/install-neoforge.sh) — automatiza instalação, backup da config anterior (se existir) e criação dos scripts `start.sh`/`stop.sh`.

## Migrando de Forge para NeoForge

Se você está migrando um modpack que já tinha Forge instalado, siga [`04-modpack-migration.md`](../04-modpack-migration.md) — o processo de backup, troca de loader e sincronização de mods é o mesmo independente do par de loaders envolvido.

## Instalando o modpack (mods)

Igual ao Forge: copie `mods/` e `config/` da instalação client para as pastas correspondentes no servidor. Mods NeoForge não são intercambiáveis com mods Fabric — confirme que o modpack realmente usa NeoForge antes de seguir este guia (veja na página do CurseForge/Modrinth, seção "Mod Loaders").

## Problemas comuns

Veja [`05-troubleshooting.md`](../05-troubleshooting.md). Atenção especial a incompatibilidade de versão Java (NeoForge recusa rodar em Java < 21) e "Mod Rejections" após trocar de pack.
