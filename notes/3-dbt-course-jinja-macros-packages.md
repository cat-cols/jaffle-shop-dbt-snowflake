># Section 2

**Learning Objectives:**
- Explain how Jinja works as a templating language.
- Anticipate the output of a block of Jinja code.
- Refactor a pivot query using Jinja.

---

># **What is Jinja?**

---

># **If Statements in Jinja**
```sql
{% set temperature = 80.0 %}

On a day like this, I especially like
{% if temperature >75 %}
    a refreshing sorbet
{% else %}
    a warm cup of coffee
{% endif %}


{% if temperature > 75 %}
    {% set weather = "hot" %}
{% else %}
    {% set weather = "cold" %}
{% endif %}
```

```sql
SELECT {{ temperature }} as temperature, '{{ weather }}' as weather
```

```bash
(venv) b@Brandons-iMac jaffle-shop-dbt-snowflake % dbtf compile -s scratch
dbt-fusion 2.0.0-preview.110
   Loading ~/.dbt/profiles.yml

================================== Errors and Warnings ===================================
error: dbt1001: Profile 'default' not found in profiles.yml

=================================== Execution Summary ====================================
Finished 'compile' with 1 error [1.4s]
```

That error means: **dbt-fusion is trying to use a connection profile named `default`, but your `~/.dbt/profiles.yml` doesn’t have a top-level profile called `default`.** So it has nowhere to get Snowflake creds/targets from.

### What to check (2 minutes)

#### 1) See what profile your dbt project expects

From your repo root:

```bash
cat dbt_project.yml | sed -n '1,60p'
```

Look for a line like:

```yml
profile: default
```

Whatever is after `profile:` **must match a top-level key** in `~/.dbt/profiles.yml`.

#### 2) See what profiles you actually have

```bash
ls -la ~/.dbt
cat ~/.dbt/profiles.yml
```

At the very top you’ll see something like:

```yml
jaffle_shop:
  outputs: ...
```

If you see `jaffle_shop:` (or something else) but **no `default:`**, that exactly explains the error.

---

## Fix options (pick one)

### Option A (cleanest): Change `dbt_project.yml` to the profile you already have

If your `profiles.yml` has `jaffle_shop:` then set:

```yml
# dbt_project.yml
profile: jaffle_shop
```

Then rerun:

```bash
dbtf compile -s scratch
```

### Option B: Add a `default:` profile to `~/.dbt/profiles.yml`

If you want to keep `profile: default` in the project, add a `default:` section that points to your Snowflake output(s). Example skeleton (fill in your real values):

```yml
default:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: YOUR_ACCOUNT
      user: YOUR_USER
      password: YOUR_PASSWORD
      role: YOUR_ROLE
      database: YOUR_DB
      warehouse: YOUR_WH
      schema: YOUR_SCHEMA
      threads: 4
      client_session_keep_alive: false
```

---

## One extra “gotcha” worth checking

You previously set `DBT_PROFILES_DIR` in other work. In this command output, dbt-fusion is loading **`~/.dbt/profiles.yml`**, so it’s *not* using a custom profiles dir right now—but it’s still worth verifying you don’t have an environment variable changing behavior in other shells:

```bash
echo $DBT_PROFILES_DIR
```

If that prints something unexpected, you can unset it:

```bash
unset DBT_PROFILES_DIR
```

---

💡💡 The fastest win is usually **Option A**: make `dbt_project.yml`’s `profile:` match the profile name you already have in `~/.dbt/profiles.yml`.

If you paste just the `profile:` line from `dbt_project.yml` and the top-level profile names from `~/.dbt/profiles.yml` (you can redact secrets), I’ll tell you exactly which one to change.








---

**For loops and Variables in Jinja**

---

**Combined Concepts**

---

**Pivot with Jinja**

---

**For Loops and Case When**

---

**Using `loop.last`**

---

**Practice**