CLASS lhc_zvi_anomaly DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR zvi_anomaly RESULT result.

    METHODS ResolveAnomaly FOR MODIFY
      IMPORTING keys FOR ACTION zvi_anomaly~ResolveAnomaly.

ENDCLASS.


CLASS lhc_zvi_anomaly IMPLEMENTATION.

  METHOD get_instance_authorizations.

    result = CORRESPONDING #( keys ).

  ENDMETHOD.


  METHOD ResolveAnomaly.

    LOOP AT keys INTO DATA(ls_key).

      UPDATE zvt_anomaly
        SET resolution_status = 'RESOLVED'
        WHERE anomaly_id = @ls_key-%tky.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.



CLASS lhc_ZVI_transaction DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR ZVI_transaction RESULT result.

    METHODS AnalyzeTransaction FOR MODIFY
      IMPORTING keys FOR ACTION ZVI_transaction~AnalyzeTransaction.

    METHODS ClearTransaction FOR MODIFY
      IMPORTING keys FOR ACTION ZVI_transaction~ClearTransaction.

    METHODS ConfirmSuspicious FOR MODIFY
      IMPORTING keys FOR ACTION ZVI_transaction~ConfirmSuspicious.

    METHODS MarkUnderReview FOR MODIFY
      IMPORTING keys FOR ACTION ZVI_transaction~MarkUnderReview.

ENDCLASS.



CLASS lhc_ZVI_transaction IMPLEMENTATION.

  METHOD get_instance_authorizations.

  ENDMETHOD.


  METHOD AnalyzeTransaction.

    READ ENTITIES OF ZVI_transaction IN LOCAL MODE
      ENTITY ZVI_transaction
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_transactions).

    LOOP AT lt_transactions INTO DATA(ls_transaction).

      DATA(lv_risk_score) = 0.
      DATA(lv_duplicate_invoice) = 0.
      DATA(lv_vendor_count) = 0.
      DATA(lv_transaction_count) = 0.


      "Duplicate Invoice Rule
      SELECT COUNT( * )
        FROM zvt_transaction
        WHERE invoice_id = @ls_transaction-InvoiceId
          AND transaction_id <> @ls_transaction-TransactionId
        INTO @lv_duplicate_invoice.

      IF lv_duplicate_invoice > 0.

        DATA(lv_duplicate_points) = 40.
        lv_risk_score = lv_risk_score + lv_duplicate_points.

        "check whether anomaly already exists
        SELECT SINGLE anomaly_id
          FROM zvt_anomaly
          WHERE anomaly_id = @ls_transaction-TransactionId
          INTO @DATA(lv_existing_anomaly).

        IF sy-subrc <> 0.

          DATA lv_timestamp TYPE timestampl.
          GET TIME STAMP FIELD lv_timestamp.

          DATA ls_anomaly TYPE zvt_anomaly.

          ls_anomaly-anomaly_id        = ls_transaction-TransactionId.
          ls_anomaly-transaction_id    = ls_transaction-TransactionId.
          ls_anomaly-anomaly_type      = 'DUPLICATE_INVOICE'.
          ls_anomaly-description       = 'Duplicate invoice detected'.
          ls_anomaly-risk_points       = lv_duplicate_points.
          ls_anomaly-detected_at       = lv_timestamp.
          ls_anomaly-resolution_status = 'OPEN'.

          INSERT zvt_anomaly FROM @ls_anomaly.

        ENDIF.

      ENDIF.


      "High Amount Rule
      IF ls_transaction-Amount > 50000.

        DATA(lv_high_amount_points) = 30.
        lv_risk_score = lv_risk_score + lv_high_amount_points.

        DATA(lv_high_amount_id) =
          |HA{ ls_transaction-TransactionId+2(8) }|.

        SELECT SINGLE anomaly_id
          FROM zvt_anomaly
          WHERE anomaly_id = @lv_high_amount_id
          INTO @DATA(lv_existing_high_amount).

        IF sy-subrc <> 0.

          DATA lv_high_amount_timestamp TYPE timestampl.
          GET TIME STAMP FIELD lv_high_amount_timestamp.

          DATA ls_high_amount_anomaly TYPE zvt_anomaly.

          ls_high_amount_anomaly-anomaly_id =
            lv_high_amount_id.

          ls_high_amount_anomaly-transaction_id =
            ls_transaction-TransactionId.

          ls_high_amount_anomaly-anomaly_type =
            'HIGH_AMOUNT'.

          ls_high_amount_anomaly-description =
            'Transaction amout exceeds threshold'.

          ls_high_amount_anomaly-risk_points =
            lv_high_amount_points.

          ls_high_amount_anomaly-resolution_status =
            'OPEN'.

          ls_high_amount_anomaly-detected_at =
            lv_high_amount_timestamp.

          INSERT zvt_anomaly FROM @ls_high_amount_anomaly.

        ENDIF.

      ENDIF.


      "High Vendor Frequency
      SELECT COUNT( * )
        FROM zvt_transaction
        WHERE vendor_id = @ls_transaction-VendorId
        INTO @lv_vendor_count.

      IF lv_vendor_count > 5.

        DATA(lv_high_frequency_points) = 20.
        lv_risk_score = lv_risk_score + lv_high_frequency_points.

        DATA(lv_high_frequency_id) =
          |HF{ ls_transaction-TransactionId+2(8) }|.

        SELECT SINGLE anomaly_id
          FROM zvt_anomaly
          WHERE anomaly_id = @lv_high_frequency_id
          INTO @DATA(lv_existing_high_frequency).

        IF sy-subrc <> 0.

          DATA lv_high_frequency_timestamp TYPE timestampl.
          GET TIME STAMP FIELD lv_high_frequency_timestamp.

          DATA ls_high_frequency_anomaly TYPE zvt_anomaly.

          ls_high_frequency_anomaly-anomaly_id =
            lv_high_frequency_id.

          ls_high_frequency_anomaly-transaction_id =
            ls_transaction-TransactionId.

          ls_high_frequency_anomaly-anomaly_type =
            'HIGH_FREQUENCY'.

          ls_high_frequency_anomaly-description =
            'Vendor transaction frequency is high'.

          ls_high_frequency_anomaly-risk_points =
            lv_high_frequency_points.

          ls_high_frequency_anomaly-detected_at =
            lv_high_frequency_timestamp.

          ls_high_frequency_anomaly-resolution_status =
            'OPEN'.

          INSERT zvt_anomaly FROM @ls_high_frequency_anomaly.

        ENDIF.

      ENDIF.


      "Unusual Time Rule
      IF ls_transaction-TransactionTime < '09:00:00'
         OR ls_transaction-TransactionTime > '18:00:00'.

        DATA(lv_unusual_time_points) = 20.
        lv_risk_score = lv_risk_score + lv_unusual_time_points.

        DATA(lv_unusual_time_id) =
          |UT{ ls_transaction-TransactionId+2(8) }|.

        SELECT SINGLE anomaly_id
          FROM zvt_anomaly
          WHERE anomaly_id = @lv_unusual_time_id
          INTO @DATA(lv_existing_unusual_time).

        IF sy-subrc <> 0.

          DATA lv_unusual_time_timestamp TYPE timestampl.
          GET TIME STAMP FIELD lv_unusual_time_timestamp.

          DATA ls_unusual_time_anomaly TYPE zvt_anomaly.

          ls_unusual_time_anomaly-anomaly_id =
            lv_unusual_time_id.

          ls_unusual_time_anomaly-transaction_id =
            ls_transaction-TransactionId.

          ls_unusual_time_anomaly-anomaly_type =
            'UNUSUAL_TIME'.

          ls_unusual_time_anomaly-description =
            'Transaction occurred outside business hours'.

          ls_unusual_time_anomaly-risk_points =
            lv_unusual_time_points.

          ls_unusual_time_anomaly-detected_at =
            lv_unusual_time_timestamp.

          ls_unusual_time_anomaly-resolution_status =
            'OPEN'.

          INSERT zvt_anomaly FROM @ls_unusual_time_anomaly.

        ENDIF.

      ENDIF.


      "Multiple Transaction Rule
      SELECT COUNT( * )
        FROM zvt_transaction
        WHERE vendor_id = @ls_transaction-VendorId
          AND transaction_date = @ls_transaction-TransactionDate
          AND transaction_id <> @ls_transaction-TransactionId
        INTO @lv_transaction_count.

      IF lv_transaction_count >= 2.

        DATA(lv_multiple_points) = 20.
        lv_risk_score = lv_risk_score + lv_multiple_points.

        DATA(lv_multiple_id) =
          |MT{ ls_transaction-TransactionId+2(8) }|.

        SELECT SINGLE anomaly_id
          FROM zvt_anomaly
          WHERE anomaly_id = @lv_multiple_id
          INTO @DATA(lv_existing_multiple).

        IF sy-subrc <> 0.

          DATA lv_multiple_timestamp TYPE timestampl.
          GET TIME STAMP FIELD lv_multiple_timestamp.

          DATA ls_multiple_anomaly TYPE zvt_anomaly.

          ls_multiple_anomaly-anomaly_id =
            lv_multiple_id.

          ls_multiple_anomaly-transaction_id =
            ls_transaction-TransactionId.

          ls_multiple_anomaly-anomaly_type =
            'MULTIPLE_TRANSACTIONS'.

          ls_multiple_anomaly-description =
            'Multiple transactions detected for vendor'.

          ls_multiple_anomaly-risk_points =
            lv_multiple_points.

          ls_multiple_anomaly-detected_at =
            lv_multiple_timestamp.

          ls_multiple_anomaly-resolution_status =
            'OPEN'.

          INSERT zvt_anomaly FROM @ls_multiple_anomaly.

        ENDIF.

      ENDIF.


      "Risk Level
      DATA(lv_risk_level) = 'LOW'.

      IF lv_risk_score >= 80.
        lv_risk_level = 'CRITICAL'.

      ELSEIF lv_risk_score >= 60.
        lv_risk_level = 'HIGH'.

      ELSEIF lv_risk_score >= 30.
        lv_risk_level = 'MEDIUM'.

      ENDIF.


      "Update Transaction
      MODIFY ENTITIES OF ZVI_transaction IN LOCAL MODE
        ENTITY ZVI_transaction
        UPDATE FIELDS ( RiskScore RiskLvl )
        WITH VALUE #(
          ( %tky      = ls_transaction-%tky
            RiskScore = lv_risk_score
            RiskLvl   = lv_risk_level )
        ).

    ENDLOOP.

  ENDMETHOD.


  METHOD ClearTransaction.

    MODIFY ENTITIES OF ZVI_transaction IN LOCAL MODE
      ENTITY ZVI_transaction
      UPDATE FIELDS ( ReviewStatus )
      WITH VALUE #(
        FOR key IN keys
        ( %tky = key-%tky
          ReviewStatus = 'CLEARED' )
      ).

  ENDMETHOD.


  METHOD ConfirmSuspicious.

    MODIFY ENTITIES OF ZVI_transaction IN LOCAL MODE
      ENTITY ZVI_transaction
      UPDATE FIELDS ( ReviewStatus )
      WITH VALUE #(
        FOR key IN keys
        ( %tky = key-%tky
          ReviewStatus = 'CONFIRMED_SUSPICIOUS' )
      ).

  ENDMETHOD.


  METHOD MarkUnderReview.

    MODIFY ENTITIES OF ZVI_transaction IN LOCAL MODE
      ENTITY ZVI_transaction
      UPDATE FIELDS ( ReviewStatus )
      WITH VALUE #(
        FOR key IN keys
        ( %tky = key-%tky
          ReviewStatus = 'UNDER_REVIEW' )
      ).

  ENDMETHOD.

ENDCLASS.
