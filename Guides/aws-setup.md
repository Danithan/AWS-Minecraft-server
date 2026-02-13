# 🚀 Guia de Configuração AWS

Este guia detalha o processo completo de configuração da infraestrutura AWS para hospedar um servidor Minecraft com mods.

## 📋 Pré-requisitos

- Conta AWS (AWS Academy ou conta pessoal)
- Conhecimento básico de navegação web
- Cliente SSH instalado (recomendado: Bitvise SSH Client para Windows)

## 🔧 Passo 1: Criar Instância EC2

### 1.1 Acessar Console EC2
1. Faça login no console AWS
2. Navegue até **EC2** no menu de serviços
3. Clique em **Launch Instance** (Executar Instância)

### 1.2 Configurações Básicas
```
Nome da instância: minecraft-server
Application and OS Images: Ubuntu Server 22.04 LTS
Architecture: 64-bit (x86)
```

### 1.3 Escolher Tipo de Instância

**Para testes iniciais:**
```
Instance Type: t3.medium
vCPUs: 2
Memory: 4 GiB
```

**Para modpacks pesados (Better MC 5):**
```
Instance Type: t3.large
vCPUs: 2
Memory: 8 GiB
```

💡 **Dica:** Comece com t3.medium e faça upgrade se necessário.

### 1.4 Configurar Key Pair (Par de Chaves)

1. Clique em **Create new key pair**
2. Defina um nome: `minecraft-server-key`
3. Tipo: **RSA**
4. Formato: **PPK** (para Bitvise/PuTTY) ou **PEM** (para SSH padrão)
5. Clique em **Create key pair**
6. **IMPORTANTE:** Salve o arquivo `.ppk` ou `.pem` em local seguro
7. Você precisará desta chave para conectar ao servidor

### 1.5 Configurar Network Settings

Deixe as configurações padrão de VPC e subnet, mas configure o Security Group:

```
Create security group: Yes
Security group name: minecraft-server-sg
Description: Security group for Minecraft server
```

### 1.6 Configurar Armazenamento

```
Volume Type: gp3
Size: 20 GiB (mínimo recomendado)
```

💡 **Dica:** Para modpacks grandes, considere 30-40 GiB.

### 1.7 Lançar Instância

1. Revise todas as configurações
2. Clique em **Launch Instance**
3. Aguarde a instância ser provisionada (Status: Running)

## 🔒 Passo 2: Configurar Security Group

**CRÍTICO:** Esta etapa é essencial para o servidor funcionar!

### 2.1 Acessar Security Groups
1. No console EC2, vá para **Security Groups** no menu lateral
2. Selecione o security group `minecraft-server-sg`
3. Vá para a aba **Inbound Rules** (Regras de Entrada)

### 2.2 Adicionar Regra para Minecraft

Clique em **Edit inbound rules** e adicione:

```
Type: Custom TCP
Port Range: 25565
Source: 0.0.0.0/0 (ou seu IP específico para mais segurança)
Description: Minecraft Server
```

### 2.3 Adicionar Regra SSH (se não existir)

```
Type: SSH
Port Range: 22
Source: My IP (seu IP atual)
Description: SSH Access
```

⚠️ **Importante:** 
- A porta 25565 é a porta padrão do Minecraft
- Sem esta regra, você terá erro "Connection Timed Out"
- Configurar "My IP" é mais seguro que "0.0.0.0/0"

## 🖥️ Passo 3: Conectar à Instância via SSH

### 3.1 Obter Informações de Conexão

1. No console EC2, selecione sua instância
2. Anote o **Public IPv4 address** (ex: 3.85.123.45)
3. Anote o **Public IPv4 DNS** (opcional)

### 3.2 Conectar com Bitvise SSH Client

1. Abra o Bitvise SSH Client
2. Configure:
   ```
   Host: [seu-ip-publico]
   Port: 22
   Username: ubuntu
   Initial method: publickey
   Client key: [selecione seu arquivo .ppk]
   ```
3. Clique em **Login**
4. Aceite o fingerprint do servidor na primeira conexão

### 3.3 Conectar com SSH (Linux/Mac)

```bash
# Ajustar permissões da chave
chmod 400 minecraft-server-key.pem

# Conectar
ssh -i minecraft-server-key.pem ubuntu@[seu-ip-publico]
```

## 📦 Passo 4: Preparar o Servidor

### 4.1 Atualizar Sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### 4.2 Instalar Java

**Para Forge (Java 17):**
```bash
sudo apt install openjdk-17-jdk -y
```

**Para NeoForge (Java 21):**
```bash
sudo apt install openjdk-21-jdk -y
```

Verificar instalação:
```bash
java -version
```

### 4.3 Instalar Screen

Screen permite manter o servidor rodando após desconectar do SSH:

```bash
sudo apt install screen -y
```

### 4.4 Criar Diretório para o Servidor

```bash
mkdir ~/minecraft-server
cd ~/minecraft-server
```

## ✅ Verificações Finais

Antes de prosseguir com a instalação do Minecraft:

- [ ] Instância EC2 está rodando (Status: Running)
- [ ] Security Group tem porta 25565 aberta
- [ ] Consegue conectar via SSH
- [ ] Java está instalado corretamente
- [ ] Screen está instalado
- [ ] Diretório `minecraft-server` criado

## 🎯 Próximos Passos

Com a infraestrutura AWS configurada, você está pronto para:

1. **Instalar o servidor Minecraft** - Veja `minecraft-setup.md`
2. **Configurar modpacks** - Veja `modpack-migration.md`
3. **Resolver problemas** - Veja `troubleshooting.md`

## 💰 Gerenciamento de Custos

### Parar a Instância quando não estiver usando

```bash
# No console AWS:
Actions > Instance State > Stop
```

⚠️ **Importante:** 
- Instâncias paradas NÃO geram custo de computação
- Storage (EBS) continua gerando custo mínimo
- IP público muda ao reiniciar (use Elastic IP para IP fixo)

### Monitorar Custos

1. Acesse **AWS Cost Explorer** no console
2. Configure **Budget Alerts** para evitar surpresas
3. Monitore uso regular da instância

## 🆘 Problemas Comuns

### Não consigo conectar via SSH
- Verifique se o IP público está correto
- Confirme que porta 22 está aberta no Security Group
- Verifique se está usando a chave correta
- Confirme username `ubuntu` (para Ubuntu Server)

### Instância não aparece no console
- Verifique se está na região AWS correta (top-right corner)
- AWS Academy pode ter restrições de região

### "Permission denied" ao usar chave SSH
```bash
chmod 400 sua-chave.pem
```

---

**Dúvidas?** Consulte o guia de troubleshooting ou a documentação AWS oficial.
