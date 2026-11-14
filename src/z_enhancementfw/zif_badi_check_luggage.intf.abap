interface ZIF_BADI_CHECK_LUGGAGE
  public .


  interfaces IF_BADI_INTERFACE .

  methods CHECK_WEIGHT
    importing
      value(IV_WEIGHT) type S_LUGWEIGH
    exporting
      value(EV_REJECTED) type ABAP_BOOL .
endinterface.
