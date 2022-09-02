*&---------------------------------------------------------------------*
*& Report ZRSA18_50_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa18_50_1_top                         .    " Global Data

 INCLUDE zrsa18_50_1_o01                         .  " PBO-Modules
 INCLUDE zrsa18_50_1_i01                         .  " PAI-Modules
 INCLUDE zrsa18_50_1_f01                         .  " FORM-Routines

 INITIALIZATION.
 "기본값 설정
 PERFORM set_init.


 AT SELECTION-SCREEN OUTPUT.  "PBO
   MESSAGE s000(zmcsa18) WITH 'PBO'.

 AT SELECTION-SCREEN.  "PAI

 START-OF-SELECTION.
  SELECT SINGLE *
    FROM sflight
*    INTO sflight
    WHERE carrid = pa_car
    AND connid = pa_con
    AND fldate IN so_dat[].

   CALL SCREEN 100.
   MESSAGE s000(zmcsa18) with 'After call screen'.
