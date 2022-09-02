*&---------------------------------------------------------------------*
*& Report ZBC401_A18_INTERFACE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a18_interface.

INTERFACE intf.
  DATA: ch1 TYPE i,
        ch2 TYPE i.

  METHODS met1.

ENDINTERFACE.

CLASS cl1 DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf.
ENDCLASS.

CLASS cl1 IMPLEMENTATION.
  METHOD intf~met1.

    DATA re1 TYPE i.
    re1 = intf~ch1 + intf~ch2.

    WRITE:/ 'result + :', re1.
  ENDMETHOD.
ENDCLASS.

CLASS cl2 DEFINITION.
  PUBLIC SECTION.
    INTERFACES intf.
ENDCLASS.

CLASS cl2 IMPLEMENTATION.
  METHOD intf~met1.

    DATA re1 TYPE i.
    re1 = intf~ch1 * intf~ch2.

    WRITE:/ 'result * :', re1.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  DATA clobj1 TYPE REF TO cl1.

  CREATE OBJECT clobj1.

  clobj1->intf~ch1 = 10.
  clobj1->intf~ch2 = 20.

  CALL METHOD clobj1->intf~met1.


  DATA clobj2 TYPE REF TO cl2.

  CREATE OBJECT clobj2.

  clobj2->intf~ch1 = 10.
  clobj2->intf~ch2 = 20.

  CALL METHOD clobj2->intf~met1.
