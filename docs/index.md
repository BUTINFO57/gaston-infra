# 📚 Documentation — gaston-infra

Bienvenue dans la documentation du projet **Les Saveurs de Gaston**.

## Navigation

| Guide | Description | Public |
|:------|:------------|:-------|
| [Quickstart](quickstart.md) | Démarrer en 5 minutes | Tout le monde |
| [Lab — Single Host](lab/overview.md) | Déployer sur 1 seul PC | Étudiants, homelab |
| [Prod — 3 Nodes](prod/overview.md) | Déploiement complet J0 | Production |
| [Architecture](architecture/diagrams.md) | Schémas, IP plan, flux | Référence |
| [Operations](ops/backup.md) | Backup, monitoring, rollback | Ops / Admin |

## Parcours recommandé

```text
1. quickstart.md        → comprendre le projet
2. lab/overview.md      → choisir son chemin (LAB ou PROD)
3. lab/ ou prod/        → suivre le guide pas à pas
4. ops/                 → opérations quotidiennes
```

## Runbooks

Les procédures exécutables sont dans [`/runbooks/`](../runbooks/):

- [Runbook J0 complet](../runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md)
- [Checklist exécutive 20 min](../runbooks/RUNBOOK-EXEC-20MIN.md)

---

## TODO Registry (global)

| ID | Description | Location | Status |
|:---|:-----------|:---------|:-------|
| TODO[001] | GitHub repository owner username | `README.md` | Pending |
| TODO[002] | Security contact email address | `SECURITY.md` | Pending |
| TODO[003] | PBS monitoring IP — 192.168.30.100 or 192.168.10.x? | `docs/ops/monitoring.md`, `docs/architecture/ip-plan.md` | Pending |
| TODO[004] | PROD VM IPs — .106/.108/.105 or .110/.111/.112? | `docs/architecture/ip-plan.md` | Pending |
| TODO[005] | GLPI exact OS and version (Debian 12 assumed) | `docs/architecture/ip-plan.md` | Pending |
| TODO[006] | LDAP Auth Container DN for pfSense VPN bind | `configs/pfsense/openvpn.md` | Pending |

---

## Git History Plan

### Branch strategy

```text
main            ← production-ready, tagged releases
```

> Single-branch strategy. Commits are ordered logically to simulate
> a realistic development history. For a solo project this is standard.

### Commit plan — 32 Conventional Commits

#### Phase 1 — Scaffolding → tag `v0.1.0`

| # | Message | Files |
|:-:|:--------|:------|
| 1 | `chore: init repo with gitignore editorconfig gitattributes` | `.gitignore`, `.editorconfig`, `.gitattributes` |
| 2 | `docs: add project README with quickstart and checklist` | `README.md` |
| 3 | `docs: add MIT license` | `LICENSE` |
| 4 | `docs: add security policy with disclosure process` | `SECURITY.md` |
| 5 | `docs: add contributor covenant code of conduct` | `CODE_OF_CONDUCT.md` |
| 6 | `docs: add contributing guide with commit convention` | `CONTRIBUTING.md` |
| 7 | `docs: add changelog with semver releases` | `CHANGELOG.md` |
| 8 | `ci: add markdown lint and link check workflow` | `.github/workflows/ci.yml` |
| 9 | `ci: add yamllint workflow on push and pull request` | `.github/workflows/lint.yml` |
| 10 | `ci: add issue templates and pull request template` | `.github/ISSUE_TEMPLATE/bug_report.yml`, `.github/ISSUE_TEMPLATE/feature_request.yml`, `.github/PULL_REQUEST_TEMPLATE.md` |

#### Phase 2 — Documentation & Runbooks → tag `v0.2.0`

| # | Message | Files |
|:-:|:--------|:------|
| 11 | `docs: add documentation index and quickstart guide` | `docs/index.md`, `docs/quickstart.md` |
| 12 | `docs(arch): add mermaid architecture diagrams` | `docs/architecture/diagrams.md` |
| 13 | `docs(arch): add full IP plan and VLAN reference` | `docs/architecture/ip-plan.md` |
| 14 | `docs(arch): add network flow matrix and port table` | `docs/architecture/flows.md` |
| 15 | `docs(lab): add single-host proxmox lab guides` | `docs/lab/overview.md`, `docs/lab/single-host-proxmox.md`, `docs/lab/networking-vlans.md` |
| 16 | `docs(prod): add production deployment and validation` | `docs/prod/overview.md`, `docs/prod/day0-runbook.md`, `docs/prod/validation.md` |
| 17 | `docs(ops): add backup and monitoring operations` | `docs/ops/backup.md`, `docs/ops/monitoring.md` |
| 18 | `docs(ops): add rollback procedures and troubleshooting` | `docs/ops/rollback.md`, `docs/ops/troubleshooting.md` |
| 19 | `feat: add full day-0 deployment runbook v2.0` | `runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md` |
| 20 | `feat: add 20-minute executive deployment checklist` | `runbooks/RUNBOOK-EXEC-20MIN.md` |

#### Phase 3 — Configs, Automation & Tools → tag `v1.0.0`

| # | Message | Files |
|:-:|:--------|:------|
| 21 | `feat(config): add nginx reverse proxy template` | `configs/nginx/rp-prod01.conf.template` |
| 22 | `feat(config): add ufw firewall rule templates` | `configs/ufw/ufw-web.template`, `configs/ufw/ufw-db.template` |
| 23 | `feat(config): add pfsense aliases rules and vpn docs` | `configs/pfsense/aliases.md`, `configs/pfsense/rules.md`, `configs/pfsense/openvpn.md`, `configs/pfsense/config-export.md` |
| 24 | `feat(config): add samba ad provision and ou scripts` | `configs/samba/provision.sh.template`, `configs/samba/ou-groups.sh.template` |
| 25 | `feat(ansible): add readme inventories and gitkeep` | `automation/.gitkeep`, `automation/ansible/README.md`, `automation/ansible/inventories/lab.ini.example`, `automation/ansible/inventories/prod.ini.example` |
| 26 | `feat(ansible): add base-linux playbook` | `automation/ansible/playbooks/base-linux.yml` |
| 27 | `feat(ansible): add hardening playbook with four roles` | `automation/ansible/playbooks/hardening-min-j0.yml`, `automation/ansible/roles/common/`, `automation/ansible/roles/ufw/`, `automation/ansible/roles/fail2ban/`, `automation/ansible/roles/ssh/` |
| 28 | `feat(ansible): add web stack playbooks` | `automation/ansible/playbooks/wordpress.yml`, `automation/ansible/playbooks/mariadb.yml`, `automation/ansible/playbooks/nginx-rp.yml` |
| 29 | `feat(ansible): add mailcow and checkmk agent playbooks` | `automation/ansible/playbooks/mailcow.yml`, `automation/ansible/playbooks/checkmk-agent.yml` |
| 30 | `feat(ps): add fs01 bootstrap and shares scripts` | `automation/powershell/fs01-bootstrap.ps1`, `automation/powershell/fs01-shares.ps1` |
| 31 | `feat(tools): add mermaid link and render validators` | `tools/validate-mermaid.sh`, `tools/validate-links.sh`, `tools/render-docs.sh` |
| 32 | `feat(examples): add secrets hosts and network examples` | `examples/secrets.env.example`, `examples/hosts.example`, `examples/network.example.md` |

### Tags

| Tag | After commit | Description |
|:----|:-------------|:------------|
| `v0.1.0` | #10 | Project scaffolding — policies, CI skeleton |
| `v0.2.0` | #20 | Documentation complete — docs, runbooks, diagrams |
| `v1.0.0` | #32 | Initial public release — automation, templates, tools |

### Release descriptions

**v0.1.0 — Project Scaffolding**
> Repository structure with README, MIT license, community files,
> CI/CD workflows (markdownlint, lychee, trufflehog, mermaid validation),
> and GitHub issue/PR templates.

**v0.2.0 — Documentation Complete**
> Full docs: architecture diagrams (Mermaid), IP plan, network flows,
> LAB single-host guide, PROD day-0 runbook, ops manuals, deployment
> runbook v2.0 (2000+ lines), 20-min executive checklist.

**v1.0.0 — Initial Public Release**
> Complete infrastructure-as-code: NGINX/UFW/pfSense/Samba templates,
> 7 Ansible playbooks, 4 hardening roles, PowerShell scripts, CI tools,
> example files. Ready for LAB or PROD deployment.

---

## How to init the repository

Copy the script below into a file named `git-init-gaston.sh` at the root
of the `gaston-infra/` directory, then run it.

> **Prerequisites**: `git` installed. All 73 files already present in the
> directory (created by the previous steps or extracted from an archive).

```bash
#!/usr/bin/env bash
# =============================================================================
# git-init-gaston.sh — Initialize gaston-infra with 32 ordered commits
# Run from inside the gaston-infra/ directory where all 73 files exist.
# =============================================================================
set -euo pipefail
cd "$(dirname "$0")"

echo "=== gaston-infra — Git History Builder ==="
echo "Directory: $(pwd)"
echo ""

# Ensure we are in gaston-infra
if [ ! -f "README.md" ] || [ ! -d "docs" ]; then
  echo "ERROR: Run this script from the gaston-infra/ root directory."
  exit 1
fi

# Abort if .git already exists
if [ -d ".git" ]; then
  echo "ERROR: .git/ already exists. Delete it first if you want to re-init."
  exit 1
fi

git init
git checkout -b main

# =========================================================================
# PHASE 1 — Scaffolding (commits 1-10) → v0.1.0
# =========================================================================

# Commit 1
git add .gitignore .editorconfig .gitattributes
git commit -m "chore: init repo with gitignore editorconfig gitattributes"

# Commit 2
git add README.md
git commit -m "docs: add project README with quickstart and checklist"

# Commit 3
git add LICENSE
git commit -m "docs: add MIT license"

# Commit 4
git add SECURITY.md
git commit -m "docs: add security policy with disclosure process"

# Commit 5
git add CODE_OF_CONDUCT.md
git commit -m "docs: add contributor covenant code of conduct"

# Commit 6
git add CONTRIBUTING.md
git commit -m "docs: add contributing guide with commit convention"

# Commit 7
git add CHANGELOG.md
git commit -m "docs: add changelog with semver releases"

# Commit 8
git add .github/workflows/ci.yml
git commit -m "ci: add markdown lint and link check workflow"

# Commit 9
git add .github/workflows/lint.yml
git commit -m "ci: add yamllint workflow on push and pull request"

# Commit 10
git add .github/ISSUE_TEMPLATE/bug_report.yml \
        .github/ISSUE_TEMPLATE/feature_request.yml \
        .github/PULL_REQUEST_TEMPLATE.md
git commit -m "ci: add issue templates and pull request template"

git tag -a v0.1.0 -m "v0.1.0 — Project scaffolding"
echo "✅ Phase 1 done — v0.1.0 tagged (10 commits)"

# =========================================================================
# PHASE 2 — Documentation & Runbooks (commits 11-20) → v0.2.0
# =========================================================================

# Commit 11
git add docs/index.md docs/quickstart.md
git commit -m "docs: add documentation index and quickstart guide"

# Commit 12
git add docs/architecture/diagrams.md
git commit -m "docs(arch): add mermaid architecture diagrams"

# Commit 13
git add docs/architecture/ip-plan.md
git commit -m "docs(arch): add full IP plan and VLAN reference"

# Commit 14
git add docs/architecture/flows.md
git commit -m "docs(arch): add network flow matrix and port table"

# Commit 15
git add docs/lab/
git commit -m "docs(lab): add single-host proxmox lab guides"

# Commit 16
git add docs/prod/
git commit -m "docs(prod): add production deployment and validation"

# Commit 17
git add docs/ops/backup.md docs/ops/monitoring.md
git commit -m "docs(ops): add backup and monitoring operations"

# Commit 18
git add docs/ops/rollback.md docs/ops/troubleshooting.md
git commit -m "docs(ops): add rollback procedures and troubleshooting"

# Commit 19
git add runbooks/RUNBOOK-DEPLOIEMENT-ARCHI-EN-1-JOUR.md
git commit -m "feat: add full day-0 deployment runbook v2.0"

# Commit 20
git add runbooks/RUNBOOK-EXEC-20MIN.md
git commit -m "feat: add 20-minute executive deployment checklist"

git tag -a v0.2.0 -m "v0.2.0 — Documentation complete"
echo "✅ Phase 2 done — v0.2.0 tagged (20 commits)"

# =========================================================================
# PHASE 3 — Configs, Automation & Tools (commits 21-32) → v1.0.0
# =========================================================================

# Commit 21
git add configs/nginx/
git commit -m "feat(config): add nginx reverse proxy template"

# Commit 22
git add configs/ufw/
git commit -m "feat(config): add ufw firewall rule templates"

# Commit 23
git add configs/pfsense/
git commit -m "feat(config): add pfsense aliases rules and vpn docs"

# Commit 24
git add configs/samba/
git commit -m "feat(config): add samba ad provision and ou scripts"

# Commit 25
git add automation/.gitkeep \
        automation/ansible/README.md \
        automation/ansible/inventories/
git commit -m "feat(ansible): add readme inventories and gitkeep"

# Commit 26
git add automation/ansible/playbooks/base-linux.yml
git commit -m "feat(ansible): add base-linux playbook"

# Commit 27
git add automation/ansible/playbooks/hardening-min-j0.yml \
        automation/ansible/roles/
git commit -m "feat(ansible): add hardening playbook with four roles"

# Commit 28
git add automation/ansible/playbooks/wordpress.yml \
        automation/ansible/playbooks/mariadb.yml \
        automation/ansible/playbooks/nginx-rp.yml
git commit -m "feat(ansible): add web stack playbooks"

# Commit 29
git add automation/ansible/playbooks/mailcow.yml \
        automation/ansible/playbooks/checkmk-agent.yml
git commit -m "feat(ansible): add mailcow and checkmk agent playbooks"

# Commit 30
git add automation/powershell/
git commit -m "feat(ps): add fs01 bootstrap and shares scripts"

# Commit 31
git add tools/
git commit -m "feat(tools): add mermaid link and render validators"

# Commit 32
git add examples/
git commit -m "feat(examples): add secrets hosts and network examples"

git tag -a v1.0.0 -m "v1.0.0 — Initial public release"
echo "✅ Phase 3 done — v1.0.0 tagged (32 commits)"

echo ""
echo "=========================================="
echo "  gaston-infra initialized successfully"
echo "  32 commits · 3 tags · 73 files"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  gh repo create gaston-infra --public --source=. --push"
echo "  # or manually:"
echo "  git remote add origin git@github.com:<OWNER>/gaston-infra.git"
echo "  git push -u origin main --tags"
```

### Verification commands

After running the script:

```bash
# Verify commit count
git log --oneline | wc -l
# Expected: 32

# Verify tags
git tag -l
# Expected: v0.1.0  v0.2.0  v1.0.0

# Verify file count
git ls-files | wc -l
# Expected: 73

# Verify no secrets
git log -p | grep -iE "password|secret|token" | grep -v "PLACEHOLDER" | grep -v "#"
# Expected: nothing dangerous
```
