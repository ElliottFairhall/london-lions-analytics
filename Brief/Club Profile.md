# Project Brief: London Lions Player Analytics Platform (SPV)

## Overview

The objective of this project is to implement a **Single Player View (SPV)** and high-performance analytics platform for
the **London Lions Football Club**. The platform integrates performance, market valuation, and transfer data from the
Transfermarkt dataset into a governed Snowflake Medallion architecture. Historically, recruiting and valuation data
resided in fragmented spreadsheets; this initiative centralises that data to drive "Recruitment Alpha" and strategic
squad management.

## Club History

The London Lions FC was established in 1901 in the heart of East London. Known as "The Pride of the East," the club has
a storied history in the English football pyramid, recently achieving promotion to the Premier League. In 2024, the club
was acquired by a global sports investment group with a mission to transform the Lions into a top-six continental
powerhouse. Central to this mission is the transition from traditional, gut-based scouting to a **data-first recruitment
and performance model**.

## Club Structure

The London Lions executive leadership is committed to technical excellence on and off the pitch:

- **CEO**: Isabella Thorne – Strategic oversight and global brand positioning.
- **Director of Football**: Arthur Lionheart – Responsible for squad construction and long-term technical strategy.
- **Head of Analytics**: Magnus Sterling – Oversight of the London Lions Analytics Platform and SPV initiative.
- **Club Secretary**: Alistair Vance – Management of player registrations, contracts, and regulatory adherence.
- **Chief Scout**: Marcus Crane – Integration of data-driven intelligence into traditional scouting workflows.

## Business Requirements

The SPV initiative must address the following key requirements:

- **Single Player View (360)**: A consolidated profile for every player in the scouting database, linking match
  performance to market value.
- **Recruitment Alpha**: Identification of undervalued talent in international leagues using metrics like "G/A per 90"
  and "Relative Market Value Trend."
- **Valuation Intelligence**: Real-time tracking of market value changes to optimize the timing of sales and
  acquisitions for maximum ROI.
- **SCD Type 2 History**: Full historical tracking of player migrations and valuation curves to understand career
  trajectories and performance peaks.
- **Squad Gap Analysis**: Automatic classification of players as "Squad Member" vs. "Scouting Target" based on current
  roster composition and performance benchmarks.

## Technical Standards

The platform is engineered on Snowflake using a medallion architecture to ensure data integrity and scalability:

- **UK Standardisation**: All terminology, documentation, and reporting follow UK English standards (e.g., *football,
  programme, standardisation*).
- **Medallion Pipeline**: Data flows through **Staging** (raw ingestion), **ODS** (deduplicated operational store), and
  **Domain** (analytical facts and dimensions).
- **Change Detection**: Implementation of **MD5 Hashing** for all entity layers to ensure idempotent loads and efficient
  delta processing.
- **Governance**: Row-level masking of sensitive player financial data to ensure scouting secrecy and compliance with
  sport administration standards.

## Project Methodology

This project follows an **Agile-Medallion approach**, focusing on delivering value layer-by-layer. Sprints focus on
specific entity integration (Players, Clubs, Appearances), culminating in the production of the `VW_PLAYER_360`
analytical layer for the Lions' technical staff.
