*&---------------------------------------------------------------------*
*& Report Z_CREATE_FLIGHT_BOOKING
*&---------------------------------------------------------------------*
*& Reserve Automaton - BAPI call with Exception handling and ALV
*&---------------------------------------------------------------------*
REPORT Z_CREATE_FLIGHT_BOOKING.

" struture declaration (SE37/SE11)
DATA: wa_booking_data TYPE bapisbonew,
      it_return       TYPE TABLE OF bapiret2,
      wa_return       TYPE bapiret2.

" UI selection screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_carrid TYPE s_carr_id OBLIGATORY,
              p_connid TYPE s_conn_id OBLIGATORY,
              p_fldate TYPE s_date OBLIGATORY,
              p_custid TYPE s_customer OBLIGATORY,
              p_class  TYPE s_class DEFAULT 'Y'.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS: p_simul TYPE abap_bool AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b2.

" main execution
START-OF-SELECTION.

  CLEAR wa_booking_data.

  " data mapping (screnn -> BAPI)
  wa_booking_data-airlineid   = p_carrid.
  wa_booking_data-connectid   = p_connid.
  wa_booking_data-flightdate  = p_fldate.
  wa_booking_data-customerid  = p_custid.
  wa_booking_data-class       = p_class.

  " hardcoded data
  wa_booking_data-agencynum = '00000093'.
  wa_booking_data-passname  = 'LUIS PINTO'.
  wa_booking_data-passform  = 'MR'.
  wa_booking_data-passbirth = '19820913'.

  " call BAPI
  CALL FUNCTION 'BAPI_FLBOOKING_CREATEFROMDATA'
    EXPORTING
      reserve_only  = space              " space = false
      booking_data  = wa_booking_data    " data structure
      test_run      = p_simul
    TABLES
      return        = it_return.

  " test
  "LOOP AT it_return into wa_return.
  "  WRITE: / wa_return-type, '-', wa_return-message.
  "ENDLOOP.

  " exception handling e transaction control (LUW - roolback or commit)
  DATA: lv_has_error  TYPE abap_bool,
        lo_alv        TYPE REF TO cl_salv_table.

  LOOP at it_return INTO wa_return WHERE type = 'E' or type = 'A'. " looking for (E)rrors or (A)bort.
    lv_has_error = abap_true.
    EXIT.
  ENDLOOP.

  IF lv_has_error = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    IF p_simul = abap_false.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING wait = 'X'. " DB will confirm
    ENDIF.
  ENDIF.

  " ALV OO
  TRY.
    cl_salv_table=>factory(
      IMPORTING r_salv_table = lo_alv
      CHANGING t_table = it_return
    ).

    " grid control
    lo_alv->get_columns( )->set_optimize( abap_true ).
    lo_alv->display( ).

  CATCH cx_salv_msg.
    WRITE: / 'Critical error generating ALV grid'.
  ENDTRY.
