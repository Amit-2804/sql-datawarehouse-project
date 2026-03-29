1. View: gold.dim_customers
Description:
Customer dimension combining CRM and ERP data, enriched with demographics and location.
-----------------------------------------------------------------------------------------------------

| Column Name     | Data Type | Description                                | Source                 |
| --------------- | --------- | ------------------------------------------ | ---------------------- |
| customer_key    | INT       | Surrogate key (generated using ROW_NUMBER) | System                 |
| customer_id     | INT       | Unique customer ID                         | `silver.crm_cust_info` |
| customer_number | VARCHAR   | Business customer key                      | `silver.crm_cust_info` |
| first_name      | VARCHAR   | Customer first name                        | CRM                    |
| last_name       | VARCHAR   | Customer last name                         | CRM                    |
| country         | VARCHAR   | Customer country                           | `silver.erp_loc_a101`  |
| marital_status  | VARCHAR   | Marital status (cleaned)                   | CRM                    |
| gender          | VARCHAR   | Gender (CRM preferred, fallback ERP)       | CRM + ERP              |
| birth_date      | DATE      | Customer DOB                               | ERP                    |
| create_date     | DATE      | Customer creation date                     | CRM                    |


2. View: gold.dim_products

Description:
Product dimension with category hierarchy and active products only.
-----------------------------------------------------------------------------------------------------
| Column Name    | Data Type | Description           | Source  |
| -------------- | --------- | --------------------- | ------- |
| product_key    | INT       | Surrogate key         | System  |
| product_id     | INT       | Product ID            | CRM     |
| product_number | VARCHAR   | Business product key  | CRM     |
| product_name   | VARCHAR   | Product name          | CRM     |
| category_id    | VARCHAR   | Category ID           | Derived |
| category       | VARCHAR   | Product category      | ERP     |
| subcategory    | VARCHAR   | Product subcategory   | ERP     |
| maintenance    | VARCHAR   | Maintenance type      | ERP     |
| cost           | INT       | Product cost          | CRM     |
| product_line   | VARCHAR   | Product line (mapped) | CRM     |
| start_date     | DATE      | Product start date    | CRM     |

3. View: gold.fact_sales

Description:
Sales fact table linking customers and products.
-----------------------------------------------------------------------------------------------------
| Column Name   | Data Type | Description        | Source  |
| ------------- | --------- | ------------------ | ------- |
| order_number  | VARCHAR   | Sales order ID     | CRM     |
| product_key   | INT       | FK → dim_products  | Derived |
| customer_id   | INT       | FK → dim_customers | CRM     |
| order_date    | DATE      | Order date         | CRM     |
| shipping_date | DATE      | Shipping date      | CRM     |
| due_date      | DATE      | Due date           | CRM     |
| sales_amount  | INT       | Total sales        | CRM     |
| quantity      | INT       | Quantity sold      | CRM     |
| price         | INT       | Unit price         | CRM     |

Relationships:
| From                   | To                        |
| ---------------------- | ------------------------- |
| fact_sales.product_key | dim_products.product_key  |
| fact_sales.customer_id | dim_customers.customer_id |



********Data_Lineage********
Bronze → Silver → Gold

crm_cust_info ─────┐
                   ├── dim_customers
erp_cust_az12 ─────┤
erp_loc_a101 ──────┘

crm_prd_info ──────┐
                   ├── dim_products
erp_px_cat_g1v2 ───┘

crm_sales_details ───────────→ fact_sales
dim_products ────────────────→ fact_sales
dim_customers ───────────────→ fact_sales
