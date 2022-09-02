*&---------------------------------------------------------------------*
*& Report ZRSA18_40
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa18_40_top                           .    " Global Data

* INCLUDE ZRSA18_40_O01                           .  " PBO-Modules
* INCLUDE ZRSA18_40_I01                           .  " PAI-Modules
* INCLUDE ZRSA18_40_F01                           .  " FORM-Routines


INITIALIZATION.
  pa_depno = 'D220101'.

START-OF-SELECTION.

SELECT *
    FROM ztsa18std  "student table
    INTO CORRESPONDING FIELDS OF TABLE st_info

    WHERE depno = pa_depno.





SELECT SINGLE *
  FROM ztsa18dep
  INTO CORRESPONDING FIELDS OF dss_info
  WHERE depno = pa_depno.


SELECT SINGLE *
  FROM ztsa18dep_t
  INTO CORRESPONDING FIELDS OF dss_info
  WHERE depno = pa_depno.


LOOP AT st_info INTO ss_info.

ss_info-depnm = dss_info-depnm.
ss_info-major = dss_info-major.

if ss_info-gender = '1'.
  ss_info-gender_t = '남성'.
ELSE.
  ss_info-gender_t = '여성'.
ENDIF.


MODIFY st_info FROM ss_info.




ENDLOOP.










cl_demo_output=>display_data( st_info ).
*cl_demo_output=>display_data( dss_info ).
