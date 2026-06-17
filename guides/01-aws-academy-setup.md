# 🚀 Configurando a Infraestrutura na AWS Academy Learner Lab

Este guia cobre a configuração de uma instância EC2 especificamente no ambiente **AWS Academy Learner Lab**, que tem particularidades diferentes de uma conta AWS pessoal. Se você está usando uma conta AWS normal, a maior parte do processo é igual, exceto a Etapa 0.

## 📋 Pré-requisitos

- Acesso a um curso da AWS Academy com Learner Lab habilitado
- Cliente SSH (terminal nativo no Linux/Mac, ou Bitvise/PuTTY no Windows)
- O modpack/jogo já escolhido e seus requisitos de RAM já levantados (veja [`02-sizing-guide.md`](02-sizing-guide.md))

## 🎓 Etapa 0: Particularidades do AWS Academy Learner Lab

Antes de tocar no EC2, entenda como esse ambiente difere de uma conta AWS comum:

| Característica | Comportamento no Learner Lab |
|---|---|
| **Login** | Não é o console AWS direto — é via Vocareum, dentro do LMS do seu curso |
| **Sessão** | O botão **Start Lab** inicia uma sessão com tempo limitado (normalmente ~4h de atividade). Ao esgotar, a AWS **para** (stop) as instâncias automaticamente — elas não são destruídas |
| **Persistência** | Dados em disco (EBS) sobrevivem entre sessões, desde que você não clique em **Reset** (isso apaga tudo permanentemente) |
| **IP público** | Muda a cada vez que a instância é parada e iniciada de novo (a menos que você associe um Elastic IP) |
| **Permissões** | Você usa uma IAM Role pré-configurada (geralmente `voclabs`), sem poder criar usuários/roles novos |
| **Região e tipos de instância** | Variam por curso — confira o catálogo de serviços liberado na sua sala antes de assumir que um tipo de instância específico está disponível |
| **Orçamento** | Você tem um crédito fixo (ex: USD 50–100) que é consumido por hora de uso de recursos, mesmo dentro do lab |

💡 **Prática recomendada:** sempre clique em **Stop Lab** (ou deixe a sessão expirar) quando terminar de usar o servidor, e não em **Reset** — Reset apaga tudo, Stop só pausa.

## 🔧 Etapa 1: Iniciar a Sessão

1. Acesse o painel do seu curso AWS Academy
2. Clique em **Start Lab** e aguarde o indicador ficar verde
3. Clique no link **AWS** (abre o console AWS já autenticado pela sessão)
4. Confirme que está na região correta (canto superior direito) — normalmente `us-east-1`

## 🔧 Etapa 2: Criar a Instância EC2

### 2.1 Acessar o console EC2
No console AWS recém-aberto, navegue até **EC2** → **Launch Instance**.

### 2.2 Configurações básicas
```
Nome da instância: game-server (ou o nome do seu projeto)
Application and OS Images: Ubuntu Server 24.04 LTS (ou 22.04 LTS)
Architecture: 64-bit (x86)
```

### 2.3 Tipo de instância
Use o resultado do [guia de dimensionamento](02-sizing-guide.md) para escolher aqui. Não adivinhe — modpacks pesados com pouca RAM travam ou nem sobem.

### 2.4 Key Pair
1. **Create new key pair**
2. Nome: `game-server-key`
3. Tipo: RSA
4. Formato: `.pem` (SSH padrão/Linux/Mac) ou `.ppk` (Bitvise/PuTTY no Windows)
5. Guarde o arquivo baixado em local seguro — sem ele, não há acesso SSH

No AWS Academy também existe a key pair padrão **`vockey`**, compartilhada entre todas as instâncias da sua sessão — pode ser usada no lugar de criar uma nova, se for mais conveniente.

### 2.5 Network e Security Group
```
Create security group: Yes
Nome: game-server-sg
```
As regras de entrada são configuradas na próxima etapa.

### 2.6 Armazenamento
```
Tipo: gp3
Tamanho: 20-30 GiB (modpacks grandes ou múltiplos jogos: considere 40 GiB)
```

### 2.7 Lançar
Revise e clique em **Launch Instance**. Aguarde o status mudar para **Running** e o **Status check** para `2/2 checks passed`.

## 🔒 Etapa 3: Configurar o Security Group

Esta etapa é **obrigatória** — sem ela você terá "Connection Timed Out" ao tentar jogar.

1. EC2 → **Security Groups** → selecione `game-server-sg`
2. Aba **Inbound rules** → **Edit inbound rules** → **Add rule**

Regras mínimas:

| Tipo | Protocolo | Porta | Origem | Descrição |
|---|---|---|---|---|
| SSH | TCP | 22 | Seu IP (`My IP`) | Acesso administrativo |
| Custom TCP/UDP | conforme o jogo | conforme o jogo | `0.0.0.0/0` | Tráfego do jogo |

A porta exata depende do jogo — Minecraft Java usa `TCP 25565`. Para outros jogos, veja [`06-other-games.md`](06-other-games.md).

⚠️ Prefira `My IP` em vez de `0.0.0.0/0` na regra SSH. Seu IP muda? Edite a regra de novo — é rápido, e bem mais seguro que deixar a porta 22 aberta ao mundo.

## 🖥️ Etapa 4: Conectar via SSH

### 4.1 Localizar o IP público
EC2 → instâncias → selecione a sua → copie o **Public IPv4 address**.

### 4.2 Linux/Mac
```bash
chmod 400 game-server-key.pem
ssh -i game-server-key.pem ubuntu@<seu-ip-publico>
```

### 4.3 Windows (Bitvise)
```
Host: <seu-ip-publico>
Port: 22
Username: ubuntu
Initial method: publickey
Client key: game-server-key.ppk
```

## 📦 Etapa 5: Preparar o Sistema Base

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y screen unzip curl jq
```

A instalação do Java é específica de cada mod loader — veja [`guides/loaders/`](loaders/).

## ✅ Checklist Final

- [ ] Sessão do Learner Lab ativa (Start Lab clicado)
- [ ] Instância EC2 rodando (status `Running`, `2/2 checks passed`)
- [ ] Security Group com porta SSH (22) e porta do jogo abertas
- [ ] Conexão SSH funcionando
- [ ] Sistema atualizado, `screen`/`unzip`/`curl`/`jq` instalados

## 💰 Gerenciando Custos e Tempo de Sessão

- **Pare a instância** (`Actions > Instance State > Stop`) quando não estiver jogando — não cobra computação parada, só o storage EBS (mínimo)
- **Não deixe a sessão do Learner Lab "vencer" com o servidor rodando sem necessidade** — ela para a instância sozinha, mas é melhor controlar isso você mesmo
- Monitore o crédito restante no painel do Vocareum
- Se o IP público mudar a cada restart for um problema (ex: compartilhar com amigos), considere alocar um **Elastic IP** — geralmente disponível no Learner Lab, sem custo enquanto associado a uma instância rodando

## 🎯 Próximos Passos

1. Escolha o tamanho certo da instância → [`02-sizing-guide.md`](02-sizing-guide.md)
2. Instale o mod loader do seu modpack → [`loaders/`](loaders/)
3. Veja um caso real completo → [`../case-studies/`](../case-studies/)
