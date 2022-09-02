*&---------------------------------------------------------------------*
*& Report ZC1R180002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r180002_top                          .    " Global Data

INCLUDE zc1r180002_s01                          .  "Selection screen
INCLUDE zc1r180002_o01                          .  " PBO-Modules
INCLUDE zc1r180002_i01                          .  " PAI-Modules
INCLUDE zc1r180002_f01                          .  " FORM-Routines

INITIALIZATION.


START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN '0100'.
