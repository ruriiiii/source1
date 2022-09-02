*&---------------------------------------------------------------------*
*& Report ZRSA00_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa00_31_top                           .    " Global Data

* INCLUDE ZRSA00_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA00_31_I01                           .  " PAI-Modules
INCLUDE zrsa00_31_f01                           .  " FORM-Routines

INITIALIZATION.
  PERFORM set_default.

START-OF-SELECTION.
  SELECT *
    FROM ztsa0001
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
   WHERE entdt BETWEEN pa_ent_b AND pa_ent_e.
  IF sy-subrc IS NOT INITIAL.
*    MESSAGE i...
    RETURN.
  ENDIF.

  cl_demo_output=>display_data( gt_emp ).
