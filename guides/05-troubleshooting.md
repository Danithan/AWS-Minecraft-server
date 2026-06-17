# 🔧 Troubleshooting

Problemas reais encontrados ao longo deste projeto (Forge, NeoForge e Fabric) e como resolvê-los.

## 🔍 Metodologia

1. **Identifique** o problema exato — qual mensagem de erro, em qual etapa
2. **Reproduza** — acontece sempre ou só às vezes?
3. **Isole** — é cliente, servidor, rede ou configuração?
4. **Teste uma hipótese por vez**
5. **Documente** o que funcionou, para a próxima vez

---

## 🚫 "Connection Timed Out"

**Causa raiz:** Security Group não libera a porta do jogo.

**Diagnóstico:**
```bash
# servidor está rodando?
screen -r minecraft

# porta está escutando?
ss -tlnp | grep 25565
```

**Solução:** AWS Console → EC2 → Security Groups → Inbound rules → adicionar `TCP 25565` (ou a porta correspondente ao jogo) com origem `0.0.0.0/0`.

---

## ⚠️ "Mod Rejections" (Forge/NeoForge) ou erro de mods incompatíveis (Fabric)

**Causa raiz:** mods diferentes entre cliente e servidor.

**Diagnóstico:**
```bash
cd ~/minecraft-server/mods
ls -1 > ~/server_mods.txt
```
Compare com a lista de `mods/` do cliente.

**Solução:** sincronize as duas listas. Excessões permitidas só no cliente: shaders (Optifine/Iris), sound mods, minimapas puramente visuais.

---

## 💾 `OutOfMemoryError`

**Causa raiz:** RAM alocada à JVM insuficiente para o modpack.

**Diagnóstico:**
```bash
free -h
cat user_jvm_args.txt   # Forge/NeoForge
cat start.sh            # Fabric
```

**Solução:**
- Aumentar `-Xmx`/`-Xms` se houver RAM livre na instância
- Ou trocar para um tipo de instância maior (veja [`02-sizing-guide.md`](02-sizing-guide.md))
- Ou reduzir mods/plugins não essenciais

---

## 🔌 Servidor não inicia

```bash
tail -100 logs/latest.log
```

| Mensagem no log | Causa provável | Solução |
|---|---|---|
| `ClassNotFoundException` | Mod corrompido ou faltando | Re-baixe o mod |
| `NoSuchMethodError` | Versão incompatível entre Java/loader/mod | Confira a versão correta na tabela do loader usado |
| `Missing or unsupported dependencies` | Falta mod dependência | Instale o mod citado no erro |
| `Address already in use` / `Port already in use` | Outro processo na porta 25565 | `lsof -i :25565` → `kill -9 <PID>` |
| `Unsupported Java version` | Java errado para o loader/versão do MC | Veja a tabela de Java em cada [guia de loader](loaders/) |

---

## 🧵 Específico de Fabric

### "Não encontro o `.jar` do servidor depois de baixar o modpack"
Esperado — modpacks Fabric não incluem o executável do servidor no `.zip` do cliente. Veja [`loaders/fabric.md`](loaders/fabric.md) para o processo correto de obtenção.

### `start.sh` aponta para um `.jar` que não existe
O nome do arquivo do servidor Fabric muda conforme a versão do loader/installer usada. Depois de qualquer atualização, confira:
```bash
ls *.jar
cat start.sh   # o nome referenciado bate com o que está na pasta?
```

### Mods Fabric não carregam mesmo parecendo corretos
Confirme que o **Fabric API** está presente em `mods/` — é dependência da maioria dos mods e normalmente já vem dentro do modpack, mas se você copiou as pastas manualmente é fácil esquecê-lo.

---

## 🐌 Lag / Performance Ruim

**Diagnóstico:**
```
/tps              # no console do servidor, deve ficar perto de 20.0
```
```bash
top               # CPU
free -h           # RAM / swap
```

**Soluções, em ordem de impacto:**
1. Reduzir `view-distance` e `simulation-distance` em `server.properties`
2. Pré-gerar o mundo com mods como Chunky
3. Adicionar mods de otimização server-side (Lithium, FerriteCore, Krypton)
4. Subir o tipo de instância

---

## 🌐 IP público mudou depois de parar/iniciar a instância

Comportamento esperado em IPs públicos dinâmicos da AWS. Solução: alocar um **Elastic IP** e associá-lo à instância (gratuito enquanto associado a uma instância em execução).

---

## 🔐 "Permission denied (publickey)" no SSH

```bash
chmod 400 game-server-key.pem
ssh -i game-server-key.pem ubuntu@<ip>   # username correto: "ubuntu" para Ubuntu Server
```

---

## 📊 Comandos úteis de diagnóstico

```bash
tail -f logs/latest.log        # acompanhar log em tempo real
grep -i error logs/latest.log  # procurar erros
free -h                        # RAM
top / htop                     # CPU
ss -tlnp                       # portas escutando
screen -ls                     # sessões screen ativas
```

## ✅ Checklist Geral

- [ ] Verificou os logs (`logs/latest.log`)
- [ ] Confirmou que o servidor está de fato rodando
- [ ] Checou o Security Group
- [ ] Confirmou mods sincronizados entre cliente e servidor
- [ ] Confirmou versão de Java correta para o loader/versão do MC
- [ ] Checou alocação de RAM e espaço em disco
