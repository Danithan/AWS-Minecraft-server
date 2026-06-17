# 📦 Case Study: Better MC 5

Segunda fase do projeto: migração do CISCO RPG Dragonfyre para um modpack "kitchen sink" muito mais pesado, trocando também o mod loader.

## Ficha técnica

```
Modpack:    Better MC 5
Loader:     NeoForge 20.4.228
Versão MC:  1.20.1
Java:       21
Mods:       ~250
RAM usada:  6-8 GB
Instância:  t3.large (8 GB RAM, 2 vCPUs)
Foco:       Conteúdo abrangente / melhorias gerais
```

## Por que essa configuração

- 250+ mods e sistemas mais pesados de geração de mundo exigiram saltar de 4 GB para 8 GB de RAM
- O modpack distribui via NeoForge, não Forge — exigiu trocar o loader, não só os mods
- NeoForge nessa versão requer Java 21, enquanto o setup anterior usava Java 17

## Migração: o que mudou na prática

| Antes (CISCO RPG) | Depois (Better MC 5) |
|---|---|
| Forge 47.4.10 | NeoForge 20.4.228 |
| Java 17 | Java 21 |
| ~150 mods | ~250 mods |
| t3.medium (4 GB) | t3.large (8 GB) |
| RAM JVM: 3 GB | RAM JVM: 6 GB, com flags G1GC |

## Problemas reais enfrentados

- **"Mod Rejections"** logo após a primeira tentativa de conexão — lista de mods do cliente e do servidor estava dessincronizada. Resolvido comparando `ls -1 mods/` dos dois lados
- **Performance instável em t3.medium** — sintoma de RAM insuficiente para o novo pack, resolvido com upgrade de instância (`Change Instance Type` → t3.large)

## Aplicando este caso

Para reproduzir uma migração assim: [`guides/04-modpack-migration.md`](../guides/04-modpack-migration.md) documenta o processo genérico de troca de loader/pack. O loader específico: [`guides/loaders/neoforge.md`](../guides/loaders/neoforge.md). Categoria de dimensionamento: "Pesado", no [guia de sizing](../guides/02-sizing-guide.md).

➡️ A migração seguinte (para um loader totalmente diferente, Fabric) está documentada em [`cobbleverse.md`](cobbleverse.md).
