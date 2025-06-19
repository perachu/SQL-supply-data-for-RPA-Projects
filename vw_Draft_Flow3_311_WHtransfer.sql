--Flow_311_WHtransfer
select A.ITR_TransType, A.ITR_TransDate, A.GLT_TransDate, A.IMA_ItemName, A.IMA_SupercededItemID, 
A.TransQty, A.ITR_StockingUnitMeasure, A.IMA_PurConvFactor, A.CostCenter, A.MLT_LotNbr, 
A.MWH_WhsName as 'MWH_WhsName_Out' , A.MWL_LocationName as 'MWL_LocationName_Out', 
A.Key_TransNbr, B.ITR_TransNbr, B.MWH_WhsName as 'MWH_WhsName_In', B.MWL_LocationName as 'MWL_LocationName_In',
replace(convert(varchar, A.ITR_TransDate, 105), '-', '.') AS 'Trans_FormattedDate',
replace(convert(varchar, A.GLT_TransDate, 105), '-', '.') AS 'GL_FormattedDate',
case when A.IMA_LeadTimeCode = 'Purchased' then (A.TransQty*-1)/A.IMA_PurConvFactor
	 when A.IMA_LeadTimeCode = 'Manufactured' then (A.TransQty*-1)/A.IMA_SalesConvFactor
	 end as 'TransQty_SAP',
case when A.IMA_LeadTimeCode = 'Purchased' then A.IMA_PurConvUnitMeasure
	 when A.IMA_LeadTimeCode = 'Manufactured' and A.IMA_SalesConvFactor = '1000' then 'Ton'
	 when A.IMA_LeadTimeCode = 'Manufactured' and A.IMA_SalesConvFactor = '1' then A.IMA_SalesConvUnitMeasure
	 end as 'UnE',
case when A.MWH_WhsName = 'SCM-TMFC' then '1'
	 when A.MWH_WhsName = 'SCM-KNS' then 'OSW1'
	 when A.MWH_WhsName = 'SCM-STN' then 'OSW2'
	 when A.MWH_WhsName = 'SCM-SCGL' then 'OSW3'
	 when A.MWH_WhsName = 'SCM-CJW' then 'OSW4'
	 when A.MWH_WhsName = 'NewBiz-TMFC' then 'OSW5'
	 end as 'Location_Out',
case when B.MWH_WhsName = 'SCM-TMFC' then '1'
	 when B.MWH_WhsName = 'SCM-KNS' then 'OSW1'
	 when B.MWH_WhsName = 'SCM-STN' then 'OSW2'
	 when B.MWH_WhsName = 'SCM-SCGL' then 'OSW3'
	 when B.MWH_WhsName = 'SCM-CJW' then 'OSW4'
	 when B.MWH_WhsName = 'NewBiz-TMFC' then 'OSW5'
	 end as 'Location_In'
from vw_iERP_MFC_LocTransOut A
left join vw_MFC_CostCenter_Transfer B on A.Key_TransNbr = B.ITR_TransNbr
where ((A.MWH_WhsName like 'SCM%' or A.MWH_WhsName like 'NewBiz%') and (B.MWH_WhsName like 'SCM%' or B.MWH_WhsName like 'NewBiz%'))
and A.MWH_WhsName != B.MWH_WhsName and A.IMA_SupercededItemID is not null 



