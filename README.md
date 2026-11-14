# SAP ABAP CLASSIC (ECC / Netweaver)

## 🎯 Business Use Case #1 Batch mass import (users): 
BDuring a corporate merger or system rollout, a massive volume of legacy user accounts (or master data) must be migrated into the SAP system. When standard BAPIs are unavailable or custom screen validations must be strictly enforced, the classic Batch Input (RPA) mechanism is required. This project simulates an automated ETL (Extract, Transform, Load) scenario to migrate legacy users into SAP via the SU01 (User Maintenance) transaction.

## 🏗️ Technical Architecture: 
- **Data Source:** Local CSV file (semicolon-separated). 
- **Frontend Integration:** CL_GUI_FRONTEND_SERVICES API for local file handling and directory navigation. 
- **Core Technology:** Batch Input (BDC) utilizing SHDB transaction recordings.
- **Target Transaction:** SU01 (User Management).
- **Session Management:** SM35 for batch processing and error logging.

## ⚙️ Execution Flow & Class Architecture:
1 **Data Extraction:** The ABAP report triggers a native OS file explorer dialog, allowing the user to select the CSV file. The data is loaded into an internal table using the GUI_UPLOAD method.
2 **Data Transformation:** The program iterates through the internal table. Generic string types are used in the initial extraction phase to prevent ABAP short dumps caused by unexpected file formatting.
3 **BDC Session Generation:** The BDC_OPEN_GROUP function initializes a new session. The program maps the CSV fields to the technical SAP Dynpro fields (BDCDATA structure) using modularized FORM routines (bdc_dynpro and bdc_field).
4 **Data Load:** BDC_INSERT pushes the transactional data into the SAP queue, followed by BDC_CLOSE_GROUP.
5 **Execution:** The session is processed via SM35 using the Display errors only mode and Default Dynpro Size parameter to guarantee UI consistency and robust error handling.

## 🛠️ Key Features Implemented:
- [x] **Clean Code Modularization:** Elimination of redundant BDCDATA mapping logic by encapsulating the SAP screen navigation and field population into reusable FORM subroutines (adhering to DRY principles).
- [x] **Defensive Programming:** Implementation of TYPE string for raw file parsing to capture oversized inputs gracefully, allowing the system to log field-length errors in SM35 instead of crashing the ABAP program.
- [x] **Modern ABAP Syntax:** Utilization of inline declarations (DATA(...)) to dynamically assign table structures without strictly typing them in the Data Dictionary.
- [x] **Robust Error Handling:** System return code (SY-SUBRC) validations at every step (file selection, upload, and session creation) with appropriate SAP message semantic types (S and E).

---
## 🎯 Business Use Case #2. BAPI Automaton & LUW Governance (Flight Model): 
The business requires a robust, automated interface to create reservations (simulating a Financial GL posting automaton) originating from external systems. The program must enforce strict data validation before committing any records to the database, ensuring that incomplete or invalid entries are rejected and logged comprehensively.

## 🏗️ Technical Architecture: 
- **Data Input:** SAP Standard Selection Screen.
- **Core Technology:** Business Application Programming Interface (BAPI) - `BAPI_FLBOOKING_CREATEFROMDATA`.
- **Transaction Control:** Logical Unit of Work (LUW) managed via `BAPI_TRANSACTION_COMMIT` and `BAPI_TRANSACTION_ROLLBACK`.
- **Frontend Output:** Object-Oriented ALV Grid (`CL_SALV_TABLE`).

## ⚙️ Execution Flow & Class Architecture: 
1 ***Data Mapping:** Variables from the selection screen are mapped into the `BAPISBONEW` input structure.
2 **BAPI Execution:** The BAPI validates the data referential integrity (optionally utilizing the `TEST_RUN` parameter for safe simulation).
3 **Error Evaluation:** The `BAPIRET2` return table is parsed. The program scans for Error (`E`) or Abort (`A`) message types.
4 **LUW Management:** If any error is detected, `BAPI_TRANSACTION_ROLLBACK` is explicitly called to clear the memory. If the validation is flawless, `BAPI_TRANSACTION_COMMIT` (with `WAIT = 'X'`) is triggered to safely persist the data.
5 **Reporting:** `CL_SALV_TABLE=>FACTORY` is instantiated within a `TRY...CATCH` block to dynamically generate and display the execution logs to the user.

## 🛠️ Key Features Implemented:
- **Defensive BAPI Calling:** Implemented `TEST_RUN` parameters to allow users to simulate database changes safely without altering physical tables.
- **Strict LUW Governance:** Enforced explicit Database Commits only upon absolute validation success, avoiding partial data dumps and ensuring database integrity.
- **Modern ALV Reporting:** Replaced legacy procedimental function modules (`REUSE_ALV`) with the `CL_SALV_TABLE` class for cleaner, object-oriented grid rendering and automatic column optimization.

---
## 🎯 Business Use Case #3 Standard Code Extension (Enhancement Framework & Clean Code):
Business stakeholders required a new fraud-prevention rule: 1st Class flight tickets cannot be booked if the base flight price is below 500 EUR. Because the reservation creation is handled by a standard SAP function module (`BAPI_FLBOOKING_CREATEFROMDATA`), the core system behavior had to be altered without modifying standard SAP code (avoiding modification keys and preserving upgradeability).

## 🏗️ Technical Architecture: 
*   **Extension Technology:** Implicit Enhancement (Enhancement Framework).
*   **Business Logic Container:** Global ABAP Class (`ZCL_FLIGHT_MARGIN_CHECK`).
*   **Data Retrieval:** Defensive Open SQL (`SELECT SINGLE`).
*   **Error Handling:** BAPI-Compliant error mapping (`BAPIRET2`).

## ⚙️ Execution Flow & Class Architecture: 
1.  **Code Injection:** An Implicit Enhancement (`Z_ENH_FLIGHT_MARGIN`) was created at the very beginning of the standard BAPI function module.
2.  **Separation of Concerns:** Instead of hardcoding business rules inside the enhancement spot, the standard code simply delegates the payload to a static method of the Global Class.
3.  **Early Return & Database Read:** The class method immediately returns if the booking is not '1st Class' (Performance Optimization). If it is, it queries the database (`SFLIGHT`) to fetch the base price, strictly verifying the `SY-SUBRC` system variable.
4.  **Interception & Exit:** If the rule is violated, the class returns an ABAP boolean flag and appends a formatted error to the BAPI return table. The enhancement catches this flag and triggers an `EXIT` statement, safely aborting the standard SAP LUW before any database commit occurs.

## 🛠️ Key Features Implemented:
*   **Clean Code in Legacy Systems:** Demonstrated the ability to intervene in legacy procedural SAP code while maintaining business logic fully encapsulated in Object-Oriented classes.
*   **Defensive Programming:** Implemented strict `SY-SUBRC` checks on database reads to prevent false positives and system dumps when evaluating business rules.
*   **Zero-Modification Extensibility:** Altered core system behavior utilizing SAP's official Enhancement Framework, ensuring the system remains clean and easily upgradable.

## 👨‍💻 About the Developer
I am an IT Engineer and Software Developer specializing in SAP ABAP, S/4HANA architecture, and Java.
With a robust background integrating cross-border financial systems and ERPs (SAP, Navision, SAGE), I build resilient technical solutions grounded in deep business process understanding.
[🔗 Connect with me on LinkedIn](https://linkedin.com/in/luispinto82/) | 💻 **GitHub:** [@vorator](https://github.com/vorator)
