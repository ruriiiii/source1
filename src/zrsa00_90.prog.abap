*&---------------------------------------------------------------------*
*& Report ZRSA00_90
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_90.

DATA: gt_data TYPE TABLE OF zssa0093,
      gs_data LIKE LINE OF gt_data.

PARAMETERS pa_car LIKE gs_data-carrid.
SELECT-OPTIONS so_mno FOR gs_data-mealnumber.
PARAMETERS pa_ca LIKE gs_data-venca AS LISTBOX VISIBLE LENGTH 20.

START-OF-SELECTION.

  " Meal Info
  SELECT *
    FROM ztsa0099
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE carrid = pa_car
     AND mealnumber IN so_mno.

  cl_demo_output=>display_data( gt_data ).
