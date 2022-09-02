@AbapCatalog.sqlViewAppendName: 'ZC118EXT0003_V'
@EndUserText.label: '[C1] Fake Standard Table Extend'
extend view ZC118CDS0003 with ZC118EXT0003 
{
    ztsa18002.zzsaknr,
    ztsa18002.zzkostl,
    ztsa18002.zzshkzg,
    ztsa18002.zzlgort
    
}
