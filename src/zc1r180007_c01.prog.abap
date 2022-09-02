*&---------------------------------------------------------------------*
*& Include          ZC1R180007_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS :
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING
          er_data_changed,
       HANDLE_CHANGED_FINISHED FOR EVENT DATA_CHANGED_FINISHED OF cl_gui_alv_grid
        IMPORTING
          E_MODIFIED
          ET_GOOD_CELLS.


ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_EVENT_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_data_changed.

    PERFORM handle_data_changed USING er_data_changed.


  ENDMETHOD.

  METHOD handle_changed_finished.

    PERFORM HANDLE_changed_finished USING E_MODIFIED ET_GOOD_CELLS.

  ENDMETHOD.

ENDCLASS.
