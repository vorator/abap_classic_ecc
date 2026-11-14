"Name: \FU:BAPI_FLBOOKING_CREATEFROMDATA\SE:BEGIN\EI
ENHANCEMENT 0 Z_ENH_FLIGHT_MARGIN.
*
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

ENDENHANCEMENT.
