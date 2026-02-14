
```py
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dbt-snowflake (if not already installed)
pip install dbt-snowflake

# Initialize a new dbt project
dbt init

#! Configure dbt (create profiles.yml)
#! Copy profiles.example.yml to profiles.yml and update with your Snowflake credentials

# Install dbt dependencies
dbt deps

# Run dbt
dbt run

# Initialize dbt project
dbt init
```

jaffle_shop % dbt init
Installing dbt project and profile setup
Warning A dbt_project.yml already exists in this directory; skipping sample project creation.
Info dbt extension already recommended in .vscode/extensions.json, skipping
Info Setting up your profile...
   Loading ~/.dbt/profiles.yml
Profile 'jaffle_shop' already exists. You can choose how to proceed.
What would you like to do?: Edit existing profile (update fields interactively)
Info Editing existing profile...
Which adapter would you like to use?: snowflake
Editing existing profile - skipping cloud config fetch
Account: <ACCT ID> (e.g., ABC12345)
User: <USERNAME> (e.g., JOHN_DOE)
Database: RAW (e.g., RAW)
Warehouse: COMPUTE_WH (e.g., COMPUTE_WH, COMPUTE_LARGE, etc.)
Schema: dbt_<USERNAME> (e.g., dbt_JOHN_DOE)
Role (optional): ACCOUNTADMIN (e.g., ACCOUNTADMIN, SYSADMIN, etc.)
Which authentication method would you like to use?: Password
Password: [hidden]
```

# Next Part:

```bash
# Seed data
dbt seed

## if it fails, try:
dbt seed --full-refresh

## if it still fails, try:
dbt seed --full-refresh --threads 1

### If it fails with a "Schema does not exist" error:

Create the schema manually in Snowflake:

```sql
CREATE SCHEMA RAW.{dbt_<name>};
```

# Run dbt
dbt run

```