*&---------------------------------------------------------------------*
*& Report ZRSA18_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_30.

types: BEGIN OF ts_info,
        stdno type n LENGTH 8,
        sname type c LENGTH 40,
       END OF ts_info.

Data gs_std type ts_info.

gs_std-stdno = '20220001'.
gs_std-sname = 'Kang SK'.
