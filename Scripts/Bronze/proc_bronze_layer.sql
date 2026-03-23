EXEC bronze.load_bronze

CREATE PROCEDURE bronze.load_bronze AS
BEGIN
DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT '==========================================================';
		PRINT 'Loading Bronze Layer';
		PRINT '==========================================================';

		PRINT '-----------------------------------------------------------';
		PRINT 'Loading crm tables';
		PRINT '-----------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>>Inserting Data Into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_crm/cust_info.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();
	PRINT '>>Truncating table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;

	PRINT '>>Inserting Data Into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_crm/prd_info.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();
	PRINT '>>Truncating table: bronze.crm_sales_details';
	TRUNCATE TABLE bronze.crm_sales_details;

	PRINT '>>Inserting Data Into: bronze.crm_sales_details';
	BULK INSERT bronze.crm_sales_details
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_crm/sales_details.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		PRINT '-----------------------------------------------------------';
		PRINT 'Loading erp tables';
		PRINT '-----------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>>Truncating table: bronze.erp_cust_az12';
	TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>>Inserting Data into: bronze.erp_cust_az12';
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_erp/cust_az12.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		PRINT '>>Truncating table: bronze.erp_loc_a101';
	TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>>Inserting data into: bronze.erp_loc_a101';
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_erp/loc_a101.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
	SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		SET @start_time = GETDATE();
		PRINT '>>Truncating table: bronze.erp_px_cat_g1v2';
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>>Inserting data into: bronze.erp_px_cat_g1v2';
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:/Users/AMIT/Documents/sql-data-warehouse-project/datasets/source_erp/px_cat_g1v2.csv'
	With(
		FIRSTROW = 2,
		FIELDTERMINATOR=',',
		TABLOCK
	);
		SET @end_time= GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'seconds';

		SET @batch_end_time= GETDATE();
		PRINT 'Loading Bronze layer is completed'
		PRINT '>> Full Batch Load Duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS VARCHAR) + 'seconds';
	END TRY
	BEGIN CATCH
	PRINT '==================================================================';
	PRINT 'Error occured loading Bronze layer';
	PRINT 'Error Message' + Error_Message();
	PRINT '==================================================================';

	END CATCH
END
