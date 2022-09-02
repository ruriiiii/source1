*&---------------------------------------------------------------------*
*& Report ZRRA18_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrra18_04.


DATA: BEGIN OF ls_scarr,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
        url      TYPE scarr-url,
      END OF ls_scarr,
      lt_scarr LIKE TABLE OF ls_scarr.

SELECT carrid carrname url
  INTO CORRESPONDING FIELDS OF TABLE lt_scarr
  FROM scarr.


"New Syntax
SELECT carrid, carrname, url
  INTO TABLE @DATA(lt_scarr2)
  FROM scarr.
"위 선언과 셀렉트를 이걸로 끝낼 수 있음.

*READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.
"Read table 사용시에도 ls_scarr2를 선언과 동시에 사용 가능함
"신문법은 버전이 낮거나 s4hana가 아니면 사용 할 수 없음.

LOOP AT lt_scarr2 INTO DATA(ls_scarr2).

ENDLOOP.   "루프문에도 동일하게 사용 가능


"----------------------------------------------------------------

DATA pa_carr TYPE scarr-carrid.


DATA : lv_carrid   TYPE scarr-carrid,
       lv_carrname TYPE scarr-carrname.

SELECT SINGLE carrid carrname
  INTO (lv_carrid, lv_carrname)
  FROM scarr
 WHERE carrid = pa_carr.

* New syntax
SELECT SINGLE carrid, carrname
  INTO (@DATA(lv_carrid2), @DATA(lv_carrname2))
  FROM scarr
 WHERE carrid = @pa_carr.

"--------------------------------------------------------------

DATA : BEGIN OF ls_scarr3,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr3.

ls_scarr3-carrid   = 'AA'.
ls_scarr3-carrname = 'America Airline'.
ls_scarr3-url      = 'www.aa.com'.

ls_scarr3-carrid = 'KA'.

* new syntax
ls_scarr3 = VALUE #( carrid   = 'AA'       "#의 의미 : 받는 변수와 똑같은 구조로 ( ) 안의 값을 넣겠다.
                     carrname = 'Americar Airline'
                     url      = 'www.aa.com' ).

ls_scarr3 = VALUE #( carrid = 'KA' ). "기술되지 않은 필드들은 모두 CLEAR 됨

ls_scarr3 = VALUE #( BASE ls_scarr3   "->기술되지 않은 필드는 모두 유지시켜줌
                     carrid = 'KA' ).
**********************************************************************

DATA : BEGIN OF ls_scarr4,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr4,

       lt_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid   = 'AA'.
ls_scarr4-carrname = 'America Airline'.
ls_scarr4-url      = 'www.aa.com'.

APPEND ls_scarr4 TO lt_scarr4.

ls_scarr4-carrid   = 'KA'.
ls_scarr4-carrname = 'Korean Air'.
ls_scarr4-url      = 'www.ka.com'.

APPEND ls_scarr4 TO lt_scarr4.

* new syntax
REFRESH lt_scarr4.

lt_scarr4 = VALUE #(  "--> Work Area 필요 없이 데이터 append 가능
                     ( carrid   = 'AA'
                       carrname = 'America Airline'
                       url      = 'www.aa.com'
                     )
                     ( carrid   = 'KA'
                       carrname = 'Korean Air'
                       url      = 'www.ka.com'
                     )
                   ).

lt_scarr4 = VALUE #(  "--> 기존 itab의 row 모두 Refresh 되고 지금 추가한것만 남음
                     ( carrid   = 'LH'
                       carrname = 'Luft Hansa'
                       url      = 'www.lh.com'
                     )
                   ).

lt_scarr4 = VALUE #( BASE lt_scarr4 "--> 기존 itab의 row 모두 유지시킴
                     ( carrid   = 'LH'
                       carrname = 'Luft Hansa'
                       url      = 'www.lh.com'
                     )
                   ).

*LOOP AT itab INTO wa.
*
*  lt_scarr4 = VALUE #( BASE lt_scarr4
*                       ( carrid   = wa-carrid
*                         carrname = wa-carrname
*                         url      = wa-url
*                       )
*                     ).
*
*ENDLOOP.
**********************************************************************
MOVE-CORRESPONDING ls_scarr3 TO ls_scarr4.

* new syntax
ls_scarr4 = CORRESPONDING #( ls_scarr3 ).
**********************************************************************
* ITAB의 데이터 이동 문법
**********************************************************************
*gt_color = lt_color."둘다 같은 구조의 itab 이어야 함 :기존데이터 사라짐
*gt_color[] = lt_color[]."둘다 같은 구조의 itab 이어야 함
** 둘다 같은 구조의 itab이면서 기존 데이터 밑으로 append
*APPEND LINES OF lt_color TO gt_color.
*
** 같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 사라짐
*MOVE-CORRESPONDING lt_color TO gt_color.
*
**같은필드ID 에 대해서만 데이터 이동 : 기존 데이터 밑으로 append됨
*MOVE-CORRESPONDING lt_color TO gt_color KEEPING TARGET LINES.
**********************************************************************
* DB Table 과 ITAB의 Join 방법
**********************************************************************
DATA : BEGIN OF ls_key,
         carrid TYPE sflight-carrid,
         connid TYPE sflight-connid,
         fldate TYPE sflight-fldate,
       END OF ls_key,

       lt_key LIKE TABLE OF ls_key,
       lt_sbook TYPE TABLE OF sbook.

SELECT carrid connid fldate
  INTO CORRESPONDING FIELDS OF TABLE lt_key
  FROM sflight
 WHERE carrid = 'AA'.

* FOR ALL ENTRIES 의 선제조건
* 1. 반드시 정렬 먼저 할것 : SORT
* 2. 정렬 후 중복제거 할것
* 3. ITAB이 비어있는지 체크하고 수행할것 : 비어있으면 안된다
SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

IF lt_key IS NOT INITIAL.
  SELECT carrid connid fldate bookid customid custtype
    INTO CORRESPONDING FIELDS OF TABLE lt_sbook
    FROM sbook
     FOR ALL ENTRIES IN lt_key
   WHERE carrid   = lt_key-carrid
     AND connid   = lt_key-connid
     AND fldate   = lt_key-fldate
     AND customid = '00000279'.
ENDIF.
* new syntax
SORT lt_key BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM lt_key COMPARING carrid connid fldate.

SELECT a~carrid, a~connid, a~fldate, a~bookid, a~customid
  FROM sbook AS a
 INNER JOIN @lt_key AS b
    ON a~carrid = b~carrid
   AND a~connid = b~connid
   AND a~fldate = b~fldate
 WHERE a~customid = '00000279'
  INTO TABLE @DATA(lt_sbook2).
**********************************************************************
* lt_sbook2 에서 connid 의 MAX 값을 알고자 할때
SORT lt_sbook2 BY connid DESCENDING.
READ TABLE lt_sbook2 INTO DATA(ls_sbook2) INDEX 1.
*new syntax
SELECT MAX( connid ) AS connid
  FROM @lt_sbook2 AS a
  INTO @DATA(lv_max).
**********************************************************************
*SELECT carrid connid price currency fldate
*  INTO CORRESPONDING FIELDS OF TABLE gt_data
*  FROM sflight.
*
*LOOP AT gt_data INTO gs_data.
*
*  CASE gs_data-carrid.
*    WHEN 'AA'.
*      gs_data-carrid = 'BB'.
*
*      MODIFY gt_data FROM gs_data INDEX sy-tabix TRANSPORTING carrid.
*  ENDCASE.
*
*ENDLOOP.

* new syntax
SELECT CASE carrid
       	 WHEN 'AA' THEN 'BB'
         ELSE carrid
       END AS carrid, connid, price, currency, fldate
   INTO TABLE @DATA(lt_sflight)
   FROM sflight.
**********************************************************************
