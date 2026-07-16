# End-to-End NYC Taxi Analytics Platform using Microsoft Fabric

**A production-inspired analytics engineering solution — from raw data ingestion to executive dashboards, built entirely on Microsoft Fabric.**

![Microsoft Fabric](https://img.shields.io/badge/Microsoft%20Fabric-Data%20Platform-blue)
![Power BI](https://img.shields.io/badge/Power%20BI-Reporting-yellow)
![SQL](https://img.shields.io/badge/SQL-Warehouse-orange)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-green)

---

## 📌 Business Scenario

A city transportation authority needs reliable, self-service analytics on taxi operations: revenue trends, vendor performance, payment behavior, and demand patterns across boroughs. Analysts were previously working from raw CSV extracts — slow, error-prone, and impossible to govern.

**This platform solves that** by delivering a governed, automated pipeline that transforms millions of raw NYC Yellow Taxi trip records into an analytics-ready warehouse and an interactive Power BI dashboard — refreshed end-to-end through orchestrated Fabric pipelines.

> ⚡ **TL;DR for reviewers:** Modular pipeline orchestration → Lakehouse (Bronze) → Dataflow Gen2 transformations (Silver) → SQL Warehouse (Gold) → Semantic Model → Power BI. Full medallion architecture, single Fabric workspace, zero external tooling.

---

## 🏗️ Solution Architecture

```mermaid
flowchart LR
    A[NYC Yellow Taxi<br/>Trip Records] --> B[Fabric Data Pipelines<br/>Orchestrated Ingestion]
    B --> C[(Lakehouse<br/>Bronze — Raw)]
    C --> D[Dataflow Gen2<br/>Silver — Clean & Validate]
    D --> E[(SQL Warehouse<br/>Gold — Analytics-Ready)]
    E --> F[Semantic Model<br/>Relationships & Measures]
    F --> G[Power BI Dashboard]
```

*(High-resolution architecture diagram: [`assets/diagrams/solution-architecture.png`](assets/diagrams/))*

### Why this design?

| Decision | Rationale |
|---|---|
| **Modular child pipelines** | Single-responsibility pipelines are independently testable, reusable, and easier to debug than one monolith |
| **Medallion architecture** | Clear contract between raw, cleaned, and business-ready data; supports reprocessing without re-ingestion |
| **SQL Warehouse for Gold** | T-SQL analytics surface familiar to BI teams; supports dimensional modeling |
| **Semantic Model layer** | Centralizes business logic (measures, relationships) so every report shares one source of truth |

---

## 🔄 Pipeline Orchestration

Ingestion and processing is coordinated by a **master orchestration pipeline** that executes modular child pipelines in sequence:

```mermaid
flowchart TD
    M[pl_orchestrate_nyctaxi<br/>🎯 Master Orchestrator] --> P1[pl_stg_lookup<br/>Lookup & Reference Data]
    M --> P2[pl_stg_process_nyctaxi<br/>Staging Ingestion]
    M --> P3[pl_pres_processing_nyctaxi<br/>Presentation Processing]
    P3 --> DF[df_pres_processing_nyctaxi<br/>Dataflow Gen2 Transformations]
```

| Pipeline | Responsibility |
|---|---|
| `pl_orchestrate_nyctaxi` | Master pipeline — coordinates execution order, dependencies, and failure handling |
| `pl_stg_lookup` | Loads lookup/reference data (vendors, payment types, borough zones) |
| `pl_stg_process_nyctaxi` | Ingests raw trip records into the Lakehouse staging layer |
| `pl_pres_processing_nyctaxi` | Promotes cleaned data into the presentation layer |
| `df_pres_processing_nyctaxi` | Dataflow Gen2 — data cleansing, type enforcement, business-rule transformations |

**Design principle:** each pipeline owns exactly one responsibility. This improves maintainability (isolated changes), reusability (lookup pipeline serves future datasets), and scalability (parallelizable stages).

---

## 🥉🥈🥇 Medallion Architecture

```mermaid
flowchart LR
    B[🥉 Bronze<br/>Raw trip records<br/>ProjectLakehouse] --> S[🥈 Silver<br/>Cleaned & validated<br/>Dataflow Gen2]
    S --> G[🥇 Gold<br/>Dimensional tables<br/>ProjectWarehouse]
```

| Layer | Store | Purpose |
|---|---|---|
| **Bronze** | `ProjectLakehouse` | Immutable raw source data — preserves full fidelity for auditing and reprocessing |
| **Silver** | Dataflow Gen2 output | Standardized types, null handling, deduplication, validated records |
| **Gold** | `ProjectWarehouse` | Analytics-ready dimensional tables optimized for reporting |

---

## 📊 Semantic Model & Dashboard

The **`nyctaxi_yellow`** semantic model sits between the warehouse and reporting layer, providing:

- **Relationships** across fact and dimension tables (star schema)
- **Reusable DAX measures** — revenue, trip counts, averages, tip ratios
- **Business-friendly naming** so analysts self-serve without knowing table internals

> ℹ️ *Note: the semantic model was published through Power BI due to Fabric Trial capacity limitations — the modeling approach is identical to a Fabric-native deployment.*

### Dashboard Coverage

The Power BI report answers the questions operators actually ask:

| Business Question | Dashboard View |
|---|---|
| Which vendor generates the highest revenue? | Vendor Analysis |
| What payment method dominates? | Payment Analysis |
| When are peak travel hours? | Time Analysis |
| Which borough has the highest trip volume? | Location Analysis |
| How many passengers travel daily? | Trips & Passenger KPIs |

*(Screenshots: [`assets/screenshots/`](assets/screenshots/))*

---

## 🗂️ Dataset

**NYC Yellow Taxi Trip Records** — millions of trip-level records including:

`Pickup/Dropoff Timestamps` · `Vendor` · `Passenger Count` · `Trip Distance` · `Fare Amount` · `Tip Amount` · `Payment Method` · `Pickup/Dropoff Borough`

---

## 🧰 Technology Stack

| Layer | Technology |
|---|---|
| Platform | Microsoft Fabric (OneLake) |
| Orchestration | Fabric Data Pipelines |
| Transformation | Dataflow Gen2 |
| Storage | Lakehouse (Bronze/Silver), SQL Warehouse (Gold) |
| Modeling | Semantic Model (star schema, DAX) |
| Reporting | Power BI |
| Version Control | Git / GitHub |

---

## 📚 Documentation

| Document | What it covers |
|---|---|
| [Pipeline Architecture](docs/pipeline-architecture.md) | Orchestration design, pipeline catalog, failure & rerun strategy, design principles |
| [Semantic Model](docs/semantic-model.md) | Star schema design, DAX measures, modeling decisions |
| [Analytical Queries](sql/analytical-queries.sql) | T-SQL queries answering each business question against the warehouse |

---

## 📁 Repository Structure

```
microsoft-fabric-nyc-taxi-analytics/
├── README.md
├── assets/
│   ├── diagrams/                    # Architecture & orchestration diagrams
│   └── screenshots/                 # Fabric workspace, pipelines, dashboard
├── docs/
│   ├── pipeline-architecture.md     # Orchestration deep-dive
│   └── semantic-model.md            # Star schema & DAX measures
├── sql/
│   └── analytical-queries.sql       # Business-question queries
├── powerbi/                         # Report file / model documentation
├── sample-data/                     # Small representative data samples
├── LICENSE
└── .gitignore
```

---

## 🧗 Challenges & Engineering Decisions

- **Large dataset volumes** — handled via staged ingestion into the Lakehouse before transformation, rather than transforming in-flight
- **Data quality** — Dataflow Gen2 enforces type safety, null handling, and validation before data reaches the warehouse
- **Orchestration complexity** — solved with a master/child pipeline pattern instead of a single monolithic pipeline
- **Fabric Trial limitations** — worked around semantic model publishing constraints via Power BI while preserving the intended architecture

---

## 🎓 Skills Demonstrated

**Analytics Engineering** · **Data Engineering** · **Microsoft Fabric** · **Pipeline Orchestration** · **Medallion Architecture** · **Data Warehousing** · **Dimensional Modeling** · **Semantic Modeling (DAX)** · **SQL** · **Power BI** · **Technical Documentation**

---

## 🚀 Roadmap

- [ ] Incremental refresh for large-scale ingestion
- [ ] Parameterized pipelines for multi-dataset reuse
- [ ] Deployment pipelines & CI/CD (Dev → Test → Prod)
- [ ] Scheduled/triggered pipeline execution
- [ ] Data quality monitoring & alerting
- [ ] Real-time streaming ingestion (Eventstream)

---

## 👤 Author

**Erwin Glenn Capitan II**
Analytics Engineer · Business Intelligence Analyst · Data Engineer

*This project demonstrates the complete analytics lifecycle — ingestion, orchestration, transformation, warehousing, semantic modeling, and reporting — within a single governed platform.*
