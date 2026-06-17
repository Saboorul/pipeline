# NexusMart — Enterprise-Grade Modular Django E-Commerce Platform

Welcome to **NexusMart**, a modern, fully rebranded, production-ready Django e-commerce platform designed for maximum performance, security, and scalability. This project is built using a modular application architecture and optimized to run on enterprise infrastructure.

---

## 🏗️ Architecture & Deployment Flow

NexusMart utilizes a fully automated CI/CD pipeline integrated with AWS cloud infrastructure for seamless zero-downtime deployment.

```
+-----------------+      +-----------------------+      +--------------------------+
|  Developer Push | ---> |     GitHub Actions    | ---> |  AWS Elastic Beanstalk   |
|                 |      | - Lint (Black/Flake8) |      |   - Web Application Tier |
|  (GitHub Repo)  |      | - Scan (Bandit)       |      |   - Static files served  |
|                 |      | - Test (Django Suite) |      |   - Runs ebextensions    |
+-----------------+      +-----------------------+      +--------------------------+
                                                                     |
                                                                     v
                                                        +--------------------------+
                                                        |      AWS RDS instance    |
                                                        |  - PostgreSQL Database   |
                                                        +--------------------------+
```

### Flow Breakdown:
1. **Source Control (GitHub)**: Main branch triggers automated pipeline workflows on every push or pull request.
2. **CI/CD Pipeline (GitHub Actions)**:
   - **Linting**: Code quality is verified using `black` (for formatting) and `flake8` (for PEP 8 syntax standards).
   - **Security Scan**: `bandit` scans for vulnerability patterns (e.g. hardcoded secrets, SQL injection vectors).
   - **Testing**: Automated migration checks and full Django unit testing suite run concurrently.
3. **Application Hosting (AWS Elastic Beanstalk)**: Runs Django in a virtualized Python environment behind a reverse proxy. Auto-triggers:
   - Safe migration execution (`manage.py migrate`).
   - Static files bundling and collection (`manage.py collectstatic`).
4. **Database (AWS RDS)**: Dedicated PostgreSQL database instance configured outside the application layer for persistent, scalable storage.

---

## 📦 Modular Applications Blueprint

The project is structured with decoupled, single-responsibility apps that collaborate via Django’s ORM and context processors:

### 👤 Accounts (`api/accounts`)
* Custom user model (`Account`) extending Django's BaseUserManager.
* Production-grade authentication with email-based logins instead of default usernames.
* Custom user registration, profile management, and account activation workflows.

### 🛒 Store (`api/store`)
* Dynamic product listing, inventory tracking, and stock availability validation.
* Detailed product profiles with slug-based routing for SEO optimization.
* Category filtering and interactive search using SQL pattern matching.

### 💳 Carts (`api/carts`)
* Asynchronous Cart item modifications via AJAX handlers, avoiding full page refreshes.
* Session-based carts for guests, translating to account-based carts on user login.
* Dynamic calculation of subtotals, standard taxes, and grand totals.

### 📁 Category (`api/category`)
* Self-contained hierarchical category structures.
* Slug field generations for pretty URL mappings.
* Context processor (`all_category`) injecting categories globally into templates.

---

## 🛠️ Local Development Setup

### 1. Prerequisites
* Python 3.12+
* PostgreSQL (Optional, defaults to SQLite local file database)
* Redis (Optional, defaults to local memory caching)

### 2. Installation & Setup
Clone the repository, create a virtual environment, and install dependencies:

```bash
# Setup virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install requirements
pip install -r requirements.txt
```

### 3. Environment Configurations
Create a `.env` file in the project root:

```ini
DEBUG=True
SECRET_KEY=your-django-secret-key

# AWS RDS / PostgreSQL Config (Set USE_RDS=True to enable PostgreSQL)
USE_RDS=False
DATABASE_NAME=nexusmart_db
DATABASE_USER=postgres
DATABASE_PASSWORD=your_password
DATABASE_HOST=127.0.0.1
DATABASE_PORT=5432

# Redis Cache Config (Leave empty to default to LocMemCache)
REDIS_URL=
```

### 4. Database Migrations, Fixture Loading & Media Setup
Run migrations, initialize media folders with product/category images, load the database fixtures, create an administrative account, and start the local development server:

```bash
# Run migrations
python manage.py migrate

# Initialize media directory and populate product/category images
python -c "import os, shutil; mr = r'media'; si = r'static\images\items'; os.makedirs(os.path.join(mr, 'photos', 'categories'), exist_ok=True); os.makedirs(os.path.join(mr, 'photos', 'category'), exist_ok=True); pm = {'ATX-Jeans_HYTQBa5.jpg': '1.jpg', 'jordan-true-flight-basketball-shoes.jpg': '2.jpg', 'Blue-Shirt.jpg': '3.jpg', 'US-Polo-Assn_Jacket.jpg': '4.jpg', 'Wrangler-Shirt.jpg': '5.jpg', 'Mavi_jeans.jpg': '6.jpg', 'image13.jpg': '7.jpg'}; [shutil.copy(os.path.join(si, s), os.path.join(mr, 'photos', 'categories', d)) for d, s in pm.items() if os.path.exists(os.path.join(si, s))]; cm = {'tshirts_DzeqLYx.jpg': '8.jpg', 'shirts_qqbmQtD.jpg': '9.jpg', 'jeans_iJaiaNx.jpg': '10.jpg', 'jackets_Ws6rBBe.jpg': '11.jpg', 'shoes_nUU4kRd.png': '12.jpg', 'ATX-Jeans.jpg': '1.jpg'}; [shutil.copy(os.path.join(si, s), os.path.join(mr, 'photos', 'category', d)) for d, s in cm.items() if os.path.exists(os.path.join(si, s))]"

# Load initial database entries
python manage.py loaddata data.json

# Create superuser
python manage.py createsuperuser

# Start development server
python manage.py runserver
```
Visit `http://127.0.0.1:8000` in your web browser.

### ⚡ Quick Launch (Windows)
For convenience, a Windows Batch Script `run_nexusmart.bat` is included in the project root. Simply double-click the file to automate:
1. Virtual environment activation.
2. Database migrations check.
3. Media directories creation & image population.
4. Starting the development server.

---

## 🔒 Security & Optimization Best Practices
* **Secrets Decoupling**: Sensitive configuration keys, credentials, and settings are managed outside the codebase via `python-decouple`.
* **Caching Layer**: Redis/LocMem caching layer config in `settings.py` speeds up category lookups and search listings.
* **SQL Injection Mitigation**: All search operations utilize Django ORM queries which parameterize database operations natively.
