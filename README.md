# 📊 SQL Data Warehouse Project (Bronze → Silver → Gold)

## 🧩 Overview

This project implements a **modern data warehouse architecture** using SQL Server, following a layered approach:

* **Bronze Layer** → Raw data ingestion
* **Silver Layer** → Data cleaning & transformation
* **Gold Layer** → Business-ready data models (Star Schema)

The solution integrates data from **CRM and ERP systems** and transforms it into analytics-ready datasets.

---

## 🏗️ Data Architecture

The pipeline follows a **multi-layered ETL design**:

* **Sources**

  * CRM (Customers, Products, Sales)
  * ERP (Customer demographics, Location, Product categories)

* **Bronze Layer**

  * Raw ingestion using `BULK INSERT`
  * No transformations
  * Tables:

    * `crm_cust_info`
    * `crm_prd_info`
    * `crm_sales_details`
    * `erp_cust_az12`
    * `erp_loc_a101`
    * `erp_px_cat_g1v2`

* **Silver Layer**

  * Data cleansing, standardization, and deduplication
  * Business rules applied
  * Handles:

    * Null values
    * Data type corrections
    * Data enrichment

* **Gold Layer**

  * Star schema modeling
  * Optimized for analytics & BI tools
  * Includes:

    * Dimensions
    * Fact tables

---

## 🔄 Data Flow

```
Sources → Bronze → Silver → Gold
```

* Raw data is loaded into Bronze
* Cleaned and transformed in Silver
* Aggregated and modeled in Gold

---

## 🧱 Schema Design

### ⭐ Gold Layer (Star Schema)

#### 📘 Dimension Tables

1. **dim_customers**

   * Customer master data
   * Combines CRM + ERP
   * Includes:

     * Name
     * Gender (CRM prioritized)
     * Country
     * Marital status

2. **dim_products**

   * Product hierarchy
   * Includes:

     * Category
     * Subcategory
     * Product line
   * Filters only active products

---

#### 📊 Fact Table

**fact_sales**

* Transaction-level sales data
* Linked to:

  * `dim_customers`
  * `dim_products`
* Measures:

  * Sales amount
  * Quantity
  * Price

---

## ⚙️ ETL Process

### 1. Bronze Layer Load

* Uses stored procedure:

  ```
  bronze.load_bronze
  ```
* Loads CSV files via `BULK INSERT`

---

### 2. Silver Layer Transformation

* Uses:

  ```
  silver.load_silver
  ```
* Key transformations:

  * Deduplication using `ROW_NUMBER()`
  * Gender & marital status standardization
  * Date conversions
  * Data validation rules

---

### 3. Gold Layer Views

Created using SQL views:

* `gold.dim_customers`
* `gold.dim_products`
* `gold.fact_sales`

---

## 📐 Key Business Rules

* CRM is the **source of truth for gender**
* ERP supplements missing demographic data
* Invalid or null values handled as `'n/a'`
* Product history handled using:

  ```
  prd_end_dt IS NULL
  ```
* Sales recalculated if inconsistent:

  ```
  sales = quantity * price
  ```

---

## 🚀 How to Run

### Step 1: Create Database & Schemas

Run setup script: 

---

### Step 2: Load Bronze Layer

```sql
EXEC bronze.load_bronze;
```

---

### Step 3: Load Silver Layer

```sql
EXEC silver.load_silver;
```

---

### Step 4: Query Gold Layer

```sql
SELECT * FROM gold.dim_customers;
SELECT * FROM gold.dim_products;
SELECT * FROM gold.fact_sales;
```

---

## ⚠️ Known Issues / Fixes

* Ensure stored procedures are created **before execution**
* Fix typo:

  * `prodcut_name` → `product_name`
* Maintain consistent alias casing (`sd` vs `Sd`)
* Always use schema-qualified names

---

## 📈 Future Enhancements

* Add surrogate keys using sequences
* Implement incremental loading (CDC)
* Add logging & audit tables
* Create indexes for performance
* Integrate with Power BI / Tableau

---

## 🧠 Learning Outcomes

This project demonstrates:

* Data warehouse design (Medallion Architecture)
* SQL-based ETL pipelines
* Data cleaning & transformation
* Star schema modeling
* Real-world data integration

---

## 👤 Author

**Amit Kumar**

---
