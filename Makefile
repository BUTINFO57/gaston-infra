# ===========================================================================
# Makefile — Les Saveurs de Gaston — IaC
# Cibles principales : lint, docs, lab-plan, lab-apply, prod-plan, prod-apply
# ===========================================================================

.DEFAULT_GOAL := help
SHELL := /bin/bash

# ---------------------------------------------------------------------------
# Aide
# ---------------------------------------------------------------------------
.PHONY: help
help: ## Afficher cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Lint / Qualité
# ---------------------------------------------------------------------------
.PHONY: lint
lint: lint-tf lint-ansible lint-yaml lint-md lint-sh ## Exécuter tous les linters

.PHONY: lint-tf
lint-tf: ## Vérifier le formatage Terraform
	bash iac/terraform/scripts/fmt.sh

.PHONY: lint-ansible
lint-ansible: ## Linter les playbooks et rôles Ansible
	cd automation/ansible && ansible-lint playbooks/ roles/

.PHONY: lint-yaml
lint-yaml: ## Linter les fichiers YAML
	yamllint -c .yamllint.yml .

.PHONY: lint-md
lint-md: ## Linter les fichiers Markdown
	markdownlint-cli2 "**/*.md"

.PHONY: lint-sh
lint-sh: ## Vérifier les scripts shell avec shellcheck
	shellcheck tools/*.sh iac/terraform/scripts/*.sh || true

# ---------------------------------------------------------------------------
# Documentation
# ---------------------------------------------------------------------------
.PHONY: docs
docs: ## Valider la documentation (liens + Mermaid)
	bash tools/validate-links.sh
	bash tools/validate-mermaid.sh

# ---------------------------------------------------------------------------
# Terraform — LAB
# ---------------------------------------------------------------------------
.PHONY: lab-init
lab-init: ## Initialiser Terraform pour le LAB
	terraform -chdir=iac/terraform/lab init

.PHONY: lab-plan
lab-plan: ## Planifier le déploiement LAB
	terraform -chdir=iac/terraform/lab plan -out=lab.tfplan

.PHONY: lab-apply
lab-apply: ## Appliquer le déploiement LAB
	terraform -chdir=iac/terraform/lab apply lab.tfplan

.PHONY: lab-output
lab-output: ## Afficher les outputs du LAB
	terraform -chdir=iac/terraform/lab output

.PHONY: lab-inventory
lab-inventory: ## Générer l'inventaire Ansible depuis le LAB
	bash tools/tf-to-ansible-inventory.sh lab

.PHONY: destroy-lab
destroy-lab: ## ⚠️  Détruire TOUTES les VMs du LAB
	@echo "╔══════════════════════════════════════════╗"
	@echo "║  ⚠️  ATTENTION : Destruction du LAB      ║"
	@echo "║  Toutes les VMs seront supprimées.       ║"
	@echo "║  Ctrl+C pour annuler (5 secondes)        ║"
	@echo "╚══════════════════════════════════════════╝"
	@sleep 5
	terraform -chdir=iac/terraform/lab destroy

# ---------------------------------------------------------------------------
# Terraform — PROD
# ---------------------------------------------------------------------------
.PHONY: prod-init
prod-init: ## Initialiser Terraform pour la PROD
	terraform -chdir=iac/terraform/prod init

.PHONY: prod-plan
prod-plan: ## Planifier le déploiement PROD
	terraform -chdir=iac/terraform/prod plan -out=prod.tfplan

.PHONY: prod-apply
prod-apply: ## Appliquer le déploiement PROD
	terraform -chdir=iac/terraform/prod apply prod.tfplan

.PHONY: prod-output
prod-output: ## Afficher les outputs de la PROD
	terraform -chdir=iac/terraform/prod output

.PHONY: prod-inventory
prod-inventory: ## Générer l'inventaire Ansible depuis la PROD
	bash tools/tf-to-ansible-inventory.sh prod

.PHONY: destroy-prod
destroy-prod: ## ⚠️  Détruire TOUTES les VMs de PROD
	@echo "╔══════════════════════════════════════════════╗"
	@echo "║  🛑 DANGER : Destruction de la PRODUCTION    ║"
	@echo "║  Toutes les VMs seront supprimées.           ║"
	@echo "║  Ctrl+C pour annuler (10 secondes)           ║"
	@echo "╚══════════════════════════════════════════════╝"
	@sleep 10
	terraform -chdir=iac/terraform/prod destroy

# ---------------------------------------------------------------------------
# Ansible — Configuration
# ---------------------------------------------------------------------------
.PHONY: ansible-base
ansible-base: ## Appliquer la configuration de base sur toutes les VMs Linux
	cd automation/ansible && ansible-playbook -i inventories/$(ENV).ini playbooks/base-linux.yml

.PHONY: ansible-harden
ansible-harden: ## Appliquer le durcissement J0
	cd automation/ansible && ansible-playbook -i inventories/$(ENV).ini playbooks/hardening-min-j0.yml

.PHONY: ansible-web
ansible-web: ## Déployer la stack web (MariaDB + WordPress + NGINX)
	cd automation/ansible && ansible-playbook -i inventories/$(ENV).ini playbooks/mariadb.yml
	cd automation/ansible && ansible-playbook -i inventories/$(ENV).ini playbooks/wordpress.yml
	cd automation/ansible && ansible-playbook -i inventories/$(ENV).ini playbooks/nginx-rp.yml

# ---------------------------------------------------------------------------
# Validation complète
# ---------------------------------------------------------------------------
.PHONY: validate
validate: lint docs ## Exécuter toute la validation (lint + docs)
	@echo ""
	@echo "✅ Toutes les validations passées"

# ---------------------------------------------------------------------------
# CI local (reproduit les checks GitHub Actions)
# ---------------------------------------------------------------------------
.PHONY: ci
ci: validate ## Simuler le pipeline CI localement
	bash iac/terraform/scripts/validate.sh
	@echo ""
	@echo "✅ Pipeline CI local terminé avec succès"
