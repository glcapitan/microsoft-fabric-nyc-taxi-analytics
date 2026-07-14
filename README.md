# 🚖 End-to-End NYC Taxi Data Engineering Platform using Microsoft Fabric

<p align="center">

![Microsoft Fabric](https://img.shields.io/badge/Microsoft-Fabric-blue?style=for-the-badge)
![Power BI](https://img.shields.io/badge/PowerBI-Dashboard-yellow?style=for-the-badge)
![SQL](https://img.shields.io/badge/SQL-Warehouse-red?style=for-the-badge)
![PySpark](https://img.shields.io/badge/PySpark-Notebook-orange?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-black?style=for-the-badge)

</p>

---

# 📖 Overview

This project demonstrates a **production-inspired end-to-end data engineering solution** built using **Microsoft Fabric**. The solution ingests NYC Yellow Taxi trip data, processes it through a modular ETL architecture, and delivers analytics-ready datasets for business intelligence reporting.

The project showcases the complete data lifecycle—from ingestion and transformation to data modeling and visualization—using modern Microsoft Fabric components.

---

# 🎯 Objectives

- Build an end-to-end ETL pipeline using Microsoft Fabric.
- Implement the Medallion Architecture (Bronze → Silver → Gold).
- Develop modular and reusable ETL pipelines.
- Transform raw taxi trip data into curated analytical datasets.
- Design a dimensional model for reporting.
- Create an interactive Power BI dashboard.
- Demonstrate industry-standard data engineering practices.

---

# 🛠️ Technology Stack

| Technology | Purpose |
|------------|----------|
| Microsoft Fabric | End-to-End Analytics Platform |
| Data Pipeline | ETL Orchestration |
| Dataflow Gen2 | Data Transformation |
| OneLake | Centralized Storage |
| Lakehouse | Bronze & Silver Layers |
| PySpark Notebook | Data Cleaning & Processing |
| SQL Warehouse | Gold Layer |
| SQL | Data Modeling |
| Power BI Desktop | Dashboard & Semantic Model |
| Git & GitHub | Version Control & Documentation |

---

# 📂 Dataset

**Dataset:** NYC Yellow Taxi Trip Records

The dataset contains millions of taxi trips collected by the New York City Taxi and Limousine Commission (TLC).

### Included Fields

- Pickup Date & Time
- Dropoff Date & Time
- Vendor
- Passenger Count
- Trip Distance
- Pickup Location
- Dropoff Location
- Fare Amount
- Tip Amount
- Total Amount
- Payment Type

---

# 🏗️ Solution Architecture

```text
                    NYC Taxi Dataset
                           │
                           ▼
                Microsoft Fabric Pipeline
                           │
                           ▼
                 Bronze Lakehouse
                    (Raw Data)
                           │
                           ▼
                PySpark Notebook ETL
                           │
                           ▼
                 Silver Lakehouse
                 (Cleaned Data)
                           │
                           ▼
                  SQL Warehouse
                (Gold Star Schema)
                           │
                           ▼
              Semantic Model (Power BI)
                           │
                           ▼
              Interactive Dashboard
```

---

# 🔄 ETL Pipeline Architecture

The project follows a modular orchestration approach.

```text
                         pl_orchestrate_nyctaxi
                                   │
        +--------------------------+--------------------------+
        │                          │                          │
        ▼                          ▼                          ▼
 +---------------+        +-------------------+      +----------------------+
 | pl_stg_lookup | -----> | pl_stgh_process   | ---> | pl_pres_processing   |
 +---------------+        +-------------------+      +----------+-----------+
                                                              │
                                                              ▼
                                               +----------------------------+
                                               | df_pres_processing_nyctaxi |
                                               | Dataflow Gen2              |
                                               +----------------------------+
```

### Pipeline Description

| Pipeline | Purpose |
|----------|---------|
| **pl_orchestrate_nyctaxi** | Coordinates the execution of the entire ETL workflow. |
| **pl_stg_lookup** | Retrieves lookup tables and metadata used during processing. |
| **pl_stgh_process_nyctaxi** | Processes staging data and applies business transformations. |
| **pl_pres_processing_nyctaxi** | Builds presentation-ready datasets for reporting. |
| **df_pres_processing_nyctaxi** | Performs final transformations using Dataflow Gen2. |

---

# 🥉 Bronze Layer

The Bronze layer stores raw NYC Taxi trip data exactly as received.

### Responsibilities

- Raw data ingestion
- Schema preservation
- Historical data retention
- Source system replication

---

# 🥈 Silver Layer

The Silver layer contains validated and cleaned datasets.

### Transformations

- Remove duplicate records
- Handle missing values
- Standardize date and time formats
- Filter invalid trips
- Improve data quality
- Prepare datasets for analytics

---

# 🥇 Gold Layer

The Gold layer provides business-ready datasets optimized for analytical workloads.

Example business tables include:

- FactTrips
- DimDate
- DimVendor
- DimPaymentType
- DimPickupLocation
- DimDropoffLocation

---

# ⭐ Semantic Model

The curated SQL Warehouse serves as the foundation for the semantic model.

The semantic model includes:

- Table relationships
- Business-friendly column names
- DAX measures
- Aggregations
- Time intelligence calculations

> **Note:** Due to Microsoft Fabric Trial limitations, the semantic model was implemented in Power BI Desktop instead of being published as a Fabric Semantic Model. The dimensional model and business logic remain the same.

---

# 📊 Dashboard

The Power BI report enables users to analyze:

- Total Revenue
- Number of Trips
- Passenger Count
- Revenue Trends
- Payment Method Distribution
- Vendor Performance
- Pickup & Dropoff Analysis
- Date Filtering

---

# 💼 Business Questions Answered

This project enables stakeholders to answer questions such as:

- Which payment method generates the most revenue?
- Which vendor handles the highest number of trips?
- What are the busiest travel periods?
- Which pickup and dropoff locations have the highest demand?
- How does revenue change over time?
- How many passengers travel each day?

---

# 📷 Project Screenshots

## Microsoft Fabric Workspace

![Workspace](screenshots/01_workspace.png)

---

## Pipeline Orchestration

![Pipeline](screenshots/02_orchestrator_pipeline.png)

---

## Dataflow Gen2

![Dataflow](screenshots/06_dataflow_gen2.png)

---

## Lakehouse

![Lakehouse](screenshots/07_lakehouse.png)

---

## PySpark Notebook

![Notebook](screenshots/08_notebook.png)

---

## SQL Warehouse

![Warehouse](screenshots/09_sql_warehouse.png)

---

## Semantic Model

![Semantic Model](screenshots/10_semantic_model.png)

---

## Power BI Dashboard

![Dashboard](screenshots/11_dashboard.png)

---

# 📚 Skills Demonstrated

## Data Engineering

- ETL Development
- Pipeline Orchestration
- Dataflow Gen2
- Lakehouse Architecture
- Data Processing
- SQL Warehouse
- Data Validation

## Data Modeling

- Medallion Architecture
- Star Schema
- Dimensional Modeling
- Semantic Modeling

## Analytics

- Power BI
- DAX
- Business Intelligence
- KPI Development

---

# 🚧 Challenges

During development, several challenges were encountered:

- Processing large datasets efficiently
- Organizing modular ETL pipelines
- Cleaning inconsistent source data
- Working with Microsoft Fabric Trial limitations
- Designing a scalable dimensional model

---

# 💡 Key Learnings

This project strengthened my understanding of:

- Microsoft Fabric
- Data Engineering Pipelines
- Dataflow Gen2
- Lakehouse Architecture
- ETL Design
- PySpark
- SQL Data Warehousing
- Semantic Modeling
- Power BI
- GitHub Documentation

---

# 🚀 Future Improvements

Future enhancements may include:

- Incremental Data Loading
- Pipeline Scheduling
- CI/CD Deployment
- Fabric Semantic Model Publishing
- Real-Time Streaming
- Data Quality Monitoring
- Automated Testing
- Parameterized Pipelines

---

# 📁 Repository Structure

```text
microsoft-fabric-nyc-taxi-data-engineering/
│
├── README.md
├── assets/
│
├── notebooks/
│
├── sql/
│
├── docs/
│
├── screenshots/
│   ├── 01_workspace.png
│   ├── 02_orchestrator_pipeline.png
│   ├── 03_lookup_pipeline.png
│   ├── 04_staging_pipeline.png
│   ├── 05_presentation_pipeline.png
│   ├── 06_dataflow_gen2.png
│   ├── 07_lakehouse.png
│   ├── 08_notebook.png
│   ├── 09_sql_warehouse.png
│   ├── 10_semantic_model.png
│   └── 11_dashboard.png
│
├── powerbi/
│   └── NYC Taxi Dashboard.pbix
│
└── sample-data/
```

---

# 👨‍💻 Author

**Erwin Glenn Capitan II**

Aspiring Data Engineer | Business Intelligence Analyst | Data Analyst

### Technical Skills

- Microsoft Fabric
- SQL
- PySpark
- Data Engineering
- ETL Pipelines
- Dataflow Gen2
- OneLake
- Lakehouse
- SQL Warehouse
- Semantic Modeling
- Power BI
- Git
- GitHub

---

## ⭐ If you found this project helpful, feel free to star this repository!
