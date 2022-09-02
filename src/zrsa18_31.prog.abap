*&---------------------------------------------------------------------*
*& Report ZRSA18_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA18_31_TOP                           .    " Global Data

* INCLUDE ZRSA18_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA18_31_I01                           .  " PAI-Modules
INCLUDE ZRSA18_31_F01                           .  " FORM-Routines

INITIALIZATION.
 PERFORM set_dafault.

START-OF-SELECTION.
 select *
   FROM ztsa1801
   into CORRESPONDING FIELDS OF table gt_emp
   WHERE entdt BETWEEN pa_ent_b and pa_ent_e.

   If sy-subrc is not INITIAL.
*     MESSAGE i,,
     return.
   ENDIF.

   cl_demo_output=>display_data( gt_emp ).
