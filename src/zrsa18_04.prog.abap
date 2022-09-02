*&---------------------------------------------------------------------*
*& Report ZRSA18_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA18_04.

PARAMETERS PA_NUM TYPE I.

DATA GV_RESULT TYPE I.

MOVE PA_NUM TO GV_RESULT.

ADD 1 TO GV_RESULT.

WRITE 'YOUR INPUT:'.
*WRITE PA_NUM.
*
*NEW-LINE.
*
*WRITE 'RESULT:  '.
*WRITE GV_RESULT.


*PARAMETERS PA_NUM TYPE I.
*
*DATA GV_RESULT TYPE I.
*
*MOVE PA_NUM
*TO GV_RESULT.
*
*ADD 1 TO GV_RESULT.
*
*WRITE : 'YOUR INPUT:',
*         PA_NUM.
*
*NEW-LINE.
*
*WRITE : 'RESULT:  ',
*         GV_RESULT.
