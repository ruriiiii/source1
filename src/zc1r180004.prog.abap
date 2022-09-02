*&---------------------------------------------------------------------*
*& Report ZC1R180004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r180004_top                          .    " Global Data

INCLUDE zc1r180004_c01                          .  " Class
INCLUDE zc1r180004_s01                          .  " Selection screen
INCLUDE zc1r180004_o01                          .  " PBO-Modules
INCLUDE zc1r180004_i01                          .  " PAI-Modules
INCLUDE zc1r180004_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN '0100'.
