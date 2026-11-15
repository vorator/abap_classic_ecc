*&---------------------------------------------------------------------*
*& Report Z_TEST_CARGO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TEST_CARGO.

DATA: lo_animal   TYPE REF TO zcl_cargo_animal,
      lo_luggage  TYPE REF TO zcl_cargo_luggage.

DATA: lo_cargo    TYPE REF TO zcl_cargo,
      lt_cargo    TYPE TABLE OF REF TO zcl_cargo,
      lv_cost     TYPE DMBTR.

CREATE OBJECT lo_animal
  EXPORTING
    iv_id     = 'REX_001'
    iv_weight = 30.

CREATE OBJECT lo_luggage
  EXPORTING
    iv_id       = 'MALA_XPTO'
    iv_weight   = 25
    iv_fragile  = abap_true.

APPEND lo_animal  TO lt_cargo.
APPEND lo_luggage TO lt_cargo.

WRITE: / '--- CARGO TRANSPORT TEST ---'.

LOOP AT lt_cargo into lo_cargo.
  lv_cost = lo_cargo->calculate_shipping_cost( ).
  WRITE: / 'Calculated cost:', lv_cost, 'EUR'. "quickfix
ENDLOOP.
