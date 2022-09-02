*&---------------------------------------------------------------------*
*& Report ZRSAMEN01_18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsamen01_18.

Data ok_code type sy-ucomm.

TABLES zssa1840.
DATA gs_flight TYPE zssa1840.


SELECT-OPTIONS : so_car FOR gs_flight-carrid NO-EXTENSION,
                 so_con FOR gs_flight-connid NO-EXTENSION,
                 so_dat FOR gs_flight-fldate NO-EXTENSION.

START-OF-SELECTION.
CALL SCREEN 100.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
* SET TITLEBAR 'xxx'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
