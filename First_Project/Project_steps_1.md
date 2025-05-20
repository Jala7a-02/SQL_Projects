# 📊 Exploratory Data Analysis (EDA)

This document outlines the step-by-step SQL-based EDA process used to explore and understand the dataset.

---

## 1️⃣ Data Overview

* Get a general understanding of the dataset you're working with.
* Check the number of rows, columns, and types of data.
* Look for missing values and duplicates.



---

## 2️⃣ Dimensions Exploration

* Identify the **unique values** in each categorical field.
* Recognize how the data can be **grouped or segmented**.
* Useful for filtering and drill-down analysis.

```sql
SELECT DISTINCT column_name FROM table_name;
```

---

## 3️⃣ Date Exploration

* Determine the **earliest** and **latest** timestamps.
* Understand the **time span** and **range** of the data.

```sql
SELECT MIN(date_column), MAX(date_column) FROM table_name;
```

---

## 4️⃣ Measures Exploration

* Calculate key business metrics (also known as **Big Numbers**).
* Understand metrics at both a **summary** and **detailed** level.

```sql
SELECT SUM(measure_column), AVG(measure_column) FROM table_name;
```

---

## 5️⃣ Magnitude by Category

* Compare measure values **across dimensions**.
* Understand the relative importance or contribution of categories.

```sql
SELECT category_column, SUM(measure_column)
FROM table_name
GROUP BY category_column;
```

---

## 6️⃣ Ranking & Performance

* Rank dimensions based on their aggregated values.
* Identify **Top N** or **Bottom N** performers.

```sql
SELECT category_column, SUM(measure_column) AS total_value
FROM table_name
GROUP BY category_column
ORDER BY total_value DESC
LIMIT 10;
```

---

> ✨ This EDA process sets a strong foundation for deeper analytics, dashboard creation, or machine learning pipelines.
