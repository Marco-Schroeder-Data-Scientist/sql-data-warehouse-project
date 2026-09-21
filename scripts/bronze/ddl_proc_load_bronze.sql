/*
===============================================================================
Procedimiento almacenado: Cargar la capa Bronze (Origen -> Bronze)
===============================================================================
Propósito del script:
    Este procedimiento almacenado carga datos en el esquema 'bronze' desde archivos CSV externos.
    Realiza las siguientes acciones:
    - Trunca las tablas de bronze antes de cargar los datos.
    - Utiliza el comando `BULK INSERT` para cargar datos desde archivos CSV en las tablas de bronze.

Parámetros:
    Ninguno.
      Este procedimiento almacenado no acepta parámetros ni devuelve valores.

Ejemplo de uso:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE
        @start_time       DATETIME,
        @end_time         DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time   DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        BEGIN TRANSACTION;

        PRINT '================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------------';

        -----------------------------------------------------------------------
        -- Load: bronze.crm_cust_info
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\sql\dwh_project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        -----------------------------------------------------------------------
        -- Load: bronze.crm_prd_info
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\sql\dwh_project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        -----------------------------------------------------------------------
        -- Load: bronze.crm_sales_details
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\sql\dwh_project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        PRINT '------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------------';


        -----------------------------------------------------------------------
        -- Load: bronze.erp_loc_a101
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\sql\dwh_project\datasets\source_erp\loc_a101.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        -----------------------------------------------------------------------
        -- Load: bronze.erp_cust_az12
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\sql\dwh_project\datasets\source_erp\cust_az12.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        -----------------------------------------------------------------------
        -- Load: bronze.erp_px_cat_g1v2
        -----------------------------------------------------------------------
        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\sql\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
        WITH
        (
            FIRSTROW        = 2,
            FIELDTERMINATOR = ',',
            TABLOCK,
            MAXERRORS       = 0
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' seconds';
        PRINT '>> -------------';


        -----------------------------------------------------------------------
        -- Finalize process
        -----------------------------------------------------------------------
        COMMIT TRANSACTION;

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT 'Total Load Duration: '
            + CAST(
                DATEDIFF(SECOND, @batch_start_time, @batch_end_time)
                AS NVARCHAR(20)
              )
            + ' seconds';
        PRINT '==========================================';
    END TRY

    BEGIN CATCH
        IF XACT_STATE() <> 0
        BEGIN
            ROLLBACK TRANSACTION;
        END;

        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(20));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(20));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(20));
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT '==========================================';

        THROW;
    END CATCH;
END;
GO
