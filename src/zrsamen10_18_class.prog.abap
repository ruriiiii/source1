*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_18_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar FOR EVENT toolbar
      OF cl_gui_alv_grid
      IMPORTING e_object.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_toolbar.

    DATA ls_button TYPE stb_button.

    ls_button-butn_type = '0'.
    ls_button-function = 'SAVE'.
    ls_button-icon = ICON_SYSTEM_SAVE.
    ls_button-text = '저장'.
    ls_button-quickinfo = 'Save'.

    INSERT ls_button INTO e_object->mt_toolbar index 1.

  ENDMETHOD.
ENDCLASS.
