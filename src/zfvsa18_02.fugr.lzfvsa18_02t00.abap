*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAPLANE_A18....................................*
DATA:  BEGIN OF STATUS_ZSAPLANE_A18                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAPLANE_A18                  .
CONTROLS: TCTRL_ZSAPLANE_A18
            TYPE TABLEVIEW USING SCREEN '0110'.
*...processing: ZSCARR_A18......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A18                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A18                    .
CONTROLS: TCTRL_ZSCARR_A18
            TYPE TABLEVIEW USING SCREEN '0080'.
*...processing: ZSFLIGHT_A18....................................*
DATA:  BEGIN OF STATUS_ZSFLIGHT_A18                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSFLIGHT_A18                  .
CONTROLS: TCTRL_ZSFLIGHT_A18
            TYPE TABLEVIEW USING SCREEN '0060'.
*...processing: ZSPFLI_A18......................................*
DATA:  BEGIN OF STATUS_ZSPFLI_A18                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSPFLI_A18                    .
CONTROLS: TCTRL_ZSPFLI_A18
            TYPE TABLEVIEW USING SCREEN '0070'.
*...processing: ZVRMAT18........................................*
DATA:  BEGIN OF STATUS_ZVRMAT18                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVRMAT18                      .
CONTROLS: TCTRL_ZVRMAT18
            TYPE TABLEVIEW USING SCREEN '0120'.
*.........table declarations:.................................*
TABLES: *ZSAPLANE_A18                  .
TABLES: *ZSCARR_A18                    .
TABLES: *ZSFLIGHT_A18                  .
TABLES: *ZSPFLI_A18                    .
TABLES: *ZVRMAT18                      .
TABLES: ZSAPLANE_A18                   .
TABLES: ZSCARR_A18                     .
TABLES: ZSFLIGHT_A18                   .
TABLES: ZSPFLI_A18                     .
TABLES: ZVRMAT18                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
