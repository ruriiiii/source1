class ZCL_IM_BC425_A18_MNX definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_18_MX .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BC425_A18_MNX IMPLEMENTATION.


  METHOD if_ex_badi_18_mx~exit_menu_book.
    SET PARAMETER ID: 'CAR' FIELD is_book-carrid,
                     'CON' FIELD is_book-connid,
                     'DAY' FIELD is_book-fldate,
                     'BOK' FIELD is_book-bookid.
    CALL TRANSACTION 'BC425_BOOK_DET' AND SKIP FIRST SCREEN.
  ENDMETHOD.
ENDCLASS.
