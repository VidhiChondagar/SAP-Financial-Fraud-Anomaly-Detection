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

🗄️ Data Model
Transaction Table
ZVT_TRANSACTION
The transaction table stores financial transaction information such as:
- Transaction ID
- Vendor ID
- Invoice ID
- Transaction Date
- Transaction Time
- Amount
- Currency
- Payment Method
- Transaction Status
- Risk Score
- Risk Level
- Review Status
- Created By
- Created At
- Last Changed At
Anomaly Table
ZVT_ANOMALY
The anomaly table stores anomalies detected for transactions.
A single transaction can have multiple detected anomalies, creating a one-to-many relationship between transactions and anomalies.
Anomaly information includes:
- Anomaly ID
- Transaction ID
- Anomaly Type
- Description
- Risk Points
- Detected At
- Resolution Status

📦 SAP RAP Objects
Interface CDS Views
- ZVI_TRANSACTION
- ZVI_ANOMALY
Projection CDS Views
- ZVC_TRANSACTION
- ZVC_ANOMALY
Behavior Definition
The application uses a managed RAP business object with behavior definitions for transaction and anomaly management.
Supported operations and actions include:
- Create Transaction
- Update Transaction
- Delete Transaction
- Analyze Transaction
- Mark Under Review
- Clear Transaction
- Confirm Suspicious
- Resolve Anomaly
Service Definition
ZUI_FINANCIAL_FRAUD
The service exposes the transaction and anomaly projection views to the Fiori Elements application.

⚙️ Business Logic
When a transaction is analyzed, the ABAP behavior implementation evaluates the transaction against the defined anomaly rules.
For each detected anomaly:
1. The corresponding anomaly is created in ZVT_ANOMALY.
2. Risk points are assigned.
3. The total risk score is calculated.
4. The corresponding risk level is determined.
5. The transaction is updated with the calculated risk information.
The system also prevents duplicate creation of the same anomaly by checking whether the anomaly already exists before inserting it.

🔄 Transaction Review Workflow
Transactions can be reviewed using the available RAP actions.

              ┌────────────────┐
              │      NEW       │
              └───────┬────────┘
                      │
                      ▼
            ┌────────────────────┐
            │   UNDER_REVIEW     │
            └─────────┬──────────┘
                      │
             ┌────────┴─────────┐
             ▼                  ▼
       ┌───────────┐    ┌─────────────────────┐
       │  CLEARED  │    │ CONFIRMED_SUSPICIOUS│
       └───────────┘    └─────────────────────┘

Available Actions
Mark Under Review
Changes the transaction review status to:
UNDER_REVIEW
Clear Transaction
Changes the review status to:
CLEARED
Confirm Suspicious
Changes the review status to:
CONFIRMED_SUSPICIOUS

🔎 Anomaly Resolution
Detected anomalies initially have the resolution status:
OPEN
Users can open an anomaly from the Detected Anomalies section and use the Resolve Anomaly action.
OPEN
  │
  ▼
RESOLVED

🖥️ SAP Fiori Elements UI
The application provides a Fiori Elements interface containing:
Transaction List Report
Displays financial transactions and their calculated risk information.
Transaction Object Page
Displays transaction details and provides actions such as:
- Analyze Transaction
- Mark Under Review
- Clear Transaction
- Confirm Suspicious
Detected Anomalies
The Transaction Object Page contains a Detected Anomalies section showing anomalies associated with the selected transaction.
Anomaly Object Page
Displays:
- Anomaly ID
- Anomaly Type
- Description
- Risk Points
- Detected At
- Resolution Status
The page also provides the Resolve Anomaly action.

🛠️ Technologies Used
- SAP ABAP
- ABAP RESTful Application Programming Model (RAP)
- Core Data Services (CDS)
- ABAP Behavior Definitions
- ABAP Behavior Implementation
- ABAP EML
- OData V2
- SAP Fiori Elements
- SAP HANA
- Eclipse ADT

📚 Learning Outcomes
Through this project, I worked with:
- Managed RAP Business Objects
- CDS Interface and Projection Views
- RAP Behavior Definitions
- RAP Behavior Implementations
- ABAP EML
- RAP Actions
- Instance Authorization
- Parent-child entity relationships
- OData services
- Fiori Elements
- SAP HANA persistence
- Business-rule-based anomaly detection

  👨‍💻 Author
Vidhi Chondagar
Final Year BE Information Technology Student
Interested in SAP ABAP, RAP, SAP HANA, Fiori Elements and enterprise application development.
