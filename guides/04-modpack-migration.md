# 🔄 Migrando Entre Modpacks ou Loaders

Processo genérico para trocar o modpack (e possivelmente o mod loader) de um servidor já em produção, independente de qual loader você está saindo ou entrando. Para um exemplo real e completo, veja os [`case-studies/`](../case-studies/).

## ⚙️ Pré-requisitos

- [ ] Backup completo do mundo e configs atuais
- [ ] Novo modpack já instalado no cliente (para copiar mods de lá)
- [ ] Requisito de RAM do novo pack levantado (veja [`02-sizing-guide.md`](02-sizing-guide.md))
- [ ] Tempo livre para testar — espere precisar de troubleshooting

## 🔧 Processo Passo a Passo

### Etapa 1: Backup completo

```bash
# Parar o servidor primeiro
screen -r minecraft
# digite: stop

cd ~/minecraft-server
mkdir -p ~/backups
tar -czf ~/backups/backup_$(date +%Y%m%d_%H%M%S).tar.gz world config server.properties mods
```

Ou use o script pronto: [`scripts/backup-world.sh`](../scripts/backup-world.sh).

### Etapa 2: Trocar o mod loader, se necessário

Se o novo modpack usa um loader diferente do atual, siga o guia específico:
- [Forge](loaders/forge.md)
- [NeoForge](loaders/neoforge.md)
- [Fabric](loaders/fabric.md)

Lembre de checar a versão de Java exigida — é a causa mais comum de erro nessa troca.

### Etapa 3: Limpar mods antigos e copiar os novos

```bash
cd ~/minecraft-server
mv mods mods_old_$(date +%Y%m%d)
mkdir mods
```

Copie `mods/` (e `config/`, `datapacks/` se aplicável) da instalação do novo modpack no seu cliente, via SFTP/SCP, para o servidor.

### Etapa 4: Revisar `server.properties` e alocação de RAM

Modpacks diferentes têm necessidades diferentes — não assuma que a configuração antiga ainda serve. Reveja `view-distance`, `simulation-distance` e a RAM alocada à JVM conforme o novo pack.

### Etapa 5: Decidir sobre o mundo

- **Mundo novo (recomendado ao trocar de pack):** renomeie `world` para `world_old` e deixe o servidor gerar um mundo novo
- **Manter o mundo atual (arriscado):** blocos/itens de mods removidos podem causar corrupção ou crashes. Faça backup extra antes de tentar

### Etapa 6: Primeira inicialização e monitoramento

```bash
screen -S minecraft
./start.sh   # ou o comando correspondente ao loader
```

Acompanhe `logs/latest.log` atentamente nos primeiros minutos, procurando por "Missing dependencies", "Mod rejections" ou crashes.

### Etapa 7: Sincronizar o cliente

Cliente e servidor precisam ter exatamente os mesmos mods (exceto os client-only). Teste a conexão antes de anunciar o servidor pronto para outros jogadores.

## ✅ Checklist de Migração

- [ ] Backup completo realizado
- [ ] Java na versão correta para o novo loader
- [ ] Loader novo instalado e funcionando
- [ ] Mods antigos arquivados, novos copiados
- [ ] `server.properties` e RAM revisados
- [ ] Decisão sobre o mundo (novo ou mantido) tomada e executada
- [ ] Servidor inicia sem erros nos logs
- [ ] Cliente sincronizado e conexão testada

## 🔄 Revertendo, se algo der muito errado

```bash
screen -r minecraft
# digite: stop

cd ~/minecraft-server
rm -rf world mods config
tar -xzf ~/backups/backup_<data>.tar.gz
./start.sh
```

## 💡 Lições que valem para qualquer migração

1. Backup não é opcional — é a etapa que separa um problema de uma catástrofe
2. Logs explicam a maioria dos erros, se você ler com atenção
3. Sincronização cliente-servidor é a causa nº 1 de "não consigo entrar no servidor"
4. Recursos (RAM) importam mais que CPU na maioria dos modpacks
5. Teste em um mundo descartável antes de comprometer o mundo principal
