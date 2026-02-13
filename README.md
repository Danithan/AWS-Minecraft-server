# 🎮 AWS Minecraft Modded Server Deployment

## 📋 Sobre o Projeto

Implementação completa de um servidor Minecraft com mods hospedado na AWS, desenvolvido do zero como projeto pessoal de aprendizado. O projeto envolveu configuração de infraestrutura cloud, administração de servidores Linux, e resolução de diversos desafios técnicos durante a migração entre diferentes modpacks.

## 🎯 Objetivos do Projeto

- Aprender AWS na prática através do AWS Academy
- Configurar e administrar um servidor Linux remoto
- Gerenciar servidor Minecraft com modpacks complexos
- Aplicar conhecimentos de redes, segurança e otimização de recursos
- Criar solução escalável e econômica para uso pessoal

## 🚀 Habilidades Demonstradas

### ☁️ Cloud Computing (AWS)
- Provisionamento e gerenciamento de instâncias EC2
- Configuração de Security Groups (regras de firewall)
- Otimização de custos com seleção adequada de tipos de instância
- Gerenciamento de recursos e monitoramento básico

### 🐧 Administração de Sistemas Linux
- Instalação e configuração de Ubuntu Server 22.04
- Gerenciamento de processos com Screen
- Conexão remota via SSH (Bitvise)
- Transferência de arquivos via SFTP
- Gerenciamento de permissões e usuários

### 🎮 Minecraft Server Management
- Instalação e configuração de Forge Server (47.4.10)
- Instalação e configuração de NeoForge Server (20.4.228)
- Gerenciamento de modpacks complexos (250+ mods)
- Migração entre diferentes modpacks:
  - CISCO RPG Dragonfyre (Forge 1.20.1)
  - Better MC 5 (NeoForge 1.20.1)
- Configuração de `server.properties`
- Sincronização cliente-servidor

### 🔧 Troubleshooting & Resolução de Problemas
- Diagnóstico e correção de erro "Connection Timed Out" (firewall)
- Resolução de "Mod Rejections" (incompatibilidade cliente-servidor)
- Gestão de conflitos entre versões Java (17 vs 21)
- Otimização de alocação de memória JVM
- Resolução de incompatibilidades entre mods

## 📈 Principais Desafios Superados

### 1. **Configuração Inicial do Servidor**
**Problema:** Primeira experiência com AWS e servidores Linux  
**Solução:** 
- Estudei documentação AWS Academy
- Aprendi comandos Linux básicos
- Configurei instância EC2 t3.medium (4GB RAM)
- Instalei Java 17 e configurei Forge Server

### 2. **Erro "Connection Timed Out"**
**Problema:** Impossibilidade de conexão ao servidor  
**Solução:** 
- Identifiquei problema nas regras do Security Group
- Abri porta 25565 (Minecraft) para tráfego TCP
- Configurei regras de entrada apropriadas
- Verifiquei que servidor estava rodando na porta correta

### 3. **Migração de Modpack (CISCO RPG → Better MC 5)**
**Problema:** Modpacks diferentes, loaders diferentes (Forge → NeoForge)  
**Solução:**
- Instalei NeoForge 20.4.228 (compatível com mods Forge 1.20.1)
- Transferi novos arquivos via SFTP
- Atualizei Java para versão 21
- Sincronizei lista de mods entre cliente e servidor
- Testei e validei funcionamento

### 4. **"Mod Rejections" após Migração**
**Problema:** Cliente rejeitando conexão devido a mods incompatíveis  
**Solução:**
- Verifiquei lista completa de mods no servidor
- Sincronizei exatamente os mesmos mods no cliente
- Removi mods exclusivos de cliente que não eram necessários
- Validei versões de todos os mods

### 5. **Otimização de Performance**
**Problema:** Performance insuficiente com t3.medium para Better MC 5  
**Solução:**
- Analisei uso de recursos (RAM e CPU)
- Upgrade para t3.large (8GB RAM)
- Otimizei alocação de memória JVM (-Xmx6G -Xms6G)
- Melhorou significativamente estabilidade e FPS

## 🔧 Tecnologias & Ferramentas

### Cloud & Infraestrutura
- **AWS EC2** - t3.medium e t3.large
- **AWS Security Groups** - Configuração de firewall
- **Ubuntu Server 22.04** - Sistema operacional

### Software & Runtimes
- **Java 17** - Para Forge Server
- **Java 21** - Para NeoForge Server
- **Forge 47.4.10** - Mod loader para Minecraft 1.20.1
- **NeoForge 20.4.228** - Mod loader moderno para Minecraft 1.20.1

### Ferramentas de Administração
- **Bitvise SSH Client** - Conexão remota e SFTP
- **Screen** - Gerenciamento de sessões persistentes
- **CurseForge** - Download e gerenciamento de modpacks

### Modpacks Implementados
1. **CISCO RPG Dragonfyre** (Forge)
   - Foco em RPG e aventura
   - ~150 mods
   
2. **Better MC 5** (NeoForge)
   - Modpack abrangente com melhorias gerais
   - ~250 mods
   - Requer mais recursos (8GB RAM recomendado)

## 📊 Especificações Técnicas

### Instância EC2 - Configuração Atual
```
Tipo: t3.large
vCPUs: 2
RAM: 8GB
Storage: 20GB SSD (gp3)
Sistema: Ubuntu Server 22.04 LTS
```

### Servidor Minecraft - Configuração
```
Versão: 1.20.1
Loader: NeoForge 20.4.228
Java: OpenJDK 21
RAM Alocada: 6GB (Xmx6G Xms6G)
Porta: 25565
Max Players: 10
```

### Comparativo de Custos AWS
| Tipo Instância | RAM  | vCPU | Custo/Hora | Mensal (8h/dia)* |
|----------------|------|------|------------|------------------|
| t3.small       | 2GB  | 2    | $0.0208    | ~$5              |
| t3.medium      | 4GB  | 2    | $0.0416    | ~$10             |
| t3.large       | 8GB  | 2    | $0.0832    | ~$20             |

*Estimativa baseada em 8 horas/dia, ~240h/mês

## 🎮 Resultados Alcançados

✅ Servidor funcional com 250+ mods simultâneos  
✅ Conexão estável e latência baixa (<50ms para jogadores locais)  
✅ Migração bem-sucedida entre diferentes modpacks  
✅ Experiência prática completa com AWS  
✅ Conhecimento aprofundado em administração Linux  
✅ Documentação técnica para referência futura  

## 📚 Aprendizados Principais

1. **AWS não é tão intimidador quanto parece** - Com prática, os conceitos ficam claros
2. **Security Groups são cruciais** - Configuração correta evita muitos problemas
3. **Documentação é essencial** - Manter registro de comandos e configurações economiza tempo
4. **Backup é importante** - Sempre manter cópias dos arquivos importantes
5. **Recursos importam** - Escolher instância adequada faz diferença na performance
6. **Troubleshooting metódico** - Isolar problemas e testar hipóteses sistematicamente

## 🔗 Estrutura do Repositório

```
aws-minecraft-server/
├── README.md                    # Este arquivo
├── guides/
│   ├── aws-setup.md            # Configuração AWS passo a passo
│   ├── minecraft-setup.md      # Instalação do servidor Minecraft
│   ├── modpack-migration.md    # Processo de migração entre modpacks
│   └── troubleshooting.md      # Problemas comuns e soluções
├── scripts/
│   ├── install-forge.sh        # Script de instalação Forge
│   └── install-neoforge.sh     # Script de instalação NeoForge
└── docs/
    └── architecture.md         # Diagrama e explicação da arquitetura
```

## 📞 Contato

Desenvolvido como projeto pessoal de aprendizado em Cloud Computing e DevOps.

---

**Nota:** Este projeto foi desenvolvido para fins educacionais e uso pessoal. Os custos AWS mencionados são estimativas baseadas em precificação da região us-east-1 e podem variar.
