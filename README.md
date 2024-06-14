# Layoffs Data Analysis

This repository contains the analysis of layoffs data obtained from Kaggle, focusing on cleaning the data, exploring trends, and identifying patterns.

## Data Source

The layoffs data was sourced from Kaggle:
- Dataset: [Layoffs 2022](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

## Data Import and Processing

### Step 1: Data Import

The data was downloaded from Kaggle and imported into MySQL for analysis.

### Step 2: Creating Staging Tables

Two staging tables were created in MySQL to facilitate data cleaning and transformation:

- **staging_layoffs_raw**: Initial staging table for the raw data import.
- **staging_layoffs_cleaned**: Staging table for cleaned and transformed data.

### Step 3: Data Cleaning Process

The data cleaning process involved the following steps:

- **Removing Duplication**: Identified and removed duplicate records.
  
- **Data Standardization and Fixing**: Standardized formats and fixed any inconsistencies in data entries.
  
- **Null Values Checking**: Examined and handled null values as per data requirements.
  
- **Removing Unnecessary Columns**: Eliminated columns not relevant to the analysis to streamline the dataset.

### Step 4: Data Analysis

#### Exploratory Data Analysis (EDA)

Performed exploratory data analysis to:

- **Explore Data**: Investigated distributions, summary statistics, and relationships among variables.
  
- **Find Trends and Patterns**: Identified trends and patterns in the layoffs data.
  
- **Check Outliers**: Detected outliers and analyzed their impact on the dataset.

## Usage

To replicate this analysis:

1. Download the layoffs dataset from Kaggle.
2. Import the dataset into MySQL or your preferred SQL database.
3. Execute the SQL scripts provided in the `scripts/` directory for data cleaning and analysis.
4. Use Jupyter notebooks in `notebooks/` for detailed exploration and visualization.
