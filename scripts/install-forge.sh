#!/bin/bash
# Script de instalação do Forge Server
# Uso: ./install-forge.sh [versao-forge]
# Exemplo: ./install-forge.sh 1.20.1-47.4.10

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador Forge Server ===${NC}"

# Verificar argumento
if [ -z "$1" ]; then
    echo -e "${RED}Erro: Versão não especificada${NC}"
    echo "Uso: $0 [versao-forge]"
    echo "Exemplo: $0 1.20.1-47.4.10"
    exit 1
fi

FORGE_VERSION=$1
INSTALLER_FILE="forge-${FORGE_VERSION}-installer.jar"

# Verificar se arquivo existe
if [ ! -f "$INSTALLER_FILE" ]; then
    echo -e "${RED}Erro: Arquivo ${INSTALLER_FILE} não encontrado${NC}"
    echo "Baixe o installer de https://files.minecraftforge.net/"
    exit 1
fi

# Verificar Java
echo -e "${YELLOW}Verificando Java...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}Java não encontrado!${NC}"
    echo "Instalando Java 17..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
echo -e "${GREEN}Java ${JAVA_VERSION} detectado${NC}"

# Instalar Forge
echo -e "${YELLOW}Instalando Forge ${FORGE_VERSION}...${NC}"
java -jar "$INSTALLER_FILE" --installServer

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Forge instalado com sucesso!${NC}"
else
    echo -e "${RED}Erro na instalação do Forge${NC}"
    exit 1
fi

# Aceitar EULA
echo -e "${YELLOW}Configurando EULA...${NC}"
echo "eula=true" > eula.txt
echo -e "${GREEN}EULA aceito${NC}"

# Criar configuração de memória padrão
if [ ! -f "user_jvm_args.txt" ]; then
    echo -e "${YELLOW}Criando user_jvm_args.txt...${NC}"
    echo "-Xmx3G -Xms3G" > user_jvm_args.txt
    echo -e "${GREEN}Alocação de memória: 3GB${NC}"
    echo -e "${YELLOW}Ajuste em user_jvm_args.txt conforme necessário${NC}"
fi

# Criar script de inicialização
echo -e "${YELLOW}Criando script de inicialização...${NC}"
cat > start.sh << 'EOF'
#!/bin/bash
# Script para iniciar servidor Forge com screen

FORGE_JAR=$(ls forge-*.jar | grep -v installer)

if [ -z "$FORGE_JAR" ]; then
    echo "Erro: Arquivo JAR do Forge não encontrado"
    exit 1
fi

echo "Iniciando servidor: $FORGE_JAR"
screen -dmS minecraft java -jar "$FORGE_JAR" nogui

echo "Servidor iniciado em screen session 'minecraft'"
echo "Use 'screen -r minecraft' para acessar o console"
echo "Para sair: Ctrl+A depois D"
EOF

chmod +x start.sh
echo -e "${GREEN}Script start.sh criado${NC}"

echo ""
echo -e "${GREEN}=== Instalação Completa! ===${NC}"
echo ""
echo "Próximos passos:"
echo "1. Ajustar server.properties conforme necessário"
echo "2. Adicionar mods na pasta mods/"
echo "3. Iniciar servidor: ./start.sh"
echo "4. Acessar console: screen -r minecraft"
echo ""
echo -e "${YELLOW}Porta padrão: 25565${NC}"
echo -e "${YELLOW}Não esqueça de configurar Security Group!${NC}"
