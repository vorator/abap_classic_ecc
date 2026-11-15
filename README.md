# SAP ABAP Classic (ECC / NetWeaver)

A portfolio of six small, self-contained ABAP projects for classic SAP systems (ECC / NetWeaver). Each one starts from a realistic business requirement and shows how it was solved with the appropriate classic technique: Batch Input, BAPIs, the Enhancement Framework, custom BAdIs, object-oriented design and Data Dictionary modeling.

The examples run on the SAP flight data model (`SFLIGHT`, `SBOOK`, `BAPI_FLBOOKING_CREATEFROMDATA`), so they can be tried on any system with the demo data installed.

## Use cases

| # | Use case | Main technique | Folder |
|---|----------|----------------|--------|
| 1 | Mass import of users from a CSV file | Batch Input (BDC), SU01, SM35 | [`z_md_user_upload`](src/z_md_user_upload) |
| 2 | Automated flight booking with transaction control | BAPI, commit/rollback (LUW), `CL_SALV_TABLE` | [`z_flight_booking_bapi`](src/z_flight_booking_bapi) |
| 3 | Business rule injected into standard code | Implicit Enhancement, global class | [`z_enhancementfw`](src/z_enhancementfw) |
| 4 | Pluggable luggage policy | Custom BAdI (`GET BADI` / `CALL BADI`) | [`z_enhancementfw`](src/z_enhancementfw) |
| 5 | Cargo pricing and routing engine | Inheritance, abstraction, polymorphism | [`z_abapobjects`](src/z_abapobjects) |
| 6 | Cargo handling instructions linked to bookings | Transparent table, foreign key, side-car design | [`z_dataengeneering`](src/z_dataengeneering) |

Each folder has its own README with the business case, the technical design, the execution flow and screenshots.

## Repository layout

```
src/
├── z_md_user_upload/        Use case 1: BDC user migration
├── z_flight_booking_bapi/   Use case 2: BAPI booking automation
├── z_enhancementfw/         Use cases 3 and 4: enhancement and BAdI
├── z_abapobjects/           Use case 5: OOP cargo model
└── z_dataengeneering/       Use case 6: ZCARGO_INSTR table
```

The code is serialized in [abapGit](https://abapgit.org) format (`.abapgit.xml`, starting folder `/src/`, folder logic `FULL`), so every folder maps to an ABAP package.

## Getting started

**Requirements**
- An SAP NetWeaver ABAP system, release 7.52 or higher (the code uses inline declarations such as `DATA(...)`).
- The SAP flight demo data. It can be generated with program `SAPBC_DATA_GENERATOR`.
- [abapGit](https://docs.abapgit.org) installed (standalone version is enough).

**Installation**
1. In abapGit choose **New Online** and enter `https://github.com/vorator/abap_classic_ecc`.
2. Pick a package for the objects, for example `$TMP` for a local test.
3. Pull the repository, then activate all objects.

Use case 1 also needs a CSV file with the users to migrate. Use case 3 and 4 enhance the standard function module `BAPI_FLBOOKING_CREATEFROMDATA`, so test them in a development system, not a shared one.

---
## 👨‍💻 About the Developer
I am an IT Engineer and Software Developer specializing in SAP ABAP, S/4HANA architecture, and Java.
With a robust background integrating cross-border financial systems and ERPs (SAP, Navision, SAGE), I build resilient technical solutions grounded in deep business process understanding.
[🔗 Connect with me on LinkedIn](https://linkedin.com/in/luispinto82/) | 💻 **GitHub:** [@vorator](https://github.com/vorator)
