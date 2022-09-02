*&---------------------------------------------------------------------*
*& Report ZRSA18_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA18_15.

Data: BEGIN OF gs_std,            "이 부분은 gs_std 테이블을 만들기 위해 존재한다고 볼 수도 있음
        stdno type n LENGTH 8,
        sname type c LENGTH 40,
        gender type c LENGTH 1,
        gender_t type c LENGTH 10,
      END OF gs_std.
Data gt_std Like TABLE OF gs_std. "internal Table로 만들기


gs_std-stdno = '20220001'.
gs_std-sname = 'KANG'.
gs_std-gender = 'M'.
APPEND gs_std TO gt_std. "gs_std의 값을 gt_std 테이블에 넣어라

Clear gs_std.
gs_std-stdno = '20220002'.
gs_std-sname = 'Han'.
gs_std-gender = 'F'.
Append gs_std To gt_std.
clear gs_std.

LOOP AT gt_std INTO gs_std.
  gs_std-gender_t = 'Male'(t01).
  MODIFY gt_std FROM gs_std. "Index sy-tabix(생략함)   "gs_std를 가지고 gt_std를 변경하시오
  CLEAR gs_std.
ENDLOOP.





cl_demo_output=>display_data( gt_std ). "internal Table을 눈으로 확인하기 위한 방법 중 하나
*클래스           static method

*LOOP AT gt_std INTO gs_std.  "gt_std값을 gs_std에 담아라
*  WRITE: sy-tabix, gs_std-stdno,
*         gs_std-sname, gs_std-gender.
*  NEW-LINE.
*  clear gs_std.
*ENDLOOP.
*WRITE:/ sy-tabix, gs_std-stdno,
*        gs_std-sname, gs_std-gender.










*1.
*DATA: gs_xxx TYPE <Structure_type>,
*      gt_xxx LIKE TABLE OF gs_xxx.
*
* 2.
* DATA: gt_xxx TYPE <Table_type>
*       gs_xxx LIKE LINE OF gt_xxx.
*
* 3.
* DATA: gt_xxx TYPE TABLE OF <Structure_type>,  "스트럭쳐를 테이블로
*       gs_xxx LIKE LINE OF gt_xxx.
*
* 4.
* DATA: gs_xxx TYPE LINE OF <Table_type>, "테이블형태를 스트럭쳐로
*       gt_xxx LIKE TABLE OF gs_xxx.
