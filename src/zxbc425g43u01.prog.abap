*&---------------------------------------------------------------------*
*& Include          ZXBC425G43U01
*&---------------------------------------------------------------------*
if flight-fldate < sy-datum.
  MESSAGE w011(bc425) with sy-datum.
ENDIF.
