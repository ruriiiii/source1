*&---------------------------------------------------------------------*
*& Report ZRSA00_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa00_25_top                           .    " Global Data

* INCLUDE ZRSA00_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA00_25_I01                           .  " PAI-Modules
INCLUDE zrsa00_25_f01                           .  " FORM-Routi1nes

START-OF-SELECTION.
*  PERFORM get_data.

  cl_demo_output=>display_data( gt_info ).
