class ZCL_CARGO_ANIMAL definition
  public
  inheriting from ZCL_CARGO
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(IV_ID) type CHAR10
      value(IV_WEIGHT) type F .

  methods CALCULATE_SHIPPING_COST
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CARGO_ANIMAL IMPLEMENTATION.


  method CALCULATE_SHIPPING_COST.
    " business rules(hardcoded): 50 per unit + 15 p/ kg
    rv_cost = 50 + ( mv_weight * 15 ).
  endmethod.


  method CONSTRUCTOR.
    super->constructor(
      iv_id       = iv_id
      iv_weight   = iv_weight
      iv_location = 'PRESSUREHOLD'
    ).
  endmethod.
ENDCLASS.
