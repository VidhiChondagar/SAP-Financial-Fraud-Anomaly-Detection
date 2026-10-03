@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for financial anomaly'
@Metadata.allowExtensions: true

define view entity ZVC_ANOMALY
  as projection on ZVI_ANOMALY
{
    key AnomalyId,

    TransactionId,
    AnomalyType,
    Description,
    RiskPoints,
    DetectedAt,
    ResolutionStatus,

    _transaction : redirected to parent ZVC_TRANSACTION
}
