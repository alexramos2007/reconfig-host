#!/bin/bash

set -e

USER_NAME="ansible"
DOCKER_COMPOSE_VERSION="v2.24.7"

# Verifica se é root
if [ "$EUID" -ne 0 ]; then
  echo "⚠️  Por favor, execute como root (use sudo)."
  exit 1
fi

echo "🔄 Atualizando pacotes..."
apt update && apt upgrade -y

echo "📦 Instalando dependências..."
apt install -y ca-certificates curl gnupg lsb-release

echo "🔐 Adicionando chave GPG do Docker..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "📂 Adicionando repositório Docker ao APT..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "🔄 Atualizando cache APT..."
apt update

echo "🐳 Instalando Docker e plugins..."
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "✅ Docker instalado com sucesso!"

# Instalação do docker-compose binário
echo "🔧 Instalando docker-compose ${DOCKER_COMPOSE_VERSION}..."
curl -SL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verifica se foi instalado corretamente
if docker-compose --version &>/dev/null; then
  echo "✅ Docker Compose instalado com sucesso: $(docker-compose --version)"
else
  echo "❌ Erro ao instalar Docker Compose"
  exit 1
fi

# Criação opcional do usuário
if id "$USER_NAME" &>/dev/null; then
  echo "👤 Usuário '$USER_NAME' já existe."
else
  echo "👤 Criando usuário '$USER_NAME'..."
  useradd -m -s /bin/bash "$USER_NAME"
  echo "Usuário '$USER_NAME' criado (sem senha)."
fi

# Adiciona ao grupo docker
usermod -aG docker "$USER_NAME"
echo "✅ Usuário '$USER_NAME' adicionado ao grupo docker."

echo "🚀 Instalação completa. Recomenda-se reiniciar ou fazer logout/login do usuário '$USER_NAME'."
