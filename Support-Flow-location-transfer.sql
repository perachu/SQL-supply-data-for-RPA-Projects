select *,
case 
when ITR_TransType ='Loc Transfer' and TransQty < 0 then ITR_TransNbr - 1 
when ITR_TransType = 'BOM Issue' then null
end as Key_TransNbr
from vw_MFC_CostCenter_Transfer
where (ITR_TransType = 'Loc Transfer' and TransQty < 0) or (ITR_TransType = 'BOM Issue') 
