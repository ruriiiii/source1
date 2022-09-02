*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZBC430_FILLTAB_A18                                  .

DATA: gt_sbook TYPE TABLE OF sbook,
      gt_spfli TYPE TABLE OF spfli,
      gt_custo TYPE TABLE OF scustom.

DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.

* Replace # by Your user-number and remove all * from here

  DELETE FROM ztspfli_a18.
  DELETE FROM ztsbook_a18.
  DELETE FROM ztscustom_a18.


    SELECT * FROM sbook INTO TABLE gt_sbook.
  INSERT ztsbook_a18 FROM TABLE gt_sbook.

  IF sy-subrc = 0.
    SELECT * FROM spfli INTO TABLE gt_spfli.
    INSERT ztspfli_a18 FROM TABLE gt_spfli.

    IF sy-subrc = 0.

      SELECT * FROM scustom INTO TABLE gt_custo.
      INSERT ztscustom_a18 FROM TABLE gt_custo.
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
