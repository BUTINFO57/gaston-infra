## Description

<!-- Que fait cette PR ? Lien vers l'issue concernée si applicable. -->

Ferme #

## Type de modification

- [ ] 📝 Documentation
- [ ] 🔧 Modèle de configuration
- [ ] 🤖 Automatisation (Ansible/PowerShell)
- [ ] 🏗️ Infrastructure as Code (Terraform)
- [ ] 🐛 Correction de bug
- [ ] ✨ Nouvelle fonctionnalité
- [ ] 🔀 Refactorisation

## Liste de vérification

- [ ] Aucun secret ni identifiant réel commité
- [ ] Tous les espaces réservés utilisent le format `<PLACEHOLDER>`
- [ ] Le lint Markdown passe (`make lint-md`)
- [ ] Les liens sont valides (`make docs`)
- [ ] Les diagrammes Mermaid s'affichent correctement
- [ ] Terraform fmt/validate passe (`make lint-tf`)
- [ ] Ansible-lint passe (`make lint-ansible`)
- [ ] Les éléments TODO suivent le format `TODO[XXX]` et sont dans le registre
- [ ] Message de Conventional Commit utilisé (en français)
- [ ] CHANGELOG mis à jour (si modification visible par l'utilisateur)

## Comment tester

<!-- Commandes pour valider cette PR -->

```bash
make validate
```

## Captures d'écran / Validation

<!-- Si applicable, ajoutez des captures d'écran ou des résultats de validation. -->
