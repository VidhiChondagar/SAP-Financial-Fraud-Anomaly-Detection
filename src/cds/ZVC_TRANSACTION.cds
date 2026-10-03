@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for financial transaction'
@Metadata.allowExtensions: true

define root view entity ZVC_TRANSACTION
  provider contract transactional_query
  as projection on ZVI_TRANSACTION
{
    key TransactionId,

    VendorId,
    InvoiceId,
    TransactionDate,
    TransactionTime,
    Amount,
    Currency,
    PaymentMethod,
    TransactionStatus,
    RiskScore,
    RiskLvl,
    ReviewStatus,
    CreatedBy,
    CraetedAt,
    LastChangedAt,

    _Anomalies : redirected to composition child ZVC_ANOMALY
}
