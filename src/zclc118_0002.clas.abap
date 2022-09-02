class ZCLC118_0002 definition
  public
  final
  create public .

public section.

  methods GET_MATERIAL_INFO
    importing
      !PI_MATNR type MAKT-MATNR
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
      !PE_MAKTX type MAKT-MAKTX .
protected section.
private section.
ENDCLASS.



CLASS ZCLC118_0002 IMPLEMENTATION.


  METHOD get_material_info.

    IF pi_matnr IS INITIAL.
      pe_code = 'E'.
      pe_msg = TEXT-e03.
      EXIT.
    ENDIF.

    SELECT single maktx
      INTO pe_maktx
      FROM makt
      WHERE matnr = pi_matnr
        AND spras = sy-langu.


    IF sy-subrc NE 0.
      pe_code = 'E'.
      pe_msg = TEXT-e02.
    ELSE.
      pe_code = 'S'.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
