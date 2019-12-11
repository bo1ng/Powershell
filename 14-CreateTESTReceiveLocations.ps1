$region = Read-Host "Введите имя региона БОЛЬШИМИ БУКВАМИ"

$ReceiveLocationClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_ReceiveLocation"
$ReceiveLocationRECEIPTS = $ReceiveLocationClass.CreateInstance()
$ReceiveLocationRECEIPTS.AdapterName = "MQSeries"
$ReceiveLocationRECEIPTS.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;uri&gt;MQS://localhost/RU.CBR.$region.SVK.TSTGATE/RECEIPTS&lt;/uri&gt;&lt;queueDetails&gt;localhost/RU.CBR.$region.SVK.TSTGATE/RECEIPTS&lt;/queueDetails&gt;&lt;transactionSupported&gt;yes&lt;/transactionSupported&gt;&lt;suspendAsNonResumable&gt;no&lt;/suspendAsNonResumable&gt;&lt;dataOffsetForHeaders&gt;yes&lt;/dataOffsetForHeaders&gt;&lt;pollingInterval&gt;3&lt;/pollingInterval&gt;&lt;pollingUnit&gt;seconds&lt;/pollingUnit&gt;&lt;maximumBatchSize&gt;100&lt;/maximumBatchSize&gt;&lt;maximumNumberOfMessages&gt;100&lt;/maximumNumberOfMessages&gt;&lt;threadCount&gt;2&lt;/threadCount&gt;&lt;fragmentationSize&gt;500&lt;/fragmentationSize&gt;&lt;characterSet&gt;none&lt;/characterSet&gt;&lt;errorThreshold&gt;10&lt;/errorThreshold&gt;&lt;segmentation&gt;none&lt;/segmentation&gt;&lt;ordered&gt;no&lt;/ordered&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$ReceiveLocationRECEIPTS.HostName= "WmqHost"
$ReceiveLocationRECEIPTS.InboundTransportURL = "MQS://localhost/RU.CBR.$region.SVK.TSTGATE/RECEIPTS"
$ReceiveLocationRECEIPTS.MgmtDbNameOverride = "BizTalkMgmtDb"
$ReceiveLocationRECEIPTS.MgmtDbServerOverride = "SVK-GATE"
$ReceiveLocationRECEIPTS.Name = "cbrWmqInternalReceiveReceiptsLocationTEST"
$ReceiveLocationRECEIPTS.PipelineName = "Microsoft.BizTalk.DefaultPipelines.PassThruReceive, Microsoft.BizTalk.DefaultPipelines, Version=3.0.1.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
$ReceiveLocationRECEIPTS.ReceivePortName = "cbrWmqInternalReceiptsPort"
<#
$ReceiveLocationRECEIPTS.StartDateEnabled = "False"
$ReceiveLocationRECEIPTS.StopDateEnabled = "False"
$ReceiveLocation.Caption = ""
$ReceiveLocation.Description = ""
$ReceiveLocation.EncryptionCert = ""
$ReceiveLocation.InboundAddressableURL = ""
$ReceiveLocation.IsDisabled= "False"
$ReceiveLocation.IsPrimary = "False"
$ReceiveLocation.OperatingWindowEnabled = "False"
$ReceiveLocation.ActiveStartDT= "20151026000000.000000+180"
$ReceiveLocation.ActiveStopDT= "20151027000000.000000+180"
$ReceiveLocation.SrvWinStartDT = "20151025210000.000000+180"
$ReceiveLocation.SrvWinStopDT = "20151026205959.000000+180"
$ReceiveLocation.SendPipeline = ""
$ReceiveLocation.SendPipelineData = ""
$ReceiveLocation.SettingID = ""
#>
$ReceiveLocationRECEIPTS.put() | Out-Null

Write-Host "Receive Location cbrWmqInternalReceiveReceiptsLocationTEST создан" -ForegroundColor "DarkCyan"

$ReceiveLocationClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_ReceiveLocation"
$ReceiveLocationUOSUFEBSFROM = $ReceiveLocationClass.CreateInstance()
$ReceiveLocationUOSUFEBSFROM.AdapterName = "MQSeries"
$ReceiveLocationUOSUFEBSFROM.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;uri&gt;MQS://localhost/RU.CBR.$region.SVK.TSTGATE/UOS.UFEBS.FROM&lt;/uri&gt;&lt;queueDetails&gt;localhost/RU.CBR.$region.SVK.TSTGATE/UOS.UFEBS.FROM&lt;/queueDetails&gt;&lt;transactionSupported&gt;yes&lt;/transactionSupported&gt;&lt;suspendAsNonResumable&gt;no&lt;/suspendAsNonResumable&gt;&lt;dataOffsetForHeaders&gt;yes&lt;/dataOffsetForHeaders&gt;&lt;pollingInterval&gt;3&lt;/pollingInterval&gt;&lt;pollingUnit&gt;seconds&lt;/pollingUnit&gt;&lt;maximumBatchSize&gt;100&lt;/maximumBatchSize&gt;&lt;maximumNumberOfMessages&gt;100&lt;/maximumNumberOfMessages&gt;&lt;threadCount&gt;2&lt;/threadCount&gt;&lt;fragmentationSize&gt;500&lt;/fragmentationSize&gt;&lt;characterSet&gt;none&lt;/characterSet&gt;&lt;errorThreshold&gt;10&lt;/errorThreshold&gt;&lt;segmentation&gt;none&lt;/segmentation&gt;&lt;ordered&gt;no&lt;/ordered&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$ReceiveLocationUOSUFEBSFROM.HostName= "WmqHost"
$ReceiveLocationUOSUFEBSFROM.InboundTransportURL = "MQS://localhost/RU.CBR.$region.SVK.TSTGATE/UOS.UFEBS.FROM"
$ReceiveLocationUOSUFEBSFROM.MgmtDbNameOverride = "BizTalkMgmtDb"
$ReceiveLocationUOSUFEBSFROM.MgmtDbServerOverride = "SVK-GATE"
$ReceiveLocationUOSUFEBSFROM.Name = "cbrWmqFromUosUfebsLocationTEST"
$ReceiveLocationUOSUFEBSFROM.PipelineName = "Microsoft.BizTalk.DefaultPipelines.PassThruReceive, Microsoft.BizTalk.DefaultPipelines, Version=3.0.1.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
$ReceiveLocationUOSUFEBSFROM.ReceivePortName = "cbrWmqFromUosAll"
$ReceiveLocationUOSUFEBSFROM.put() | Out-Null

Write-Host "Receive Location cbrWmqFromUosUfebsLocationTEST создан" -ForegroundColor "DarkCyan"

$ReceiveLocationClass = [WMIClass] "root\MicrosoftBiztalkServer:MSBTS_ReceiveLocation"
$ReceiveLocationUOSOLDFROM = $ReceiveLocationClass.CreateInstance()
$ReceiveLocationUOSOLDFROM.AdapterName = "MQSeries"
$ReceiveLocationUOSOLDFROM.CustomCfg = "<CustomProps><AdapterConfig vt='8'>&lt;Config xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema'&gt;&lt;uri&gt;MQS://localhost/RU.CBR.$region.SVK.TSTGATE/UOS.OLD.FROM&lt;/uri&gt;&lt;queueDetails&gt;localhost/RU.CBR.$region.SVK.TSTGATE/UOS.OLD.FROM&lt;/queueDetails&gt;&lt;transactionSupported&gt;yes&lt;/transactionSupported&gt;&lt;suspendAsNonResumable&gt;no&lt;/suspendAsNonResumable&gt;&lt;dataOffsetForHeaders&gt;yes&lt;/dataOffsetForHeaders&gt;&lt;pollingInterval&gt;3&lt;/pollingInterval&gt;&lt;pollingUnit&gt;seconds&lt;/pollingUnit&gt;&lt;maximumBatchSize&gt;100&lt;/maximumBatchSize&gt;&lt;maximumNumberOfMessages&gt;100&lt;/maximumNumberOfMessages&gt;&lt;threadCount&gt;2&lt;/threadCount&gt;&lt;fragmentationSize&gt;500&lt;/fragmentationSize&gt;&lt;characterSet&gt;none&lt;/characterSet&gt;&lt;errorThreshold&gt;10&lt;/errorThreshold&gt;&lt;segmentation&gt;none&lt;/segmentation&gt;&lt;ordered&gt;no&lt;/ordered&gt;&lt;/Config&gt;</AdapterConfig></CustomProps>"
$ReceiveLocationUOSOLDFROM.HostName= "WmqHost"
$ReceiveLocationUOSOLDFROM.InboundTransportURL = "MQS://localhost/RU.CBR.$region.SVK.TSTGATE/UOS.OLD.FROM"
$ReceiveLocationUOSOLDFROM.MgmtDbNameOverride = "BizTalkMgmtDb"
$ReceiveLocationUOSOLDFROM.MgmtDbServerOverride = "SVK-GATE"
$ReceiveLocationUOSOLDFROM.Name = "cbrWmqFromUosOldLocationTEST"
$ReceiveLocationUOSOLDFROM.PipelineName = "Microsoft.BizTalk.DefaultPipelines.PassThruReceive, Microsoft.BizTalk.DefaultPipelines, Version=3.0.1.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
$ReceiveLocationUOSOLDFROM.ReceivePortName = "cbrWmqFromUosAll"
$ReceiveLocationUOSOLDFROM.put() | Out-Null

Write-Host "Receive Location cbrWmqFromUosOldLocationTEST создан" -ForegroundColor "DarkCyan"

Write-Host "Нажмите любую клавишу для продолжения..."
$x=$host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
