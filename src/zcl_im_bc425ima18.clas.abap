class ZCL_IM_BC425IMA18 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK18 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BC425IMA18 IMPLEMENTATION.


  method IF_EX_BADI_BOOK18~CHANGE_VLINE.
    c_pos = c_pos + 25.
  endmethod.


  METHOD if_ex_badi_book18~output.
    DATA: name TYPE s_custname,
          country type scustom-country.

    SELECT SINGLE name country
      FROM scustom
      INTO (name, country)
      WHERE id = i_booking-customid.

    WRITE: name, country.

  ENDMETHOD.
ENDCLASS.
