# 🎯 Business Use Case #3 Standard Code Extension (Enhancement Framework & Clean Code):
Business stakeholders required a new fraud-prevention rule: 1st Class flight tickets cannot be booked if the base flight price is below 500 EUR. Because the reservation creation is handled by a standard SAP function module (`BAPI_FLBOOKING_CREATEFROMDATA`), the core system behavior had to be altered without modifying standard SAP code (avoiding modification keys and preserving upgradeability).

### 🏗️ Technical Architecture: 
* **Extension Technology:** Implicit Enhancement (Enhancement Framework).
* **Business Logic Container:** Global ABAP Class (`ZCL_FLIGHT_MARGIN_CHECK`).
* **Data Retrieval:** Defensive Open SQL (`SELECT SINGLE`).
* **Error Handling:** BAPI-Compliant error mapping (`BAPIRET2`).

### ⚙️ Execution Flow & Class Architecture: 
1. **Code Injection:** An Implicit Enhancement (`Z_ENH_FLIGHT_MARGIN`) was created at the very beginning of the standard BAPI function module.
2. **Separation of Concerns:** Instead of hardcoding business rules inside the enhancement spot, the standard code simply delegates the payload to a static method of the Global Class.
3. **Early Return & Database Read:** The class method immediately returns if the booking is not '1st Class' (Performance Optimization). If it is, it queries the database (`SFLIGHT`) to fetch the base price, strictly verifying the `SY-SUBRC` system variable.
4. **Interception & Exit:** If the rule is violated, the class returns an ABAP boolean flag and appends a formatted error to the BAPI return table. The enhancement catches this flag and triggers an `EXIT` statement, safely aborting the standard SAP LUW before any database commit occurs.

### 🛠️ Key Features Implemented:
* [x] **Clean Code in Legacy Systems:** Demonstrated the ability to intervene in legacy procedural SAP code while maintaining business logic fully encapsulated in Object-Oriented classes.
* [x] **Defensive Programming:** Implemented strict `SY-SUBRC` checks on database reads to prevent false positives and system dumps when evaluating business rules.
* [x] **Zero-Modification Extensibility:** Altered core system behavior utilizing SAP's official Enhancement Framework, ensuring the system remains clean and easily upgradable.

---
# 🎯 Business Use Case #4 Framework Architecture (Custom BAdIs & Inversion of Control)
The airline introduced a new luggage policy rejecting bookings exceeding 20kg of base luggage. Rather than hardcoding this volatile business rule into the standard system flow, the requirement was to build a scalable, plug-and-play architecture where luggage rules can be activated, deactivated, or versioned without touching standard SAP code.

### 🏗️ Technical Architecture: 
* **Framework Foundation:** Custom BAdI Definition / Enhancement Spot (`ZES_FLIGHT_BOOKING`).
* **Contract:** Object-Oriented BAdI Interface (`ZIF_BADI_CHECK_LUGGAGE`).
* **Business Logic:** BAdI Implementation Class (`ZCL_IM_CHECK_LUGGAGE`).
* **Integration:** Implicit Enhancement utilizing modern `GET BADI` and `CALL BADI` statements.

### ⚙️ Execution Flow & Class Architecture: 
1. **Framework Creation:** A Kernel BAdI was created from scratch via SE18, defining an instance method interface to receive luggage weight and export a boolean rejection flag.
2. **Implementation:** A single-use BAdI implementation was developed via SE19 to enforce the 20kg threshold.
3. **Loose Coupling (IoC):** The standard SAP BAPI was extended via Implicit Enhancement. Instead of calling a specific class, the BAPI requests any active BAdI implementations via `GET BADI`. 
4. **Graceful Degradation:** Wrapped in a `TRY...CATCH cx_badi_not_implemented` block, the system ensures that if the BAdI implementation is ever deactivated (e.g., policy revoked), the standard booking flow continues flawlessly without causing system dumps.

### 🛠️ Key Features Implemented:
* [x] **Inversion of Control:** Demonstrated advanced architectural patterns by decoupling the standard execution flow from the actual business logic implementation.
* [x] **BAdI Lifecycle Management:** Mastered both sides of the Enhancement Framework: acting as a Framework Architect (SE18) and a Business Developer (SE19).
* [x] **Future-Proofing:** Eliminated tight coupling, ensuring the business rule can be modified or disabled purely through configuration/activation states without requiring standard code transports.

### 📸 Showcase
<img width="3839" height="1052" alt="image" src="https://github.com/user-attachments/assets/cde848f4-b842-43fc-a9ff-25402f137774" />

---
## 👨‍💻 About the Developer
I am an IT Engineer and Software Developer specializing in SAP ABAP, S/4HANA architecture, and Java.
With a robust background integrating cross-border financial systems and ERPs (SAP, Navision, SAGE), I build resilient technical solutions grounded in deep business process understanding.
[🔗 Connect with me on LinkedIn](https://linkedin.com/in/luispinto82/) | 💻 **GitHub:** [@vorator](https://github.com/vorator)
