*&---------------------------------------------------------------------*
*& Include          ZC1R180004_C01
*&---------------------------------------------------------------------*
"Inheritance   : 상속성
"Encapsulation : 캡슐화
"Polymorphism  : 다형성

CLASS lcl_event_handler DEFINITION FINAL.  "final이 붙는 의미 : 이 로컬에서만 사용
  PUBLIC SECTION.
    METHODS :
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column,
      handle_hotspot FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id.


*    CLASS-METHODS : on_doubleclick FOR EVENT double_click
*      OF cl_gui_alv_grid
*      IMPORTING e_row e_column es_row_no,
*
*      on_hotspot FOR EVENT hotspot_click
*        OF cl_gui_alv_grid
*        IMPORTING e_row_id e_column_id es_row_no.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_double_click.

    PERFORM handle_double_click USING e_row e_column.

*    CASE e_column-fieldname.
*      WHEN 'MATNR'.
*        READ TABLE gt_data INTO gs_data INDEX e_row-index.
*
*        SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
*        CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
*
*    ENDCASE.

  ENDMETHOD.

  METHOD handle_hotspot.

    PERFORM handle_hotspot USING e_row_id e_column_id.

  ENDMETHOD.






*  METHOD on_hotspot.
*    CASE e_column_id-fieldname.
*       WHEN 'STLNR'.
*         READ TABLE gt_data INTO gs_data INDEX e_row_id-index.
*
*         SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
*         SET PARAMETER ID 'WRK' FIELD gs_data-werks.
*
*
*
*         CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.
*
*     ENDCASE.
*
*
*  ENDMETHOD.

ENDCLASS.
