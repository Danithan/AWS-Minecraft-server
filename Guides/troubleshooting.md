# 🔧 Guia de Troubleshooting

Documentação dos problemas encontrados durante o projeto e suas soluções.

## 🔍 Metodologia de Troubleshooting

Antes de entrar em pânico, siga este processo:

1. **Identifique o problema** - O que exatamente está errado?
2. **Reproduza** - O problema acontece sempre?
3. **Isole** - É cliente, servidor, rede, ou configuração?
4. **Pesquise** - Já aconteceu com outras pessoas?
5. **Teste hipóteses** - Mude uma coisa por vez
6. **Documente** - Anote o que funcionou

## 🚫 Problema: "Connection Timed Out"

### Sintomas
```
java.net.ConnectException: Connection timed out: no further information
```
Ou simplesmente: **Conexão expirou** ao tentar conectar ao servidor.

### Causa Raiz
Security Group da instância EC2 não permite tráfego na porta 25565.

### Diagnóstico

**1. Verificar se servidor está rodando:**
```bash
# Via SSH no servidor
screen -r minecraft
# Deve mostrar console do Minecraft ativo

# Ou verificar processo
ps aux | grep minecraft
```

**2. Verificar se porta está escutando:**
```bash
ss -tlnp | grep 25565
# Deve mostrar: LISTEN 0 50 *:25565
```

**3. Verificar Security Group:**
- AWS Console > EC2 > Security Groups
- Selecione o security group da instância
- Vá para "Inbound rules"
- Deve haver regra: `TCP 25565 0.0.0.0/0`

### Solução

**Adicionar regra no Security Group:**
1. AWS Console > EC2 > Security Groups
2. Selecione seu security group
3. "Inbound rules" > "Edit inbound rules"
4. "Add rule":
   ```
   Type: Custom TCP
   Port: 25565
   Source: 0.0.0.0/0 (ou seu IP para mais segurança)
   ```
5. Save rules

**Testar:**
```bash
# Do seu computador
telnet [ip-do-servidor] 25565
# Deve conectar (não mostra nada, mas não dá timeout)
```

### Prevenção
- Sempre configure Security Group antes de testar conexão
- Documente as portas necessárias

---

## ⚠️ Problema: "Mod Rejections"

### Sintomas
```
Mod rejections: ...
Server sent mod list: [mod1, mod2, mod3...]
Client has mods: [mod1, mod4, mod5...]
```
Impossível conectar ao servidor.

### Causa Raiz
Mods diferentes entre cliente e servidor.

### Diagnóstico

**1. Listar mods do servidor:**
```bash
cd ~/minecraft-server/mods
ls -1 > ~/server_mods.txt
cat ~/server_mods.txt
```

**2. Listar mods do cliente:**
- Vá para pasta de instalação do modpack
- Entre em `mods/`
- Compare com a lista do servidor

**3. Identificar diferenças:**
- Mods que estão no servidor mas não no cliente
- Mods que estão no cliente mas não no servidor
- Versões diferentes do mesmo mod

### Solução

**Sincronizar mods:**

1. **Mods faltando no cliente:**
   - Baixe do servidor via SFTP
   - Copie para pasta `mods/` do cliente

2. **Mods extras no cliente:**
   - Remova mods que não estão no servidor
   - **EXCETO** mods client-only permitidos:
     - Optifine / Iris (shaders)
     - Sound Physics
     - JEI/REI (receitas)
     - Alguns mods de minimapa

3. **Versões diferentes:**
   - Use exatamente a mesma versão
   - Mods geralmente têm versão no nome do arquivo

**Reinstalar modpack (se necessário):**
- CurseForge > Reinstalar modpack
- Confirme versão exata do servidor

### Prevenção
- Sempre use a mesma fonte para servidor e cliente
- Documente versão do modpack
- Teste após adicionar/remover mods

---

## 💾 Problema: OutOfMemoryError

### Sintomas
```
java.lang.OutOfMemoryError: Java heap space
```
Servidor trava, congela, ou crasheia.

### Causa Raiz
Memória JVM insuficiente para o modpack.

### Diagnóstico

**1. Verificar alocação atual:**
```bash
cat user_jvm_args.txt
# Ver valores de -Xmx e -Xms
```

**2. Verificar uso de RAM:**
```bash
free -h
# Olhar linha "Mem:" - available
```

**3. Verificar tamanho da instância:**
```bash
# Tipo de instância
curl http://169.254.169.254/latest/meta-data/instance-type
```

### Solução

**Opção 1: Aumentar Alocação (se houver RAM disponível)**
```bash
nano user_jvm_args.txt

# Para 4GB disponível:
-Xmx3G -Xms3G

# Para 8GB disponível:
-Xmx6G -Xms6G
```

**Opção 2: Aumentar Tipo de Instância**
1. Parar a instância EC2
2. Actions > Instance Settings > Change Instance Type
3. Mudar para tipo maior:
   - t3.medium (4GB) → t3.large (8GB)
   - t3.large (8GB) → t3.xlarge (16GB)
4. Start instance

**Opção 3: Reduzir Mods**
- Remova mods pesados/desnecessários
- Foque nos essenciais
- Use ferramentas como Spark para identificar mods pesados

### Prevenção
- Pesquise requisitos de RAM do modpack antes
- Deixe margem de segurança (não use 100% da RAM)
- Monitore uso com `free -h`

---

## 🔌 Problema: Server Não Inicia

### Sintomas
Servidor crasheia imediatamente ou não inicia.

### Diagnóstico

**1. Verificar logs:**
```bash
cat logs/latest.log
# Ou
tail -100 logs/latest.log
```

**2. Procurar por erros comuns:**
- "ClassNotFoundException" → Mod faltando ou corrupto
- "NoSuchMethodError" → Incompatibilidade de versão
- "Missing dependencies" → Mod dependência não instalado
- "Port already in use" → Porta 25565 ocupada

### Soluções por Tipo de Erro

#### "Port 25565 is already in use"
```bash
# Encontrar processo usando a porta
lsof -i :25565

# Matar processo
kill -9 [PID]

# Ou reiniciar máquina
sudo reboot
```

#### "Missing or unsupported dependencies"
```
Error: Mod X requires mod Y version Z
```
**Solução:** Instale o mod dependência faltante.

#### "java.lang.ClassNotFoundException"
```bash
# Verificar se arquivo do mod está corrupto
cd ~/minecraft-server/mods
ls -lh
# Arquivos muito pequenos podem estar corrompidos

# Re-baixar mod problemático
```

#### Versão Java errada
```
Error: Unsupported Java version
```
**Solução:**
```bash
# Verificar versão atual
java -version

# Instalar versão correta
sudo apt install openjdk-21-jdk -y  # Para NeoForge
# ou
sudo apt install openjdk-17-jdk -y  # Para Forge

# Selecionar versão padrão
sudo update-alternatives --config java
```

---

## 🐌 Problema: Lag / Performance Ruim

### Sintomas
- FPS baixo
- Delay nas ações
- Blocos "flutuando"
- TPS abaixo de 20

### Diagnóstico

**1. Verificar TPS (servidor):**
No console do Minecraft:
```
/tps
# Deve ser ~20.0
```

**2. Verificar recursos do servidor:**
```bash
# CPU
top
# Procurar java - %CPU

# RAM
free -h
# Verificar se está usando swap

# Disco
df -h
# Verificar espaço disponível
```

**3. Profiling (avançado):**
Instalar mod Spark:
```
/spark profiler
# Esperar 30 segundos
/spark profiler stop
```

### Soluções

**1. Otimizar configurações:**
```bash
nano server.properties
```
```properties
# Reduzir distâncias
view-distance=6
simulation-distance=5

# Otimizar entities
entity-broadcast-range-percentage=50
```

**2. Otimizar JVM:**
```bash
nano user_jvm_args.txt
```
```
-Xmx6G -Xms6G
-XX:+UseG1GC
-XX:+ParallelRefProcEnabled
-XX:MaxGCPauseMillis=200
-XX:+UnlockExperimentalVMOptions
-XX:+DisableExplicitGC
-XX:G1NewSizePercent=30
-XX:G1MaxNewSizePercent=40
```

**3. Pre-gerar mundo:**
Instalar mod Chunky:
```
/chunky world [world_name]
/chunky radius 5000
/chunky start
```

**4. Mods de otimização:**
Adicionar (server-side):
- FerriteCore - Reduz RAM
- Lithium - Otimiza lógica
- Krypton - Otimiza rede
- Spark - Profiling

**5. Upgrade de hardware:**
- t3.medium → t3.large
- Considerar CPU otimizada: c6i.large

---

## 🌐 Problema: IP Público Muda

### Sintomas
Após parar/iniciar instância, IP muda.

### Causa
IPs públicos dinâmicos mudam a cada start/stop.

### Solução

**Opção 1: Elastic IP (recomendado)**
1. AWS Console > EC2 > Elastic IPs
2. Allocate Elastic IP address
3. Associate com sua instância
4. Anote o Elastic IP

**Custos:**
- Grátis se associado a instância rodando
- ~$0.005/hora se não estiver associado

**Opção 2: Dynamic DNS**
- Usar serviço como Duck DNS
- Script para atualizar IP automaticamente

---

## 🔐 Problema: Permission Denied (SSH)

### Sintomas
```
Permission denied (publickey)
```

### Soluções

**1. Verificar permissões da chave:**
```bash
chmod 400 minecraft-server-key.pem
```

**2. Verificar username:**
- Ubuntu: `ubuntu`
- Amazon Linux: `ec2-user`
- Debian: `admin`

**3. Verificar caminho da chave:**
```bash
ssh -i /caminho/correto/para/chave.pem ubuntu@ip
```

---

## 📊 Ferramentas Úteis de Debug

### Logs
```bash
# Últimas 100 linhas
tail -100 logs/latest.log

# Seguir log em tempo real
tail -f logs/latest.log

# Procurar por erro
grep -i error logs/latest.log
```

### Monitoramento
```bash
# RAM
free -h
watch -n 1 free -h

# CPU
top
htop  # (instalar: sudo apt install htop)

# Rede
ss -tlnp  # Portas escutando
ping 8.8.8.8  # Testar internet
```

### Minecraft Específico
```bash
# Dentro do jogo: F3
# Ver coordenadas, FPS, TPS, memória

# No console do servidor:
/tps  # Server performance
/spark profiler  # Performance profiling
/timings  # Análise de timing
```

---

## 📝 Checklist Geral de Troubleshooting

Quando algo der errado:

- [ ] Verificar logs (`logs/latest.log`)
- [ ] Confirmar que servidor está rodando
- [ ] Verificar Security Group (portas abertas)
- [ ] Confirmar mods sincronizados
- [ ] Verificar versão Java correta
- [ ] Checar alocação de memória
- [ ] Verificar espaço em disco
- [ ] Testar com cliente vanilla (se possível)
- [ ] Procurar erro no Google
- [ ] Consultar fóruns Minecraft/mod
- [ ] Pedir ajuda na comunidade

---

## 💡 Dicas Finais

1. **Sempre documente o erro** antes de mudar algo
2. **Mude uma coisa por vez** - facilita identificar solução
3. **Mantenha backups atualizados**
4. **Logs são seus amigos** - leia-os com atenção
5. **Comunidade é valiosa** - Discord, Reddit, Fóruns
6. **Paciência** - troubleshooting leva tempo

---

**Ainda com problemas?** 
- Verifique fóruns do modpack específico
- Discord do Forge/NeoForge
- r/admincraft no Reddit
- Servidor Discord do Better MC
