*&---------------------------------------------------------------------*
*& Report ZC1R180006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r180006_top                          .    " Global Data

INCLUDE zc1r180006_s01                          . " SELECTION SCREEN
INCLUDE zc1r180006_c01                          . " CLASS
INCLUDE zc1r180006_o01                          .  " PBO-Modules
INCLUDE zc1r180006_i01                          .  " PAI-Modules
INCLUDE zc1r180006_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_belnr.

  CALL SCREEN '0100'.
