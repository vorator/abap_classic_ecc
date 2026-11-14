"Name: \FU:BAPI_FLBOOKING_CREATEFROMDATA\SE:BEGIN\EI
ENHANCEMENT 0 Z_ENH_FLIGHT_MARGIN.
*
  " margin validator
  DATA: lv_margin_error TYPE abap_bool.

  zcl_flight_margin_check=>check_first_class_price(
    EXPORTING
      is_booking_data   = booking_data
    IMPORTING
      et_return         = return[]
      ev_error          = lv_margin_error
  ).

  IF lv_margin_error = abap_true.
    EXIT.
  ENDIF.

  " weight control
  DATA: lo_badi_luggage     TYPE REF TO zbadi_check_luggage,
        lv_luggage_reject   TYPE abap_bool,
        lv_simulated_weight TYPE s_lugweigh.

  lv_simulated_weight = 25.

  TRY.
    GET BADI lo_badi_luggage.

    CALL BADI lo_badi_luggage->check_weight
      EXPORTING
        iv_weight   = lv_simulated_weight
      IMPORTING
        ev_rejected = lv_luggage_reject.

    IF lv_luggage_reject = abap_true.
      DATA: ls_return_lug TYPE bapiret2.
      ls_return_lug-type    = 'E'.
      ls_return_lug-id      = 'BAPI'.
      ls_return_lug-number  = '000'.
      ls_return_lug-message = 'BAdI: Lugagge excedeed (> 20kg)'.
      APPEND ls_return_lug TO return[].
      EXIT.
    ENDIF.

    CATCH cx_badi_not_implemented.
  ENDTRY.


ENDENHANCEMENT.
