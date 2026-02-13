#!/bin/bash
# Script de instalação do NeoForge Server
# Uso: ./install-neoforge.sh [versao-neoforge]
# Exemplo: ./install-neoforge.sh 20.4.228

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador NeoForge Server ===${NC}"

# Verificar argumento
if [ -z "$1" ]; then
    echo -e "${RED}Erro: Versão não especificada${NC}"
    echo "Uso: $0 [versao-neoforge]"
    echo "Exemplo: $0 20.4.228"
    exit 1
fi

NEOFORGE_VERSION=$1
INSTALLER_FILE="neoforge-${NEOFORGE_VERSION}-installer.jar"

# Verificar se arquivo existe
if [ ! -f "$INSTALLER_FILE" ]; then
    echo -e "${RED}Erro: Arquivo ${INSTALLER_FILE} não encontrado${NC}"
    echo "Baixe o installer de https://neoforged.net/"
    exit 1
fi

# Verificar e instalar Java 21
echo -e "${YELLOW}Verificando Java 21...${NC}"
JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)

if [ "$JAVA_VERSION" != "21" ]; then
    echo -e "${YELLOW}Java 21 necessário. Versão atual: ${JAVA_VERSION}${NC}"
    echo "Instalando Java 21..."
    sudo apt update
    sudo apt install -y openjdk-21-jdk
    
    # Configurar Java 21 como padrão
    sudo update-alternatives --set java /usr/lib/jvm/java-21-openjdk-amd64/bin/java
    
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
fi

echo -e "${GREEN}Java ${JAVA_VERSION} detectado${NC}"

# Backup de instalação anterior (se existir)
if [ -d "mods" ] || [ -f "server.properties" ]; then
    echo -e "${YELLOW}Instalação anterior detectada. Criando backup...${NC}"
    BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    [ -d "mods" ] && cp -r mods "$BACKUP_DIR/"
    [ -d "config" ] && cp -r config "$BACKUP_DIR/"
    [ -f "server.properties" ] && cp server.properties "$BACKUP_DIR/"
    
    echo -e "${GREEN}Backup salvo em: ${BACKUP_DIR}${NC}"
fi

# Instalar NeoForge
echo -e "${YELLOW}Instalando NeoForge ${NEOFORGE_VERSION}...${NC}"
java -jar "$INSTALLER_FILE" --installServer

if [ $? -eq 0 ]; then
    echo -e "${GREEN}NeoForge instalado com sucesso!${NC}"
else
    echo -e "${RED}Erro na instalação do NeoForge${NC}"
    exit 1
fi

# Aceitar EULA
echo -e "${YELLOW}Configurando EULA...${NC}"
echo "eula=true" > eula.txt
echo -e "${GREEN}EULA aceito${NC}"

# Criar/Atualizar configuração de memória
echo -e "${YELLOW}Configurando alocação de memória...${NC}"
if [ ! -f "user_jvm_args.txt" ]; then
    echo "-Xmx6G -Xms6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200" > user_jvm_args.txt
    echo -e "${GREEN}Alocação de memória: 6GB (recomendado para NeoForge)${NC}"
else
    echo -e "${YELLOW}user_jvm_args.txt já existe. Verifique a alocação de memória.${NC}"
fi

# Criar pasta de mods se não existir
mkdir -p mods
echo -e "${GREEN}Pasta mods/ pronta${NC}"

# Criar script de inicialização
echo -e "${YELLOW}Criando script de inicialização...${NC}"
cat > start.sh << 'EOF'
#!/bin/bash
# Script para iniciar servidor NeoForge com screen

NEOFORGE_JAR=$(ls neoforge-*.jar | grep -v installer)

if [ -z "$NEOFORGE_JAR" ]; then
    echo "Erro: Arquivo JAR do NeoForge não encontrado"
    exit 1
fi

echo "Iniciando servidor: $NEOFORGE_JAR"
screen -dmS minecraft java -jar "$NEOFORGE_JAR" nogui

echo "Servidor iniciado em screen session 'minecraft'"
echo "Use 'screen -r minecraft' para acessar o console"
echo "Para sair: Ctrl+A depois D"
EOF

chmod +x start.sh
echo -e "${GREEN}Script start.sh criado${NC}"

# Criar script de parada
cat > stop.sh << 'EOF'
#!/bin/bash
# Script para parar servidor gracefully

if screen -list | grep -q "minecraft"; then
    echo "Enviando comando stop para o servidor..."
    screen -S minecraft -p 0 -X stuff "stop^M"
    echo "Aguardando servidor desligar..."
    sleep 10
    
    if screen -list | grep -q "minecraft"; then
        echo "Servidor ainda rodando, forçando parada..."
        screen -X -S minecraft quit
    fi
    
    echo "Servidor parado."
else
    echo "Servidor não está rodando."
fi
EOF

chmod +x stop.sh
echo -e "${GREEN}Script stop.sh criado${NC}"

echo ""
echo -e "${GREEN}=== Instalação NeoForge Completa! ===${NC}"
echo ""
echo "Próximos passos:"
echo "1. Adicionar mods na pasta mods/"
echo "2. Ajustar server.properties conforme necessário"
echo "3. Verificar user_jvm_args.txt (memória alocada)"
echo "4. Iniciar servidor: ./start.sh"
echo "5. Acessar console: screen -r minecraft"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "• NeoForge requer Java 21"
echo "• Recomendado: 6-8GB RAM (instância t3.large)"
echo "• Porta padrão: 25565"
echo "• Não esqueça de configurar Security Group!"
echo ""
if [ -n "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Backup da instalação anterior: ${BACKUP_DIR}${NC}"
fi
