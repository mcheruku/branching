/*

	Author:			Rajendra Pratap Singh
	Date created:	10 Jun 2011
	Purpose:		The purpose the TescoSubscription DB is to hold all the master and transactional 
					data related to TescoSubscription.
	Usage:			The DB will be called by multiple applications (Interface). All the interfaces with go via 
					Appstore services.
					a)Suscription Website
					b)Backoffice Application
					c)Customer Service Application

	--Modifications History--
	Changed On		Changed By		Defect Ref		Change Description
	<dd Mmm YYYY>	<Dev Name>		<TFS no.>		<Summary of changes>

*/

--Change focus to the [master] DB for intial DB creation.
USE [master]
GO

--If the DB does not exist, create it, otherwise, report existence.
IF DB_ID(N'TescoSubscription') IS NOT NULL
	BEGIN
	
		PRINT 'EXISTS - Database [TescoSubscription] already exists.'
		
	END
ELSE
	BEGIN
	
		--Create the new DB using system defaults.
		CREATE DATABASE [TescoSubscription]

		--Apply intial DB sizing/growth for LIVE based on estimates of DB usage, data generation and any backup policy.
		IF @@SERVERNAME like 'LIV%'
			BEGIN
			
				ALTER DATABASE [TescoSubscription] MODIFY FILE (NAME = 'TescoSubscription', SIZE = 100MB, FILEGROWTH = 10%)
				ALTER DATABASE [TescoSubscription] MODIFY FILE (NAME = 'TescoSubscription_log', SIZE = 100MB, FILEGROWTH = 10%)
				
			END

		--Report on the creation of the DB.
		IF DB_ID(N'TescoSubscription') IS NOT NULL
			BEGIN
				PRINT 'SUCCESS - Database [TescoSubscription] created.'
			END
		ELSE
			BEGIN
				RAISERROR('FAIL - Database [TescoSubscription] not created.',16,1)
			END

	END
GO

--Change focus to the correct DB, to support correct execution of any following batches.
IF DB_ID(N'TescoSubscription') IS NOT NULL
	BEGIN
	
		USE [TescoSubscription]
		
	END
GO

--Ensure DB is owned by [sa] as per DB Ops requirements.
IF NOT EXISTS(SELECT
					1
				FROM
					sys.databases db
					INNER JOIN sys.sql_logins sl
						ON db.[owner_sid] = sl.[sid]
				WHERE
					db.[name] = 'TescoSubscription'
					AND sl.[name] = 'sa')
	BEGIN

		EXEC sp_changedbowner 'sa'
		
	END
GO