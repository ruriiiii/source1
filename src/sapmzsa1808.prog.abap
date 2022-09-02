*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1808
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1808_top                            .    " Global Data

INCLUDE mzsa1808_o01                            .  " PBO-Modules
INCLUDE mzsa1808_i01                            .  " PAI-Modules
INCLUDE mzsa1808_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.

  SELECT SINGLE pernr
    FROM ztsa1805
    INTO zssa1861-pernr.
