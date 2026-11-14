class ZCL_IM_CHECK_LUGGAGE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZIF_BADI_CHECK_LUGGAGE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_CHECK_LUGGAGE IMPLEMENTATION.


  method ZIF_BADI_CHECK_LUGGAGE~CHECK_WEIGHT.

    ev_rejected = abap_false.

    IF iv_weight > 20.
      ev_rejected = abap_true.
    ENDIF.

  endmethod.
ENDCLASS.
