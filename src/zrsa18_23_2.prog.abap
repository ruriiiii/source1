*&---------------------------------------------------------------------*
*& Report ZRSA18_23_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA18_23_2_TOP                         .    " Global Data

* INCLUDE ZRSA18_23_2_O01                         .  " PBO-Modules
* INCLUDE ZRSA18_23_2_I01                         .  " PAI-Modules
INCLUDE ZRSA18_23_2_F01                         .  " FORM-Routines

"EVENT
INITIALIZATION.

at SELECTION-SCREEN OUTPUT. "PBO

at SELECTION-SCREEN. "PAI

START-OF-SELECTION.
 clear: gs_info,
        gt_info.
