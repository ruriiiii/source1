*&---------------------------------------------------------------------*
*& Report ZRSA18_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZRSA18_25_TOP                           .    " Global Data

* INCLUDE ZRSA18_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA18_25_I01                           .  " PAI-Modules
 INCLUDE ZRSA18_25_F01                           .  " FORM-Routines

 START-OF-SELECTION.
  Select *
      FROM sflight
    into CORRESPONDING FIELDS OF TABLE gt_info
    WHERE carrid = pa_car
*    And connid In so_con[].  "[]는 생략 가능, 실제로는 아래 between문보다 SELECT-OPTIONS을 사용
    And connid BETWEEN pa_con1 AND pa_con2.

  cl_demo_output=>display_data( gt_info ).
