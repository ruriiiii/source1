*&---------------------------------------------------------------------*
*& Report ZRSA18_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA18_24_TOP                           .    " Global Data

* INCLUDE ZRSA18_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA18_24_I01                           .  " PAI-Modules
 INCLUDE ZRSA18_24_F01                           .  " FORM-Routines

 INITIALIZATION.

 AT SELECTION-SCREEN OUTPUT.

 AT SELECTION-SCREEN.

 START-OF-SELECTION.

PERFORM get_info.


 IF gt_info IS INITIAL.
   MESSAGE i016(pn) WITH 'Data is not found'.
 RETURN.
 ENDIF.


 cl_demo_output=>display_data( gt_info ).
