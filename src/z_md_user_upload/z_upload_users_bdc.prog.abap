*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Report Z_UPLOAD_USERS_BDC
*&---------------------------------------------------------------------*
*& User Mass Migration (Batch Input SU01)
*&---------------------------------------------------------------------*
REPORT Z_UPLOAD_USERS_BDC.

" data structure
  TYPES: BEGIN OF ty_user_csv,
        username TYPE string,
        lastname TYPE string,
        password TYPE string,
  END OF ty_user_csv.

" tables and work areas
  DATA: it_csv_data TYPE TABLE OF ty_user_csv,
        wa_csv_data TYPE ty_user_csv.

  DATA: it_bdcdata TYPE TABLE OF bdcdata,
        wa_bdcdata TYPE bdcdata.

" Selection screen for path
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
    PARAMETERS: p_file TYPE string LOWER CASE OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b1.

" F4 Search option (select file)
  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
    DATA: it_file_table TYPE filetable,
          lv_rc         TYPE i.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      CHANGING
        file_table              = it_file_table
        rc                      = lv_rc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.

    IF sy-subrc = 0 and lv_rc > 0.
      READ TABLE it_file_table INTO DATA(wa_file_table) INDEX 1.
      IF sy-subrc = 0.
        p_file = wa_file_table-filename.
      ENDIF.
    ENDIF.

" main execution (load file to internal table)
  START-OF-SELECTION.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename              = p_file
        has_field_separator   = abap_true
        dat_mode              = abap_true
      CHANGING
        data_tab              = it_csv_data
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.

    IF sy-subrc <> 0.
      MESSAGE 'Error reading CSV file.' TYPE 'E'.
    ELSE.

      " batch input
      CALL FUNCTION 'BDC_OPEN_GROUP'
        EXPORTING
            client  = sy-mandt
            group   = 'MIG_USERS'
            user    = sy-uname
            keep    = 'X'.

      LOOP AT it_csv_data INTO wa_csv_data.
        CLEAR it_bdcdata.

        " 1st screen: 1050
        PERFORM bdc_dynpro  USING 'SAPLSUID_MAINTENANCE' '1050'.
        PERFORM bdc_field   USING 'BDC_OKCODE' '=CREA'.
        PERFORM bdc_field   USING 'SUID_ST_BNAME-BNAME' wa_csv_data-username.

        " 2nd screen: 1100
        PERFORM bdc_dynpro  USING 'SAPLSUID_MAINTENANCE' '1100'.
        PERFORM bdc_field   USING 'BDC_OKCODE' '=LOGO'.
        PERFORM bdc_field   USING 'SUID_ST_NODE_PERSON_NAME-NAME_LAST' wa_csv_data-lastname.
        " 3rd screen: 1100
        PERFORM bdc_dynpro  USING 'SAPLSUID_MAINTENANCE' '1100'.
        PERFORM bdc_field   USING 'BDC_OKCODE' '=UPD'.
        PERFORM bdc_field   USING 'SUID_ST_NODE_LOGONDATA-USTYP' 'A'.
        PERFORM bdc_field   USING 'SUID_ST_NODE_PASSWORD_EXT-PASSWORD' wa_csv_data-password.
        PERFORM bdc_field   USING 'SUID_ST_NODE_PASSWORD_EXT-PASSWORD2' wa_csv_data-password.

        CALL FUNCTION 'BDC_INSERT'
          EXPORTING
            tcode     = 'SU01'
          TABLES
            dynprotab = it_bdcdata.

      ENDLOOP.

      CALL FUNCTION 'BDC_CLOSE_GROUP'.

      MESSAGE 'MIG_USERS session created. Check SM35.' TYPE 'S'.
    ENDIF.

" sub-routines for batch input
FORM bdc_dynpro USING p_program p_dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = p_program.
  wa_bdcdata-dynpro   = p_dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.

FORM bdc_field USING p_fnam p_fval.
  " only map if the field is empty
  IF p_fval IS NOT INITIAL.
    CLEAR wa_bdcdata.
    wa_bdcdata-fnam = p_fnam.
    wa_bdcdata-fval = p_fval.
    APPEND wa_bdcdata TO it_bdcdata.
  ENDIF.
ENDFORM.
