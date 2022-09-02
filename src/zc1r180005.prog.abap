*&---------------------------------------------------------------------*
*& Report ZC1R180005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R180005_TOP                          .    " Global Data

 INCLUDE ZC1R180005_S01                           . "Selection Screen
 INCLUDE ZC1R180005_C01                          .  "Class
 INCLUDE ZC1R180005_O01                          .  " PBO-Modules
 INCLUDE ZC1R180005_I01                          .  " PAI-Modules
 INCLUDE ZC1R180005_F01                          .  " FORM-Routines

 START-OF-SELECTION.
  PERFORM get_flight_list.
  PERFORM set_carrname.

  call SCREEN '0100'.
