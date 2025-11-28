# SpendSense: Financial ETL and MoM Analytics Pipeline

## Project Status
**Status:** ETL and Reporting Complete (V1.0) | ML Prediction Stage Pending
**Goal:** To build a robust, production-ready pipeline for extracting unstructured financial data from PDFs, transforming it into analytics-ready records, and visualizing key financial metrics.

## Key Achievements
* **Performance:** Implemented a semi-automated ETL pipeline (Camelot, Pandas, PostgreSQL) that **cut monthly statement processing time** from ~1 hour to < 10 seconds (a ~90% reduction).
* **Data Quality:** Improved data extraction accuracy from ~84% raw to **100%** clean records; implemented robust **data-quality checks** (validation, handling, duplicate detection, category mapping).
* **Advanced Analytics:** Designed $\mathbf{SQL\ queries}$ to track spending $\mathbf{KPIs}$ and developed $\mathbf{Power\ BI}$ dashboards featuring dynamic controls to **filter non-core spending** (Rent, Transfers) and visualize **Month-over-Month (MoM) trends**.

## Technical Stack
* **Extraction & Transformation:** Python (Pandas, Camelot-Py)
* **Storage & Logic:** PostgreSQL, Advanced SQL (Window Functions, CTEs)
* **Visualization:** Power BI

## Dashboard Visualizations

### Monthly Summary KPIs
This view tracks MoM change for Spending, Income, and Net Savings, providing quick performance checks.
![Monthly KPI Summary] (./Dashboard/assets/monthly_summary.png)

### Spending Trends and Category Distribution
This view allows dynamic filtering to analyze core spending (excluding transfers/rent) and tracks category distribution over time.
![Category Trends] (./Dashboard/assets/category_trends.png)

## Setup and Installation

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/YourUsername/SpendSense-ETL.git](https://github.com/YourUsername/SpendSense-ETL.git)
    cd SpendSense-ETL
    ```
2.  **Setup Python Environment:**
    ```bash
    pip install -r requirements.txt
    ```
3.  **Database Setup:**
    * Create a PostgreSQL database named `spendsense`.
    * Run the schema setup script: `\i SQL-Scripts/01_schema_setup.sql`
4.  **Run ETL:** Execute the `ETL-Pipeline/extractv2.ipynb` notebook to process data and populate tables.
5.  **Run Analytics:** Run the KPI view script: `\i SQL-Scripts/02_kpi_views.sql`
6.  **View Dashboard:** Open `Dashboard/SpendSense_Dashboard.pbix` in Power BI Desktop.

## Roadmap (Future Development)
* Integrate Scikit-learn to build a classification model for automatic transaction category prediction.

* Containerize the ETL using Docker for easy deployment.

