
ALTER PROC [dbo].[sp_IncentivePayment]
AS

Declare @EndDate Date
set @EndDate=cast(getdate() as date);


with EntranceFeeCTE(ID,ID2,FullName,AccountNo,AccountId,Amount,TrnxDate,RefereeName,RefereeAcno,RefereeSerial,RefereeCustomerID,RefereeAccountID,RefereeMobileLine,RefereeAccountName,SavingsCOA)
AS
(

SELECT       NewId(),newid(), dbo.vw_CustomerAccounts.FullName, dbo.vw_CustomerAccounts.Reference1,dbo.vw_CustomerAccounts.Id,
isnull((SELECT  top 1    Amount   
FROM            dbo.JournalEntries INNER JOIN
                         dbo.CustomerAccounts ON dbo.JournalEntries.CustomerAccountId = dbo.CustomerAccounts.Id INNER JOIN
                         dbo.InvestmentProducts ON dbo.JournalEntries.ChartOfAccountId = dbo.InvestmentProducts.ChartOfAccountId AND 
                         dbo.CustomerAccounts.CustomerAccountType_TargetProductId = dbo.InvestmentProducts.Id
						 where dbo.InvestmentProducts.Id='356AE948-2928-40A6-A174-3216E5D15300' and dbo.CustomerAccounts.CustomerId=dbo.vw_CustomerAccounts.CustomerId 
						 and Amount>0  order by dbo.JournalEntries.CreatedDate desc),0) as EntranceFee,

						 isnull((SELECT   top 1 dbo.JournalEntries.ValueDate   
FROM            dbo.JournalEntries INNER JOIN
                         dbo.CustomerAccounts ON dbo.JournalEntries.CustomerAccountId = dbo.CustomerAccounts.Id INNER JOIN
                         dbo.InvestmentProducts ON dbo.JournalEntries.ChartOfAccountId = dbo.InvestmentProducts.ChartOfAccountId AND 
                         dbo.CustomerAccounts.CustomerAccountType_TargetProductId = dbo.InvestmentProducts.Id
						 where dbo.InvestmentProducts.Id='356AE948-2928-40A6-A174-3216E5D15300' and dbo.CustomerAccounts.CustomerId=dbo.vw_CustomerAccounts.CustomerId 
						 and Amount>0 order by dbo.JournalEntries.CreatedDate),'') as CreatedDate,

vw_CustomerAccounts_1.FullName AS Referee, 
                         vw_CustomerAccounts_1.Reference1 AS RefereeAcno,vw_CustomerAccounts_1.SerialNumber,vw_CustomerAccounts_1.CustomerId AS RefereeCustomerID, vw_CustomerAccounts_1.Id AS RefereeAccountID,
						 vw_CustomerAccounts_1.Address_MobileLine, vw_CustomerAccounts_1.Description as RefereeAccountName,
						 vw_CustomerAccounts_1.ChartOfAccountId
FROM            dbo.vw_CustomerAccounts INNER JOIN
                         dbo.Referees ON dbo.vw_CustomerAccounts.CustomerId = dbo.Referees.CustomerId INNER JOIN
                         dbo.vw_CustomerAccounts AS vw_CustomerAccounts_1 ON dbo.Referees.WitnessId = vw_CustomerAccounts_1.CustomerId
						 where dbo.vw_CustomerAccounts.CustomerAccountType_TargetProductId='074BF333-DA31-EA11-BAE8-E09D31F190DB' and 
						 vw_CustomerAccounts_1.CustomerAccountType_TargetProductId='074BF333-DA31-EA11-BAE8-E09D31F190DB'
						 )

						 Select * into #EntranceFeeCTE from EntranceFeeCTE where Amount>=1000 and cast(TrnxDate as date)=@EndDate
						 --select * from #EntranceFeeCTE 
						 --drop table #EntranceFeeCTE 

						 --select * from SavingsProducts
						 --select * from InvestmentProducts

						 --select RecruitedBy,* from Customers where Reference1='031506'
						 -- select SerialNumber,* from Customers where Reference1='002912'

						 						 
INSERT INTO [dbo].[Journals]
           ([Id]
           ,[ParentId]
           ,[PostingPeriodId]
           ,[BranchId]
           ,[AlternateChannelLogId]
           ,[TotalValue]
           ,[PrimaryDescription]
           ,[SecondaryDescription]
           ,[Reference]
           ,[ApplicationUserName]
           ,[EnvironmentUserName]
           ,[EnvironmentMachineName]
           ,[EnvironmentDomainName]
           ,[EnvironmentOSVersion]
           ,[EnvironmentMACAddress]
           ,[EnvironmentMotherboardSerialNumber]
           ,[EnvironmentProcessorId]
           ,[EnvironmentIPAddress]
           ,[ModuleNavigationItemCode]
           ,[TransactionCode]
           ,[ValueDate]
           ,[SuppressAccountAlert]
           ,[IsLocked]
           ,[IntegrityHash]
  
           ,[CreatedBy]
           ,[CreatedDate])

		 --  select top 1  * from Journals order by createddate asc
		    
			SELECT ID [Id]
           ,(select   [ParentId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ParentId]
           ,(select top 1 id from PostingPeriods where IsActive=1) [PostingPeriodId]
           ,(select top 1 id from Branches) [BranchId]
           ,(select  [AlternateChannelLogId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [AlternateChannelLogId]
           ,500 [TotalValue]
           ,'Referee Incentive' [PrimaryDescription]
           ,'Received From'+' '+FullName [SecondaryDescription]
           ,'Member No'+' '+AccountNo [Reference]
           ,(select  [ApplicationUserName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ApplicationUserName]
           ,(select  [EnvironmentUserName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentUserName] 
           ,(select [EnvironmentMachineName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMachineName]
           ,(select [EnvironmentDomainName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentDomainName]
           ,(select [EnvironmentOSVersion] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentOSVersion]
           ,(select [EnvironmentMACAddress] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMACAddress]
           ,(select[EnvironmentMotherboardSerialNumber] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMotherboardSerialNumber]
           ,(select [EnvironmentProcessorId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentProcessorId]
           ,(select [EnvironmentIPAddress] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentIPAddress]
           ,(select [ModuleNavigationItemCode] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ModuleNavigationItemCode]
           ,14  [TransactionCode]
           ,getdate() [ValueDate]
           ,(select [SuppressAccountAlert] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [SuppressAccountAlert]
           ,0 [IsLocked]
           ,(select [IntegrityHash] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [IntegrityHash]
       
           ,'SYSTEM' [CreatedBy]
           ,getdate() [CreatedDate]
		   from #EntranceFeeCTE
		  -- select * from Enumerations where "key" like '%transactioncode%'

		 INSERT INTO [dbo].[JournalEntries]
           ([Id]
           ,[JournalId]
           ,[ChartOfAccountId]
           ,[CustomerAccountId]
           ,[Amount]
           ,[ValueDate]
           ,[IntegrityHash]
         
           ,[CreatedBy]
           ,[CreatedDate])

		   SELECT 
		    NEWID() [Id]
           ,ID [JournalId]
           ,'D9D203BE-FE3C-EA11-9E52-E4115BB03D0A' [ChartOfAccountId] --Entrance Fee GL
           ,RefereeAccountID [CustomerAccountId]
           ,500*-1 [Amount]
           ,getdate() [ValueDate]
           ,NULL [IntegrityHash]
         
           ,'SYSTEM' [CreatedBy]
           ,getdate() [CreatedDate]
        
		   from #EntranceFeeCTE

		   UNION
		    SELECT 
		    NEWID() [Id]
           ,ID [JournalId]
           ,SavingsCOA[ChartOfAccountId] --Legacy COA
           ,RefereeAccountID [CustomerAccountId]
           ,500 [Amount]
           ,getdate() [ValueDate]
           ,NULL [IntegrityHash]
           ,'SYSTEM' [CreatedBy]
           ,getdate()[CreatedDate]
        
		   from #EntranceFeeCTE

	---Inserting into TextAlerts
	INSERT INTO [dbo].[TextAlerts]
           ([Id]
           ,[TextMessage_Recipient]
           ,[TextMessage_Body]
           ,[TextMessage_DLRStatus]
           ,[TextMessage_Reference]
           ,[TextMessage_Origin]
           ,[TextMessage_Catalyst]
           ,[TextMessage_Priority]
           ,[TextMessage_SendRetry]
           ,[TextMessage_SecurityCritical]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[CreatedBy]
           ,[CreatedDate],
		    [CustomerId])
           --select top 1000 * from Textalerts where TextMessage_DLRStatus=4
		   --select * from Enumerations where "key" like '%dlr%'

		   select newid() [Id]
           ,RefereeMobileLine [TextMessage_Recipient]
           ,'Hi '+RefereeName+' '+',your incentive fee has been credited to your Fosa account. Refer more members to join Jamii Sacco' [TextMessage_Body]
           ,4[TextMessage_DLRStatus]
           ,''[TextMessage_Reference]
           ,1[TextMessage_Origin]
           ,'Entrance Fee'[TextMessage_Catalyst]
           ,7[TextMessage_Priority]
           ,0[TextMessage_SendRetry]
           ,0[TextMessage_SecurityCritical]
           ,NULL [ModifiedBy]
           ,getdate()[ModifiedDate]
           ,'System'[CreatedBy]
           ,getdate()[CreatedDate]
           ,RefereeCustomerID [CustomerId] from #EntranceFeeCTE
		   
---Insert Text Alert Commission
INSERT INTO [dbo].[Journals]
           ([Id]
           ,[ParentId]
           ,[PostingPeriodId]
           ,[BranchId]
           ,[AlternateChannelLogId]
           ,[TotalValue]
           ,[PrimaryDescription]
           ,[SecondaryDescription]
           ,[Reference]
           ,[ApplicationUserName]
           ,[EnvironmentUserName]
           ,[EnvironmentMachineName]
           ,[EnvironmentDomainName]
           ,[EnvironmentOSVersion]
           ,[EnvironmentMACAddress]
           ,[EnvironmentMotherboardSerialNumber]
           ,[EnvironmentProcessorId]
           ,[EnvironmentIPAddress]
           ,[ModuleNavigationItemCode]
           ,[TransactionCode]
           ,[ValueDate]
           ,[SuppressAccountAlert]
           ,[IsLocked]
           ,[IntegrityHash]
  
           ,[CreatedBy]
           ,[CreatedDate])

		 --  select top 1  * from Journals order by createddate asc
		 --select * from ChartOfAccounts where accountname like '%sms%'
		    
			SELECT ID2 [Id]
           ,(select   [ParentId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ParentId]
           ,(select top 1 id from PostingPeriods where IsActive=1) [PostingPeriodId]
           ,(select top 1 id from Branches) [BranchId]
           ,(select  [AlternateChannelLogId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [AlternateChannelLogId]
           ,10 [TotalValue]
           ,'Text Alert Commission' [PrimaryDescription]
           ,'Referee Incentive Commission' [SecondaryDescription]
           ,'Member No'+' '+AccountNo [Reference]
           ,(select  [ApplicationUserName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ApplicationUserName]
           ,(select  [EnvironmentUserName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentUserName] 
           ,(select [EnvironmentMachineName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMachineName]
           ,(select [EnvironmentDomainName] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentDomainName]
           ,(select [EnvironmentOSVersion] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentOSVersion]
           ,(select [EnvironmentMACAddress] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMACAddress]
           ,(select[EnvironmentMotherboardSerialNumber] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentMotherboardSerialNumber]
           ,(select [EnvironmentProcessorId] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentProcessorId]
           ,(select [EnvironmentIPAddress] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [EnvironmentIPAddress]
           ,(select [ModuleNavigationItemCode] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [ModuleNavigationItemCode]
           ,14  [TransactionCode]
           ,getdate() [ValueDate]
           ,(select [SuppressAccountAlert] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [SuppressAccountAlert]
           ,0 [IsLocked]
           ,(select [IntegrityHash] from Journals where id='19396C23-279A-43FA-ABD2-F42AF354C74A') [IntegrityHash]
       
           ,'SYSTEM' [CreatedBy]
           ,getdate() [CreatedDate]
		   from #EntranceFeeCTE
		  -- select * from Enumerations where "key" like '%transactioncode%'

		 INSERT INTO [dbo].[JournalEntries]
           ([Id]
           ,[JournalId]
           ,[ChartOfAccountId]
           ,[CustomerAccountId]
           ,[Amount]
           ,[ValueDate]
           ,[IntegrityHash]
         
           ,[CreatedBy]
           ,[CreatedDate])

		   SELECT 
		    NEWID() [Id]
           ,ID2 [JournalId]
           ,'CB06FB7C-F43C-EA11-9E52-E4115BB03D0A' [ChartOfAccountId] --Sms Commission GL
           ,RefereeAccountID [CustomerAccountId]
           ,10 [Amount]
           ,getdate() [ValueDate]
           ,NULL [IntegrityHash]
         
           ,'SYSTEM' [CreatedBy]
           ,getdate() [CreatedDate]
        
		   from #EntranceFeeCTE

		   UNION
		    SELECT 
		    NEWID() [Id]
           ,ID2 [JournalId]
           ,SavingsCOA[ChartOfAccountId] --Legacy COA
           ,RefereeAccountID [CustomerAccountId]
           ,10*-1 [Amount]
           ,getdate() [ValueDate]
           ,NULL [IntegrityHash]
           ,'SYSTEM' [CreatedBy]
           ,getdate()[CreatedDate]
        
		   from #EntranceFeeCTE

		drop table #EntranceFeeCTE

		   --select * from ChartOfAccounts where AccountName like '%Entrance%'
		   --delete JournalEntries where valuedate='2020-05-29'
		   --delete Journals where valuedate='2020-05-29'

		  
