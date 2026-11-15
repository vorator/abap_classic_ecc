class ZCL_CARGO definition
  public
  abstract
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(IV_ID) type CHAR10
      value(IV_WEIGHT) type F
      value(IV_LOCATION) type CHAR12 .
  methods CALCULATE_SHIPPING_COST
  abstract
    returning
      value(RV_COST) type F .
protected section.

  data MV_WEIGHT type DMBTR .
  data MV_LOCATION type CHAR10 .
private section.

  data MV_ID type CHAR10 .
ENDCLASS.



CLASS ZCL_CARGO IMPLEMENTATION.


  method CONSTRUCTOR.
    mv_id       = iv_id.
    mv_weight   = iv_weight.
    mv_location = iv_location.
  endmethod.
ENDCLASS.
