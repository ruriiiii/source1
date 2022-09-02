*&---------------------------------------------------------------------*
*& Include          ZYFSA18_00007_E01
*&---------------------------------------------------------------------*

START-OF-SELECTION.

select *
  from ztspfli_t03
  into CORRESPONDING FIELDS OF table gt_spf
  where carrid in so_car
    and connid in so_con.
