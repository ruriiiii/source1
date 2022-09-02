*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_18_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'VERSION'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CUSTOM'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PCODE'.
  gs_fcat-coltext = '제품코드'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'UNIT'.
  gs_fcat-coltext = '단위'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'MAKTX'.
  gs_fcat-coltext = '제품코드명'.
  gs_fcat-col_pos = 5.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-sel_mode = 'A'.

ENDFORM.
