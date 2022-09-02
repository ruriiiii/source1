*&---------------------------------------------------------------------*
*& Report ZRSA18_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_37.

DATA: gs_info TYPE zvsa1802,  "Database View
      gt_info LIKE TABLE OF gs_info.

"PARAMETERS pa_dep LIKE gs_info-depid.

START-OF-SELECTION.
*SELECT *
*  FROM zvsa1802  "Database View
*  INTO CORRESPONDING FIELDS OF TABLE gt_info.
*  WHERE depid = pa_dep.



"Open SQL
*SELECT *
*  from ztsa1801 INNER JOIN ztsa1802_2
*    on ztsa1801~depid = ztsa1802_2~depid    "on은 inner join의 조건!
*  into CORRESPONDING FIELDS OF table gt_info
*  WHERE ztsa1801~depid = pa_dep.


*SELECT pernr ename a~depid phone   "depid에 a~를 지정해준 이유는 depid가 두개여서 딱 지정해줘야됨!
*  FROM ztsa1801 AS a INNER JOIN ztsa1802_2 AS b  "이 swlect문에서 ztsa1801는 a로, ztsa1802_2는 b로 부르겠다
*  ON a~depid = b~depid
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE a~depid = pa_dep.




SELECT *
  from ztsa1801 as emp LEFT OUTER JOIN ztsa1802_2 as dep   "left outer join: 왼쪽테이블에  있는 것들은 교집합이 아니어도 다 나옴
  on emp~depid = dep~depid          "조건이 더 있다면 and로 이어주면 됨
  into CORRESPONDING FIELDS OF TABLE gt_info.




  cl_demo_output=>display_data( gt_info ).
