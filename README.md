# E-commerce Profitability, Returns & Customer Retention Analysis

An end-to-end data analytics project involving data cleaning, business analysis and interactive dashboard development for a fictional Indian e-commerce retailer.

The project uses **Python (Pandas), MySQL and Power BI** to investigate profitability, customer retention, product returns, acquisition channels and operational performance.

> **Note:** All data is synthetic. The company, customers and transactions are fictional. All monetary values are in Indian Rupees (₹).

## 1. Business Problem

Management of an online retailer selling 12 product categories across 38 cities wants to understand:

- Where does revenue and profit come from, and how fast is it growing?
- How much profit is lost to returns, and why do customers return products?
- Which acquisition channels bring customers who come back?
- How reliable is delivery, and how satisfied are customers?
- Which customers are most valuable, and which are at risk of becoming inactive?

## 2. Dataset Overview

| Table | Raw Rows | Description |
|---|---:|---|
| Customers | 12,400 | Customer master data |
| Orders | 53,866 | One row per order, Jan 2023 – Jun 2026 |
| Order Items | 105,261 | Individual product lines |
| Products | 84 | Product master across 12 categories |

The dataset contains deliberately introduced data quality issues, including duplicate records, inconsistent labels, mixed date formats, missing values, invalid quantities, orphan keys and financial inconsistencies.

## 3. Tools & Technologies

- **Python (Pandas):** Data cleaning, transformation and validation.
- **MySQL:** Business analysis and SQL queries.
- **Power BI (DAX):** Interactive dashboards and KPI calculations.
- **GitHub:** Project documentation and version control.

## 4. Project Structure

```text
E-commerce-Analytics/
│
├── customers_raw.csv
├── orders_raw.csv
├── order_items_raw.csv
│
├── customers_analysis.csv
├── orders_analysis.csv
├── order_lines_analysis.csv
├── products.csv
│
├── Cleaning.ipynb
├── Final_Cleaning.ipynb
│
├── Queries.sql
│
├── ecom.pbix
│
├── Executive Performance & Commercial Drivers.png
├── Customer Retention & Operations.png
│
└── README.md
```

## 5. Data Cleaning & Preparation

The raw dataset contained several deliberately introduced data quality issues.

| Data Quality Issue | Cleaning Approach |
|---|---|
| Discounts above 100% (329 lines) | Recovered using stored discount amounts |
| Placeholder product ID `P000` | Mapped to the correct product using product names |
| Duplicate coupon column | Removed |
| Unit prices 10× too high | Corrected approximately 90 lines; excluded one invalid line |
| Quantity of 500 | Excluded 3 invalid records |
| Financial inconsistencies | Recalculated revenue and profit using business rules |
| Inconsistent categorical labels | Standardised payment, channel and loyalty labels |
| Missing values | Handled using appropriate imputation or blank values |
| Ages above 80 and delivery days of 0 | Set to blank |

### Profit Calculation Rules

- **Delivered:** Revenue minus product cost and shipping cost.
- **Returned:** Revenue reversed, with shipping and reverse-logistics costs accounted for. Product cost is also written off for Fragile and Perishable items.
- **Cancelled, Failed and Pending:** No recognised revenue or profit.

## 6. KPI Definitions

| KPI | Definition |
|---|---|
| Revenue | Sum of recognised revenue from delivered orders |
| Profit | Total profit across all lines, including return losses |
| Profit Margin | Total Profit / Total Revenue |
| Average Order Value | Revenue / Distinct Delivered Orders |
| Return Rate | Returned Orders / (Delivered + Returned Orders) |
| Repeat Rate | Customers with 2+ delivered orders / Customers with 1+ delivered order |
| On-Time Delivery | Delivered or returned orders arriving within promised delivery days |

## 7. Key Business Findings

### Overall Performance

| Metric | Result |
|---|---:|
| Revenue | ₹231.8M |
| Total Profit | ₹46.1M |
| Profit Margin | 19.9% |
| Delivered Orders | 43,860 |
| Average Order Value | ₹5,286 |
| Return Rate | 10.1% |
| Returns-Related Profit Loss | ~₹7.4M |
| Repeat Customer Rate | 55% |
| Average Rating | 3.88 / 5 |

### Key Insights

**1. Strong Business Growth**

Comparing January–June 2026 with the same period in 2025:

- Revenue increased by 54.1%.
- Profit increased by 58.1%.
- Delivered orders increased by 46.1%.
- Average order value increased by 5.5%.
- Profit margin improved by 0.5 percentage points.
- Return rate decreased by 0.5 percentage points.

**2. Returns Are Expensive**

Returns account for approximately ₹7.4M in profit losses.

The three leading return reasons are:
- Size/Fit issues: 16.3%
- Changed Mind: 16.0%
- Quality issues: 15.8%

**3. Acquisition Channel Performance**

Repeat rates by first-touch acquisition channel:

| Channel | Repeat Rate |
|---|---:|
| Referral | 68.9% |
| Email Marketing | 65.2% |
| Direct | 60.2% |
| Organic Search | 57.5% |
| Paid Search | 55.3% |
| Affiliate | 41.8% |
| Paid Social | 41.6% |

**4. Customer Segmentation**

Of the 7,808 customers scored using RFM analysis:

| Segment | Customers |
|---|---:|
| Hibernating | 2,804 |
| Champions | 1,904 |
| Loyal | 1,203 |
| At Risk | 1,067 |
| New | 830 |

Hibernating customers represent the largest segment and a significant win-back opportunity.

**5. Delivery Performance**

Only approximately two-thirds of orders arrive within their promised delivery time. Shipping types perform similarly, with on-time delivery rates of approximately 65–69%.

**6. Customer Ratings**

- 5 stars: 30.5%
- 4 stars: 38.6%
- 3 stars: 21.7%
- 2 stars: 7.3%
- 1 star: 2.0%

**7. Seasonal Revenue Patterns**

October to December generates the highest average monthly revenue, approximately ₹5.4M–₹5.7M, consistent with festive-season demand.

## 8. Business Recommendations

1. **Reduce Return Losses:** Improve product descriptions, size guides and quality checks to address the leading return reasons.
2. **Optimise Acquisition:** Test increasing investment in Referral and Email Marketing while evaluating the performance of Paid Social and Affiliate channels.
3. **Customer Win-Back:** Launch targeted campaigns for Hibernating and At Risk customers.
4. **Improve Delivery Reliability:** Investigate late deliveries and improve carrier performance or delivery promises.
5. **Prepare for Festive Demand:** Plan inventory and delivery capacity ahead of the October–December peak.

## 9. Power BI Dashboard

The project includes two interactive dashboard pages.

### Page 1: Executive Performance & Commercial Drivers

- Revenue, profit and profitability KPIs.
- Year-over-year performance comparisons.
- Revenue and profit by product category.
- Top-performing products.
- Monthly revenue trends.
- Order status distribution.
- Return reason analysis.
- Acquisition channel performance.

### Page 2: Customer Retention & Operations

- Customer retention KPIs.
- RFM customer segmentation.
- On-time delivery by shipping type.
- Month-over-month revenue growth.
- Customer rating distribution.
- Customer support ticket analysis.

## 10. Project Limitations

- Approximately 23% of orders have no usable order date. Monthly and year-over-year analysis uses the remaining 77%.
- Approximately 5% of orders reference customers missing from the cleaned customer table.
- 3,316 customers cannot be included in RFM scoring.
- Approximately 49% of orders have no rating.
- Customer Acquisition Cost (CAC) and Return on Ad Spend (ROAS) cannot be calculated because marketing spend is unavailable.
- The dataset is synthetic, so some relationships may be more structured than those found in real-world business data.

## 11. How to Run the Project

1. Clone or download this repository.
2. Install the required Python libraries, including Pandas and Jupyter Notebook.
3. Open `Final_Cleaning.ipynb` to review and reproduce the final data cleaning process.
4. Import the cleaned CSV files into MySQL:
   - `customers_analysis.csv`
   - `orders_analysis.csv`
   - `order_lines_analysis.csv`
   - `products.csv`
5. Execute `Queries.sql` in MySQL to reproduce the business analysis.
6. Open `ecom.pbix` using Power BI Desktop to explore the interactive dashboards.

---

## 12. Project Objective

This project demonstrates an end-to-end data analytics workflow, from handling messy relational data to extracting business insights and communicating findings through interactive dashboards.

**Key Skills Demonstrated:** Data Cleaning · Data Validation · SQL Analysis · Business Intelligence · DAX · Customer Segmentation · Profitability Analysis · Data Visualisation
