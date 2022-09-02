*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1804_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA1804_2_TOP                          .    " Global Data

 INCLUDE MZSA1804_2_O01                          .  " PBO-Modules
 INCLUDE MZSA1804_2_I01                          .  " PAI-Modules
 INCLUDE MZSA1804_2_F01                          .  " FORM-Routines

 load-of-PROGRAM.
 PERFORM set_default CHANGING zssa0073.
