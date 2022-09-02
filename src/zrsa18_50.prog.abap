*&---------------------------------------------------------------------*
*& Report ZRSA18_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa18_50_top                           .    " Global Data

* INCLUDE ZRSA18_50_O01                           .  " PBO-Modules
* INCLUDE ZRSA18_50_I01                           .  " PAI-Modules
* INCLUDE ZRSA18_50_F01                           .  " FORM-Routines

INITIALIZATION.

START-OF-SELECTION.

SELECT *
  FROM zvsa1810
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE pernr = pa_pernr.

IF gt_info IS INITIAL.
  MESSAGE i016(pn) WITH 'Data is not found.'.
  RETURN.
ENDIF.



LOOP AT gt_info INTO gs_info.
  "부서코드, 부서명 가져오기
SELECT SINGLE depid
  FROM ztsa1801
  INTO gs_info-dcode
  WHERE pernr = pa_pernr.

SELECT SINGLE dtext
  FROM ztsa1802_2_t
  INTO gs_info-dname
  WHERE depid = gs_info-dcode.

  "제품정보 가져오기
SELECT SINGLE *
  FROM ztsa18pro
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE pcode = gs_info-pcode.


SELECT SINGLE *
  FROM ZTSA18PRO_t
  INTO CORRESPONDING FIELDS OF gs_info
  WHERE pcode = gs_info-pcode.



 IF gs_info-ptype = 'C01'.
   gs_info-ptpnm = '스낵'.
 ELSEIF gs_info-ptype = 'C02'.
   gs_info-ptpnm = '음료'.
 ELSEIF gs_info-ptype = 'C03'.
   gs_info-ptpnm = '식품'.
 ELSE.
   gs_info-ptpnm = '미정'.
 ENDIF.

 MODIFY gt_info FROM gs_info.


ENDLOOP.


  cl_demo_output=>display_data( gt_info ).
