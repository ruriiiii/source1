*&---------------------------------------------------------------------*
*& Report ZC1R180001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r180001_top                          .    " Global Data

INCLUDE zc1r180001_s01                          .  "Selection Screen
INCLUDE zc1r180001_o01                          .  " PBO-Modules
INCLUDE zc1r180001_i01                          .  " PAI-Modules
INCLUDE zc1r180001_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.


START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN '0100'.
