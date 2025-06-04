select ReceivedDate, SCMDate, WKO_ItemID, IMA_SupercededItemID, WSS_SubmitQty, A.IMA_UnitMeasure, 
IMA_SalesConvFactor, WSS_SubmitQty/IMA_SalesConvFactor as QtySAP, PDLot, WSS_Status, IMA_ProdFam, 
B.IMA_ItemName, Attribute9_Value as CostCenter,
replace(convert(varchar, SCMDate, 105), '-', '.') AS SCMFormattedDate,
replace(convert(varchar, ReceivedDate, 105), '-', '.') AS ReceivedFormattedDate,
case when WSS_Status = 'Received' then ' ' end as 'Stocktype', 
case when WSS_Status = 'Received' then '1' end as 'Location',
case when IMA_SalesConvFactor = '1000' then 'Ton'
     when IMA_SalesConvFactor = '1' then 'KG' 
	 end as UnE
from vw_MFC_SendToSCM A
left join IMA B on WKO_ItemID = IMA_ItemID
left join ItemAttribute C on IMA_RecordID = ItemAttr_IMA_RecordID
where IMA_ItemTypeCode in ('81-Fg','21-WIP') 
and IMA_M_SCMReceiveFlag = '1' 
and IMA_SupercededItemID is not null
and WSS_Status = 'Received' 
