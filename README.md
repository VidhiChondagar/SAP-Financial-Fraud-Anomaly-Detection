# SAP Financial Transaction Fraud & Anomaly Detection System

A SAP ABAP RAP-based financial transaction monitoring system that detects suspicious transaction patterns using rule-based anomaly detection and calculates risk scores for review.

## 📌 Project Overview

This project demonstrates how SAP's RESTful Application Programming Model (RAP) can be used to build a transaction monitoring application with a Fiori Elements user interface.

The system analyzes financial transactions against predefined business rules, identifies anomalies, assigns risk points, calculates an overall risk score and risk level, and allows users to review and resolve detected anomalies.

> Note: This is a rule-based anomaly detection system developed for demonstration and portfolio purposes. It does not use external APIs, AI services, or machine-learning models.

## 🎯 Key Features

- Transaction management using SAP RAP
- Rule-based anomaly detection
- Automatic risk score calculation
- Risk level classification
- Duplicate invoice detection
- High transaction amount detection
- High vendor transaction frequency detection
- Unusual transaction timing detection
- Multiple transactions for the same vendor on the same date
- Transaction review workflow
- Anomaly resolution workflow
- Parent-child transaction and anomaly relationship
- SAP Fiori Elements List Report and Object Page

## 🔍 Anomaly Detection Rules

| Rule | Risk Points |
|------|-------------|
| Duplicate Invoice | +40 |
| High Amount | +30 |
| High Vendor Frequency | +20 |
| Unusual Transaction Time | +20 |
| Multiple Transactions | +20 |

### Risk Levels

| Risk Score | Risk Level |
|------------|------------|
| 0–29 | LOW |
| 30–59 | MEDIUM |
| 60–79 | HIGH |
| 80+ | CRITICAL |

## 🏗️ SAP Architecture

The application follows a managed RAP architecture.

```text
SAP Fiori Elements
        │
        ▼
OData V2 Service
        │
        ▼
Projection CDS Views
        │
        ▼
Interface CDS Views
        │
        ▼
Managed RAP Business Object
        │
        ▼
ABAP Behavior Implementation
        │
        ▼
SAP HANA Database Tables
