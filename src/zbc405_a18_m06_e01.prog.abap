*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_M06_E01
*&---------------------------------------------------------------------*

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.  "PBO

AT SELECTION-SCREEN.   "PAI

START-OF-SELECTION.

  SELECT *
    FROM ztsbook_a18
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    WHERE carrid IN pa_car
      AND connid IN pa_con.

  LOOP AT gt_sbook INTO gs_sbook.
    "gs_sbook을 바꾸는 로직

    "Row color
    Case gs_sbook-invoice.
      when 'X'.
        gs_sbook-rowcol = 'C510'.
        gs_sbook-rowcol2 = 'C510'.
    ENDCASE.





    "신호등
    IF gs_sbook-luggweight >= 25.
      gs_sbook-light = 1.
    ELSEIF gs_sbook-luggweight >= 15.
      gs_sbook-light = 2.
    ELSE.
      gs_sbook-light = 3.
    ENDIF.




    MODIFY gt_sbook FROM gs_sbook. "바뀐 gs_sbook으로 gt_sbook을 변경함
    clear gs_sbook.
  ENDLOOP.




  CALL SCREEN 100.
