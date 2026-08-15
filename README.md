# E-commerce Sales & Customer Behaviour Analysis

## Project Overview

This project analyzes e-commerce sales performance, product
profitability, refunds, website sessions, and customer behaviour using
**SQL, Power BI, and DAX**.

The goal is to turn raw transactional and website data into a
business-focused dashboard that helps identify revenue trends, product
performance, refund patterns, device behaviour, and customer retention
opportunities.

------------------------------------------------------------------------

## Tools & Technologies

-   **SQL (MySQL)** --- data exploration, validation, conversion
    analysis, sales analysis, product analysis, refund analysis, and
    data-quality checks
-   **Power BI** --- interactive dashboard and data visualization
-   **DAX** --- calculated measures and KPIs

------------------------------------------------------------------------

## Data Areas

The analysis uses the following datasets:

-   Orders
-   Order Items
-   Products
-   Order Item Refunds
-   Website Sessions
-   Website Pageviews

------------------------------------------------------------------------

## Dashboard

The Power BI report contains three pages:

1.  **Sales Overview**
2.  **Product Performance**
3.  **Customer & Website Behaviour**

### Sales Overview

Provides a high-level view of business performance, including:

-   Net Revenue
-   Net Gross Profit
-   Total Orders
-   Net Margin
-   Total Refunds
-   Average Order Value
-   Monthly Net Revenue Trend
-   Net Revenue by Product
-   Refunds by Product
-   Orders by Device

![Sales Overview](Screenshots/sales_overview.png)

### Product Performance

Focuses on product-level revenue, profitability, refunds, and gross
margin.

Key visuals include:

-   Net Revenue by Product
-   Gross Profit by Product
-   Refunds by Product
-   Gross Margin by Product

![Product Performance](Screenshots/product_performance.png)

### Customer & Website Behaviour

Analyzes website engagement and session behaviour.

Key metrics and visuals include:

-   Total Users
-   Total Sessions
-   Repeat Sessions
-   Desktop Sessions
-   Mobile Sessions
-   Monthly Sessions & Users
-   Sessions by Device
-   New vs Repeat Sessions

![Customer & Website
Behaviour](Screenshots/customer_behaviour.png)

------------------------------------------------------------------------

## Key DAX Measures

### Core Sales Measures

``` dax
Total Revenue =
SUM(Orders[price_usd])

Total Refunds =
SUM(Refunds[refund_amount_usd])

Net Revenue =
[Total Revenue] - [Total Refunds]

Total COGS =
SUM(Orders[cogs_usd])

Net Gross Profit =
[Net Revenue] - [Total COGS]

Net Margin % =
DIVIDE([Net Gross Profit], [Net Revenue])
```

### Order Measures

``` dax
Total Orders =
DISTINCTCOUNT(Orders[order_id])
```

### Product Measures

``` dax
Product Revenue =
SUM(order_items[price_usd])

Product COGS =
SUM(order_items[cogs_usd])

Product Gross Profit =
[Product Revenue] - [Product COGS]

Product Gross Margin % =
DIVIDE([Product Gross Profit], [Product Revenue])
```

### Website & Session Measures

``` dax
Total Sessions =
COUNTROWS(website_sessions)

Total Users =
DISTINCTCOUNT(website_sessions[user_id])

Repeat Sessions =
SUM(website_sessions[is_repeat_session])

Desktop Sessions =
CALCULATE(
    [Total Sessions],
    website_sessions[device_type] = "desktop"
)

Mobile Sessions =
CALCULATE(
    [Total Sessions],
    website_sessions[device_type] = "mobile"
)
```

A calculated column was also created to classify sessions as **New** or
**Repeat**.

------------------------------------------------------------------------

## SQL Analysis Workflow

The SQL analysis was organized into separate files:

``` text
sql/
├── 01_data_exploration.sql
├── 02_conversion_analysis.sql
├── 03_sales_analysis.sql
├── 04_product_analysis.sql
├── 05_refund_analysis.sql
└── 06_data_quality.sql
```

The workflow covers:

1.  Data exploration and validation
2.  Website conversion analysis
3.  Sales and revenue analysis
4.  Product performance analysis
5.  Refund analysis
6.  Data-quality checks

------------------------------------------------------------------------

## Key Business Insights

### 1. Revenue & Profitability

The business generated approximately **\$1.85M in net revenue** and
**\$1.13M in net gross profit**, resulting in a net margin of
approximately **61%**.

### 2. Revenue Trend

Monthly net revenue shows a strong upward trend across the observed
period, with the highest levels occurring toward the end of the dataset.

The decline in the final month should be interpreted cautiously if the
month represents only a partial period.

### 3. Product Concentration

**The Original Mr. Fuzzy** is the strongest-performing product by net
revenue and gross profit, significantly outperforming the other
products.

### 4. Product Profitability

The Original Mr. Fuzzy generates the highest revenue and gross profit
but has the lowest gross margin among the four products.

This suggests that its strong sales volume does not necessarily
translate into the strongest profitability percentage.

### 5. Refunds

The Original Mr. Fuzzy has the highest absolute refund amount.

Because it also has the highest sales volume, refund performance should
be evaluated using a **refund rate**, rather than absolute refund value
alone.

### 6. Device Behaviour

Desktop accounts for approximately **69% of sessions**, while mobile
accounts for approximately **31%**.

### 7. Customer Retention

Approximately **83% of sessions are new sessions** and **17% are repeat
sessions**.

This indicates an opportunity to improve repeat engagement and customer
retention.

------------------------------------------------------------------------

## Business Recommendations

### Protect and Improve the Leading Product

The Original Mr. Fuzzy is the strongest product by revenue and gross
profit.

Potential actions include:

-   Review COGS and supplier costs
-   Evaluate pricing opportunities
-   Review discounts and promotions
-   Investigate packaging and fulfillment costs

### Investigate Lower Gross Margin

Although The Original Mr. Fuzzy generates the highest revenue, its gross
margin is lower than the other products.

Management should investigate whether unit costs, pricing, or promotions
are reducing profitability.

### Increase Sales of Other Products

The lower-volume products could benefit from:

-   Cross-selling
-   Product bundles
-   Checkout recommendations
-   Product-specific promotions

Examples include pairing Mr. Fuzzy with Forever Love Bear or using
themed promotions for Birthday Sugar Panda.

### Investigate Refund Rates

The Original Mr. Fuzzy has the highest absolute refund value, but its
larger sales volume may explain part of this result.

Refund rate should therefore be monitored by product before taking
corrective action.

### Improve Customer Retention

With approximately 17% of sessions classified as repeat sessions,
opportunities include:

-   Post-purchase email campaigns
-   Personalized product recommendations
-   Loyalty incentives
-   Remarketing campaigns

### Optimize the Mobile Experience

Mobile represents approximately one-third of website sessions.

The business should ensure the mobile experience is:

-   Fast
-   Easy to navigate
-   Optimized for product discovery
-   Optimized for checkout

------------------------------------------------------------------------

## Project Structure

``` text
data_analysis_project_01/
│
├── README.md
│
├── dashboard/
│   ├── sales-overview.png
│   ├── product-performance.png
│   └── customer-website-behaviour.png
│
├── sql/
│   ├── 01_data_exploration.sql
│   ├── 02_conversion_analysis.sql
│   ├── 03_sales_analysis.sql
│   ├── 04_product_analysis.sql
│   ├── 05_refund_analysis.sql
│   └── 06_data_quality.sql
│
└── powerbi/
    └── data_analysis_project_01.pbix
```

------------------------------------------------------------------------

## Conclusion

This project demonstrates an end-to-end analytics workflow:

**Raw Data → SQL Analysis → Data Validation → DAX Measures → Power BI
Dashboard → Business Insights → Recommendations**

The analysis combines financial performance with product and customer
behaviour to provide a broader view of the e-commerce business and
identify practical areas for improvement.
