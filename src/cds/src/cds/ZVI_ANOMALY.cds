@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for anomaly'

define view entity ZVI_ANOMALY
  as select from zvt_anomaly

  association to parent ZVI_TRANSACTION as _transaction
    on $projection.TransactionId = _transaction.TransactionId
{
    key anomaly_id as AnomalyId,

    transaction_id as TransactionId,
    anomaly_type   as AnomalyType,
    description    as Description,
    risk_points    as RiskPoints,
    detected_at    as DetectedAt,
    resolution_status as ResolutionStatus,

    _transaction
}
