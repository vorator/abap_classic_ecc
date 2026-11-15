class ZCL_CARGO_LUGGAGE definition
  public
  inheriting from ZCL_CARGO_NOANIMAL
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(IV_ID) type CHAR10
      value(IV_WEIGHT) type F
      value(IV_FRAGILE) type ABAP_BOOL .

  methods CALCULATE_SHIPPING_COST
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CARGO_LUGGAGE IMPLEMENTATION.


  method CALCULATE_SHIPPING_COST.
    " bussiness rules (hardcoded): 5 Eur/Kg; fragile +2 Eur/kg
    rv_cost = mv_weight * 5.

    IF mv_fragile = abap_true.
      rv_cost = rv_cost + ( mv_weight * 2 ).
    ENDIF.
  endmethod.


  method CONSTRUCTOR.
    super->constructor(
      iv_id       = iv_id
      iv_weight   = iv_weight
      iv_fragile  = iv_fragile
    ).
  endmethod.
ENDCLASS.
