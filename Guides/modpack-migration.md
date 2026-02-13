# 🔄 Guia de Migração entre Modpacks

Este guia documenta o processo de migração entre diferentes modpacks, incluindo a experiência real de migrar do CISCO RPG Dragonfyre para o Better MC 5.

## 📋 Visão Geral da Migração

### Contexto da Migração
- **Modpack Origem:** CISCO RPG Dragonfyre
  - Loader: Forge 47.4.10
  - Versão Minecraft: 1.20.1
  - Java: 17
  - Foco: RPG e aventura
  
- **Modpack Destino:** Better MC 5
  - Loader: NeoForge 20.4.228
  - Versão Minecraft: 1.20.1
  - Java: 21
  - Foco: Melhorias gerais e conteúdo abrangente

## 🎯 Razões para Migração

1. Explorar diferentes estilos de jogo
2. Experimentar NeoForge (fork moderno do Forge)
3. Testar modpack mais pesado (250+ mods)
4. Aprender processo de migração

## ⚙️ Pré-requisitos

- [ ] Backup completo do mundo atual
- [ ] Backup do servidor atual
- [ ] Novo modpack baixado no cliente
- [ ] Lista de mods do novo modpack
- [ ] Espaço suficiente no servidor
- [ ] Tempo para testes (espere problemas!)

## 🔧 Processo de Migração - Passo a Passo

### Etapa 1: Backup Completo

**CRÍTICO:** Sempre faça backup antes de qualquer mudança!

```bash
# Conectar ao servidor via SSH
cd ~/minecraft-server

# Parar o servidor (se estiver rodando)
screen -r minecraft
# Digite: stop

# Criar pasta de backup
mkdir -p ~/backups/$(date +%Y%m%d)

# Backup do mundo
cp -r world ~/backups/$(date +%Y%m%d)/

# Backup das configurações
cp -r config ~/backups/$(date +%Y%m%d)/
cp server.properties ~/backups/$(date +%Y%m%d)/

# Backup dos mods atuais
cp -r mods ~/backups/$(date +%Y%m%d)/mods_old
```

💡 **Dica:** Comprimir o backup para economizar espaço:
```bash
tar -czf ~/backups/backup_$(date +%Y%m%d).tar.gz world config server.properties mods
```

### Etapa 2: Instalar Novo Loader (se necessário)

#### Migrar de Forge para NeoForge

**2.1: Instalar Java 21**
```bash
sudo apt update
sudo apt install openjdk-21-jdk -y
java -version  # Confirmar Java 21
```

**2.2: Download do NeoForge**
- No computador local: https://neoforged.net/
- Baixar NeoForge 20.4.228 (para 1.20.1)

**2.3: Transferir e Instalar**
```bash
# Via SFTP, transferir o installer para ~/minecraft-server
cd ~/minecraft-server
java -jar neoforge-20.4.228-installer.jar --installServer
```

**2.4: Verificar Instalação**
```bash
# Verificar se criou os arquivos necessários
ls -la
# Deve haver: neoforge-20.4.228.jar, libraries/, etc.
```

### Etapa 3: Preparar Mods do Novo Modpack

**3.1: Limpar Mods Antigos**
```bash
cd ~/minecraft-server

# Remover mods antigos (já fizemos backup!)
rm -rf mods/*

# Ou renomear para manter
mv mods mods_old
mkdir mods
```

**3.2: Obter Mods do Novo Modpack**

**No seu computador:**
1. Instale o Better MC 5 no CurseForge/launcher
2. Localize a pasta de instalação do modpack
3. Vá para a pasta `mods/`
4. Copie TODOS os arquivos `.jar`

**3.3: Transferir Mods via SFTP**

Usando Bitvise:
1. Conecte via SSH/SFTP
2. Navegue até `/home/ubuntu/minecraft-server/mods/`
3. Transfira todos os arquivos `.jar` do modpack
4. **Importante:** Isso pode levar tempo (250+ arquivos!)

💡 **Dica:** Para uploads grandes, considere:
- Compactar mods em um `.zip` primeiro
- Transferir o zip
- Descompactar no servidor: `unzip mods.zip -d mods/`

### Etapa 4: Configurações do Servidor

**4.1: Revisar server.properties**
```bash
nano server.properties
```

Ajustes importantes para Better MC 5:
```properties
# Aumentar limites devido a mais mods
max-tick-time=60000
network-compression-threshold=512

# Performance
view-distance=8  # Reduzir se lag
simulation-distance=6
```

**4.2: Ajustar Memória JVM**

Better MC 5 requer mais recursos:
```bash
nano user_jvm_args.txt
```

Para t3.large (8GB):
```
-Xmx6G -Xms6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200
```

### Etapa 5: Primeira Inicialização

**5.1: Criar Novo Mundo (Recomendado)**

Se for começar um mundo novo:
```bash
# Renomear mundo antigo
mv world world_old

# O servidor criará um novo mundo na próxima inicialização
```

**5.2: Manter Mundo Antigo (Arriscado)**

⚠️ **Atenção:** Mods diferentes podem causar corrupção!

Se quiser tentar manter o mundo:
- Faça backup adicional
- Espere problemas com blocos/itens de mods removidos
- Pode haver crashes

**5.3: Iniciar Servidor**
```bash
screen -S minecraft
java -jar neoforge-20.4.228.jar nogui
```

**5.4: Monitorar Logs**

Fique atento a:
- Erros de carregamento de mods
- "Missing dependencies"
- "Mod rejections"
- Crashes

Logs ficam em: `logs/latest.log`

### Etapa 6: Sincronizar Cliente

**FUNDAMENTAL:** Cliente e servidor devem ter os mesmos mods!

**6.1: No Cliente (seu computador)**
- Certifique-se de ter o Better MC 5 instalado via CurseForge
- Verifique que a versão do modpack é a mesma

**6.2: Testar Conexão**
1. Abrir Minecraft com o modpack
2. Multiplayer > Add Server
3. IP: `[seu-ip-publico]:25565`
4. Tentar conectar

### Etapa 7: Resolução de Problemas

#### Problema: "Mod Rejections"

**Sintoma:** Erro ao conectar listando mods incompatíveis

**Causa:** Mods diferentes entre cliente e servidor

**Solução:**
```bash
# No servidor, listar todos os mods
ls -1 mods/ > server_mods.txt

# Comparar com mods do cliente
# Garantir que são EXATAMENTE os mesmos
```

**No cliente:**
- Remova mods que estão no cliente mas não no servidor
- Adicione mods que estão no servidor mas não no cliente
- Mods permitidos apenas no cliente:
  - Shaders (Optifine, Iris)
  - Sound Physics
  - Alguns mods de UI

#### Problema: Servidor Não Inicia

**Verificar logs:**
```bash
tail -50 logs/latest.log
```

Procure por:
- "Java HotSpot(TM) 64-Bit Server VM warning: OutOfMemoryError"
  - Solução: Aumentar RAM ou reduzir mods
  
- "Missing or unsupported mandatory dependencies"
  - Solução: Instalar mod dependência faltante
  
- "java.lang.NoSuchMethodError"
  - Solução: Incompatibilidade de versão Java/loader

#### Problema: Performance Ruim

**Diagnóstico:**
```bash
# Verificar uso de RAM
free -h

# Verificar CPU
top

# Dentro do jogo: F3
# Ver TPS (should be 20.0)
```

**Soluções:**
1. Aumentar tipo de instância (t3.medium → t3.large)
2. Reduzir view-distance
3. Pre-gerar chunks
4. Instalar mods de otimização:
   - FerriteCore
   - Lithium
   - Spark (para profiling)

## 📊 Comparação: Antes e Depois

### CISCO RPG Dragonfyre (Antes)
```
Loader: Forge 47.4.10
Java: 17
Mods: ~150
RAM Necessária: 3-4GB
Instância: t3.medium
Performance: Estável
Foco: RPG
```

### Better MC 5 (Depois)
```
Loader: NeoForge 20.4.228
Java: 21
Mods: ~250
RAM Necessária: 6-8GB
Instância: t3.large
Performance: Exige mais recursos
Foco: Conteúdo abrangente
```

## ✅ Checklist de Migração

- [ ] Backup completo realizado
- [ ] Java 21 instalado (se NeoForge)
- [ ] NeoForge instalado corretamente
- [ ] Mods antigos removidos/backup
- [ ] Novos mods transferidos
- [ ] server.properties atualizado
- [ ] RAM ajustada adequadamente
- [ ] Servidor inicia sem erros
- [ ] Cliente sincronizado com servidor
- [ ] Conexão testada e funcionando
- [ ] Performance aceitável
- [ ] Backup pós-migração realizado

## 💡 Lições Aprendidas

1. **Sempre faça backup** - Sério, SEMPRE!
2. **Leia logs cuidadosamente** - Erros geralmente explicam o problema
3. **Sincronização cliente-servidor é crucial** - Verifique duas vezes
4. **Recursos importam** - Better MC 5 realmente precisa de mais RAM
5. **Paciência é fundamental** - Troubleshooting leva tempo
6. **Comunidade ajuda** - Fóruns e Discord são valiosos
7. **Teste antes de comprometer** - Use mundo de teste primeiro

## 🔄 Reverter Migração (Se necessário)

Se algo der muito errado:

```bash
# Parar servidor
screen -r minecraft
# Digite: stop

# Restaurar backup
cd ~/minecraft-server
rm -rf world mods config
cp -r ~/backups/[data]/world ./
cp -r ~/backups/[data]/mods_old ./mods
cp -r ~/backups/[data]/config ./
cp ~/backups/[data]/server.properties ./

# Voltar para Forge/Java antigo se necessário
# Reiniciar servidor
```

## 🎯 Próximas Migrações

Com experiência adquirida, migrações futuras serão:
- Mais rápidas
- Menos propensas a erros
- Melhor planejadas

Considere documentar cada migração para referência futura!

---

**Dúvidas?** Consulte `troubleshooting.md` ou comunidade Minecraft.
