*&---------------------------------------------------------------------*
*& Report ZRSA18_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_22.

DATA: gs_list TYPE scarr,
      gt_list LIKE TABLE OF gs_list.

CLEAR: gt_list, gs_list.
*SELECT *
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF gs_list
*  WHERE carrid BETWEEN 'ZZ' AND 'UA'.
*  APPEND gs_list TO gt_list.
*  CLEAR gs_list.
*ENDSELECT.

SELECT carrid carrname
  FROM scarr
  into CORRESPONDING FIELDS OF TABLE gt_list
  WHERE carrid BETWEEN 'AA' and 'UA'.
WRITE sy-subrc.
WRITE sy-dbcnt. "몇건인지

cl_demo_output=>display_data( gt_list ).
