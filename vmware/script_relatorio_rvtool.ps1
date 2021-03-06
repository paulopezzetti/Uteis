#variaveis de abas da planilha utilizar na linha 41

#ExportAll2xlsx - exportar todas as abas
#ExportvInfo2xlsx - exportar a aba info
#ExportvCPU2xlsx - exportar a aba vCPU
#ExportvMemory2xlsx - exportar a aba vMemory
#ExportvDisk2xlsx - exportar a aba vDisk
#ExportvPartition2xlsx - exportar a aba vPartition
#ExportvNetwork2xlsx - exportar a aba Network
#ExportvFloppy2xlsx - exportar a aba vFloppy
#ExportvSnapshot2xlsx - exportar a aba vSnapshot
#ExportvTools2xlsx - exportar a aba vTools
#ExportvCluster2xlsx - exportar a aba vCluster
#ExportvHost2xlsx - exportar a aba vHost 
#ExportvHBA2xlsx - exportar a aba vHBA
#ExportvNIC2xlsx - exportar a aba vNIC
#ExportvSwitch2xlsx - exportar a aba vSwitch
#ExportvPort2xlsx - exportar a aba vPort
#ExportdvSwitch2xlsx - exportar a aba dvSwitch
#ExportdvPort2xlsx - exportar a aba dvPort
#ExportvSC+VMK2xlsx - exportar a aba vSC+VMK
#ExportvDatastore2xlsx - exportar a aba vDatastore
#ExportvMultiPath2xlsx - exportar a aba vMultiPath
#ExportvLicense2xlsx - exportar a aba vLicense
#ExportvHealth2xlsx - exportar a aba vHealth




#INICIO DO SCRIPT


#Variaveis geração do relatorio.
$ExportPath = 'D:\Nova pasta'
$Server = 'vcenter.adm-cesumar.local'
#####################################


#Iniciar RVTools

. "C:\Program Files (x86)\Robware\RVTools\RVTools.exe" -passthroughAuth -s "$Server" -c ExportvSnapshot2xls -d "$ExportPath" -f "$Server.xlsx"

write-host "Gerando relatorio, aguarde por favor" -ForegroundColor Red

#tempo de espera para que o relatorio seja gerado.
Start-Sleep -s 75

#excel
$file = "localdoarquivo" 
$ColumnsToKeep = 1,2,3,4,5 # colunas que o script não irá fazer a remoção.

# Create the com object
$excel = New-Object -comobject Excel.Application # Creating object of excel in powershell.
$excel.DisplayAlerts = $False
$excel.visible = $False

# Abrir arquivo xls
$workbook = $excel.Workbooks.Open($file)
$sheet = $workbook.Sheets.Item(1)

# Determinar o número de linhas em uso
$maxColumns = $sheet.UsedRange.Columns.Count

$ColumnsToRemove = Compare-Object $ColumnsToKeep (1..$maxColumns) | Where-Object{$_.SideIndicator -eq "=>"} | Select-Object -ExpandProperty InputObject
0..($ColumnsToRemove.Count - 1) | %{$ColumnsToRemove[$_] = $ColumnsToRemove[$_] - $_}
$ColumnsToRemove  | ForEach-Object{
    [void]$sheet.Cells.Item(1,$_).EntireColumn.Delete()
}

# salvar arquivo
$workbook.SaveAs("caminhodestino\nomedoarquivo.xlsx")

# Fechar excel
$workbook.Close($true)
$excel.Quit()
[void][System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
Remove-Variable excel 

#tempo de espera para que o relatorio seja gerado.
Start-Sleep -s 15


write-host "enviando email" -ForegroundColor Red

#Variaveis usuario utilizado para envio do email.
$Username = "usuarioqueserausado";
$Password= "senha";
##########################


function Send-ToEmail([string]$email){

    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add($email);
    $message.Subject = "ASSUNTO";
    $message.Body = "MENSAGEM";

    write-host "Anexando arquivo" -ForegroundColor Red
    $file = "D:\caminhodoarquivo\nomedoarquivo.xlsx"
    
    $att = new-object Net.Mail.Attachment($file)
    $message.Attachments.Add($file)
	
    $smtp = new-object Net.Mail.SmtpClient("servidorftp", "porta"); 
    $smtp.EnableSSL = $false;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);

    write-host "Enviando mensagem" -ForegroundColor Cyan
    $smtp.send($message);
    write-host "Pre disparo" -ForegroundColor Cyan
    $att.Dispose()
    write-host "email enviado" -ForegroundColor Cyan ; 
 }
 
Send-ToEmail -email "emaildodestinatario@example.com";

