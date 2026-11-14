class ZCL_FLIGHT_MARGIN_CHECK definition
  public
  final
  create public .

public section.

  class-methods CHECK_FIRST_CLASS_PRICE
    importing
      value(IS_BOOKING_DATA) type BAPISBONEW
    exporting
      value(ET_RETURN) type BAPIRET2_T
      value(EV_ERROR) type ABAP_BOOL .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FLIGHT_MARGIN_CHECK IMPLEMENTATION.


  method CHECK_FIRST_CLASS_PRICE.

    ev_error = abap_false.
    CLEAR et_return.

    IF is_booking_data-class <> 'F'.
      RETURN.
    ENDIF.

    DATA: lv_price TYPE sflight-price.

    SELECT SINGLE price
      FROM sflight
      INTO lv_price
      WHERE carrid = is_booking_data-airlineid
        AND connid = is_booking_data-connectid
        AND fldate = is_booking_data-flightdate.

    IF sy-subrc = 0 AND lv_price < 500.
      ev_error = abap_true.

      DATA: ls_return TYPE bapiret2.
      ls_return-type    = 'E'.
      ls_return-id      = 'BAPI'.
      ls_return-number  = '000'.
      ls_return-message = 'Margin error: 1st class not allowed for <500EUR flights.'.
      APPEND ls_return to et_return.
    ENDIF.

  endmethod.
ENDCLASS.
