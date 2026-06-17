# 📐 Guia de Dimensionamento (Sizing)

Antes de lançar a instância EC2, descubra quanto de RAM/CPU o seu modpack ou jogo realmente precisa. Adivinhar gera dois cenários ruins: pagar mais que o necessário, ou ter um servidor que trava/crasheia.

## 🧭 Como descobrir o requisito de RAM

Ordem de prioridade para decidir:

1. **Página oficial do modpack/jogo** (CurseForge, Modrinth, site do jogo) — geralmente tem uma recomendação explícita de RAM. Use-a como piso.
2. **Contagem de mods** — na ausência de recomendação oficial, uma régua aproximada:
   - Até ~100 mods leves: 4 GB costuma bastar
   - 100–250 mods (modpacks médios/RPG): 6 GB
   - 250+ mods ou packs "kitchen sink" (Better MC, All The Mods, etc.): 8 GB+
3. **Teste real** — depois de subir o servidor, monitore com `free -h` durante o uso normal. Se o heap da JVM está sempre no limite e há swap sendo usado, suba de instância.

⚠️ A régua do item 2 é só um ponto de partida — mods de Pokémon/criaturas (Cobblemon, etc.), shaders server-side, ou packs com geração de mundo pesada podem pesar mais que o número de mods sugere.

## 🖥️ Tabela: Categoria do Pack → Instância

| Categoria | RAM necessária | Tipo de instância (referência) | vCPUs |
|---|---|---|---|
| Vanilla / leve (Fabric API + poucos QoL mods) | 2–4 GB | t3.medium | 2 |
| Médio (RPG, aventura, 100–250 mods) | 4–6 GB | t3.large | 2 |
| Pesado (250+ mods, mundos grandes, mobs customizados) | 6–8 GB | t3.large / t3.xlarge | 2–4 |
| Muito pesado (vários jogadores simultâneos + pack pesado) | 8–16 GB | t3.xlarge / t3.2xlarge | 4–8 |

Regra prática de alocação: deixe **1–2 GB de RAM livre para o sistema operacional** acima do que você passa para a JVM (`-Xmx`). Uma instância de 8 GB total geralmente aloca `-Xmx6G`, não `-Xmx8G`.

⚠️ No AWS Academy, confira o catálogo de instâncias liberado para o seu curso antes de escolher — nem todo tipo está disponível em todo curso.

## 💰 Estimativa de Custo (us-east-1, sob demanda)

| Tipo | vCPU | RAM | Custo/hora aprox. | ~240h/mês (8h/dia) |
|---|---|---|---|---|
| t3.medium | 2 | 4 GB | $0.0416 | ~$10 |
| t3.large | 2 | 8 GB | $0.0832 | ~$20 |
| t3.xlarge | 4 | 16 GB | $0.1664 | ~$40 |

No AWS Academy esses valores saem do crédito da disciplina, não do seu cartão — mas vale monitorar mesmo assim, já que o crédito é limitado.

## 🔄 Redimensionando depois

Errou a escolha? Não precisa recriar a instância:

1. Pare a instância: `Actions > Instance State > Stop`
2. `Actions > Instance Settings > Change Instance Type`
3. Escolha o novo tipo
4. Inicie a instância de novo

Downtime: alguns minutos. O disco (EBS) e tudo que está nele permanece intacto.

## 🎯 Próximo Passo

Com o tamanho decidido, volte para [`01-aws-academy-setup.md`](01-aws-academy-setup.md) e lance a instância, ou siga direto para o [mod loader](loaders/) que seu modpack usa.
