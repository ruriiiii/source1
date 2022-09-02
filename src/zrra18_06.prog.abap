*&---------------------------------------------------------------------*
*& Report ZRRA18_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRRA18_06_TOP                           .    " Global Data

 INCLUDE ZRRA18_06_S01                           .  " SELECTION SCREEN
 INCLUDE ZRRA18_06_C01                           .  " CLASS
 INCLUDE ZRRA18_06_O01                           .  " PBO-Modules
 INCLUDE ZRRA18_06_I01                           .  " PAI-Modules
 INCLUDE ZRRA18_06_F01                           .  " FORM-Routines

 START-OF-SELECTION.
  PERFORM GET_DATA.
  CALL SCREEN '0100'.
