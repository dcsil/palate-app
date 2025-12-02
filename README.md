# Project Name

This repository contains the source code and documentation for the project.  
The **main branch** serves as the stable, production-ready branch.  

---

## Branching Strategy

- **main** – Stable branch, always contains production-ready code.  
- **dev** – Active development branch where features are merged before release.  
- **test-*** – Experimental branches for testing features, ideas, or prototypes.  
  - Example: `test-agent-orchestration`, `test-ui-layout`  
- **release/** – Used if you want a staging area before merging into `main`.  
  - Good for tagging versions (`release/v1.0.0`) and preparing hotfixes.  
- **hotfix/** – For urgent fixes applied directly to production (`main`).  
  - After applying, merge back into `dev` to keep branches aligned.  
- **feature/** – For specific new features branched off `dev`.  
  - Example: `feature-auth-system`.  

---

## Getting Started

Clone and switch to the development branch:
```bash
git clone https://github.com/dcsil/palate-app.git
cd palate-app
git checkout dev
