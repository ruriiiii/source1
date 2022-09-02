*&---------------------------------------------------------------------*
*& Report ZRCA18_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca18_02.

"구구단 만들기
*DATA gv_step TYPE i.
*DATA gv_cal TYPE i.
*DATA gv_lev TYPE i.
*
*DO 9 TIMES.
*  gv_lev = gv_lev + 1.
*
*  DO 9 TIMES.
*  gv_step = gv_step + 1.
*  clear gv_cal.
*  gv_cal = gv_lev * gv_step.
*  WRITE: gv_lev,' * ', gv_step, ' = ', gv_cal.
*  NEW-LINE.
* ENDDO.
* CLEAR gv_step.
*WRITE '======================================================================'.
*NEW-LINE.
*ENDDO.

"단계를 입력하면 해당 단계까지만 출력하기.

*DATA gv_step TYPE i.
*DATA gv_cal TYPE i.
*DATA gv_lev TYPE i.
*
*PARAMETERS pa_stage Like gv_lev.    "LIKE 뒤에는 이미 선언된 변수가 나온다.
*
*DO pa_stage TIMES.
*  gv_lev = gv_lev + 1.
*
*  DO 9 TIMES.
*  gv_step = gv_step + 1.
*  clear gv_cal.
*  gv_cal = gv_lev * gv_step.
*  WRITE: gv_lev,' * ', gv_step, ' = ', gv_cal.
*  NEW-LINE.
* ENDDO.
* CLEAR gv_step.
*WRITE '======================================================================'.
*NEW-LINE.
*ENDDO.


"단계와 학년 입력시 조건에 따라 출력하기

DATA gv_step TYPE i.
DATA gv_cal TYPE i.
DATA gv_lev TYPE i.

PARAMETERS pa_stage LIKE gv_lev.    "LIKE 뒤에는 이미 선언된 변수가 나온다.
PARAMETERS pa_grade(1) TYPE c.
DATA gv_new_lev LIKE gv_lev.

CASE pa_grade.
  WHEN 1.
    IF pa_stage > 3.
    gv_new_lev = 3.
    ELSE.
    gv_new_lev = pa_stage.
    ENDIF.
  WHEN 2.
    IF pa_stage > 5.
    gv_new_lev = 5.
    ELSE.
      gv_new_lev = pa_stage.
    ENDIF.
  WHEN 3.
    IF pa_stage > 7.
    gv_new_lev = 7.
    ELSE.
      gv_new_lev = pa_stage.
    ENDIF.
  WHEN 4 OR 5.
    IF pa_stage > 9.
    gv_new_lev = 9.
    ELSE.
      gv_new_lev = pa_stage.
    ENDIF.
  WHEN 6.
    gv_new_lev = 9.

ENDCASE.

DO gv_new_lev TIMES.
  gv_lev = gv_lev + 1.

  DO 9 TIMES.
  gv_step = gv_step + 1.
  CLEAR gv_cal.
  gv_cal = gv_lev * gv_step.
  WRITE: gv_lev,' * ', gv_step, ' = ', gv_cal.
  NEW-LINE.
 ENDDO.
 CLEAR gv_step.
WRITE '======================================================================'.
NEW-LINE.
ENDDO.
