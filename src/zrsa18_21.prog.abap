*&---------------------------------------------------------------------*
*& Report ZRSA18_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_21.
TYPES: BEGIN OF ts_info,
        carrid TYPE c LENGTH 3,
        carrname TYPE scarr-carrname,
        connid TYPE spfli-connid,
        countryfr TYPE spfli-countryfr,
        countryto TYPE spfli-countryto,
        atype, "type c length 1
        atype_t type c LENGTH 10,
      END OF ts_info.

*Connection Internal Table
DATA gt_info TYPE TABLE OF ts_info.

*Structure Variable
Data gs_info like LINE OF gt_info.
*Data gs_info type ts_info. "이거 보다는 위에꺼가 나음


*Data: gs_info type ts_info,
*      gt_info Like TABLE OF gs_info. "위처럼 써도 되고 이렇게 써도 됨


PARAMETERS pa_car type spfli-carrid.
*                  like gs_info-carrid.

*PERFORM carrid using 'AA'
*                     '0017'
*                     'US'
*                     'US'.
*
*PERFORM carrid USING 'AA' '0064' 'US' 'US'.

SELECT carrid connid countryfr countryto
  from spfli
  into CORRESPONDING FIELDS OF table gt_info
where carrid = pa_car.

LOOP AT gt_info into gs_info.
  IF gs_info-countryfr = gs_info-countryto.
    gs_info-atype = 'D'.
  Else.
    gs_info-atype = 'I'.
  ENDIF.

  "Get airline Name
  select single carrname
    from scarr
    into gs_info-carrname
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info from gs_info
                 TRANSPORTING carrname atype.
  CLEAR gs_info.
ENDLOOP.


SORT gt_info By atype ASCENDING. "오름차순 정렬




cl_demo_output=>display_data( gt_info ).
*&---------------------------------------------------------------------*
*& Form carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_INFO_CARRID
*&      --> GS_INFO_CONNID
*&      --> GS_INFO_COUNTRYFR
*&      --> GS_INFO_COUNTRYTO
*&---------------------------------------------------------------------*
FORM carrid using value(p_carrid)
                  value(p_connid)
                  value(p_countryfr)
                  value(p_countryto).
  Data ls_info like line of gt_info.
  CLEAR ls_info.
  ls_info-carrid = 'AA'.
  ls_info-connid = '0017'.
  ls_info-countryfr = 'US'.
  ls_info-countryto = 'US'.
  APPEND ls_info TO gt_info.
  CLEAR ls_info.

ENDFORM.
