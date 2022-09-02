@AbapCatalog.sqlViewName: 'ZC118CDS0002_V'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '[C1] Flight and Booking View'
define view Zc118cds0002 as 
select A.carrid,
       A.connid,
       A.fldate,
       B.bookid,
       B.customid,
       B.custtype,
      case A.planetype
       when '747-400' then '@7T@'
       when 'A380-800' then '@AV@'
       else A.planetype
      end as PLANETYPE,
       A.price,
       A.currency,
       B.invoice
from sflight as A 
inner join sbook as B
on A.mandt = B.mandt
and A.carrid = B.carrid
and A.connid = B.connid
and A.fldate = B.fldate
where A.carrid = 'KA'
