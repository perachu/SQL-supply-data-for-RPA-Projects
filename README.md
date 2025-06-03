# SQL-supply-data-for-RPA-Projects
Extract and Transform data from database to supply RPA Projects(ETL Pipeline)

1) Flow1:
2) Flow2:

```sql
select A.ITR_TransType, A.ITR_TransDate, A.GLT_TransDate, A.IMA_ItemName, A.ITR_ItemID, 
A.TransQty, A.ITR_StockingUnitMeasure, A.IMA_PurConvFactor, (A.TransQty*-1)/A.IMA_PurConvFactor as TransQty_SAP, 
A.CostCenter, A.MLT_LotNbr, A.MWH_WhsName as MWH_WhsName_Out , A.MWL_LocationName as MWL_LocationName_Out, 
A.Key_TransNbr, B.ITR_TransNbr, B.MWH_WhsName as MWH_WhsName_In, B.MWL_LocationName as MWL_LocationName_In,
replace(convert(varchar, A.ITR_TransDate, 105), '-', '.') AS Trans_FormattedDate,
replace(convert(varchar, A.GLT_TransDate, 105), '-', '.') AS GL_FormattedDate,
case when A.IMA_PurConvFactor = '1000' then 'Ton'
	 when A.IMA_PurConvFactor = '1' then 'KG'
	 end as 'UnE',
case when A.MWH_WhsName = 'SCM-TMFC' then '1'
	 when A.MWH_WhsName = 'SCM-KNS' then 'OSW1'
	 when A.MWH_WhsName = 'SCM-STN' then 'OSW2'
	 when A.MWH_WhsName = 'SCM-SCGL' then 'OSW3'
	 when A.MWH_WhsName = 'SCM-CJW' then 'OSW4'
	 end as 'Location'
from vw_iERP_MFC_LocTransOut A
left join vw_MFC_CostCenter_Transfer B on A.Key_TransNbr = B.ITR_TransNbr
where ((A.MWH_WhsName like 'SCM%' and B.MWH_WhsName not like 'SCM%') or A.Key_TransNbr is null)
and A.IMA_LeadTimeCode = 'Purchased' 
and (A.IMA_ItemTypeCode in ('10-RM','32-Supply')) 
and A.IMA_SupercededItemID is not null 
```
