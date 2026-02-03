# IFRS License Calculation ETL DBT Project

This project implements the data pipeline for `WRK_IFRS_LIC_CALC` in Snowflake using DBT, replacing legacy Informatica workflows. The pipeline uses best practice modular staging and a mart build, closely matching the business logic and transformations of the original Informatica mapping. See `models/marts/wrk_ifrs_lic_calc.sql` for the final union of all partitions.

## Project Structure
- **models/staging/**: Single model per raw/lookup source table (light cleans/casts; 1:1 logical mapping)
- **models/marts/**: Mart model (`wrk_ifrs_lic_calc.sql`) implementing six partitioned CTEs, final union, and all business rules
- **models/schema.yml**: All model & column documentation + core tests

## Orchestration
- All staging tables run in parallel. Final mart builds after all staging.
- No incremental builds: full-rebuild only for WRK_IFRS_LIC_CALC

## Developer Onboarding
- Install dbt-snowflake and configure your Snowflake target/profile
- Adjust variables as needed in `dbt_project.yml`
- Run `dbt run`

