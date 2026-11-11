# SAP ABAP CLASSIC (ECC / Netweaver)

## 🎯 Business Use Case #1: During a corporate merger or system rollout, a massive volume of legacy user accounts (or master data) must be migrated into the SAP system. When standard BAPIs are unavailable or custom screen validations must be strictly enforced, the classic Batch Input (RPA) mechanism is required. This project simulates an automated ETL (Extract, Transform, Load) scenario to migrate legacy users into SAP via the SU01 (User Maintenance) transaction.

## 🏗️ Technical Architecture: 
- [x] **Data Source:** Local CSV file (semicolon-separated). 
- [x] **Frontend Integration:** CL_GUI_FRONTEND_SERVICES API for local file handling and directory navigation. 
- [x] **Core Technology:** Batch Input (BDC) utilizing SHDB transaction recordings.
- [x] **Target Transaction:** SU01 (User Management).

Session Management: SM35 for batch processing and error logging.

## ⚙️ Execution Flow & Class Architecture:
- [x] **Data Extraction:** The ABAP report triggers a native OS file explorer dialog, allowing the user to select the CSV file. The data is loaded into an internal table using the GUI_UPLOAD method.
- [x] **Data Transformation:** The program iterates through the internal table. Generic string types are used in the initial extraction phase to prevent ABAP short dumps caused by unexpected file formatting.
- [x] **BDC Session Generation:** The BDC_OPEN_GROUP function initializes a new session. The program maps the CSV fields to the technical SAP Dynpro fields (BDCDATA structure) using modularized FORM routines (bdc_dynpro and bdc_field).
- [x] **Data Load:** BDC_INSERT pushes the transactional data into the SAP queue, followed by BDC_CLOSE_GROUP.
- [x] **Execution:** The session is processed via SM35 using the Display errors only mode and Default Dynpro Size parameter to guarantee UI consistency and robust error handling.

## 🛠️ Key Features Implemented:
- [x] **Clean Code Modularization:** Elimination of redundant BDCDATA mapping logic by encapsulating the SAP screen navigation and field population into reusable FORM subroutines (adhering to DRY principles).
- [x] **Defensive Programming:** Implementation of TYPE string for raw file parsing to capture oversized inputs gracefully, allowing the system to log field-length errors in SM35 instead of crashing the ABAP program.
- [x] **Modern ABAP Syntax:** Utilization of inline declarations (DATA(...)) to dynamically assign table structures without strictly typing them in the Data Dictionary.
- [x] **Robust Error Handling:** System return code (SY-SUBRC) validations at every step (file selection, upload, and session creation) with appropriate SAP message semantic types (S and E).

## 👨‍💻 About the Developer
I am an IT Engineer and Software Developer specializing in SAP ABAP, S/4HANA architecture, and Java.
With a robust background integrating cross-border financial systems and ERPs (SAP, Navision, SAGE), I build resilient technical solutions grounded in deep business process understanding.
[🔗 Connect with me on LinkedIn](https://linkedin.com/in/luispinto82/) | 💻 **GitHub:** [@vorator](https://github.com/vorator)
