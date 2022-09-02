*&---------------------------------------------------------------------*
*& Report ZC1R180007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R180007_TOP                          .    " Global Data

 INCLUDE ZC1R180007_S01                          .
 INCLUDE ZC1R180007_C01                          .
 INCLUDE ZC1R180007_O01                          .  " PBO-Modules
 INCLUDE ZC1R180007_I01                          .  " PAI-Modules
 INCLUDE ZC1R180007_F01                          .  " FORM-Routines

 START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM SET_STYLE.

  CALL SCREEN '0100'.
