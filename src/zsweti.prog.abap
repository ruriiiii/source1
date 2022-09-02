*&---------------------------------------------------------------------*
*& Report ZSWETI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSWETI.
*DATA: gs_scarr   TYPE scarr,
*      gt_spfli   TYPE TABLE OF spfli,
*      gs_spfli   LIKE LINE OF gt_spfli,
*      gt_sflight TYPE TABLE OF  sflight,
*      gs_sflight LIKE LINE OF gt_sflight,
*      gt_sbook   TYPE TABLE OF sbook,
*      gs_sbook   LIKE LINE OF gt_sbook.
*
*gs_scarr-carrid = 'KA'.
*gs_scarr-carrname = 'Korea Airline'.
*gs_scarr-currcode = 'KRW'.
*MODIFY scarr FROM gs_scarr.
*
*SELECT *
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli
*  WHERE carrid = 'AA'.
*
*LOOP AT gt_spfli INTO gs_spfli.
*  gs_spfli-carrid = 'KA'.
*  MODIFY gt_spfli FROM gs_spfli.
*ENDLOOP.
*MODIFY spfli FROM TABLE gt_spfli.
*
*SELECT *
*  FROM sflight
*  INTO CORRESPONDING FIELDS OF TABLE gt_sflight
*  WHERE carrid = 'AA'.
*
*LOOP AT gt_sflight INTO gs_sflight.
*  gs_sflight-carrid = 'KA'.
*  gs_sflight-currency = 'KRW'.
*  MODIFY gt_sflight FROM gs_sflight.
*ENDLOOP.
*MODIFY sflight FROM TABLE gt_sflight.
*
*
*SELECT *
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
*  WHERE carrid = 'AA'.
*
*LOOP AT gt_sbook INTO gs_sbook.
*  gs_sbook-carrid = 'KA'.
*  gs_sbook-loccurkey = 'KRW'.
*  MODIFY gt_sbook FROM gs_sbook.
*ENDLOOP.
*MODIFY sbook FROM TABLE gt_sbook.
