*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1850
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA1850_TOP                            .    " Global Data

 INCLUDE MZSA1850_O01                            .  " PBO-Modules
 INCLUDE MZSA1850_I01                            .  " PAI-Modules
 INCLUDE MZSA1850_F01                            .  " FORM-Routines

 Load-OF-PROGRAM.
  ZSSA1890-CARRID = 'AA'.
  ZSSA1890-MEALNO = '7'.
