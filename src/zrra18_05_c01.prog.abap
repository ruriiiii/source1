*&---------------------------------------------------------------------*
*& Include          ZRRA18_05_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS :
      on_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id
          es_row_no,

      on_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column.



ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  METHOD on_hotspot.

    READ TABLE gt_data INTO gs_data INDEX e_row_id-index.

    CASE e_column_id-fieldname.
      WHEN 'PLANETYPE'.

        IF sy-subrc NE 0.
          EXIT.

        ELSE.
          PERFORM get_airline_info.
        ENDIF.



    ENDCASE.


  ENDMETHOD.

  METHOD on_double_click.

    READ TABLE gt_data INTO gs_data INDEX e_row-index.

    IF e_column-fieldname NE 'PLANETYPE'.
      IF sy-subrc NE 0.
        EXIT.

      ELSE.
        PERFORM get_booking_info.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
