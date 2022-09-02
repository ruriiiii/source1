*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZSAPBC430S_FILL_CLUSTER_TAB_18                                  .

DATA wa_scarr  TYPE scarr.
DATA wa_spfli  TYPE spfli.
DATA wa_flight TYPE sflight.

DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.

* Replace # by Your user-number and remove all * from here

  DELETE FROM zscarr_a18.
  DELETE FROM zspfli_a18.
  DELETE FROM zsflight_a18.


  SELECT * FROM scarr INTO wa_scarr.
    INSERT INTO zscarr_a18 VALUES wa_scarr.
  ENDSELECT.

  IF sy-subrc = 0.
    SELECT * FROM spfli INTO wa_spfli.
      INSERT INTO zspfli_a18 VALUES wa_spfli.
    ENDSELECT.

    IF sy-subrc = 0.

      SELECT * FROM sflight INTO wa_flight.
        INSERT INTO zsflight_a18 VALUES wa_flight.
      ENDSELECT.
      IF sy-subrc <> 0.
        my_error = 1.
      ENDIF.
    ELSE.
      my_error = 2.
    ENDIF.
  ELSE.
    my_error = 3.
  ENDIF.

  IF my_error = 0.
    WRITE / 'Data transport successfully finished'.
  ELSE.
    WRITE: / 'ERROR:', my_error.
  ENDIF.
