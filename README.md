# Jaffle Shop dbt Project on Snowflake

A dbt analytics engineering project built on the Jaffle Shop dataset and run on Snowflake. This repo is intended to show core dbt workflow skills: source-to-model transformation, warehouse organization, testing, documentation, and analytics-ready modeling.

## What this project demonstrates

This project is a hands-on dbt build using a Snowflake warehouse and the standard dbt project structure. It focuses on:

- organizing models into a maintainable dbt project
- transforming raw source data into analytics-ready tables
- applying tests and documentation
- practicing analytics engineering workflows in Snowflake

## Project structure

```text
.
├── analyses/
├── docs/
├── macros/
├── models/
├── seeds/
├── snapshots/
├── tests/
├── dbt_project.yml
├── packages.yml
└── quick-start.md
```

## Tech stack

* dbt
* Snowflake
* YAML
* SQL

## Workflow

1. Configure your Snowflake target in `~/.dbt/profiles.yml`
2. Install dependencies
3. Build models
4. Run tests
5. Generate docs

## Getting started

### 1. Install packages

```bash
dbt deps
```

### 2. Build the project

```bash
dbt build
```

### 3. Run models only

```bash
dbt run
```

### 4. Run tests only

```bash
dbt test
```

### 5. Generate and serve docs

```bash
dbt docs generate
dbt docs serve
```

## What I’m practicing here

This repo is part of my analytics engineering learning workflow. The main goals are:

* understanding dbt project structure
* working with Snowflake as the warehouse
* building confidence with transformations, tests, and documentation
* creating a foundation for more advanced dbt projects

## Next improvements

Planned upgrades to make this more portfolio-ready:

* add stronger model and column documentation
* add custom tests beyond basic `unique` and `not_null`
* add exposures for downstream BI use cases
* add screenshots of dbt docs lineage
* extend the project with a business-focused use case beyond the base tutorial dataset

## Why this repo exists

I used this project to strengthen my understanding of how dbt organizes analytics workflows in a real warehouse environment. It is a foundation project focused on learning core patterns that can later be applied to more business-specific datasets and production-style modeling.

## Notes

This repo is based on the Jaffle Shop learning pattern and adapted for practice with Snowflake.

## Contact

GitHub: [cat-cols](https://github.com/cat-cols)
