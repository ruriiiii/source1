*&---------------------------------------------------------------------*
*& Report ZRSA18_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_23.

DATA: gt_info TYPE TABLE OF zsinfo,
      gs_info LIKE LINE OF gt_info.

PARAMETERS pa_code1 TYPE spfli-carrid.
PARAMETERS pa_code2 TYPE spfli-carrid.



SELECT *
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid BETWEEN pa_code1 AND pa_code2.
*APPEND gs_info TO gt_info.


LOOP AT gt_info into gs_info.

  select single carrname
    from scarr
    into gs_info-carrname
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info from gs_info
                 TRANSPORTING carrname.
  CLEAR gs_info.
ENDLOOP.



cl_demo_output=>display_data( gt_info ).
