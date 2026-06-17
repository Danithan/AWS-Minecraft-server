# 📦 Case Study: CISCO RPG Dragonfyre

Primeiro modpack hospedado neste projeto. Serviu como introdução prática a EC2, Security Groups e administração de servidor Minecraft com mods.

## Ficha técnica

```
Modpack:    CISCO RPG Dragonfyre
Loader:     Forge 47.4.10
Versão MC:  1.20.1
Java:       17
Mods:       ~150
RAM usada:  3-4 GB
Instância:  t3.medium (4 GB RAM, 2 vCPUs)
Foco:       RPG e aventura
```

## Por que essa configuração

- t3.medium foi suficiente porque o pack é mais leve (~150 mods, foco em conteúdo de RPG, não em sistemas pesados de simulação)
- Forge foi a escolha natural por ser o loader nativo do pack — sem necessidade de migração nesse momento

## O que esse caso ensinou

1. **Primeira configuração de Security Group** — a causa do clássico erro "Connection Timed Out" foi a porta 25565 não liberada por padrão
2. **Fluxo básico de Forge** — installer → aceitar EULA → configurar `user_jvm_args.txt` → `screen` para manter rodando
3. **Sincronização cliente-servidor** — entender que mods precisam ser idênticos nos dois lados (exceto shaders/visual)

## Aplicando este caso

Siga [`guides/01-aws-academy-setup.md`](../guides/01-aws-academy-setup.md) para a instância, depois [`guides/loaders/forge.md`](../guides/loaders/forge.md) para o loader. Use a categoria "Médio" do [guia de dimensionamento](../guides/02-sizing-guide.md).

➡️ Este pack foi posteriormente substituído por [Better MC 5](better-mc-5.md), documentado como a primeira migração de loader deste projeto.
