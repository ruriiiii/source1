*&---------------------------------------------------------------------*
*& Report ZC1R180003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r180003 MESSAGE-ID zmcsa18.

TABLES : mara, marc.



SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS : werks TYPE mkal-werks DEFAULT '1010',
               berid TYPE pbid-berid DEFAULT '1010',
               pbdnr TYPE pbid-pbdnr,
               versb TYPE pbid-versb DEFAULT '00'.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS : rad1 RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND mod,  "User-command를 써줌으로써 이벤트가 발생함
               rad2 RADIOBUTTON GROUP gr1.
SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03.
  SELECT-OPTIONS : matnr FOR mara-matnr MODIF ID ra1,
                   mtart FOR mara-mtart MODIF ID ra1,
                   matkl FOR mara-matkl MODIF ID ra1,
                   ekgrp FOR marc-ekgrp MODIF ID ra2.
  PARAMETERS     : dispo TYPE marc-dispo MODIF ID ra2,
                   dismm TYPE marc-dismm MODIF ID ra2.
SELECTION-SCREEN END OF BLOCK bl3.


AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen.


*&---------------------------------------------------------------------*
*& Form modify_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .

  LOOP AT SCREEN.
    CASE screen-name.
      WHEN 'PBDNR' OR 'VERSB'.
        screen-input = 0.
        MODIFY SCREEN.   "꼭 써줘야 적용됨
    ENDCASE.

    CASE 'X'.
      WHEN rad1.
        CASE screen-group1.
          WHEN 'RA1'.
            screen-active = '0'.
            MODIFY SCREEN.
        ENDCASE.

      WHEN rad2.
        CASE screen-group1.
          WHEN 'RA2'.
            screen-active = '0'.
            MODIFY SCREEN.
        ENDCASE.

    ENDCASE.

  ENDLOOP.

ENDFORM.
