Here is a clean, production-ready **CONTRIBUTING.md** built from your branching document.
No fluff. No filler. Just the rules as they should be.

---

# **CONTRIBUTING.md**

## **Overview**

This project uses a lean, high-velocity branching model.
All work flows into `main`, which must always remain stable and deployable.
Releases follow semantic versioning: **major.minor.patch**.

The goal: clarity, speed, and zero branching bloat.

---

# **Branch Types**

### **main**

The stable branch. Always deployable.
All releases — major, minor, patch — originate here.

---

### **feature/***

Used for new features, enhancements, or any work that changes product behavior.

---

### **hotfix/***

Used for urgent fixes required to resolve production issues immediately.

---

### **chore/***

Used for non-feature work such as refactoring, dependency updates, config changes, or reorganizing files.

---

### **docs/***

Used exclusively for documentation updates.

---

# **Release Flows**

## **1. Minor Release Flow**

**feature → main → tag**

Trigger this flow when adding or improving product behavior without breaking compatibility.

**This applies when:**

* Adding new functionality
* Enhancing or refining existing features
* Improving UX or workflows
* Shipping iterative upgrades
* Promoting experimental work into stable form

---

## **2. Patch Release Flow**

**hotfix → main → tag**

Reserved for immediate fixes to production-impacting issues.

**This applies when:**

* Production is broken
* A regression must be corrected
* A security issue requires a fast patch
* A deployment error needs fixing
* The fix restores expected behavior (no new functionality)

---

## **3. Major Release Flow**

**feature (or chore) → main → tag**

Triggered when changes break compatibility or represent significant architectural shifts.

**This applies when:**

* Overhauling architecture or core systems
* Removing or deprecating features
* Introducing incompatible API or schema changes
* Reorganizing routing or content structures
* Migrating frameworks or core technologies
* Rewriting major internal systems

Major releases reset expectations — use them intentionally.

---

# **Contribution Rules**

1. Keep branches short-lived.
2. Each branch must represent a single intention.
3. Tag every deployable state on `main`.
4. Delete branches after merging.
5. Keep branch names lowercase and predictable.
6. Use major releases sparingly and only when compatibility changes demand it.

---

If you want this formatted with project badges, version tables, or a custom header for your repo, I can polish it further.

