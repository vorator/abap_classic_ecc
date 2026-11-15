# 🎯 Business Use Case #5 OOP Architecture
The airline required a dynamic pricing and routing engine for its cargo transport division. Pricing rules vary heavily depending on the cargo type (e.g., live animals require flat vet fees and mandatory hold routing; normal luggage pays per kg; fragile luggage pays a handling surcharge). The goal was to build a scalable engine where new cargo types can be introduced without modifying the main program's logic.

### 🏗️ Technical Architecture: 
* **Design Pattern:** Multi-level Inheritance & Polymorphism logic.
* **Object Types:** Global ABAP Classes (`SE24` / `SE80`).
* **Execution:** ABAP Executable Report with generic internal tables and Upcasting.

### ⚙️ The 4 Pillars of OOP Implemented: 
1. **Abstraction:** Created `ZCL_CARGO` and `ZCL_CARGO_NOANIMAL` as Abstract Classes. They define the mandatory blueprint and method signatures (e.g., `CALCULATE_SHIPPING_COST`) but cannot be instantiated directly, forcing developers to use specific subclasses.
2. **Encapsulation:** Protected the system's integrity by using strict visibility rules:
    * `MV_ID`: **Private** (Cannot be altered or read by external programs once instantiated).
    * `MV_WEIGHT` / `MV_FRAGILE`: **Protected** (Only accessible by the inheriting child classes).
    * Routing rules (e.g., Animals strictly in 'PRESSUREHOLD') are enforced inside the Constructor methods, eliminating the risk of external input errors.
3. **Inheritance:** Built a multi-level class hierarchy to share core DNA: `ZCL_CARGO` (Grandparent) ➔ `ZCL_CARGO_NOANIMAL` (Parent) ➔ `ZCL_CARGO_LUGGAGE` (Child).
4. **Polymorphism:** Utilized method redefinition. The main report simply calls `lo_cargo->calculate_shipping_cost( )` inside a loop. The ABAP runtime dynamically executes the specific algorithm for an Animal or a Fragile Luggage depending on the object reference, completely eliminating the need for `IF` or `CASE` statements in the main program.

### 🛠️ Key Features Implemented:
* [x] **Upcasting (Widening Cast):** Inserted specific subclass objects (Animals, Luggage) into a generic internal table typed to the abstract superclass.
* [x] **Clean Code & Scalability:** The main executable program is decoupled from the business rules. Adding a new cargo type (e.g., 'Surfboard') requires zero changes to the `Z_TEST_CARGO` report.

### 📸 Showcase
<img width="3837" height="1054" alt="image" src="https://github.com/user-attachments/assets/7c11ae7e-3df5-4c41-af0b-3ca196283210" />

---
## 👨‍💻 About the Developer
I am an IT Engineer and Software Developer specializing in SAP ABAP, S/4HANA architecture, and Java.
With a robust background integrating cross-border financial systems and ERPs (SAP, Navision, SAGE), I build resilient technical solutions grounded in deep business process understanding.
[🔗 Connect with me on LinkedIn](https://linkedin.com/in/luispinto82/) | 💻 **GitHub:** [@vorator](https://github.com/vorator)
