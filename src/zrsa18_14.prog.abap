*&---------------------------------------------------------------------*
*& Report ZRSA18_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA18_14.

*TYPES: BEGIN OF ts_cat,
*          home type c LENGTH 10,
*          name type c LENGTH 10,
*          age TYPE i,
*       END OF ts_cat.
*
*Data gs_cat type ts_cat.
*Data xxx type ts_cat-age.
*Data xxx like gs_cat-age.
*DATA xxx like gs_cat.



*data: gv_cat_name type c LENGTH 10,
*      gv_cat_age type i.
*
*Data: BEGIN OF gs_cat,
*        name TYPE c LENGTH 10,
*        age type i,
*      END OF gs_cat.
* structure variable,  name과 age는 컴포넌트(컴포넌트는 -로 연결)

*WRITE gs_cat-age.
*gs_cat-age = 2.
*IF gs_cat is NOT INITIAL.
*  WRITE 'Check'.
*ENDIF.



"Transparent Table = Structure Type
Data gs_scarr type scarr.

PARAMETERS pa_carr like gs_scarr-carrid.

select SINGLE carrid carrname currcode
  From scarr
  into CORRESPONDING FIELDS OF gs_scarr   "field에 딱 맞게 들어가기 위해서 corresponding fields of 사용
  WHERE carrid = pa_carr.

  WRITE: gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.
