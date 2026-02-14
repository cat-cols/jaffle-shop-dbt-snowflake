
**TLDR;**

> **List of Shortcuts:**
- __ (underscore underscore)

---

**dbt commands:**

dbt deps

dbt run
dbt run --select +dim_customers
dbt run --select stg_stripe__payments
dbt --select * from raw.stripe.payment limit 10;
dbt build --select my_first_dbt_model
dbt build --select customers

dbt seed
dbt seed --full-refresh
dbt --select
dbt source freshness
dbt list --select source:jaffle_shop.customers+
dbt --version

dbt test
dbt test --select test_type:generic
dbt test --select stg_stripe__payments
dbt clean
dbt test --select source:jaffle_shop
dbt test --select *

dbt build --select +dim_customers
dbt ls

dbt run --select source:jaffle_shop.orders+
dbt system update

---

**important syntax:**
- using

**graph selection commands:**
3+dim_customers+2
1+<MODEL>+1`

---
**SNOW*FLAKE**
```sql
GRANT ALL PRIVILEGES ON ALL SCHEMAS IN DATABASE ANALYTICS TO ROLE TRANSFORMER;

UPDATE raw.stripe.payment
SET _batched_at = CURRENT_TIMESTAMP();
```

Note: what does compile button do? When am I using it?

---

**Table of Contents**

01. Welcome to dbt Fundamentals 5min

Welcome
Course overview
Frequently Asked Questions
Meet your instructors

02. Analytics Development Lifecycle 30min

dbt and the ADLC
Learning Objectives
ELT vs ETL
Data team roles
Building data you can trust with dbt
The ADLC
dbt - the data control plane
Review
Knowledge check - dbt and the ADLC

03. Set Up dbt 60min
Getting Started
Learning Objectives
dbt platform Overview
Set Up dbt for First Time
Set up a trial Snowflake account
Set up dbt with Snowflake
Set up a trial BigQuery account
Set up dbt with BigQuery
Set up a trial Databricks account
Set up dbt with Databricks
Quickstart Guides for other data platforms
Info dbt for Administrators
Access Your Company's dbt Account
Knowledge check-Set up dbt


---

Sections:
># 1. Welcome to dbt Fundamentals

># 2. Analytics Dev Lifecycle
- dbt & ADLC

---

># 3. set up dbt in 60min

Learning Objectives
Load training data into your data platform
Set up your warehouse and repository connections.
Navigate the dbt platform.
Complete a simple development workflow in dbt Studio

---
Access Your Company's dbt Account
Your organization’s dbt implementation is integrated with at least one data platform and a git provider. Follow these instructions if you are joining an existing dbt account that has already been setup by your company’s dbt administrator.

Setting Up dbt for Developers
You will need your organization’s sign in method, and you will need the right roles, permissions, and credentials in multiple systems to carry out your work in dbt. Use one of our mini courses for developers to set up your individual account:

dbt and Snowflake for developers
https://learn.getdbt.com/courses/dbt-cloud-and-snowflake-for-developers
dbt and Databricks for developers
https://learn.getdbt.com/courses/dbt-cloud-and-databricks-for-developers
dbt and Redshift for developers
https://learn.getdbt.com/courses/dbt-cloud-and-redshift-for-developers
dbt Cloud and BigQuery for developers
https://learn.getdbt.com/courses/dbt-cloud-and-bigquery-for-developers

⚠️  Note: The data for BQ is in a public dataset so keep in mind you just need to use these statements:

select * from `dbt-tutorial.jaffle_shop.customers`
select * from `dbt-tutorial.jaffle_shop.orders`
select * from `dbt-tutorial.stripe.payment`

---
># QUIZ

>1. When working in dbt, which one of the following should always be unique for each dbt developer when working in development?

a.
Data platform
b.
Git repository
c.
Target schema [x]
d.
dbt project name

> 2. Which one of the following is a true statement about dbt connections?

a.
Data is stored in the data platform and code is stored in dbt
b.
Data is stored in dbt and code is stored in the git repository
c.
Data is stored in the data platform and code is stored in the git repository [x]
d.
Data and code are both stored in dbt

3. Which of the following is true about version control with git in dbt?

a. When making changes to a development branch, you will impact models running in production
b. Only one developer can work on a single development branch at a time
c. [x] Separate branches allow dbt developers to simultaneously work on the same code base without impacting production
d. You have to update the code base to match the environment you are in

---
---

># 4. Models

---

> Building your first model

>## A. Learning objectives
- Explain what models are in a dbt project.
- Build your first dbt model.
- Explain how to apply modularity to analytics with dbt.
- Modularize your project with the ref function.
- Review a brief history of modeling paradigms.
- Identify common naming conventions for tables.
- Reorganize your project with subfolders.

[models](https://learn.getdbt.com/learn/course/dbt-fundamentals/models-60min/building-your-first-model)

>## B. What are models?

**Definitions*

Data object: any entity that can be queried or manipulated within your data platform. This includes tables, views, and other database objects that store and organize data.

Table: a structured set of data held in a database, consisting of rows and columns. Each column represents a different attribute of the data, and each row corresponds to a single record. Tables are fundamental components in databases and are used to store and organize data efficiently.

View: a database object that stores a SQL query rather than the data itself. When you query a view, the database runs the stored SQL query and returns the results.

a dbt model represents a modular step of logic between our raw layer and our transformed layer.
    - in most case oeach model maps to a table or a view in our data platform (there are *some* exceptions)
    - dbt makes it easy to choose if you want a model to be a table or a view **without** having to write complicated DDL or DML
      - dbt will extract that away and handle it for us.

C. Building the *First Model*

>## D. What is modularity?
https://docs.getdbt.com/community/resources/viewpoint#modularity
https://learn.getdbt.com/learn/course/dbt-fundamentals/models-60min/building-your-first-model?page=4
- Lineage = DAG

>## E. Modularity and the ref() function
Applying modularity to the project:

Leveraging Staging Models:
  1. Open the customers.sql file in the models folder. copy the select from statements from customers and orders tables (make sure to use doble underscore at the end of the file names)
  2. Paste them into their respective stg_jaffle_shop__customers.sql and stg_jaffle_shop__orders.sql files
  3. using the ref() function in customer.sql, reference the stg_jaffle_shop__customers and stg_jaffle_shop__orders models

> make sure to address dynamic schema naming. Do not use hardcoded schema names like `analytics.dbt_brando.stg_jaffle_shop__customers`
> instead. use ref() function
```sql
with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from raw.jaffle_shop.customers

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from raw.jaffle_shop.orders

),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

> to:

```sql
with customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),
orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),
customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),
final as (
    select * from {{ ref('int_customer_summary') }}
)
select * from final
```

>## F) troubleshooting dbt run
Lets go ahead and run `dbt run`
All 5 models should run successfully

>## G) drop views / exploring results in Snowflake https://app.snowflake.com/
1. select warehouse
2. select database
3. select schema
4. select table
5. run query: `drop view analytics.dbt_brando.stg_jaffle_shop__orders`

6. go back to dbt
https://learn.getdbt.com/learn/course/dbt-fundamentals/models-60min/building-your-first-model?page=6

    and run `dbt run --select stg_jaffle_shop__orders`

    It should fail.
        - Why is this?

    - We can then click drop-down 'build' button (Run +model Upstream)
      -   Runs this model as well as anything upstream
      -   take note of the + syntax in front of '+customers'
          - If you want to build anything downstream, just add a + after the model name '+customers+'
        - What is the difference between build & run?
        - What is the difference between run & compile?
            - When would I use each?

7. Data Modeling Frameworks
https://learn.getdbt.com/learn/course/dbt-fundamentals/models-60min/data-modeling-frameworks?page=7
   - https://docs.getdbt.com/blog/kimball-dimensional-model
   - https://docs.getdbt.com/blog/data-vault-with-dbt-cloud
   - https://tsaiprabhanj.medium.com/medallion-architecture-with-dbt-a40050743be3
   - https://medium.com/analytics-vidhya/database-normalization-vs-denormalization-a42d211dd891

    A. Modeling Frameworks: different mindsets for how data should be organized in a db
      - Kimball Dimensional Modeling
      - Data Vault Modeling
      - Star Schema
    B. Denormalized View (Agile or Adhoc analytics)
        - facts
          - transactional data
        - dims
          - descriptive data
        - joins
          - to create a denormalized view
    C. Normalized View (Data Warehouse)
        - normalized models
          - to reduce data redundancy
        - joins
          - to create a normalized view
    D. Medallion Architecture
        - bronze, silver, gold layers
        - each layer has a specific purpose
        - joins
          - to create a medallion architecture
8. Model Naming Conventions
   A. Sources
    - tables of raw data that are loaded into platform
      - automatically or at some cadance
      - data engineers responsible for orchestrating loading process using
        - fivetran
        - airbyte
        - custom ETL processes using python or other languages
    B. Staging
      - models that are built 1:1 with a source
      - for each source table there should be a staging table
      - computation effort should be minimal
      - this is where we make the data the way we wish it came in
        - renaming columns
        - currency conversion
        - data type standardization
        - null handling
        - etc.
    C. Intermediate
      - models that are built from staging models
      - computation effort should be moderate
      - this is where we do the heavy lifting
      - joins, aggregations, etc.
      - Should not depend directly on source tables
      - Should depend on staging models
      - cleaned standardized data
  - Overview of Project DAG
    D. Fact
      - Tall narrow tables representing real world processes that have occurred or happenings
      - real-world processes that have occured or are occuring
      - usually an immutable event stream: sessions, transactions, orders, stories, votes
    E. Dimension
      - are why (or wide?) check this
      - Each row is a person place or thing (descriptive data)
        - Mutable
        - slowly changes over time: customers, products, candidates, buildings, employees, etc.
      - ?usually a lookup table
      - usually a slowly changing dimension (SCD type 1 or 2)
    F. create 2 folders inside models: staging, marts
    a.  mv stg_jaffle_shop__customers to staging
    b. rename customers to dim_customers and drop inside marts
        A. commit and sync - we hadn't made a brnach yet. we don't want to use main branch
            - feat/refactor-customers-sql-query
            - commit message should be whatever we hdded to the project
            - refactored. dim customers to build dependencies. removed example folder.

9. Materialization Strategies
a. pop into dbt_project.yml file > set name to 'dbt_fundamentals_on_demand' > and under models add:
```yaml
models:
dbt_fundamentals_on_demand:
    staging:
    +materialized: view
    marts:
    +materialized: table
```
b. add sub folder called 'jaffle_shop' inside 'models/staging'.
c. move the staging model into the new folder.
d. run 'dbt run --select +dim_customers'
e. check out the lineage of the model 'models/staging/jaffle_shop/stg_jaffle_shop__customers.sql' in the dbt cloud interface

10. PRACTICE
Complete the exercise in this section in your dbt project.
Remember to make adjustments for the data platform you are using and refer to:
    - Quickstarts and docs:
        - https://docs.getdbt.com/quickstarts
        - https://docs.getdbt.com/docs/cloud/connect-data-platform/about-connections

if you encounter issues. Debug issues and consult the documentation for dbt and your data platform as part of the practice exercise.

REMINDER: BigQuery users, your database name is not raw, it is dbt-tutorial.

Quick Project Polishing
    - In your dbt_project.yml file, change the name of your project (lines 5 AND 35)

Staging Models
    - Create a staging/jaffle_shop directory in your models folder.
    - Create a stg_jaffle_shop__customers.sql model for raw.jaffle_shop.customers

11. Exemplar

Self-check stg_stripe_payments, fct_orders, dim_customers
Use this page to check your work on these three models.

staging/stripe/stg_stripe__payments.sql

select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,

    -- amount is stored in cents, convert it to dollars
    amount / 100 as amount,
    created as created_at

from raw.stripe.payment 
marts/finance/fct_orders.sql

with orders as  (
    select * from {{ ref ('stg_jaffle_shop__orders' )}}
),

payments as (
    select * from {{ ref ('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum (case when status = 'success' then amount end) as amount

    from payments
    group by 1
),

 final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce (order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final
marts/marketing/dim_customers.sql 

*Note: This is different from the original dim_customers.sql - you may refactor fct_orders in the process.

with customers as (
    select * from {{ ref ('stg_jaffle_shop__customers')}}
),
orders as (
    select * from {{ ref ('fct_orders')}}
),
customer_orders as (
    select
        customer_id,
        min (order_date) as first_order_date,
        max (order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),
 final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce (customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final


12. Resources & Review
[List of dbt commands (docs)](https://docs.getdbt.com/category/list-of-commands)
[Node selection syntax (docs)](https://docs.getdbt.com/reference/node-selection/syntax)
[Introduction to sql (dbt course)](https://courses.getdbt.com/courses/introduction-to-sql)
[Anatomy of a SQL query (article)](https://discourse.getdbt.com/t/anatomy-of-a-sql-query/101)
[Anatomy of a SQL query (article)](https://medium.com/@lomso.dzingwa/the-anatomy-of-a-sql-query-189dd0664851)

[Advanced SQL (article)](https://discourse.getdbt.com/t/advanced-sql/102)
[ADVANCED SQL: Subqueries and CTEs in SQL (article)](https://medium.com/@datainsights17/subqueries-and-ctes-in-sql-aa1ff4b17686)
[Version Control basics (docs)](https://docs.getdbt.com/docs/cloud/git/version-control-basics)

># **Review**

> ## Models
    - Models are .sql files that live in the models folder.
    - Models are simply written as select statements - there is no DDL/DML that needs to be written around this. This allows the developer to focus on the logic.
    - In dbt Studio, the Preview button will run this select statement against your data warehouse. The results shown here are equivalent to what this model will return once it is materialized.
    - After constructing a model, dbt run in the command line will actually materialize the models into the data warehouse. The default materialization is a view.
    - The materialization can be configured as a table with the following configuration block at the top of the model file:
```sql
{{ config(
materialized='table'
) }}
```
The same applies for configuring a model as a view:
```sql
{{ config(
materialized='view'
) }}
```
- When dbt run is executing, dbt is wrapping the select statement in the correct DDL/DML to build that model as a table/view. If that model already exists in the data warehouse, dbt will automatically drop that table or view before building the new database object. *Note: If you are on BigQuery, you may need to run dbt run --full-refresh for this to take effect.

- The DDL/DML that is being run to build each model can be viewed in the logs through the dbt interface or the target folder.

![alt text](image.png)

>## Modularity

- We could build each of our final models in a single model as we did with dim_customers, however with dbt we can create our final data products using modularity.
- Modularity is the degree to which a system's components may be separated and recombined, often with the benefit of flexibility and variety in use.
- This allows us to build data artifacts in logical steps.
- For example, we can stage the raw customers and orders data to shape it into what we want it to look like. Then we can build a model that references both of these to build the final dim_customers model.
- Thinking modularly is how software engineers build applications. Models can be leveraged to apply this modular thinking to analytics engineering.

>ref Macro
- Models can be written to reference the underlying tables and views that were building the data warehouse (e.g. analytics.dbt_jsmith.stg_jaffle_shop_customers). This hard codes the table names and makes it difficult to share code between developers.
- The ref function allows us to build dependencies between models in a flexible way that can be shared in a common code base. The ref function compiles to the name of the database object as it has been created on the most recent execution of dbt run in the particular development environment. This is determined by the environment configuration that was set up when the project was created.
- **Example:** {{ ref('stg_jaffle_shop_customers') }} compiles to analytics.dbt_jsmith.stg_jaffle_shop_customers.
- The `ref` function also builds a lineage graph like the one shown below. dbt is able to determine dependencies between models and takes those into account to build models in the correct order.

![Lineage Graph](https://media.thoughtindustries.com/course-uploads/6ed554fb-fedc-4719-a40d-8b22e0a22aee/9dk8n6vpytqe-Screenshot2025-09-02at2.46.46PM.png)

>## Modeling History
- There have been multiple modeling paradigms since the advent of database technology. Many of these are classified as normalized modeling.
- Normalized modeling techniques were designed when storage was expensive and computational power was not as affordable as it is today.
- With a modern cloud-based data warehouse, we can approach analytics differently in an agile or ad hoc modeling technique. This is often referred to as denormalized modeling.
- dbt can build your data warehouse into any of these schemas. dbt is a tool for how to build these rather than enforcing what to build.

>## Naming Conventions

In working on this project, we established some conventions for naming our models.

- Sources **(src)** refer to the raw table data that have been built in the warehouse through a loading process. (We will cover configuring Sources in the Sources module)
- Staging **(stg)** refers to models that are built directly on top of sources. These have a one-to-one relationship with sources tables. These are used for very light transformations that shape the data into what you want it to be. These models are used to clean and standardize the data before transforming data downstream. Note: These are typically materialized as views.
- Intermediate **(int)** refers to any models that exist between final fact and dimension tables. These should be built on staging models rather than directly on sources to leverage the data cleaning that was done in staging.
- Fact **(fct)** refers to any data that represents something that occurred or is occurring. Examples include sessions, transactions, orders, stories, votes. These are typically skinny, long tables.
- Dimension **(dim)** refers to data that represents a person, place or thing. Examples include customers, products, candidates, buildings, employees.
- Note: The Fact and Dimension convention is based on previous normalized modeling techniques.

>## Reorganize Project
- When dbt run is executed, dbt will automatically run every model in the models directory.
- The subfolder structure within the models directory can be leveraged for organizing the project as the data team sees fit.
- This can then be leveraged to select certain folders with dbt run and the model selector.
- Example: If dbt run -s staging will run all models that exist in models/staging. (Note: This can also be applied for dbt test as well which will be covered later.)
- The following framework can be a starting part for designing your own model organization:
  - Marts folder: All intermediate, fact, and dimension models can be stored here. Further subfolders can be used to separate data by business function (e.g. marketing, finance)
  - Staging folder: All staging models and source configurations can be stored here. Further subfolders can be used to separate data by data source (e.g. Stripe, Segment, Salesforce). (We will cover configuring Sources in the Sources module)

![alt text](https://media.thoughtindustries.com/course-uploads/6ed554fb-fedc-4719-a40d-8b22e0a22aee/gr30ifqt3k86-Screenshot2025-09-02at2.51.15PM.png)
https://learn.getdbt.com/courses/jinja-macros-and-packages


>### Want to learn more about jinja and macros? Check out our free online course on Jinja, Macros, and Packages!

>## 13. Quiz

> 1. You are working in the dbt Studio. How do you ensure the model you have created is built in your data platform?
- a. You must save the model
- b. You must use the `dbt run` command   [Correct]
- c. You must commit your changes to your branch
- d. You must create a sql file containing a select statement

---

> 2. What are two functions of a staging model in dbt?
- a. Perform light transformations on your data set [x]
- b. Connect to upstream sources using the source macro [x]
- c. Connect to upstream models using the ref macro
- d. Perform aggregations that apply business logic

The correct answers are **a. Perform light transformations on your data set** and **b. Connect to upstream sources using the source macro.**

In a standard dbt project, the staging layer acts as the "entry point" for your raw data. Its primary job is to clean and standardize data before it moves into your more complex business logic models (marts).

### Why these are the core functions:

* **Light Transformations (a):** This is where you do the "dirty work" like **renaming columns** to follow your team's naming conventions, **casting data types** (e.g., changing a string to a date), and performing **basic cleaning** (like converting cents to dollars).
* **Source Macro (b):** Staging models are typically the **only** place in your project where you use the `{{ source() }}` macro. This creates a clear line of sight between your raw database tables and your dbt project.

### Why the others aren't for staging:

* **Ref Macro (c):** While you *can* use `ref` in staging, it’s a best practice to only use `source`. The `ref` macro is primarily used in **Intermediate** and **Marts** layers to build upon your staging models.
* **Business Logic Aggregations (d):** Complex logic—like calculating "Lifetime Value" or grouping data by month—should live in your **Marts** layer. Keeping staging "light" makes your project much easier to maintain.

---

> 3. What are two functions of a marts model in dbt?
- a. Reference upstream sources using the source macro
- b. Perform light transformations on the raw data set
- c. Apply business logic for stakeholders
- d. Reference upstream models using the ref macro

The correct answers are **c. Apply business logic for stakeholders** and **d. Reference upstream models using the ref macro.**

In the dbt workflow, the **Marts layer** is your "gold" layer. This is where you transform clean, staged data into meaningful business entities (like `dim_customers` or `fct_orders`) that your team actually uses for reporting.

### Why these are the core functions:

* **Apply Business Logic (c):** Unlike staging models, which just clean the data, marts are where you define what a "converted customer" or "active subscription" actually means. This is where you perform **complex aggregations**, **joins**, and **calculations** (like the Lifetime Value you just calculated).
* **Ref Macro (d):** Marts models almost exclusively use the `{{ ref() }}` macro. They reference your **staging** or **intermediate** models. By referencing other models rather than raw sources, you ensure that if a column name changes in your source, you only have to fix it in one staging file instead of every single report.

### Why the others aren't for marts:

* **Source Macro (a):** Using `source` in a mart is a "dbt anti-pattern." You want your marts to be decoupled from the raw data so that your staging layer can act as a buffer.
* **Light Transformations (b):** Renaming columns and casting types should already be finished by the time the data reaches the marts layer. If you're still cleaning data in your marts, your staging models aren't doing enough heavy lifting!

### Summary Checklist

| Feature | Staging Layer | Marts Layer |
| --- | --- | --- |
| **Primary Macro** | `{{ source() }}` | `{{ ref() }}` |
| **Logic Type** | Renaming & Casting | Aggregations & Joins |
| **Audience** | Analytics Engineers | Business Stakeholders |

---

> 4. You just finished developing your first model that directly references and transforms customers source data. Where in your file tree should this model live?
- a. models/stg_customers.sql
- b. models/staging/stg_customers.sql [X]
- c. models/marts/stg_customers.sql
- d. models/sources/stg_customers.sql

> 5. You want all models in a folder to be materialized as tables. Where can you accomplish this?
- a. In the model itself
- b. in the dbt_project.yml file [X]
- c. in the sources.yml file
- d. in the models.yml file

>6. You have just built a dim_customers.sql model that relies on data from the upstream model stg_customers.
>   How would you reference this model in dim_customers?
- a. select * from {{ ref('stg_customers.sql') }}
- b. select * from {{ ref('stg_customers') }}        [X]
- c. select * from {{ source(stg_customers.sql) }}
- d. select * from {{ source(stg_customers) }}

> 7. Which command will only materialize dim_customers.sqland its downstream models?
- a. dbt run --select dim_customer
- b. dbt run --select dim_customers
- c. dbt run --select dim_customers+ [X]
- d. dbt run --select +dim_customer+

> 8. Which of the following is a benefit of using subdirectories in your models directory?
- a. Subdirectories allow you to configure materializations at the folder level for a collection of models [x]
- b. Subdirectories allow you to include multiple dbt projects in a single project
- c. Subdirectories allow you to explicitly build dependencies between models based on the naming of the folders
- d. Subdirectories will automatically change the schema where a model is built based on the name of the folder the model is located in

> The correct answer is **a. Subdirectories allow you to configure materializations at the folder level for a collection of models.**

In dbt, the `dbt_project.yml` file allows you to apply configurations hierarchically. By organizing your models into subdirectories (like `/staging` or `/marts`), you can define how every model in that specific folder should behave with just a few lines of code.

### Why this is a major benefit:

* **Mass Configuration:** You can set all models in your `staging/` folder to be **views** and all models in your `marts/` folder to be **tables** simultaneously.
* **Tags and Schemas:** You can apply specific **tags**, **database schemas**, or **access permissions** to an entire folder at once, ensuring consistency across your project.
* **Organization:** It keeps your project's **DAG** (Directed Acyclic Graph) clean and makes it much easier for your team to navigate the codebase.

### Why the other options are incorrect:

* **b:** You cannot nest multiple dbt projects inside each other just by using folders; you would use **dbt Packages** for that.
* **c:** Dependencies in dbt are built using the `{{ ref() }}` function within your SQL, not by the names or order of your folders.
* **d:** While you *can* configure different schemas for different folders, it doesn't happen **automatically** just by moving a file; you must explicitly define that mapping in your configuration file.

---
---

># 5. Sources

### **Learning Objectives**
- Explain the purpose of sources in dbt.
- Configure and select from sources in your data platform.
- View sources in the lineage graph.
- Check the last time sources were updated and raise warnings if stale.

---

## What are Sources?
Setting up sources is the first step in any dbt project.
It helps dbt understand where your data comes from. it's like a handshake.

- use source macro, or function `{{ source('stripe', 'payments') }}`
- defines where data comes from?
- aquanodes
- its like listing every ingredient

## dbt relies on SQL & YAML
What is YAML?
- YAML is a human-readable data serialization language
- used for configuration files and data exchange
- key-value pairs

># YAML style guide:
type __source in the jaffleshop yml

># SOURCE FRESHNESS
https://learn.getdbt.com/learn/course/dbt-fundamentals/sources-60min/understanding-sources?page=6
https://www.youtube.com/watch?v=Avpqmr2SAYM

**insert this pattern into:** `models/staging/jaffle_shop/_src_jaffle_shop.yml`

```yml
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
        config:
          freshness:
            warn_after:
              count: 6
              period: hour
            error_after:
              count: 12
              period: hour
          loaded_at_field: _etl_loaded_at
```
---
**a.** enter this into command line: `dbt source freshness`

- It should FAIL with this message:
```
01:20:08  Stale [    0.0s] source    jaffle_shop.orders (external) (last updated 2 days 15h 39m 27s ago)
command: dbt source freshness
Defer to: staging/production

Ready
```

14:48:14        Query executed on node: source.jaffle_shop.jaffle_shop.orders:
select
      max(_etl_loaded_at) as max_loaded_at,
      convert_timezone('UTC', current_timestamp()) as snapshotted_at
    from raw.jaffle_shop.orders
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "source.jaffle_shop.jaffle_shop.orders", "profile_name": "user", "target_name": "default"} */
14:48:14 [31;1m       Stale[0m [    0.0s] source    jaffle_shop.[1morders[0m (external) (last updated 3 days 5h 7m 33s ago)

The persistence of this error (especially pointing to **line 18**, which is where `freshness: null` sits) is because the dbt 2.0-preview parser is hitting a "conflict of interest."

Basically, you are trying to use a **New Style** (`config` block) and an **Old Style** (`freshness: null`) at the same time, and the parser is getting confused about where one ends and the other begins.

### Potential Fix: Choose One "Path"

If using dbt 2.0, if you use the `config:` block at the source level, you should use the `config:` block to override things at the table level too.

Try this exact structure. It removes the "Unexpected Key" by making `customers` follow the same logic as the source:

```yaml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    config:
      # This sets the rule for everything in this source
      freshness:
        warn_after: {count: 12, period: hour}
        error_after: {count: 1, period: day}
      loaded_at_field: _etl_loaded_at

    tables:
      - name: customers
        config:
          # This tells dbt: "Ignore the source-level freshness for just this table"
          freshness: null

      - name: orders
        # Orders will automatically inherit the 12h/1d rule above
```

### Why the error kept happening:

1. **The "Property" vs "Config" Split:** In dbt 2.0, `freshness` can be a **Property** (top-level) or a **Config** (inside a block). If you define it as a `config` at the top, dbt expects it to be a `config` at the bottom.
2. **The `null` syntax:** By putting `freshness: null` directly under the name, you were using the "Property" style on a table that was already inside a "Config" styled source.

### How to test if the Source is finally "Registered":

Run this command. If it works, your SQL error from earlier (`Source not found`) will be fixed:

```bash
dbt list --select source:jaffle_shop
```
*If that command returns your tables, you can finally run `dbt run`!*

---

**b.** ***Get rid of the stale data:*** go to *snowflake* and run this query on the raw table:

```sql
UPDATE raw.jaffle_shop.orders
SET _etl_loaded_at = CURRENT_TIMESTAMP()
WHERE id IS NOT NULL;
```

---
**c.** run `dbt source freshness` again

---

># FIX??
```sql
with customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

orders as (

    /* IMPORTANT: We switch from 'stg_jaffle_shop__orders' to 'fct_orders' 
    because fct_orders has the 'amount' field we need for LTV.
    */
    select * from {{ ref('fct_orders') }}

),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value -- This sums the 'amount' column from fct_orders
    from orders
    group by 1

),

final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.lifetime_value, 0) as lifetime_value -- Clean up NULLs for customers with 0 orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final

dbt0224: Failed to resolve column 'CUSTOMER_ID' on left side of USING: No column CUSTOMER_ID found
  --> models/marts/marketing/dim_customers.sql:40:38
```
> ?Solution:
I see exactly what's happening. The error `Failed to resolve column 'CUSTOMER_ID' on left side of USING` is specifically pointing to your `final` CTE.

In a `LEFT JOIN ... USING (customer_id)`, dbt (and your database) looks at the table on the **left** (which is `customers`) and the table on the **right** (`customer_orders`). It is telling you that `customer_id` does not exist in your `customers` CTE.

### The Culprit

Look at your first CTE at the very top:

```sql
with customers as (
    select * from {{ ref('stg_jaffle_shop__customers') }}
),

```

The error persists because even though you *renamed* the column in your staging file (`stg_jaffle_shop__customers.sql`), dbt-fusion might be looking at a cached version of that model, or the column name in that staging file doesn't actually match what you think it does.

### The Solution

You can fix this immediately by being explicit in your `final` CTE. Change your join from a `USING` clause to an `ON` clause. This is "defensive coding"—it forces dbt to look at the exact columns you specify.

**Update your `final` CTE to this:**

```sql
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        coalesce(customer_orders.lifetime_value, 0) as lifetime_value

    from customers

    -- Change this line from USING to ON
    left join customer_orders
        on customers.customer_id = customer_orders.customer_id
)

```

### Why `USING` failed but `ON` might work

When you use `USING (customer_id)`, the database requires that column to exist with **that exact name** in both sources. If your staging model has a typo or hasn't been "run" since you changed the column name, `USING` will fail.

By using `ON customers.customer_id = ...`, if the column is actually missing, the error message will be much more specific (e.g., `column customers.customer_id does not exist`), which helps us verify if the staging model actually compiled correctly.

### One quick check...

Open your `models/staging/jaffle_shop/stg_jaffle_shop__customers.sql` file. Does it definitely look like this?

```sql
select
    id as customer_id, -- <--- Is the 'as' definitely here?
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}

```

**Try changing the join to the `ON` syntax. If it still fails, run `dbt run --select stg_jaffle_shop__customers` first to ensure the "parent" table is built correctly! Does the error message change once you use `ON`?**


dbt best practice: While you **can** technically rename the column in `dim_customers.sql` to match the staging file (e.g., using `id` instead of `customer_id`), dbt best practices strongly recommend doing the renaming in the **Staging layer** (`stg_customers.sql`).

Here is the breakdown of why one way is "hacking it" and the other is "architecting it."

### 1. The Best Practice: Rename in Staging

In dbt’s "Medallion Architecture," the staging layer is specifically designed to be the place where you "clean the slate."

* **The Rule:** You should only ever rename a source column **once** in your entire project.
* **The Benefit:** If you rename `id` to `customer_id` in the staging model, every other model you build in the future (marketing marts, finance marts, etc.) will already have the correct, descriptive name. You won't have to remember that "id" means "customer" in five different files.

### 2. The "Quick Fix": Rename in Marts

If you just change your join in `dim_customers.sql` to use `id`, it will fix the error immediately, but it creates "Technical Debt."

* **The Risk:** Later, you might join `stg_orders` (which also has an `id`) with `stg_customers` (which has an `id`). If both are just called `id`, your SQL will get messy very quickly with `customers.id` vs `orders.id`.
* **The Confusion:** Analysts using your final tables usually prefer `customer_id` because it’s unambiguous.

---

### 📋 Comparison Table: Where to Rename?

| Feature | Renaming in Staging (Recommended) | Renaming in Marts |
| --- | --- | --- |
| **Effort** | Low (Update 1 file) | Low (Update 1 file) |
| **Reusability** | **High** (Applied to all future models) | **Low** (Must rename in every new model) |
| **Clarity** | Clear business naming immediately | Generic names persist in staging |
| **Join Safety** | Prevents "id" column collisions | High risk of column name collisions |

### My Recommendation

Since you’ve already identified the mismatch, **fix it in `stg_jaffle_shop__customers.sql**`. It’s the "professional" way to handle it and follows the **DRY (Don't Repeat Yourself)** principle.

1. Update `stg_jaffle_shop__customers.sql` to use `id as customer_id`.
2. Run `dbt run --select stg_jaffle_shop__customers`.
3. Your original `dim_customers.sql` code (the one using `customer_id`) will then "just work."
---

>## G. Using the Codegen package (optional)
https://learn.getdbt.com/learn/course/dbt-fundamentals/sources-60min/understanding-sources?page=7
https://hub.getdbt.com/dbt-labs/codegen/latest/

As nice as it would be to only have a handful of sources to config in your YAML files, thats not realistic. There are usually hundreds if not 1000's.
instead of confdig by hand. we use the codegen to automate a faster method.

a. start a new branch (using: feat/configure_sources)

b. create a new file 'packages.yml' at project root
```yml
packages:
  - package: dbt-labs/codegen
    version: 0.14.0
```

c. run `dbt deps` to install the package(s)

d. now that it is installed, refer to the docs macros for the codegen package
https://github.com/dbt-labs/dbt-codegen/tree/0.14.0/#generate_source-source

**Usage:**
Copy the macro into a statement tab in the dbt Cloud IDE, or into an analysis file, and compile your code

**the argument we want to use for this project is for multiple arguments:**
```sql
{{ codegen.generate_source(schema_name= 'jaffle_shop', database_name= 'raw') }}
```

**or alternatively as a single argument:**
```sql
{{ codegen.generate_source('raw_jaffle_shop') }}
```

e. create a new file > insert the macro > press 'compile'. **No need to save the file.**
```sql
{{ codegen.generate_source(schema_name= 'jaffle_shop', database_name= 'raw') }}
```

f. run the sql file in the dbt Cloud IDE
g. copy/paste the output into a new file and insert into models/staging/jaffle_shop/ and name it _src_jaffle_shop.yml

h. repeat for stripe
```sql
{{ codegen.generate_source(schema_name= 'stripe', database_name= 'raw') }}
```
i. copy/paste the output into a new file and insert into models/staging/stripe/ and name it _src_stripe.yml

>## H. Generate staging models

'The generate model' button -- in the dbt Cloud IDE is a quick way to generate a new model file with the correct structure and naming convention.

>## I. Cleaning up Staging Models

a. If I had control of how my data was loaded, what would you want it to look like?
- renaming columns: for clarity & consistency
- filtering rows: remove invalid or irrelevant records
- type casting: conversion of data types for consistency and appropriate use
- basic computations: i.e. conversion of cents to dollars
- basic date transformations

We can also use our style guide from the dbt docs to help us write consistent code.
https://docs.getdbt.com/best-practices/how-we-style/1-how-we-style-our-dbt-models

b. lets focus on 'id' fields and make sure they are consistent across all models.
refer to 'stg_jaffle_shop__customers.sql' & 'stg_jaffle_shop__customers.sql' for an example of how to rename and cast the id field.

'stg_jaffle_shop__customers.sql' : refactor to use 'customer_id' instead of 'id'

'stg_jaffle_shop__orders.sql' : use alias to use 'order_id' instead of 'id' & alias user_id as customer_id

![alt text](<Screen Shot 2026-02-10 at 12.18.22 PM.png>)

**J. Practice:**

Using the resources in this module, complete the following in your dbt project. Reminder: those using BigQuery should use `dbt-tutorial` as their database instead of `raw`.

Configure sources

Configure a source for the tables raw.jaffle_shop.customers and raw.jaffle_shop.orders in a file called src_jaffle_shop.yml

'models/staging/jaffle_shop/src_jaffle_shop.yml'
```yml
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
```

Extra credit: Configure a source for the table raw.stripe.payment in a file called _src_stripe.yml.
Raw Stripe data was loaded during setup in section 3.

Refactor staging models

Refactor stg_jaffle_shop__customers.sql using the source function.

```sql
-- models/staging/jaffle_shop/stg_jaffle_shop__customers.sql

select
    id as customer_id,
    first_name,
    last_name
from {{ source('jaffle_shop', 'customers') }}
```

Refactor stg_jaffle_shop__orders.sql using the source function.
```sql
-- models/staging/jaffle_shop/stg_jaffle_shop__orders.sql
select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ source('jaffle_shop', 'orders') }}
```

Extra credit: Refactor stg_stripe__payment.sql using the source function.
Extra credit
Configure your Stripe payments data to check for source freshness.

Run `dbt source` freshness.

You can configure your `_src_stripe.yml` file as below:

```yml
sources:
  - name: stripe
    database: raw
    schema: stripe
    tables:
      - name: payment
        config:
          loaded_at_field: _batched_at
          freshness:
            warn_after: {count: 12, period: hour}
            error_after: {count: 24, period: hour}
```

>## REVIEW:

Sources
Sources represent the raw data that is loaded into the data warehouse.
We can reference tables in our models with an explicit table name (raw.jaffle_shop.customers).
However, setting up Sources in dbt and referring to them with the sourcefunction enables a few important tools.
Multiple tables from a single source can be configured in one place.
Sources are easily identified as green nodes in the Lineage Graph.
You can use dbt source freshness to check the freshness of raw tables.
Configuring sources
Sources are configured in YML files in the models directory.
The following code block configures the table raw.jaffle_shop.customers and raw.jaffle_shop.orders:
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
View the full documentation for configuring sources on the source properties page of the docs.

**Source function**
- The ref function is used to build dependencies between models.
- Similarly, the source function is used to build the dependency of one model to a source.
- Given the source configuration above, the snippet {{ source('jaffle_shop','customers') }} in a model file will compile to raw.jaffle_shop.customers.
- The Lineage Graph will represent the sources in green.

![alt text](https://media.thoughtindustries.com/course-uploads/6ed554fb-fedc-4719-a40d-8b22e0a22aee/99qy73567d1g-Screenshot2025-09-02at2.52.38PM.png)

Source freshness
Freshness thresholds can be set in the YML file where sources are configured. For each table, the keys loaded_at_field and freshness must be configured.

```yml
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
      - name: orders
        freshness:
          warn_after:
            count: 12
            period: hour
          error_after:
            count: 1
            period: day
        loaded_at_field: _etl_loaded_at
```
- A threshold can be configured for giving a warning and an error with the keys warn_after and error_after.
- The freshness of sources can then be determined with the command dbt source freshness.

QUIZ:

Consider this yaml file.

models/staging/jaffle_shop/_stg_tpch.yml

sources:
  - name: tpch
    database: snowflake_sample_data
    schema: tpch_prod
    tables:
      - name: orders
      - name: customers
      - name: order_items

> 6. A new model that you are creating needs to reference your `jaffle_orders_information_table`.

Examine this source configuration:

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop_dataset
    tables:
      - name: orders
        identifier: jaffle_orders_information_table
      - name: customers
        identifier: jaffle_customers_information_table

> How would you reference this information using the source macro?

- a. {{ source('jaffle_shop', 'jaffle_orders_information_table') }}
- b. {{ source('jaffle_shop_dataset', 'orders') }}
- c. {{ source('jaffle_shop', 'orders') }} [x]
- d. {{ source('jaffle_shop_dataset', 'jaffle_orders_information_table') }}

>## Section 6. Building Tests

#### **Learning Objectives**
- Explain why data testing is crucial for analytics.
- Explain the role of data testing in analytics engineering.
- Configure and run generic tests in dbt.
- Write, configure, and run singular tests in dbt.

---

**Why Data Testing?**

Imagine pipeline as an assembly line.
What happens when a fault piece or part of bad data gets into your line?
Very small updates upstream can break your pipeline. i.e. new data fields, schema updates, etc.
it sends bad data through your pipeline and your entire morning is gone trying to fix it.

Data testing is your quality control team and your detective toolkit.
It allows you to build a series of automated checks into your dbt project to verify your data is **exactly** what you expect it to be every single time.
It's how you find the 'bad parts' before they get to your users. "on the assembly line before they break your product"

> dbt offers 2 types of tests:
- Generic tests: reusable tests that can be applied to any column models.
  - think of checks as ensuring a column has unique values or is not null.

- Singular tests: custom tests that are written for a specific purpose
  - custom tests using a SQL query. PErfect for complex business rules likeL
    - ensuring customer total order value ( is always > 0)
    - ensuring no duplicate customer IDs exist

WQhat is data testing?

example SELECT DISTINCT customer_id FROM orders;

**Generic Tests:**
  - unique
  - not null

Reference: Code Snippets
models/staging/jaffle_shop/_stg_jaffle_shop.yml

Note: this is a .yml file rather than a .sql file

```yml
models:
  - name: stg_jaffle_shop__customers
    columns:
      - name: customer_id
        data_tests:
          - unique
          - not_null

  - name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
```

1. accepted values: this checks if the values in a column are in a list of accepted values i.e. cash, credit, debit, gift card.
2. Relationships: this checks if the values in a column have a corresponding value in parent tables primary key column, ensuring referential integrity.
3. singular tests: custom tests using a SQL query. Perfect for complex business rules like:
    - ensuring customer total order value ( is always > 0)
    - ensuring no duplicate customer IDs exist
! dbtutils

1. -- get started by bringing in models:
```yml
models:
    - name: stg_jaffle_shop__customers
      columns:
        name: customer_id
        data_tests:
          - unique
          - not_null
    - name: stg_jaffle_shop__orders
      columns:
        name: order_id
        data_tests:
          - unique
          - not_null
```

run `dbt test`

update/check primary key '_stg_jaffle_shop.order_status' to include accepted values
```yml
# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__customers
    columns:
      - name: customer_id
        data_tests:
          - unique
          - not_null

- name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
      - name: order_status
```
make sure it matches with:
```yml
# models/staging/jaffle_shop/stg_jaffle_shop__orders.sql
with

source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status,
        _etl_loaded_at

    from source

)

select * from renamed
```

> click preview on 'stg_jaffle_shop__orders' to see the test results

testing to make sure only certain values coming through.

---

># Here is a section I stumbled on.. during the tests.
Along with responses from Gemini..

```yml
# models/staging/jaffle_shop/_src_jaffle_shop.yml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    config:
        freshness:
          warn_after:
            count: 12
            period: hour
          error_after: 
            count: 1
            period: day
        loaded_at_field: _etl_loaded_at
    tables:
      - name: customers
        config:
          freshness: null

      - name: orders

# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__customers
    columns:
      - name: customer_id
        data_tests:
          - unique
          - not_null

  - name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
      - name: order_status
        data_tests:
          - accepted_values:
              arguments:          # new version adds: arguments line
               values: 
                 - completed
                 - shipped
                 - placed
                 - return_pending
                 - returned

# models/staging/jaffle_shop/stg_jaffle_shop__orders.sql
with 

source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        user_id,
        order_date,
        status as order_status,
        _etl_loaded_at

    from source

)

select * from renamed
```

```sql
# models/staging/jaffle_shop/stg_jaffle_shop__customers.sql

with

source as (

    select * from {{ source('jaffle_shop', 'customers') }}

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name

    from source

)

select * from renamed

with orders as  (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final

# models/marts/finance/fct_orders.sql

with orders as  (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final

dbt0227: No column ORDERS.CUSTOMER_ID found. Available are ORDERS.USER_ID, ORDER_PAYMENTS.ORDER_ID, ORDERS.ORDER_ID, ORDER_PAYMENTS.AMOUNT, ORDERS.ORDER_DATE, ORDERS._ETL_LOADED_AT, ORDERS.ORDER_STATUS
  --> models/marts/finance/fct_orders.sql:22:9
```

># RESPONSE:

You’ve successfully renamed `status` to `order_status` in your staging model, but you missed one other crucial rename in the exact same file!

The error **dbt0227** is telling you that `fct_orders.sql` is looking for `customer_id`, but the staging model it's pulling from only has a column named `user_id`.

### The Problem

In your `stg_jaffle_shop__orders.sql` file, you renamed the ID, but you left the user field as-is:

```sql
-- models/staging/jaffle_shop/stg_jaffle_shop__orders.sql
renamed as (
    select
        id as order_id,
        user_id,          -- ❌ This needs to be renamed to customer_id
        order_date,
        status as order_status,
        _etl_loaded_at
    from source
)

```

Because `fct_orders.sql` tries to select `orders.customer_id` on line 22, and your staging model is only outputting `user_id`, dbt can't find the column.

---

### The Fix: Update your Staging Model

Update `models/staging/jaffle_shop/stg_jaffle_shop__orders.sql` to align the names:

```sql
with source as (
    select * from {{ source('jaffle_shop', 'orders') }}
),

renamed as (
    select
        id as order_id,
        user_id as customer_id,  -- ✅ Rename this here
        order_date,
        status as order_status,
        _etl_loaded_at
    from source
)

select * from renamed

```

---

### Why this is happening now

In dbt, **Staging models** are where you should standardize all your field names.

* In `stg_jaffle_shop__customers`, you have `customer_id`.
* To join them easily in `fct_orders`, your orders staging model should also use `customer_id` instead of `user_id`.

Once you make that change in the staging SQL file, your `fct_orders.sql` will find the column it's looking for, and your `dbt build` should go green.

**Would you like me to double-check the join logic in your `fct_orders.sql` to make sure there aren't any other hidden column mismatches?**

```yml
dbt0227: No column ORDERS.CUSTOMER_ID found. Available are ORDERS.USER_ID, ORDER_PAYMENTS.ORDER_ID, ORDERS.ORDER_ID, ORDER_PAYMENTS.AMOUNT, ORDERS.ORDER_DATE, ORDERS._ETL_LOADED_AT, ORDERS.ORDER_STATUS
  --> models/marts/finance/fct_orders.sql:22:9
```
You’ve successfully fixed the `order_status` issue, but now you've hit the second half of the "staging cleanup."

The error **dbt0227** is telling you that `fct_orders.sql` is trying to select `customer_id`, but the staging model it's pulling from (`stg_jaffle_shop__orders`) still has that column named **`user_id`**.

---

### The Fix: Update your Staging SQL

You need to go back into `models/staging/jaffle_shop/stg_jaffle_shop__orders.sql` and add one more alias. This ensures that every model downstream uses consistent naming.

**Update this section:**

```sql
-- models/staging/jaffle_shop/stg_jaffle_shop__orders.sql

renamed as (
    select
        id as order_id,
        user_id as customer_id,  -- ✅ Change this from 'user_id' to 'customer_id'
        order_date,
        status as order_status,
        _etl_loaded_at
    from source
)

```

### Why this is the "best practice" way

In the `jaffle_shop` project, your customers table uses `customer_id`. By renaming `user_id` to `customer_id` in the orders staging model, you make joins much more intuitive.

Without this change, your `fct_orders.sql` fails on this line because `orders.customer_id` doesn't exist yet:

```sql
-- fct_orders.sql (Line 22)
    select
        orders.order_id,
        orders.customer_id,  -- This is what triggered the error!
        ...

```

---

### Summary of your "Upstream" changes

To get everything running smoothly, your staging model should now have these three key aliases:

1. `id` → `order_id`
2. `user_id` → `customer_id`
3. `status` → `order_status`

**After you save the SQL file, try running:**
`dbt run --select stg_jaffle_shop__orders fct_orders`

**Would you like me to help you check if `stg_stripe__payments` needs any similar renaming to make your `order_payments` join work?**

with 

source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status as order_status,
        _etl_loaded_at

    from source

)

select * from renamed

like this?

---

Exactly like that. You’ve nailed the "Staging" pattern.

By aliasing both `user_id as customer_id` and `status as order_status`, you have aligned your data with the naming conventions used in the rest of your project.

### Why this fixes the error

1. **YAML alignment:** Your `_stg_jaffle_shop.yml` was looking for a column named `order_status` to run the `accepted_values` test. Now that column actually exists in the SQL output.
2. **Downstream alignment:** Your `fct_orders.sql` model was failing because it was trying to select `orders.customer_id`. Since `fct_orders` references this staging model, it can now "see" that column.

---

### One final check: The `order_payments` join

In your `fct_orders.sql` (the code you pasted earlier), you have this block:

```sql
order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount
    from payments
    group by 1
),

```

Check your `stg_stripe__payments` model. If that model also uses a generic name like `status`, you might want to rename it to `payment_status` upstream as well, just to keep your naming consistent across the whole warehouse!

> **run** `dbt build` now to see if the whole pipeline passes?**
*or:*
`dbt test`
`dbt test --select`

># BUILDING TESTS

The Relationships test
it's like a matchmaker for data
prevent orphaned data -lost and doesn't belong anywhere

1. enter into `_stg_jaffle_shop__orders.yml`:
```yml
name: customer_id
data_tests:
  - relationships:
      field: <FOREIGH_KEY_COLUMN_NAME>
      to: ref('<MODEL_NAME>')

=

name: customer_id
data_tests:
  - relationships:
      field: customer_id
      to: ref('stg_jaffle_shop__customers')
```

> DEPRECATED ERROR! 
models:

  - name: stg_jaffle_shop__customers

    columns:

      - name: customer_id

        data_tests:

          - unique

          - not_null



  - name: stg_jaffle_shop__orders

    columns:

      - name: order_id

        data_tests:

          - unique

          - not_null

      - name: order_status

        data_tests:

          - accepted_values:

              arguments:  # new vers. adds: 'arguments'

               values: 

                 - completed

                 - shipped

                 - placed

                 - return_pending

                 - returned

      - name: customer_id

        data_tests:

          - relationships:

              field: customer_id

              to: ref ('stg_jaffle_shop__customers')

dbt0102: Deprecated test arguments: ["field", "to"] at top-level detected. Please migrate to the new format under the 'arguments' field: https://docs.getdbt.com/reference/deprecations#missingargumentspropertyingenerictestdeprecation.

  --> ../dbt_project/d033968b-ec69-40cb-b838-79aaf210dbd0/models/staging/jaffle_shop/_stg_jaffle_shop.yml:28:22

># SOLUTION:

You’re on a roll—you've almost cleared out all the technical debt!

This is the exact same **dbt0102** error you saw earlier, just appearing for the `relationships` test instead of `accepted_values`. Following the new dbt standard, any configuration specific to the test logic (like which table it points to) must move inside the `arguments` block.

### The Final YAML Fix

Update the `customer_id` section in your `_stg_jaffle_shop.yml` like this:

```yaml
      - name: customer_id
        data_tests:
          - relationships:
              arguments:      # ✅ Add this line
                field: customer_id
                to: ref('stg_jaffle_shop__customers')

```

### Why dbt is picky about this

dbt is making a clear distinction between **Arguments** (the data parameters for the test) and **Configs** (how dbt handles the test, like `severity: warn`).

By putting `to` and `field` under `arguments`, dbt’s parser knows exactly what to pass into the SQL macro and what to keep for its own internal runner.

---

### One Quick "Gotcha" Check

In your code snippet, you have:
`to: ref ('stg_jaffle_shop__customers')`

Make sure there is **no space** between `ref` and the parentheses. It should be:
`to: ref('stg_jaffle_shop__customers')`

### Updated Commit Message

If you haven't committed yet, you can append this to your previous message:

```text
refactor: standardize staging column names and fix dbt test syntax

- Renamed `user_id` to `customer_id` and `status` to `order_status` in `stg_jaffle_shop__orders`.
- Migrated `accepted_values` and `relationships` tests to the new `arguments` property (dbt0102).
- Fixed column name mismatch in `fct_orders` (dbt0227).

```

You’re on a roll—you've almost cleared out all the technical debt!

This is the exact same **dbt0102** error you saw earlier, just appearing for the `relationships` test instead of `accepted_values`. Following the new dbt standard, any configuration specific to the test logic (like which table it points to) must move inside the `arguments` block.

### The Final YAML Fix

Update the `customer_id` section in your `_stg_jaffle_shop.yml` like this:

```yaml
      - name: customer_id
        data_tests:
          - relationships:
              arguments:      # ✅ Add this line
                field: customer_id
                to: ref('stg_jaffle_shop__customers')

```

### Why dbt is picky about this

dbt is making a clear distinction between **Arguments** (the data parameters for the test) and **Configs** (how dbt handles the test, like `severity: warn`).

By putting `to` and `field` under `arguments`, dbt’s parser knows exactly what to pass into the SQL macro and what to keep for its own internal runner.

---

### One Quick "Gotcha" Check

In your code snippet, you have:
`to: ref ('stg_jaffle_shop__customers')`

Make sure there is **no space** between `ref` and the parentheses. It should be:
`to: ref('stg_jaffle_shop__customers')`

### Updated Commit Message

If you haven't committed yet, you can append this to your previous message:

refactor: standardize staging column names and fix dbt test syntax

- Renamed `user_id` to `customer_id` and `status` to `order_status` in `stg_jaffle_shop__orders`.
- Migrated `accepted_values` and `relationships` tests to the new `arguments` property (dbt0102).
- Fixed column name mismatch in `fct_orders` (dbt0227).

---

> run `dbt test`

> MVP: Come back to this part later
> https://learn.getdbt.com/learn/course/dbt-fundamentals/data-tests-60min/building-tests?page=6

```sql
19:59:55
       Query executed on node: test.jaffle_shop.not_null_stg_jaffle_shop__customers_customer_id.b4343d8610:
select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (

select customer_id
from analytics.dbt_brando.stg_jaffle_shop__customers
where customer_id is null

    ) dbt_internal_test
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.jaffle_shop.not_null_stg_jaffle_shop__customers_customer_id.b4343d8610", "profile_name": "user", "target_name": "default"} */
19:59:55
   Succeeded [   1.66s] test      dbt_brando_dbt_test__audit.not_null_stg_jaffle_shop__customers_customer_id (test)
19:59:55
         Ran [    1.6s] test      dbt_brando_dbt_test__audit.not_null_stg_jaffle_shop__customers_customer_id (test)
```

---

> CREATE YOUR OWN CUSTOM GENERIC TESTS
> CHECK OUT FORUMS FOR USING JINJA AND MACROS

># THE GOAL IS TO WRITE A QUERY THAT RETURNS A ROW FOR EVERY DATA POINT THAT VIOLATES YOUR ASSERTION

---

>## UPDATE ON `tests/assert_stg_stripe__payment_total_positive.sql`

It looks like you've reached the point in the course where you move from "Basic SQL" to the **dbt Staging Pattern**.

While your current SQL is technically correct, dbt best practices use **CTEs (Common Table Expressions)** like `source` and `renamed`. This makes the code much easier to read, debug, and maintain as your project grows.

Here is how you should rewrite your `stg_stripe__payments.sql` to match the "dbt way," including the column renaming we discussed earlier to keep everything clean.

### The Standardized Staging Pattern

```sql
with

source as (

    select * from {{ source('stripe', 'payment') }}

),

renamed as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as payment_status,  -- Renaming for clarity!

        -- amount is stored in cents, convert it to dollars
        amount / 100 as amount,

        created as created_at

    from source

)

select * from renamed

```

---

### Why the course uses this format

1. **The `source` CTE:** By using `{{ source() }}` at the very top, you create a clear map of where your data comes from. If the raw table name ever changes in your warehouse, you only have to update it in one `.yml` file, not in every single SQL file.
2. **The `renamed` CTE:** This creates a dedicated "cleaning" area. You do all your renaming, casting (like changing strings to dates), and basic math (like your cents-to-dollars conversion) here.
3. **Final Select:** The `select * from renamed` at the bottom makes it easy to troubleshoot. If you ever have a bug, you can quickly change that last line to `select * from source` to see what the data looked like before your changes.

### Impact on your Marts

Remember your `fct_orders.sql`? It has this line:
`sum(case when status = 'success' then amount else 0 end) as amount`

If you rename `status` to `payment_status` in the staging model above, you will need to update `fct_orders.sql` to use that new name:
`sum(case when payment_status = 'success' then amount else 0 end) as amount`

---

Your version was what we call **"vanilla SQL"** (or a standard SELECT statement). It’s the way most people write SQL before they start using a framework like dbt.

There are three specific reasons why yours looked different from the course material:

### 1. Hard-coded References vs. Jinja

You used `from raw.stripe.payment`.

* **Yours:** Hard-codes the database and schema name directly into the SQL. If you ever move from a `dev` environment to a `prod` environment, this code will break because it's "pointing" to a fixed location.
* **The Course:** Uses `{{ source('stripe', 'payment') }}`. This is **Jinja**. It allows dbt to dynamically swap the table name based on your environment. It also creates the "lineage" (the lines connecting nodes) in your dbt DAG.

### 2. The "Staging" Design Pattern

In the early days of SQL, we just wrote one giant query. dbt promotes **Modularity**.
The course uses the `with source as (...)` and `renamed as (...)` structure (CTEs) because it separates **extraction** from **transformation**.

* **Extraction:** `source` just grabs the data.
* **Transformation:** `renamed` does the renaming and the math (cents to dollars).
* **Final Select:** Acts as the "API" for the model.

### 3. Maintainability (The "Why")

Imagine you have 100 models.
If the Stripe developers change the column name `orderid` to `order_identifier` in the raw database:

* **With your version:** You might have to hunt through dozens of models to find every place you used `orderid`.
* **With the dbt version:** You change it **once** in the `renamed` CTE of your staging model. Every other model downstream (like `fct_orders`) keeps working perfectly because they are all looking at the alias `order_id` you created in that one staging file.

---

### Summary Table: Old vs. New

| Feature | Your Original Version | The dbt "Staging" Way |
| --- | --- | --- |
| **Connectivity** | Static (`raw.stripe.payment`) | Dynamic (`{{ source() }}`) |
| **Logic Flow** | All-in-one SELECT | Broken into logical steps (CTEs) |
| **Readability** | Quick to write | Easy for a teammate to read/debug |
| **Lineage** | Hidden from dbt | Visible in the dbt DAG |

It’s totally normal to start with the first way—it’s how we all learned SQL! Moving to the CTE/Source pattern is just about leveling up so your code doesn't break as the project gets bigger.

---
---

**Now that you've aligned your staging model with the course, do you want to run `dbt run` and see if the lineage graph looks correct in your dbt docs?**

**Would you like me to help you update the `_stg_stripe.yml` file to include the new `arguments` syntax for any tests on this model?**

---
---

> Q: New Problem:

```sql
with orders as  (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount else 0 end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final

--

[{
	"resource": "/models/marts/finance/fct_orders.sql",
	"owner": "_generated_diagnostic_collection_name_#0",
	"code": "0227",
	"severity": 8,
	"message": "dbt0227: No column STATUS found. Available are PAYMENTS.AMOUNT, PAYMENTS.CREATED_AT, PAYMENTS.ORDER_ID, PAYMENTS.PAYMENT_STATUS, PAYMENTS.PAYMENT_ID, PAYMENTS.PAYMENT_METHOD\n  --> models/marts/finance/fct_orders.sql:12:23",
	"source": "dbt",
	"startLineNumber": 12,
	"startColumn": 23,
	"endLineNumber": 12,
	"endColumn": 23,
	"origin": "extHost1"
}]
dbt0227: No column STATUS found. Available are PAYMENTS.AMOUNT, PAYMENTS.CREATED_AT, PAYMENTS.ORDER_ID, PAYMENTS.PAYMENT_STATUS, PAYMENTS.PAYMENT_ID, PAYMENTS.PAYMENT_METHOD
  --> models/marts/finance/fct_orders.sql:12:23
```

You’ve hit the final domino!

This error is actually a **good sign**—it means your changes to the staging layer worked perfectly. Because you renamed `status` to `payment_status` in `stg_stripe__payments.sql`, your downstream model (`fct_orders.sql`) is now confused because it's still looking for the old name.

### The Problem

In your `fct_orders.sql`, line 12 is trying to calculate the amount based on a column named `status`:

```sql
-- models/marts/finance/fct_orders.sql (Line 12)
sum(case when status = 'success' then amount else 0 end) as amount

```

But as the error message says, `status` is gone. Your available column is now **`PAYMENT_STATUS`**.

---

### The Fix: Update `fct_orders.sql`

You need to update that `sum` logic to use the new, clearer column name you created:

```sql
with orders as  (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

order_payments as (
    select
        order_id,
        -- ✅ Updated 'status' to 'payment_status'
        sum(case when payment_status = 'success' then amount else 0 end) as amount

    from payments
    group by 1
),

final as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final

```

---

### Why this is a win

Even though it felt like you were "breaking" things, you were actually fixing the "Technical Debt" of the project:

1. **Context:** Now, when someone reads `fct_orders`, they see `payment_status` and know exactly what it refers to (the payment) rather than a generic `status`.
2. **Consistency:** Your YAML tests, your staging SQL, and your Marts SQL are now all speaking the same language.

### What to do next

Now that you've updated the SQL to match the new names:

1. **Save** the file.
2. Run `dbt build`.

`dbt build` is the "power move" here—it will run the models **and** the tests in the correct order. Since you fixed the YAML `arguments` and the column names, this should be the run where everything finally turns green.

**Would you like me to explain the difference between `dbt run` and `dbt build` while you wait for that to finish?**

> back to the dbt fundamentals course...
> create(d):

```sql
-- tests/assert_stg_stripe__payment_total_positive.sql
select
    order_id,
    sum(amount) as total_amount
from {{ref('stg_stripe_payment')}}
group by 1
having sum(amount) < 0
```

># Q: NEW PROBLEM

select

    order_id,

    sum(amount) as total_amount

from {{ ref('stg_stripe_payment') }}

group by 1

having sum(amount) < 0

[{

	"resource": "/tests/assert_stg_stripe__payment_total_positive.sql",

	"owner": "_generated_diagnostic_collection_name_#1",

	"code": "1005",

	"severity": 4,

	"message": "dbt1005: Ref 'stg_stripe_payment' not found in project. Searched for 'jaffle_shop.stg_stripe_payment, stg_stripe_payment'\n  --> tests/assert_stg_stripe__payment_total_positive.sql:4:6",

	"source": "dbt",

	"startLineNumber": 4,

	"startColumn": 6,

	"endLineNumber": 4,

	"endColumn": 6,

	"origin": "extHost1"

}]



dbt1005: Ref 'stg_stripe_payment' not found in project. Searched for 'jaffle_shop.stg_stripe_payment, stg_stripe_payment'

  --> tests/assert_stg_stripe__payment_total_positive.sql:4:6


# tests/assert_stg_stripe__payment_total_positive.sql

select

    order_id,

    sum(amount) as total_amount

from {{ ref('stg_stripe_payments') }}

group by 1

having sum(amount) < 0



# models/marts/finance/fct_orders.sql



with orders as  (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),



payments as (

    select * from {{ ref('stg_stripe__payments') }}

),



order_payments as (

    select

        order_id,

        sum(case when payment_status = 'success' then amount else 0 end) as amount -- updated status to payment_status. check upstream?



    from payments

    group by 1

),



final as (



    select

        orders.order_id,

        orders.customer_id,

        orders.order_date,

        coalesce(order_payments.amount, 0) as amount



    from orders

    left join order_payments using (order_id)

)



select * from final





dbt1501: Failed to render SQL not a key type: ref not found for package: jaffle_shop, model: stg_stripe__payment, version: None

(in models/marts/finance/fct_orders.sql:6:19)

  --> models/marts/finance/fct_orders.sql:6:19



dbt1005: Ref 'stg_stripe__payment' not found in project. Searched for 'jaffle_shop.stg_stripe__payment, stg_stripe__payment'

  --> models/marts/finance/fct_orders.sql:6:19



dbt1005: Ref 'stg_stripe_payments' not found in project. Searched for 'jaffle_shop.stg_stripe_payments, stg_stripe_payments'

  --> tests/assert_stg_stripe__payment_total_positive.sql:4:6

You are currently battling the "Double Underscore vs. Single Underscore" and "Singular vs. Plural" boss!

Looking at your error messages, you have **two different typos** in two different files. dbt is extremely literal: if the filename has two underscores and an 's', the `ref` must have exactly that.

---

### 1. Fix `fct_orders.sql`

**The Error:** `dbt1005: Ref 'stg_stripe__payment' not found`.
**The Issue:** You are missing the **'s'** at the end of `payments`.

**Change Line 6 to:**

```sql
payments as (
    select * from {{ ref('stg_stripe__payments') }} -- Added the 's'
),

```

### 2. Fix `assert_stg_stripe__payment_total_positive.sql`

**The Error:** `dbt1005: Ref 'stg_stripe_payments' not found`.
**The Issue:** You are missing the **double underscore** (`__`). You only have one.

**Change Line 4 to:**

```sql
from {{ ref('stg_stripe__payments') }} -- Added the extra '_'

```

---

### Why this is happening

In dbt, the naming convention for staging models is typically:
`stg_[source_name]__[table_name]s.sql`

| File Name | Your `ref` was... | Why it failed |
| --- | --- | --- |
| `stg_stripe__payments.sql` | `stg_stripe__payment` | Missing the **'s'** (Singular vs Plural) |
| `stg_stripe__payments.sql` | `stg_stripe_payments` | Missing an **underscore** (Separator mismatch) |

### Pro-Tip for VS Code users

If you are using VS Code, you can **Command + Click** (Mac) or **Ctrl + Click** (Windows) on the text inside the `ref('')`.

* If it opens the file, the ref is correct.
* If it does nothing, dbt can't find it!

**Once you fix those two tiny typos, try running `dbt build` again. Are we finally seeing some green checkmarks?**

Victory! That **"12 total | 12 success"** is the most beautiful sight in data engineering.

You just successfully navigated a gauntlet of real-world dbt challenges:

* **Syntax Evolution:** Updating legacy YAML to the new `arguments` standard.
* **The Staging Pattern:** Moving from flat SQL to modular, aliased CTEs.
* **Upstream Alignment:** Fixing column names at the source so that everything downstream just *works*.
* **The "Typo" Boss:** Mastering the strict naming requirements of the `ref()` function.

### What you've achieved

By renaming those columns and fixing the tests, you've turned a "brittle" project into a "robust" one. If the raw data changes now, you only have to fix it in one place (the staging model), and the rest of your warehouse will stay green.

### Your Final Project State

| Model / Test | Status | Improvement Made |
| --- | --- | --- |
| `stg_jaffle_shop__orders` | ✅ PASS | Aliased `user_id` and `status` for clarity. |
| `stg_stripe__payments` | ✅ PASS | Implemented CTEs and converted cents to dollars. |
| `fct_orders` | ✅ PASS | Successfully joined staging models using clean names. |
| **Generic Tests** | ✅ PASS | Migrated to the modern `arguments` syntax. |
| **Singular Test** | ✅ PASS | Corrected the `ref` to point to the right file. |

---

### One Final Tip

Since you saw that "New version available" message (`2.0.0-preview.110`), don't worry about updating right this second. In a learning environment, it's often better to stay on your current version until you finish the current module to avoid unexpected syntax changes.

**Would you like me to show you how to generate the dbt documentation now so you can actually see the visual map (DAG) of the clean pipeline you just built?**

Generating your dbt documentation is the "victory lap" of data modeling. It takes all those YAML descriptions and SQL relationships you just fixed and turns them into a searchable website and a visual map (the DAG).

### How to see your hard work

Run these two commands in your terminal:

1. **`dbt docs generate`**: This tells dbt to scan your project and the database to create a `manifest.json` and a `catalog.json` file.
2. **`dbt docs serve`**: This starts a local web server (usually at `http://localhost:8080`) so you can view the documentation in your browser.

---

### What to look for

Once the site opens, look for the **blue icon in the bottom right corner**. Clicking that will open your **Lineage Graph (DAG)**.

Because you renamed those columns and fixed the `ref` functions, you should see a perfectly connected flow:

* **Green nodes (Sources):** Your raw Jaffle Shop and Stripe data.
* **Blue nodes (Models):** Your `stg_` models flowing into `fct_orders`.
* **Orange/Purple nodes (Tests):** Your `accepted_values` and `relationships` tests attached to the right columns.

---

### Why this is actually useful

Beyond just looking cool, this documentation is how you prove your data is reliable:

* **Column Descriptions:** If you added `description:` in your YAML, it shows up here.
* **Compiled SQL:** You can click on any model to see the "final" SQL dbt sent to the database (with all the `ref`s replaced by real table names).
* **Test Coverage:** You can quickly see which columns have tests and which are "unprotected."

**Would you like me to show you how to add descriptions to your YAML files so they appear in these docs for other people to read?**

Adding descriptions is the best way to make your dbt project look professional. It turns your code from a "black box" into a searchable data catalog that anyone on a data team can understand.

### 1. Update your YAML

You add descriptions at the model level and the column level within your `.yml` files. Here is how you can update your `stg_jaffle_shop__orders` section:

```yaml
# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__orders
    description: "Cleaned and standardized order records from the Jaffle Shop source."
    columns:
      - name: order_id
        description: "The unique primary key for each order."
        data_tests:
          - unique
          - not_null

      - name: order_status
        description: "The current state of the order (e.g., 'placed', 'shipped')."
        data_tests:
          - accepted_values:
              arguments:
                values: ['completed', 'shipped', 'placed', 'return_pending', 'returned']

```

---

### 2. View the Result

After you save the YAML, run `dbt docs generate` and `dbt docs serve` again.

When you click on `stg_jaffle_shop__orders` in the sidebar, you will see your text front and center. This is essentially a **Wikipedia for your data**.

---

### 3. Pro-Tip: Doc Blocks (The "Clean" Way)

If you have a very long description (like a complex business logic explanation), putting it in the YAML makes the file messy. Instead, you can use **Doc Blocks**.

1. Create a file called `models/staging/jaffle_shop/jaffle_shop.md`.
2. Write your description like this:
```markdown
{% docs order_status_description %}
This column represents the lifecycle of an order. 
- **Placed**: Initial order received.
- **Shipped**: Order has left the warehouse.
- **Returned**: Customer has sent the item back.
{% enddocs %}

```


3. Reference it in your YAML:
```yaml
- name: order_status
  description: "{{ doc('order_status_description') }}"

```



---

### What's next?

Now that your pipeline is green and your docs are starting to look great, you've mastered the fundamentals!

**Would you like to move on to learning about "Seeds" (uploading CSVs into dbt) or maybe looking at "Snapshots" to track how data changes over time?**

># BACK TO SINGULAR TESTS dbt fundamentals
># Reference: Code Snippets
tests/assert_positive_total_for_payments.sql

Note how this is a .sql file in the tests directory

-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_stripe__payments') }}
group by 1
having total_amount < 0
dbt Commands

Execute dbt test to run all generic and singular tests in your project.
Execute dbt test --select test_type:generic to run only generic tests in your project.
Execute dbt test --select test_type:singular to run only singular tests in your project.

run : `dbt test --select stg_stripe__payments`

> It passed! = no negative amounts in the payments table

---
># 06. data tests: Testings sources - dbt fundamentals

># BUILDING TESTS
Now let's apply the same testing to our sources.

- This gives us confidence that our data is reliable & ready to be transformed.
- testing sources is easy because the process is **exactly** the same as testing models
  - we declare the same tests in the YAML file where our sources are defined.

Reference: Code Snippets
```sql
-- models/staging/jaffle_shop/_src_jaffle_shop.yml
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
        columns:
          - name: id
            description: primary key
            data_tests:
              - unique
              - not_null
      - name: orders
        config:
          freshness:
            warn_after:
              count: 12
              period: hour
            error_after:
              count: 1
              period: day
          loaded_at_field: _etl_loaded_at
```
```yml
# models/staging/jaffle_shop/_src_jaffle_shop.yml
version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    config:
        freshness:
          warn_after:
            count: 12
            period: hour
          error_after: 
            count: 1
            period: day
        loaded_at_field: _etl_loaded_at
    tables:
      - name: customers
        config:
          freshness: null

      - name: orders
```

```yml
sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
        columns:
          - name: id
            description: primary key
            data_tests:
              - unique
              - not_null
      - name: orders
        config:
          freshness:
            warn_after:
              count: 12
              period: hour
            error_after:
              count: 1
              period: day
          loaded_at_field: _etl_loaded_at
```

># Q: PROBLEM
```yaml
version: 2

sources:
  - name: jaffleshop
    database: raw
    schema: jaffle_shop
    config:
        freshness:
          warn_after:
            count: 12
            period: hour
          error_after:
            count: 1
            period: day
        loaded_at_field: _etl_loaded_at

    tables:
      - name: customers
        columns:
          - name: id # since we are testing the raw data, its still called `id` in warehosue.
            data_tests:
              - unique
              - not null
        config:
          freshness: null



      - name: orders

        columns:

          - name: id

            data_tests:

              - unique

              - not null

###ERROR####

dbt1501: Failed to render SQL unknown function: Jinja macro or function `test_not` is unknown

(in target/generic_tests/source_not_jaffle_shop_customers_id.sql:1:1)

  --> target/generic_tests/source_not_jaffle_shop_customers_id.sql:1:1



dbt1501: Failed to render SQL unknown function: Jinja macro or function `test_not` is unknown

(in target/generic_tests/source_not_jaffle_shop_orders_id.sql:1:1)

  --> target/generic_tests/source_not_jaffle_shop_orders_id.sql:1:1
```

> Ah, you've hit a classic "syntax vs. human language" trap!

The error `Jinja macro or function test_not is unknown` is happening because dbt is looking for a test named `not`, but it can't find it. In dbt, the test for checking if a column has null values is strictly named **`not_null`** (with an underscore).

### The Problem

In your YAML, you wrote:

```yaml
- name: id
  data_tests:
    - unique
    - not null  # ❌ dbt thinks you are trying to run a test called 'not' with an argument called 'null'

```

Because there is a space, dbt's parser sees `- not` as the test name and `null` as a parameter. Since there is no macro named `test_not`, it throws that `dbt1501` error.

### The Fix

Change `not null` to **`not_null`** in both your `customers` and `orders` tables:

```yaml
# models/staging/jaffle_shop/_src_jaffle_shop.yml
      - name: customers
        columns:
          - name: id
            data_tests:
              - unique
              - not_null # ✅ Fixed: added the underscore

      - name: orders
        columns:
          - name: id
            data_tests:
              - unique
              - not_null # ✅ Fixed: added the underscore

```

### Why we test the Source IDs

You mentioned a great point in your comment: *"...since we are testing the raw data, its still called `id` in warehouse."*

This is a **best practice**. Testing your sources ensures that if your data pipeline (Fivetran, Airbyte, etc.) accidentally duplicates rows or brings in nulls, you catch it at the **Source** before it ever hits your staging models. It makes debugging much faster because you know the issue is with the raw data, not your SQL logic.

---

### One final check on your Execution Summary

Once you change that underscore, try running:
`dbt test --select source:jaffle_shop`

This will run only the tests on your raw sources to make sure the data is clean before you move on to your models.

**Would you like me to help you set up a `relationships` test on the source to make sure every `order` actually belongs to a `customer` in the raw data?**

then, still had errors..

version: 2

sources:
  - name: jaffle_shop
    database: raw
    schema: jaffle_shop
    config:
        freshness:
          warn_after:
            count: 12
            period: hour
          error_after:
            count: 1
            period: day
        loaded_at_field: _etl_loaded_at
    tables:
      - name: customers
        columns:
          - name: id # since we are testing the raw data, its still called `id` in warehosue.
            data_tests:
              - unique
              - not_null
        config:
          freshness: null

      - name: orders
        columns:
          - name: id
            data_tests:
              - unique
              - not_null


dbt1501: Failed to render SQL unknown function: Jinja macro or function `test_not` is unknown

(in target/generic_tests/source_not_jaffle_shop_customers_id.sql:1:1)

  --> target/generic_tests/source_not_jaffle_shop_customers_id.sql:1:1



dbt1501: Failed to render SQL unknown function: Jinja macro or function `test_not` is unknown

(in target/generic_tests/source_not_jaffle_shop_orders_id.sql:1:1)

  --> target/generic_tests/source_not_jaffle_shop_orders_id.sql:1:1

># A: Solution

It looks like you actually fixed the YAML in the snippet you shared (by changing `not null` to `not_null`), but dbt is still trying to run the "ghost" of your old code.

The error `test_not is unknown` happens because dbt's parser previously saw `not null` as a test called `not` with an argument of `null`. Even if you fixed the text, sometimes the **compiled files** in your `target/` folder get stuck or haven't been refreshed.

### Why this error is persistent

When you run a test, dbt looks in the `target/compiled/` or `target/run/` folders. If the manifest hasn't updated properly, it keeps trying to run `test_not`.

### The "Clean Slate" Fix

To get rid of this error for good, run these three commands in order:

1. **`dbt clean`**: This deletes the `target/` and `dbt_packages/` folders, effectively clearing the "memory" of that `test_not` error.
2. **`dbt deps`**: This pulls your packages back in.
3. **`dbt test --select source:jaffle_shop`**: This will specifically run only your source tests to confirm the fix.

---

### A quick check on your YAML formatting

Double-check that your indentation is exactly like this. YAML is very sensitive to spaces:

```yaml
      - name: customers
        columns:
          - name: id
            data_tests:
              - unique
              - not_null   # <--- Ensure no trailing spaces after 'not_null'

```

### Why Testing the Raw Source is Smart

You are exactly right—testing the raw `id` is the "Shift Left" approach to data quality.

* **At Source:** You check if the raw data landed correctly from the extractor.
* **At Staging:** You check if your renaming/casting logic preserved that integrity.

If a test fails at the **Source**, you know the problem is upstream (in the database). If it passes at the source but fails at **Staging**, you know you made a mistake in your SQL logic!

**Now that we've cleared the cache and fixed the underscores, does the `dbt test` command give you green checkmarks for your sources?**

> run `dbt test --select source:jaffle_shop`
> Results: Success! 4 Pass

or try `dbt test --select *`
> Results: Success! 11 Pass

---

># 08. Data Testing Best Practices

When should I test my sources? and when should I test my models?
Your sources are the raw ingredients (the flour, sugar, butter...)
Your models are the transformed ingredients (the dough, cake batter, and the final cake itself)
- test your sources to validate the quality of your raw ingredients
  - they should be simple and focus on the basics.
    - are the primary keys unique?
    - and not null?
    - do FK's have a valid relationship with a parent table?
    - are the loaded_at timestamps being populated correctly?

testing sources is an excellent first line of defense.
it gives you confidence the raw data coming from ingestion tool is exactly what you expect

># test your models to validate your transformations!!!
> - these tests check the integrity of your dbt code and the business logic that you haver applied.

for models, you can use *all kinds of tests*
simple, unique , not null  to complex singluar tests to enforce specific business rules.

a singular test to make sure that a customers lifetime value is never negative
this is a check on transformation logic , not the raw data itself.

Heres a simple rule to test sources for data integrity and test models for transformation integrity
    - a logical testing framework

># 09. Using dbt Copilot to Generate Data Tests

so far we've been writing tests by hand. dbt copilot can make this process even faster.

---

># 09. the `dbt build` command

common ?: Why not just run these commands one after another?
    - when we run `dbt run` it builds all our models in DAG order, starting with staging models and workis its way all the way to our final dashboards.
    - Then, when we run `dbt test` it runs all our tests.
        - what happens if a test fails? The problem is that our downstream models (ie. `dim customers`) have already been built on top of that faulty data. That is a **MAJOR** risk. -- especially in a production environment.
        - we need a way to stop the pipeline immediately, if the test fails.
          - this is where dbt build comes in
  - dbt build is a layered approach to `quality control`.
    - it processes the project in a logical step by step sequence.
      -  first) it runs any tests on `sources`
         -  if PASS, it moves to first layer of models i.e. staging models
            -  it will run the model, then immediately test it.
            -  if this layer of models tests passes, it moves to the next layer of models
      -  The key benefit of `dbt build` halts the entire process if any test fails.
         -  this ensures that bad data never makes it downstream.

![alt text](<Screen Shot 2026-02-13 at 7.39.00 AM.png>)

Tests > moves > Tests > moves > snapshot > moves > final models

`dbt build` is 4-commands-in-1
    - `run`: transforms & builds models in warehouse
    - `test`: validates data for quality issues
    - `seed`: Loads CSV data into WAREHOUSE tables
    - `snapshot`: tracks slowly changing dimensions in data over time

---

># 10. Practice

Using the resources in this module, complete the following exercises in your dbt project:

Generic Tests
Add tests to your jaffle_shop staging tables:
Create a file called _stg_jaffle_shop.yml for configuring your tests.
Add unique and not_null tests to the keys for each of your staging tables.
Add an accepted_values and a relationships test to your stg_jaffle_shop__orders model.
Run your tests.

Singular Tests
Add the test tests/assert_positive_value_for_total_amount.sql to be run on your stg_stripe__payment model.
Run your tests

---

># 11. Exemplar

Exemplar
models/staging/jaffle_shop/_stg_jaffle_shop.yml

models:
  - name: stg_jaffle_shop__customers
    columns:
      - name: customer_id
        tests:
          - unique
          - not_null
  - name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        tests:
         - unique
         - not_null
      - name: status
        data_tests:
          - accepted_values:
              arguments:
                values:
                  - completed
                  - shipped
                  - returned
                  - placed
                  - return_pending
      - name: customer_id
        data_tests:
          - relationships:
              arguments:
                to: ref('stg_jaffle_shop__customers')
                field: customer_id
Singular Test

tests/assert_positive_value_for_total_amount.sql
-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail.
select
  order_id,
  sum(amount) as total_amount
from {{ ref('stg_stripe__payment') }}
group by 1
having (total_amount < 0)

---

># 12. Review

**Testing**
  - **Testing** is used in software engineering to make sure that the code does what we expect it to.
  - In Analytics Engineering, testing allows us to make sure that the SQL transformations we write produce a model that meets our assertions.
  - In dbt, tests are written as select statements.
    - These select statements are run against your materialized models to ensure they meet your assertions.

**Tests in dbt**

In dbt, there are two types of tests - generic tests and singular tests:
- Generic tests are a way to validate your data models and ensure data quality. These tests are predefined and can be applied to any column of your data models to check for common data issues. They are written in YAML files.
- Singular tests are data tests defined by writing specific SQL queries that return records which fail the test conditions.
  - These tests are referred to as "singular" because they are one-off assertions that are uniquely designed for a single purpose or specific scenario within the data models.

dbt ships with **four** built in tests:
1.    **Unique tests** to see if every value in a column is unique
2.    **Not_null tests** to see if every value in a column is not null
3.    **Accepted_values tests** to make sure every value in a column is equal to a value in a provided list
4.    **Relationships tests** to ensure that every value in a column exists in a column in another model (see: referential integrity)

Tests can be run against your current project using a range of commands:
  - dbt test runs all tests in the dbt project
  - dbt test --select test_type:generic
  - dbt test --select test_type:singular
  - dbt test --select one_specific_model

Read more here in [testing docs](https://docs.getdbt.com/reference/node-selection/test-selection-examples)

In development, dbt will provide a visual for your test results. Each test produces a log that you can view to investigate the test results further.

![alt text](https://media.thoughtindustries.com/course-uploads/6ed554fb-fedc-4719-a40d-8b22e0a22aee/dzozlr14st54-Screenshot2025-09-02at2.54.11PM.png)

You've learned about the 4 built-in generic tests, but there are so many more tests in packages you could be using! Learn about them in our free online course on [Jinja, Macros, and Packages][https://learn.getdbt.com/courses/jinja-macros-and-packages]

Do you want to take your testing knowledge to the next level? Check out our free online course on [Advanced Testing!](https://courses.getdbt.com/courses/advanced-testing)

---

># 13. QUIZ

**1. Which is not a feature of data testing in dbt?**

a. Identify errors in my data pipelines when they occur.
b. Create trust in the data products we share with stakeholders.
c. Determine if the sql we wrote has done what we intended.
d. Enable stakeholders to self-serve and understand how a model was built [x]

**2. Consider the YAML configuration below. Assume this is the only YAML file in the models directory.**
```yml
sources:
  - name: salesforce
    tables:
      - name: accounts
        columns:
          - name: account_id
            data_tests:
              - unique
```

> What data tests will be run in your project?

a. A unique test will be run on the accounts source table. [x]
b. A unique test will be run on the salesforce source table.
c. A unique test will be run on the salesforce model
d. A unique test will be run on the accounts model

**3. When a data test is run, what is happening under the hood in dbt?**

a. dbt will compile python to run against models or sources
b. dbt will compile SQL to run against models or sources [x]
c. dbt will enforce a constraint on the column of the models or sources
d. dbt will scan the SQL of your data models to ensure the data materializes correctly

**4. On Monday, you are working in development and run dbt build. Your entire project materializes and tests successfully. You have only accepted values tests on your sources and models.**

On Tuesday, you log back in and run `dbt run` and your models all run. You then run `dbt test` and find that 5 tests failed.

What is most likely the reason for the tests failing?

a. The SQL in your models resulted in a compilation error.
b. The column name in one of your sources that changed.
c. A new value was introduced on a column you were testing. [x]
d. A column you were testing now has a duplicate.

**5. Consider the YAML block below**

```yml
sources:
  - name: salesforce
    tables:
      - name: accounts
        loaded_at_field: _updated_at
        freshness:
          warn_after: {count: 1, period: day}
          error_after: {count: 7, period: day}
        columns:
          - name: account_id
             tests:
               - unique
               - not_null
```

> When running `dbt source freshness` what will cause a warning to be flagged?

a. A duplicate in the account_id column will cause a warning.
b. A null value in the account_id column will cause a warning.
c. The greatest value of the _updated_at column is more than 7 days before the current time
d. The greatest value of the _updated_at column is between 1 and 7 days before the current time. [x]

**6. What is the dbt best practice for testing your primary keys?**

a. Apply a unique test to your primary keys.
b. Apply a not_null test to your primary keys.
c. Apply a unique and not_null test to your primary keys. [x]
d. Apply a relationships test to your primary keys to ensure referential integrity to a foreign key.

**7. Assume your project only has models and sources and data tests configured on models and sources. (i.e. there are not snapshots or seeds -- these are beyond the scope of this quiz)**

> How does the dbt build command work?

a. dbt build will first test your sources, then materialize all your models, and then test all your models.
b. dbt build will first test your sources, then materialize and test each model in DAG order. [x]
c. dbt build will first materialize your models, then test your sources, and then test your models.

**8. Which command will run data tests only on sources?**

a. dbt test --select source:* [x]
b. dbt test --select _sources.yml
c. dbt test --select staging/
d. dbt source test

> ---
> # SECTION 07. DOCUMENTATION
>

> **1. Learning Objectives**

Explain why documentation is crucial for analytics.
Understand the documentation features of dbt.
Write documentation for models, sources, and columns in .yml files.
Write documentation in markdown using doc blocks.
View and navigate the lineage graph to understand the dependencies between models.

---

> **2. Why is Documentation Important?**

Think back to your last project or team setting, How easy was it to find the answers to the questions?
that struggle is exactly why documentation is **so important** in analytics.
i.e. how is this field calculated, or what does this column mean?

The problem is that documentation is often a seperate task and when faced with a choice between writing good code and writing a documentation ... we usually prioritize the code

dbt solves this by bringing documentation right into the dev workflow
    - create documentation in the same yaml files you configuring your models and tests

---

> **3. What is Documentation?**
[docs](https://learn.getdbt.com/learn/course/dbt-fundamentals/documentation-40min/documentation-basics?page=3)

The goal of documentation is to help others (and future you!) understand your data and models.
    - essential part of creating a single source of truth

importance of DAGs

use of `description:`

> **4. Writing Documentation**
  a. intro to docs and doc blocks
  b. doc models in yaml file
  c. adding descriptions to models
  d. using doc blocks for organized docs
  e. creating a doc block markdown file
  f. stucturing a doc block
  g. writing documentation in dock block
  h. connecting Doc Block to YAML files


start in `stg_jaffle_shop.yml` bc it already had tests and is a perfect place to document bc:
       -  we often write staging models for other devs to use

under `models: name: stg_jaffle_shop__customers` write `description: The grain on this table is one unique customer per row`

Reference: Code Snippets

```yml
# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__customers
    description: one unique customer per row
    columns:
      - name: customer_id
        description: the primary key
        data_tests:
          - unique
          - not_null

  - name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
      - name: status
        description: "{{ doc('order_status') }}"
        data_tests:
          - accepted_values:
              arguments:
                values: ['placed', 'shipped', 'completed', 'returned', 'return_pending']
      - name: customer_id
        data_tests:
          - relationships:
              arguments:
                to: ref('stg_jaffle_shop__customers')
                field: customer_id
```

> **5. Writing Doc Blocks**

[get started with markdown](https://www.markdownguide.org/getting-started/)

a. create a new file: models/staging/jaffle_shop/jaffle_shop_docs.md
b. insert the following:

{% docs order_status %}

One of the following values:

| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}

c. press preview
d. now its time to reference back to `order_status` in `# models/staging/jaffle_shop/_stg_jaffle_shop.yml`

```yml
# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__customers
    description: one unique customer per row
    columns:
      - name: customer_id
        description: the primary key
        data_tests:
          - unique
          - not_null

  - name: stg_jaffle_shop__orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
      - name: order_status
        description: "{{ doc('order_status') }}"
        data_tests:
          - accepted_values:
              arguments:
                values: ['placed', 'shipped', 'completed', 'returned', 'return_pending']
      - name: customer_id
        data_tests:
          - relationships:
              arguments:
                to: ref('stg_jaffle_shop__customers')
                field: customer_id
```

> **6. Documenting Sources**

**Reference: Code Snippets**
```yml
# models/staging/jaffle_shop/_src_jaffle_shop.yml
sources:
  - name: jaffle_shop
    description: A clone of a Postgres database
    database: raw
    schema: jaffle_shop
    tables:
      - name: customers
        description: Raw customers data
        columns:
          - name: id
            description: primary key
            data_tests:
              - unique
              - not_null
      - name: orders
        config:
          freshness:
            warn_after:
              count: 24
              period: hour
            error_after:
              count: 48
              period: hour
          loaded_at_field: _etl_loaded_at
```

> **7. Using AI to doc**

> **8. Merge to main**
knowing when your project is ready for primetime

we need to make sure you've completed a few things:
- you've configured your sources
- where your raw data lives

We merge to main when we're ready to deploy our changes to production.

> **9. Practice**

*Using the resources in this module, complete the following in your dbt project:*

**Write documentation**
- Add documentation to the file models/staging/jaffle_shop/_stg_jaffle_shop.yml.
- Add a description for your stg_jaffle_shop__customers model and the column customer_id.
- Add a description for your stg_jaffle_shop__orders model and the column order_id.

**Create a reference to a doc block**
- Create a doc block for your stg_jaffle_shop__orders model to document the status column.
- Reference this doc block in the description of status in stg_jaffle_shop__orders.

```yml
# models/staging/jaffle_shop/_stg_jaffle_shop.yml
models:
  - name: stg_jaffle_shop__customers
    description: Staged customer data from our jaffle shop app.
    columns:
      - name: customer_id
        description: The primary key for customers.
        data_tests:
          - unique
          - not_null

  - name: stg_jaffle_shop__orders
    description: Staged order data from our jaffle shop app.
    columns
      - name: order_id
        description: Primary key for orders.
        data_tests:
          - unique
          - not_null
      - name: status
        description: "{{ doc('order_status') }}"
        data_tests:
          - accepted_values:
              arguments:
                values:
                  - completed
                  - shipped
                  - returned
                  - placed
                  - return_pending
      - name: customer_id
        description: Foreign key to stg_customers.customer_id
        data_tests:
          - relationships:
              arguments:
                to: ref('stg_jaffle_shop__customers')
                field: customer_id
```

```md
#models/staging/jaffle_shop/_jaffle_shop.md

{% docs order_status %}

One of the following values:
| status         | definition                                       |
|----------------|--------------------------------------------------|
| placed         | Order placed, not yet shipped                    |
| shipped        | Order has been shipped, not yet been delivered   |
| completed      | Order has been received by customers             |
| return pending | Customer indicated they want to return this item |
| returned       | Item has been returned                           |

{% enddocs %}
```

**Extra Credit**
Add documentation to the other columns in stg_jaffle_shop__customers and stg_jaffle_shop__orders.
Add documentation to the stg_stripe__payment model.
Create a doc block for another place in your project and generate this in your documentation.

---

**Review**
Documentation
Documentation is essential for an analytics team to work effectively and efficiently. Strong documentation empowers users to self-service questions about data and enables new team members to on-board quickly.
Documentation often lags behind the code it is meant to describe. This can happen because documentation is a separate process from the coding itself that lives in another tool.
Therefore, documentation should be as automated as possible and happen as close as possible to the coding.
In dbt, models are built in SQL files. These models are documented in YML files that live in the same folder as the models.
Writing documentation and doc blocks
Documentation of models occurs in the YML files (where generic tests also live) inside the models directory. It is helpful to store the YML file in the same subfolder as the models you are documenting.
For models, descriptions can happen at the model, source, or column level.
If a longer form, more styled version of text would provide a strong description, doc blocks can be used to render markdown in the generated documentation.

---

> **QUIZ**

You are documenting the columns in your models. Several models have the same column. What documentation type guarantees these columns have a shared description?

a. Single-line string description
b. Multi-line string description
c. Doc block [x]
d. Read-me file

Which file type are single-line descriptions written in?

a. .sql
b. .yml [x]
c. .md
d. .py

---

># Section 09. Deployment

**Learning Objectives**
- Understand why it's necessary to deploy your project.
- Explain the purpose of creating a deployment environment.
- Schedule a job in dbt.
- Review the results and artifacts of a scheduled job in dbt.

---

> **What is Deployment?**

Deployment is the process of moving your dbt project from your local development environment to a production environment where it can be executed automatically and consistently.
1. deploying dbt involves running dbt commands on a schedule.
    - this will allow you to build models on any cadence you need them to
        - nightly or on weekends
        - run test build
2. all of our models will be built into a production schema.
    - this is a schema that we can then point a BI tool at.
    - can be referenced as the single source of truth for our data.
    - All of the development schemas are completely separate & that allows devs to tinker and refactor without impacting the models (i.e. production environment.)

3. When we deploy, dbt will use the main branch for building models
    - thats why all the work done so far is done in a different branch.
    - instead of messing up the production branch.
    - that way we don't mess up the models that power our dashboard.

when you merge to main, your next production run will include the changes you made and will be scheduled to run at the cadence you set.

---

> **Set up a Deployment Environment**

There are 2 different types of environments:
1. Development - wee can have only one dev environment
2. Production - we can have multiple production environments

What is the target? 

The schema 'analytics'

Under **orchestration** tab on the left, go into environments.. click `create environment`

> name the Environment: `Production`
> set type: `Production`
    - dbt needs to know the specific env type for deployment env so it understand where to pull specific metadata.
> set version: `Latest Fusion`

> connection: snowflake

connection was mostly auto-filled but it error'd because role: TRANSFORMER was not created

I had to go into Snowflake and create a temporary sql file to run commands like:
```sql
-- 0) See what role you're currently using
select current_role();

-- 1) Try switching to ACCOUNTADMIN (best), otherwise SECURITYADMIN
use role accountadmin;
    -- if that errors, do `use role securityadmin;`

-- 2) Confirm whether the role exists
show roles;

show roles like 'TRANSFORMER';

-- 3) Create it if it doesn't exist
create role if not exists TRANSFORMER;

-- 4) Grant role to your user
grant role TRANSFORMER to user BRANDO;

-- 5) Verify BRANDO has it
show grants to user BRANDO;

GRANT USAGE ON WAREHOUSE transforming TO ROLE TRANSFORMER;
```

Success!

---

> **Set up a Deployment Job**

Click `Orchestration` then click `Jobs` > select `create job` select `deploy`

Job settings:
    - Job name: give a name like `daily run` to indicate what it does
    - set the environment `Production`

Execution Settings: what do you want to do with taht code?
    - run `source freshness`
    - use `dbt build`
    - select `generate docs on run`

Triggers:
- Schedule:
  - Run on Schedule:
    - Timing:
      - Intervals
      - Run every:
        - 1,2,4,8 12h etc.
        - Days of the week
      - Days of the week
    - Specific Hours
      - 12 UTC
    - Cron schedules
      - 0 0 * * * (runs at midnight UTC every day)
- Job Completion:
  - Run when another job finishes.

**Cron scheduling**
[custom cron](https://docs.getdbt.com/docs/deploy/deploy-jobs#custom-cron-schedule)
To fully customize the scheduling of your job, choose the Custom cron schedule option and use the "cron" syntax. With this syntax, you can specify the minute, hour, day of the month, month, and day of the week, allowing you to set up complex schedules like running a job on the first Monday of each month.

Use tools such as crontab.guru to generate the correct cron syntax. This tool allows you to input cron snippets and returns their plain English translations.

Refer to the following example snippets:

0 * * * *: Every hour, at minute 0
*/5 * * * *: Every 5 minutes
5 4 * * *: At exactly 4:05 AM UTC
30 */4 * * *: At minute 30 past every 4th hour (e.g. 4:30AM, 8:30AM, 12:30PM, etc., all UTC)
0 0 */2 * *: At midnight UTC every other day
0 0 * * 1: At midnight UTC every Monday.

> **Review a dbt JOB**

---

> **?**

---

> **QUIZ**

**1. How do you indicate a deployment environment as a production environment?**

a. Add a flag to the job execution settings.
b. Select `production` in the deployment environment settings. [x]
c. Select `production` in the development environment settings.
d. Enter a service account's credentials in the deployment environment settings.
Enter a service account's credentials in the deployment environment settings.

**2. What is the function of a job in dbt?**

a. the execution of dbt commands in development environments
b. the execution of dbt commands in deployment environments [x]
c. configure the settings for where code should be run in production.
d. investigate the data assets in your production environment


**3.Which one of the following are true about running your dbt project in production?**

a. Running dbt in production should use a different repository than I used in development
b. Running dbt in production requires the re-configuration of sources to refer to production data.
c. Running dbt in production should use a different database schema than I used in development [x]
d. Running dbt in production only supports the `dbt run` command - it does not support `dbt test`

**4. When does a dbt job run?**

a. Every morning at 9 am, in the time zone of your choosing
b. At whatever cadence you set up for the job [x]
c. When developing in the dbt studio and the command “dbt run” is entered in the command bar
d. Only when you open a pull request

**5. The following commands are configured for a production job in dbt.**

dbt seed

dbt test --select source:*

dbt run

dbt test --exclude source:*

> If any of the tests on sources fails, how will dbt handle the rest of the commands?

a. dbt will still execute dbt run AND dbt test --exclude source:*
b. dbt will still execute dbt run BUT will not execute dbt test --exclude source:*
c. dbt will still execute dbt test --exclude source:* BUT will not execute dbt run
d. dbt will not execute any further commands [x]

---

**Section 09. Survey & Feedback:**
1. use a cursor that is more accessible for the audience.
2. make sure videos reflect the version given to user
3. improve fluidity of file creation/code patterns

---
---

**Congratulations!**
Thank you for joining all of us from the dbt Labs team! At this point, you have been empowered with the fundamentals of dbt - models, sources, tests, docs, and deployment.

Make sure you hit complete on each of the lessons (including this one!) and pass all of the Checks for Understanding to mark the course as complete and receive your dbt Fundamentals badge. When you mark all lessons complete, it may take a few seconds for your badge to be created.

Once your badge is created, you’ll receive an email from training@dbtlabs.com with a link to download or share your dbt Fundamentals badge.

Check out the resources below to continue the journey, stay fresh on your skills, and share this with your fellow analytics engineers.

Resources

[dbt Docs:](https://docs.getdbt.com/docs/introduction) There is no shame in referencing the docs as an analytics engineer! Use this to continue your journey, copy YML code into your project, or figure out more advanced features.

Short courses: We have four courses to continue leveling up:

[**Jinja, Macros, and Packages:**](https://learn.getdbt.com/courses/jinja-macros-and-packages)
: Extend dbt with Jinja/Macros and import packages to speed up modeling and leverage existing macros.


[**Materialization Fundamentals:**](https://learn.getdbt.com/courses/materializations-fundamentals) So far you have learned about tables and views. This course will teach you about ephemeral models, incremental models, and snapshots.

[**Analyses and Seeds:**](https://learn.getdbt.com/courses/analyses-and-seeds) Analyses can be used for ad hoc queries in your dbt project and seeds are for importing CSVs into your warehouse with dbt.

[**Refactoring SQL for Modularity:**](https://learn.getdbt.com/courses/refactoring-sql-for-modularity) Migrating code from a previous tool to dbt? Learn how to migrate legacy code into dbt with modularity in mind.

**Contribute**
Support other beginners in Slack: #advice-dbt-help

**Share**
Share the course with your team on LinkedIn!
Add the dbt Learn Fundamentals badge to your LinkedIn profile.

**Feedback**
[Feedback](https://getdbt.slack.com/archives/C01DU491K1A): Let us know what you thought about the course with positive and constructive feedback.  We are transparent about getting better, so don't hesitate to share in #learn-on-demand (request new courses too).

Bugs: Help the dbt Labs training team squash bugs in the course by sending them to training@dbtlabs.com and we will triage them from there.
Congratulations and thank you again! See you in dbt Slack!

- The dbt Labs Training Team

---
---
---

> **Get dbt-Certified!**

![alt text](https://d36ai2hkxl16us.cloudfront.net/course-uploads/6ed554fb-fedc-4719-a40d-8b22e0a22aee/pgnd4sw3afrg-Whygetdbt-certified.png)


---
---

># **Further Development**

I disconnected managed repo and switched the connection to my github cat-cols account
> created a new repo called `https://github.com/cat-cols/jaffle-shop-dbt-snowflake`