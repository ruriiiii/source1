*&---------------------------------------------------------------------*
*& Report ZBC405_A18_M04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a18_m04_top                      .    " Global Data

* INCLUDE ZBC405_A18_M04_O01                      .  " PBO-Modules
* INCLUDE ZBC405_A18_M04_I01                      .  " PAI-Modules
* INCLUDE ZBC405_A18_M04_F01                      .  " FORM-Routines

"초기화설정

INITIALIZATION.
  gv_text = '버튼'.
  gv_chg = 1.

"Tab 초기설정
  tab1 = 'Car Info'.
  tab2 = 'Fldate'.
  ts_info-activetab = 'FID'.
  ts_info-dynnr = '1200'.

"fid 초기값 설정
 so_fid-low+0(4) = sy-datum+0(4) - 2.
 so_fid-low+4 = sy-datum+4.
* so_fid-high+0(4) = sy-datum+0(4).
*so_fid-high+4 = '1231'.
so_fid-high = sy-datum+0(4) && '1231'.
append so_fid.



  "PBO

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        screen-active = gv_chg.
        MODIFY SCREEN.
    ENDCASE.
  ENDLOOP.

  "PAI

AT SELECTION-SCREEN.
  CHECK sy-dynnr = '1000'.
  CASE sscrfields-ucomm.
    WHEN 'ON'.
      CASE gv_chg.
        WHEN '1'.
          gv_chg = 0.
        WHEN '0'.
          gv_chg = 1.
      ENDCASE.
  ENDCASE.
