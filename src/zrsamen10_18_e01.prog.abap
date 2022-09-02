*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_18_E01
*&---------------------------------------------------------------------*

*AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_cus.

START-OF-SELECTION.

  SELECT *
    FROM zvrmat18
    INTO CORRESPONDING FIELDS OF TABLE gt_manage
    WHERE custom = pa_cus.



  SELECT *
    FROM makt
    INTO CORRESPONDING FIELDS OF TABLE gt_maktx.

  SELECT *
    FROM kna1
    INTO CORRESPONDING FIELDS OF TABLE gt_kna1.


  LOOP AT gt_manage INTO gs_manage.
    READ TABLE gt_maktx INTO gs_maktx WITH KEY matnr = gs_manage-pcode.
    gs_manage-maktx = gs_maktx-maktx.
    MODIFY gt_manage FROM gs_manage.
  ENDLOOP.

  LOOP AT gt_manage INTO gs_manage.
    READ TABLE gt_kna1 INTO gs_kna1 WITH KEY kunnr = gs_manage-custom.
    gs_manage-name = gs_kna1-name1.
    MODIFY gt_manage FROM gs_manage.
  ENDLOOP.



*  cl_demo_output=>display_data( gt_maktx ).
*  cl_demo_output=>display_data( gt_manage ).

*cl_demo_output=>display_data( gs_manage ).
