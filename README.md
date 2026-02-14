<<<<<<< HEAD
Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

---
---

The short answer is: **Yes, but with a major "catch."**

If you just copy-paste the Jaffle Shop code and put it on GitHub, a hiring manager will recognize it immediately. It’s the "Hello World" of data engineering. It proves you can follow directions, but it doesn't prove you can solve **new** problems.

To make it **Portfolio-Grade**, you need to evolve it. Here is how you turn a tutorial project into a "Hire Me" project.

---

### 1. Document the "Why," not just the "How"

Hiring managers love **README** files. Instead of just showing the code, explain the business logic:

* **The Problem:** "The raw Jaffle Shop data was messy, with inconsistently named IDs and no way to track customer lifetime value (LTV)."
* **The Solution:** "I built a dbt pipeline to normalize the staging layer and created a `dim_customers` mart that aggregates order history."

### 2. Add "Professional Grade" Features

Tutorials often skip the boring-but-vital parts of a real job. Add these to stand out:

* **Custom Data Tests:** Don't just use `unique` and `not_null`. Write a test that ensures `order_total` is never negative.
* **Documentation (YML):** Write clear descriptions for every column. When you click "View Docs" in dbt, it should look like a professional data dictionary.
* **Exposure Layer:** Create an `exposures.yml` file to show how this data would connect to a tool like Tableau or PowerBI.

---

### 3. Change the "Vibe" (The Pro Move)

The best way to use the Jaffle Shop logic is to **replace the data.**

* If you love sports, find a Kaggle dataset about NBA stats and apply the *exact same staging/marts structure* you learned in the course to that data.
* If a recruiter sees the "Jaffle Shop Architecture" applied to a "Subscription SaaS" or "E-commerce Electronics" dataset, they know you actually **understood** the concepts, not just the tutorial.

### 4. Show your "Warehouse Hygiene"

Since you already have Snowflake set up, take a screenshot of your **Lineage Graph**. It shows you understand how data flows from Raw ➔ Staging ➔ Marts.

---

### The Final Verdict for Your Portfolio

The fact that you are already troubleshooting **dbt Fusion** and checking `INFORMATION_SCHEMA` in **Snowflake** puts you ahead of most beginners. Most learners just hit "Run" and hope for the best; you are actually looking under the hood.

**My advice:** Finish the course to get the foundation, then immediately create a "Branch" or a new repo where you add one "advanced" feature (like a Incremental Model or a Macro) that wasn't in the tutorial.

**Would you like me to help you brainstorm a "Bonus Feature" you could add to your Jaffle Shop project to make it look more impressive to a recruiter?**

=======

# 🥪 The Jaffle Shop 🦘

_powered by the dbt Fusion engine_

Welcome! This is a sandbox project for exploring the basic functionality of Fusion. It's based on a fictional restaurant called the Jaffle Shop that serves [jaffles](https://en.wikipedia.org/wiki/Pie_iron).

To get started:
1. Set up your database connection in `~/.dbt/profiles.yml`. If you got here by running `dbt init`, you should already be good to go.
2. Run `dbt build`. That's it!

> [!NOTE]
> If you're brand-new to dbt, we recommend starting with the [dbt Learn](https://learn.getdbt.com/) platform. It's a free, interactive way to learn dbt, and it's a great way to get started if you're new to the tool.
>>>>>>> 82efb32 (upload and merge?)
