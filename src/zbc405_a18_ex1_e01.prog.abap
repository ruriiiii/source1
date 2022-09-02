*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_EX01_E01
*&---------------------------------------------------------------------*

CASE 'X'.
  WHEN p_rad1.
    SELECT *
      FROM dv_flights
      INTO gs_flight
      WHERE carrid IN so_car
        AND connid IN so_con
        AND fldate IN so_dat.

      WRITE: / gs_flight-carrid,
               gs_flight-connid,
               gs_flight-fldate,
               gs_flight-countryfr,
               gs_flight-cityfrom,
               gs_flight-airpfrom,
               gs_flight-countryto,
               gs_flight-cityto,
               gs_flight-airpto,
               gs_flight-seatsmax,
               gs_flight-seatsocc.
    ENDSELECT.

   WHEN p_rad2.

     SELECT *
      FROM dv_flights
      INTO gs_flight
      WHERE carrid IN so_car
        AND connid IN so_con
        AND fldate IN so_dat
        and countryto = dv_flights~countryfr
       or countryto = ''.

      WRITE: / gs_flight-carrid,
               gs_flight-connid,
               gs_flight-fldate,
               gs_flight-countryfr,
               gs_flight-cityfrom,
               gs_flight-airpfrom,
               gs_flight-countryto,
               gs_flight-cityto,
               gs_flight-airpto,
               gs_flight-seatsmax,
               gs_flight-seatsocc.
    ENDSELECT.

    WHEN p_rad3.

     SELECT *
      FROM dv_flights
      INTO gs_flight
      WHERE carrid IN so_car
        AND connid IN so_con
        AND fldate IN so_dat
        and countryto <> dv_flights~countryfr.

      WRITE: / gs_flight-carrid,
               gs_flight-connid,
               gs_flight-fldate,
               gs_flight-countryfr,
               gs_flight-cityfrom,
               gs_flight-airpfrom,
               gs_flight-countryto,
               gs_flight-cityto,
               gs_flight-airpto,
               gs_flight-seatsmax,
               gs_flight-seatsocc.
    ENDSELECT.






ENDCASE.
