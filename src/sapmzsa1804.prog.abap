*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1804
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA1804_TOP                            .    " Global Data

 INCLUDE MZSA1804_O01                            .  " PBO-Modules
 INCLUDE MZSA1804_I01                            .  " PAI-Modules
 INCLUDE MZSA1804_F01                            .  " FORM-Routines

 LOAD-OF-PROGRAM.

    select SINGLE PERNR
    from ztsa0001
    into CORRESPONDING FIELDS OF zssa1831.
