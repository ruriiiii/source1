*&---------------------------------------------------------------------*
*& Report ZRRA18_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRRA18_05_TOP                           .    " Global Data

 INCLUDE ZRRA18_05_S01                           .  " Selection Screen
 INCLUDE ZRRA18_05_C01                           .  " Class
 INCLUDE ZRRA18_05_O01                           .  " PBO-Modules
 INCLUDE ZRRA18_05_I01                           .  " PAI-Modules
 INCLUDE ZRRA18_05_F01                           .  " FORM-Routines


 START-OF-SELECTION.
  PERFORM GET_DATA.
  CALL SCREEN '0100'.
