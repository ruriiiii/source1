*&---------------------------------------------------------------------*
*& Report ZC1R180004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R180004_CLASS_TOP.
*INCLUDE zc1r180004_top                          .    " Global Data

INCLUDE ZC1R180004_CLASS_C01.
*INCLUDE zc1r180004_c01                          .  " Class
INCLUDE ZC1R180004_CLASS_S01.
*INCLUDE zc1r180004_s01                          .  " Selection screen
INCLUDE ZC1R180004_CLASS_O01.
*INCLUDE zc1r180004_o01                          .  " PBO-Modules
INCLUDE ZC1R180004_CLASS_I01.
*INCLUDE zc1r180004_i01                          .  " PAI-Modules
INCLUDE ZC1R180004_CLASS_F01.
*INCLUDE zc1r180004_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_material.
  CALL SCREEN '0100'.
