*&---------------------------------------------------------------------*
*& Report ZBC405_A18_M07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zbc405_a18_m07_top                      .    " Global Data

* INCLUDE ZBC405_A18_M07_O01                      .  " PBO-Modules
* INCLUDE ZBC405_A18_M07_I01                      .  " PAI-Modules
* INCLUDE ZBC405_A18_M07_F01                      .  " FORM-Routines


TYPES: BEGIN OF ts_emp,
         pernr    TYPE ztsa2001-pernr,
         ename    TYPE ztsa2001-ename,
         depid    TYPE ztsa2001-depid,
         gender   TYPE ztsa2001-gender,
         gender_t TYPE c LENGTH 10,
         phone    TYPE ztsa2002-phone,
       END OF ts_emp.

DATA: gs_emp TYPE ts_emp,
      gt_emp LIKE TABLE OF gs_emp,
      gs_dep TYPE ztsa2002,
      gt_dep LIKE TABLE OF gs_dep.


*SELECT SINGLE pernr gender
*  FROM ztsa2001
*  INTO CORRESPONDING FIELDS OF gs_emp
*  WHERE pernr = '20220001'.
*
*
*WRITE: '사원명', gs_emp-pernr.
*NEW-LINE.
*WRITE: 'Ename : ', gs_emp-ename.
*NEW-LINE.
*WRITE: '부서코드 : ', gs_emp-depid.
*WRITE: /'성별 :', gs_emp-gender.


"Loop문
SELECT *
  FROM ztsa2001
  INTO CORRESPONDING FIELDS OF TABLE gt_emp.


*LOOP AT gt_emp INTO gs_emp.
*  "gs_emp를 바꾸는 로직
*  CASE gs_emp-gender.
*    WHEN '1'.
*      gs_emp-gender_t = '남성'.
*    WHEN '2'.
*      gs_emp-gender_t = '여성'.
*  ENDCASE.
*
*  SELECT SINGLE phone
*    FROM ztsa2002
*    INTO CORRESPONDING FIELDS OF gs_emp
*    WHERE depid = gs_emp-depid.
*
*
*
*
*  MODIFY gt_emp FROM gs_emp.
*  CLEAR gs_emp.
*ENDLOOP.




SELECT *
  FROM ztsa2002
  INTO CORRESPONDING FIELDS OF TABLE gt_dep.

LOOP AT gt_emp INTO gs_emp.
  "gs_emp
  READ TABLE gt_dep INTO gs_dep with key depid = gs_emp-depid.

  gs_emp-phone = gs_dep-phone.



  MODIFY gt_emp FROM gs_emp.
  CLEAR: gs_emp, gs_dep.
ENDLOOP.







cl_demo_output=>display_data( gt_emp ).
