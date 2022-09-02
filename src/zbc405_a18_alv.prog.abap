*&---------------------------------------------------------------------*
*& Report ZBC405_A18_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a18_alv_top                      .    " Global Data
INCLUDE zbc405_a18_alv_e01.

* INCLUDE ZBC405_A18_ALV_O01                      .  " PBO-Modules
* INCLUDE ZBC405_A18_ALV_I01                      .  " PAI-Modules
* INCLUDE ZBC405_A18_ALV_F01                      .  " FORM-Routines
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
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

*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container      "ALV가 얹혀지는 곳
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

gv_variant-report = sy-cprog.
gv_variant-variant = pa_lv.
gv_save = 'A'.


    CALL METHOD go_alv_grid->set_table_for_first_display
  EXPORTING
*    i_buffer_active               =
*    i_bypassing_buffer            =
*    i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
    is_variant                    = gv_variant
    i_save                        = gv_save
    i_default                     = 'X'
*    is_layout                     =
*    is_print                      =
*    it_special_groups             =
*    it_toolbar_excluding          =
*    it_hyperlink                  =
*    it_alv_graphics               =
*    it_except_qinfo               =
*    ir_salv_adapter               =
      CHANGING
        it_outtab = gt_flt
*   it_fieldcatalog               =
*   it_sort   =
*   it_filter =
*  EXCEPTIONS
*   invalid_parameter_combination = 1
*   program_error                 = 2
*   too_many_lines                = 3
*   others    = 4
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.
