# 🎮 Guia de Instalação do Servidor Minecraft

Este guia cobre a instalação e configuração do servidor Minecraft com Forge e NeoForge.

## 📋 Pré-requisitos

- Instância EC2 configurada e rodando
- Acesso SSH ao servidor
- Java instalado (17 ou 21 dependendo do loader)
- Screen instalado

## 🔨 Instalação do Forge Server

### Passo 1: Download do Forge Installer

No seu **computador local**:
1. Acesse https://files.minecraftforge.net/
2. Selecione a versão do Minecraft (ex: 1.20.1)
3. Baixe o **Installer** (recomendado: 47.4.10 para 1.20.1)
4. Salve o arquivo (ex: `forge-1.20.1-47.4.10-installer.jar`)

### Passo 2: Transferir para o Servidor

**Usando Bitvise SFTP:**
1. No Bitvise, vá para a aba **SFTP**
2. Navegue até `/home/ubuntu/minecraft-server`
3. Arraste o arquivo installer para o servidor

**Usando SCP (Linux/Mac):**
```bash
scp -i minecraft-server-key.pem forge-1.20.1-47.4.10-installer.jar ubuntu@[seu-ip]:~/minecraft-server/
```

### Passo 3: Instalar Forge no Servidor

Conecte via SSH e execute:

```bash
cd ~/minecraft-server
java -jar forge-1.20.1-47.4.10-installer.jar --installServer
```

Aguarde o processo completar. Isso criará vários arquivos incluindo:
- `forge-1.20.1-47.4.10.jar` (servidor)
- `libraries/` (dependências)
- `user_jvm_args.txt` (argumentos JVM)

### Passo 4: Aceitar EULA

Primeira execução para gerar arquivos:
```bash
java -jar forge-1.20.1-47.4.10.jar nogui
```

O servidor vai parar e pedir para aceitar o EULA:
```bash
nano eula.txt
# Mude: eula=false para eula=true
# Ctrl+O para salvar, Ctrl+X para sair
```

### Passo 5: Configurar server.properties

Edite as configurações do servidor:
```bash
nano server.properties
```

Configurações recomendadas:
```properties
# Porta do servidor
server-port=25565

# Modo de jogo
gamemode=survival
difficulty=normal

# Configurações de mundo
max-world-size=29999984
spawn-protection=0

# Limites de jogadores
max-players=10
online-mode=true
white-list=false

# Performance
view-distance=10
simulation-distance=8

# Outros
motd=Meu Servidor Minecraft
```

### Passo 6: Otimizar Alocação de Memória

Para instância **t3.medium (4GB RAM)**:
```bash
nano user_jvm_args.txt
```

Adicione/modifique:
```
-Xmx3G -Xms3G
```

Para instância **t3.large (8GB RAM)**:
```
-Xmx6G -Xms6G
```

💡 **Dica:** Deixe sempre 1-2GB livres para o sistema operacional.

### Passo 7: Iniciar Servidor com Screen

Screen permite que o servidor continue rodando após você desconectar do SSH:

```bash
# Criar sessão screen
screen -S minecraft

# Iniciar servidor
java -jar forge-1.20.1-47.4.10.jar nogui

# Para sair do screen sem parar o servidor: Ctrl+A, depois D
# Para voltar ao screen: screen -r minecraft
# Para parar o servidor: digite "stop" no console
```

## 🆕 Instalação do NeoForge Server

NeoForge é um fork moderno do Forge, compatível com a maioria dos mods Forge 1.20.1.

### Passo 1: Download do NeoForge

No seu **computador local**:
1. Acesse https://neoforged.net/
2. Baixe o installer para a versão desejada (ex: 20.4.228 para 1.20.1)
3. Salve o arquivo (ex: `neoforge-20.4.228-installer.jar`)

### Passo 2: Preparar Diretório

Se estiver migrando de Forge:
```bash
cd ~/minecraft-server
# Backup dos arquivos importantes
cp -r world world_backup
cp server.properties server.properties.backup
```

### Passo 3: Instalar Java 21

NeoForge requer Java 21:
```bash
sudo apt install openjdk-21-jdk -y
java -version  # Verificar que está usando Java 21
```

### Passo 4: Transferir e Instalar

```bash
cd ~/minecraft-server
# Transferir arquivo via SFTP/SCP
java -jar neoforge-20.4.228-installer.jar --installServer
```

### Passo 5: Configuração

O processo é similar ao Forge:
1. Aceitar EULA
2. Configurar `server.properties`
3. Ajustar memória em `user_jvm_args.txt`

### Passo 6: Iniciar com Screen

```bash
screen -S minecraft
java -jar neoforge-20.4.228.jar nogui
```

## 📦 Instalando Modpacks

### Método 1: Instalação Manual

1. **Baixe o modpack** no CurseForge (seu computador)
2. **Extraia a pasta** do modpack
3. **Localize a pasta mods** dentro do modpack
4. **Transfira via SFTP:**
   - Copie todos os arquivos `.jar` de `mods/` para o servidor
   - Transfira para `/home/ubuntu/minecraft-server/mods/`

### Método 2: Server Pack (se disponível)

Alguns modpacks oferecem um "Server Pack":
1. Baixe o server pack do modpack
2. Extraia no servidor
3. Geralmente já vem com configurações otimizadas

### Sincronização Cliente-Servidor

**IMPORTANTE:** Cliente e servidor devem ter EXATAMENTE os mesmos mods!

Mods que podem ser diferentes:
- Mods de shader (ex: Optifine, Iris)
- Mods de som ambiente
- Mods de UI/HUD

Todos os outros devem ser idênticos!

## 🔍 Verificação de Funcionamento

### Testar Localmente

```bash
# Ver logs do servidor
screen -r minecraft

# Verificar se está aceitando conexões
ss -tlnp | grep 25565
```

### Conectar do Cliente

1. Abra Minecraft com o mesmo modpack instalado
2. Multiplayer > Add Server
3. Server Address: `[seu-ip-publico]:25565`
4. Tente conectar

## 🛠️ Comandos Úteis

### Gerenciar Screen
```bash
# Listar sessões
screen -ls

# Conectar a sessão
screen -r minecraft

# Sair sem parar (dentro do screen)
Ctrl+A, depois D

# Matar sessão
screen -X -S minecraft quit
```

### Comandos do Servidor (dentro do console)
```
stop              # Parar servidor
save-all          # Salvar mundo
list              # Listar jogadores online
whitelist add <player>  # Adicionar à whitelist
op <player>       # Dar permissões admin
```

### Logs e Monitoramento
```bash
# Ver últimas linhas do log
tail -f logs/latest.log

# Uso de memória
free -h

# Uso de CPU
top
```

## 📊 Performance e Otimização

### Sinais de Pouca Memória
- Servidor trava/congela
- "Out of memory" errors
- Lag extremo

**Solução:** Aumentar tipo de instância ou reduzir número de mods.

### Otimizações Adicionais

1. **Reduzir view-distance** em `server.properties`
2. **Instalar mods de otimização** (server-side):
   - FerriteCore (reduz uso de RAM)
   - Lithium (otimiza lógica do jogo)
   - Spark (profiling de performance)

3. **Pre-gerar chunks**:
```bash
# No console do servidor
/chunky radius 5000
/chunky start
```

## 🆘 Problemas Comuns

### Servidor não inicia
```bash
# Verificar Java
java -version

# Verificar logs
cat logs/latest.log
```

### "Failed to bind to port"
- Outro processo usando porta 25565
- Verificar: `ss -tlnp | grep 25565`
- Matar processo ou mudar porta

### Mods não carregam
- Verificar compatibilidade de versões
- Checar logs em `logs/latest.log`
- Procurar por "Failed to load" ou "Missing dependencies"

### Lag/Performance ruim
- Aumentar alocação de RAM
- Verificar se não está swapping: `free -h`
- Considerar upgrade de instância

---

**Próximo:** Configure e migre entre modpacks em `modpack-migration.md`
