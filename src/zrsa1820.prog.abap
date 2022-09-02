*&---------------------------------------------------------------------*
*& Report ZRSA1820
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa1820.

DATA: BEGIN OF gs_info,
        carrid TYPE spfli-carrid,
        carrname TYPE scarr-carrname,
        connid TYPE spfli-connid,
        countryfr TYPE spfli-countryfr,
        countryto TYPE spfli-countryto,
        atype TYPE c LENGTH 10,
      END OF gs_info.
DATA gt_info LIKE TABLE OF gs_info.


gs_info-carrid = 'AA'.
gs_info-connid = '0017'.
gs_info-countryfr = 'US'.
gs_info-countryto = 'US'.
APPEND gs_info TO gt_info.

CLEAR gs_info.
gs_info-carrid = 'AA'.
gs_info-connid = '0064'.
gs_info-countryfr = 'US'.
gs_info-countryto = 'US'.
APPEND gs_info TO gt_info.

CLEAR gs_info.
gs_info-carrid = 'AZ'.
gs_info-connid = '0555'.
gs_info-countryfr = 'IT'.
gs_info-countryto = 'DE'.
APPEND gs_info TO gt_info.




LOOP AT gt_info INTO gs_info.
  DATA gs_scarr TYPE scarr.

  SELECT SINGLE carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_scarr
  WHERE carrid = gs_info-carrid.

  gs_info-carrname = gs_scarr-carrname.

  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = '국내선'.
  ELSE.
    gs_info-atype = '해외선'.
  ENDIF.

  MODIFY gt_info FROM gs_info.
ENDLOOP.


cl_demo_output=>display_data( gt_info ).

"서브루틴 하기 시러
