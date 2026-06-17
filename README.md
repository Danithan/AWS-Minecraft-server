# 🎮 AWS Game Server Infrastructure

Template reutilizável para hospedar servidores de jogos (Minecraft com mods, e o mesmo padrão aplicável a outros jogos) na AWS — incluindo o ambiente da **AWS Academy Learner Lab**. Nasceu como projeto pessoal de aprendizado em Cloud Computing e administração de sistemas Linux, e foi reorganizado para servir como referência reaplicável a qualquer modpack ou jogo novo.

## 🆕 Sobre esta versão

Esta é uma reorganização do projeto original (que documentava só Forge e NeoForge em um modpack específico). Agora o repositório é estruturado como **template + casos de uso reais**, com a adição de:
- Guia específico para o ambiente AWS Academy Learner Lab (sessão, vockey, particularidades)
- Guia de dimensionamento de instância por categoria de carga, em vez de números fixos
- Suporte a **Fabric** como terceiro mod loader, incluindo o caso de modpacks sem "server pack" oficial (Cobbleverse/Cobblemon)
- Script de instalação automatizada para Fabric, via API de metadados oficial
- Script de backup
- Nota introdutória sobre como aplicar o mesmo padrão a jogos não-Minecraft

## 📂 Estrutura do Repositório

```
.
├── README.md
├── LICENSE
├── docs/
│   ├── architecture.md          # Arquitetura (diagrama + decisões)
│   └── resume-guide.md          # Como apresentar este projeto em currículo/LinkedIn
├── guides/
│   ├── 01-aws-academy-setup.md  # EC2 na AWS Academy, do zero
│   ├── 02-sizing-guide.md       # Qual instância usar, por categoria de modpack
│   ├── loaders/
│   │   ├── forge.md
│   │   ├── neoforge.md
│   │   └── fabric.md
│   ├── 04-modpack-migration.md  # Processo genérico de migração entre packs/loaders
│   ├── 05-troubleshooting.md    # Problemas reais e soluções
│   └── 06-other-games.md        # Aplicando o padrão a jogos não-Minecraft
├── case-studies/
│   ├── cisco-rpg-dragonfyre.md  # Caso real: Forge
│   ├── better-mc-5.md           # Caso real: NeoForge
│   └── cobbleverse.md           # Caso real: Fabric (sem server pack oficial)
└── scripts/
    ├── install-forge.sh
    ├── install-neoforge.sh
    ├── install-fabric.sh        # usa a Fabric Meta API para descobrir versões
    └── backup-world.sh
```

## 🚀 Quick Start

1. **Tem AWS Academy?** Comece em [`guides/01-aws-academy-setup.md`](guides/01-aws-academy-setup.md)
2. **Não sabe quanto de RAM precisa?** Veja [`guides/02-sizing-guide.md`](guides/02-sizing-guide.md)
3. **Sabe qual mod loader seu modpack usa?** Vá direto para [`guides/loaders/`](guides/loaders/)
4. **Quer ver um exemplo real completo, do início ao fim?** Veja [`case-studies/`](case-studies/)
5. **Algo deu errado?** [`guides/05-troubleshooting.md`](guides/05-troubleshooting.md)

## 🧩 Mod Loaders Suportados

| Loader | Java | Server pack oficial? | Guia |
|---|---|---|---|
| Forge | 17 (MC ≤1.20.1) | Sim, via installer `--installServer` | [forge.md](guides/loaders/forge.md) |
| NeoForge | 21 (MC 1.20.1+) | Sim, via installer `--installServer` | [neoforge.md](guides/loaders/neoforge.md) |
| Fabric | 21 (MC 1.20.5+) | **Não** — montagem manual | [fabric.md](guides/loaders/fabric.md) |

## 📦 Casos de Uso Documentados

| Modpack | Loader | RAM | Detalhes |
|---|---|---|---|
| CISCO RPG Dragonfyre | Forge | 3-4 GB | [case-studies/cisco-rpg-dragonfyre.md](case-studies/cisco-rpg-dragonfyre.md) |
| Better MC 5 | NeoForge | 6-8 GB | [case-studies/better-mc-5.md](case-studies/better-mc-5.md) |
| Cobbleverse (Cobblemon) | Fabric | 6-8 GB | [case-studies/cobbleverse.md](case-studies/cobbleverse.md) |

## 🕹️ E para jogos que não são Minecraft?

O padrão de infraestrutura (EC2 + Security Group + processo persistente) generaliza bem. Veja [`guides/06-other-games.md`](guides/06-other-games.md) para uma referência rápida de portas/RAM/método de instalação de outros jogos comuns (Valheim, Palworld, Terraria, CS2).

## 🎯 Objetivos do Projeto

- Aprender AWS na prática através da AWS Academy
- Configurar e administrar um servidor Linux remoto
- Gerenciar servidores Minecraft com modpacks complexos, em três mod loaders diferentes
- Aplicar conceitos de redes, segurança e otimização de recursos
- Transformar o aprendizado em um template público, reaplicável e documentado

## 📜 Licença

[MIT](LICENSE)

---

**Nota:** este projeto foi desenvolvido para fins educacionais e uso pessoal. Custos de AWS mencionados nos guias são estimativas para a região `us-east-1` e podem variar.
