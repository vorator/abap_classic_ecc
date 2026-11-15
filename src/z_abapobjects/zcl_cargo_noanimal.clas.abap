class ZCL_CARGO_NOANIMAL definition
  public
  inheriting from ZCL_CARGO
  abstract
  create public .

public section.

  methods CONSTRUCTOR
    importing
      value(IV_ID) type CHAR10
      value(IV_WEIGHT) type F
      value(IV_FRAGILE) type ABAP_BOOL .
protected section.

  data MV_FRAGILE type ABAP_BOOL .
private section.
ENDCLASS.



CLASS ZCL_CARGO_NOANIMAL IMPLEMENTATION.


  method CONSTRUCTOR.

    DATA: lv_calculated_location TYPE char12.

    IF iv_weight >= 20.
      lv_calculated_location = 'DEPRESSHOLD'.
    ELSE.
      lv_calculated_location = 'CABIN'.
    ENDIF.

    super->constructor(
      iv_id       = iv_id
      iv_weight   = iv_weight
      iv_location = lv_calculated_location
    ).
    " non-animal specific
    mv_fragile    = iv_fragile.

  endmethod.
ENDCLASS.
