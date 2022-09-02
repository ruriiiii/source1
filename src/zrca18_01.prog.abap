*&---------------------------------------------------------------------*
*& Report ZRCA18_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca18_01.

*DATA gv_gender TYPE c LENGTH 1.  " = DATA gv_gender : gender 라는 도메인 타입이 c타입, 길이 1자리. (M, F 로 표현)
*
*gv_gender = 'X'.
**IF문 사용
*IF gv_gender = 'M'.
*
*ELSEIF gv_gender = 'F'.
*
*ELSE.
*
*ENDIF.                           "예외사항처리를 위해 ELSE를 사용. ex) M과 F가 아닌 다른 값을 입력할 경우도 있기 때문에.
*
*
**CASE문 사용
*CASE gv_gender.
*  When 'M'.
*
*  When 'F'.
*
*  When others.
*
*ENDCASE.

DATA gv_num TYPE i.

DO 6 TIMES.
  gv_num = gv_num + 1.
  WRITE sy-index.
  IF gv_num > 3.
    EXIT.
  ENDIF.
  WRITE gv_num.
  NEW-LINE.
ENDDO.
