@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for transaction'
define root view entity ZVI_transaction as select from zvt_transaction
composition [0..*] of zvi_anomaly as _Anomalies
{
    
   key transaction_id as TransactionId,
   vendor_id as VendorId,
   invoice_id as InvoiceId,
   transaction_date as TransactionDate,
   transaction_time as TransactionTime,
   amount as Amount,
   currency as Currency,
   payment_method as PaymentMethod,
   transaction_status as TransactionStatus,
   risk_score as RiskScore,
   risk_lvl as RiskLvl,
   review_status as ReviewStatus,
   created_by as CreatedBy,
   craeted_at as CraetedAt,
   last_changed_at as LastChangedAt,
   _Anomalies
}
