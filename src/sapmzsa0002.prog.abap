*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0002_top                            .    " Global Data

INCLUDE mzsa0002_o01                            .  " PBO-Modules
INCLUDE mzsa0002_i01                            .  " PAI-Modules
INCLUDE mzsa0002_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default.
