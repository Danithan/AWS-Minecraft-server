#!/bin/bash
# Script de instalação do Fabric Server
# Usa a Fabric Meta API (https://meta.fabricmc.net) para descobrir automaticamente
# as versões mais recentes do loader e do installer compatíveis com a versão
# do Minecraft informada, e baixa o .jar do servidor já compilado.
#
# Uso: ./install-fabric.sh [versao-minecraft] [ram-em-gb]
# Exemplo: ./install-fabric.sh 1.21.1 6

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Instalador Fabric Server ===${NC}"

# Verificar argumento obrigatório
if [ -z "$1" ]; then
    echo -e "${RED}Erro: Versão do Minecraft não especificada${NC}"
    echo "Uso: $0 [versao-minecraft] [ram-em-gb]"
    echo "Exemplo: $0 1.21.1 6"
    exit 1
fi

MC_VERSION=$1
RAM_GB=${2:-4}   # padrão: 4GB se não informado
SERVER_JAR="fabric-server-launch.jar"

# Verificar/instalar dependências (curl, jq)
echo -e "${YELLOW}Verificando dependências (curl, jq)...${NC}"
for dep in curl jq; do
    if ! command -v "$dep" &> /dev/null; then
        echo -e "${YELLOW}Instalando ${dep}...${NC}"
        sudo apt update -qq
        sudo apt install -y "$dep"
    fi
done

# Verificar Java
echo -e "${YELLOW}Verificando Java...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}Java não encontrado!${NC}"
    echo "Minecraft 1.20.5+ requer Java 21. Instale com:"
    echo "  sudo apt install -y openjdk-21-jdk"
    exit 1
fi
java -version

# Descobrir versão mais recente do loader compatível com a versão do MC
echo -e "${YELLOW}Consultando Fabric Meta API...${NC}"
LOADER_VERSION=$(curl -s "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}" | jq -r '.[0].loader.version')

if [ -z "$LOADER_VERSION" ] || [ "$LOADER_VERSION" == "null" ]; then
    echo -e "${RED}Erro: não foi possível encontrar uma versão de loader para Minecraft ${MC_VERSION}${NC}"
    echo "Confirme se a versão informada está correta (ex: 1.21.1)"
    exit 1
fi
echo -e "${GREEN}Loader encontrado: ${LOADER_VERSION}${NC}"

# Descobrir versão mais recente do installer
INSTALLER_VERSION=$(curl -s "https://meta.fabricmc.net/v2/versions/installer" | jq -r '.[0].version')
echo -e "${GREEN}Installer encontrado: ${INSTALLER_VERSION}${NC}"

# Montar URL e baixar o .jar do servidor (já compilado, pronto para rodar)
DOWNLOAD_URL="https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER_VERSION}/${INSTALLER_VERSION}/server/jar"
echo -e "${YELLOW}Baixando ${SERVER_JAR}...${NC}"
curl -sL -o "$SERVER_JAR" "$DOWNLOAD_URL"

if [ ! -s "$SERVER_JAR" ]; then
    echo -e "${RED}Erro: download falhou ou arquivo vazio${NC}"
    exit 1
fi
echo -e "${GREEN}${SERVER_JAR} baixado com sucesso${NC}"

# Aceitar EULA
echo -e "${YELLOW}Configurando EULA...${NC}"
echo "eula=true" > eula.txt
echo -e "${GREEN}EULA aceito${NC}"

# Criar pastas padrão se não existirem
mkdir -p mods config

# Criar script de inicialização (com a RAM já parametrizada)
echo -e "${YELLOW}Criando script de inicialização...${NC}"
cat > start.sh << EOF
#!/bin/bash
# Script para iniciar o servidor Fabric com screen
java -Xmx${RAM_GB}G -Xms${RAM_GB}G -jar ${SERVER_JAR} nogui
EOF
chmod +x start.sh
echo -e "${GREEN}start.sh criado (RAM: ${RAM_GB}GB)${NC}"

# Criar script de parada graceful
cat > stop.sh << 'EOF'
#!/bin/bash
# Script para parar o servidor gracefully
if screen -list | grep -q "minecraft"; then
    echo "Enviando comando stop para o servidor..."
    screen -S minecraft -p 0 -X stuff "stop^M"
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
echo -e "${GREEN}stop.sh criado${NC}"

echo ""
echo -e "${GREEN}=== Instalação Fabric Completa! ===${NC}"
echo ""
echo "Próximos passos:"
echo "1. Copiar mods/, config/ (e datapacks/, se houver) do modpack instalado no seu cliente"
echo "2. Ajustar server.properties conforme necessário"
echo "3. Iniciar servidor: screen -dmS minecraft ./start.sh"
echo "4. Acessar console: screen -r minecraft"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "• Jar do servidor: ${SERVER_JAR} (esse nome é fixo, não muda entre atualizações)"
echo "• RAM alocada: ${RAM_GB}GB — ajuste em start.sh se necessário"
echo "• Porta padrão: 25565"
echo "• Não esqueça de configurar o Security Group!"
echo "• Modpacks Fabric não têm 'server pack' oficial — copie mods/config manualmente"
