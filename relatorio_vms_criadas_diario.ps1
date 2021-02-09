connect-viserver SEUVCENTER -User SEUUSER -Password SEUPASSWORD
$data = get-date 

Get-VIEvent -maxsamples 10000 -Start (Get-Date).AddDays(–1) | where {$_.Gettype().Name-eq "VmCreatedEvent" -or $_.Gettype().Name-eq "VmBeingClonedEvent" -or $_.Gettype().Name-eq "VmBeingDeployedEvent"} |Sort CreatedTime -Descending |Select CreatedTime, UserName,FullformattedMessage |Export-Csv -encoding utf8 -Path SEUDIRETORIO\vmsremovidas.csv

write-host "enviando email" -ForegroundColor Red

#Variaveis usuario utilizado para envio do email.
$Username = "EMAIL@EXAMPLE.COM";
##########################


function Send-ToEmail([string]$email){

    $message = new-object Net.Mail.MailMessage;
    $message.From = $Username;
    $message.To.Add($email);
    $message.Subject = "RELATORIO DIARIO DE NOVAS VM'S REMOVIDAS DO AMBIENTE";
    $message.Body = "Segue em anexo relatório com vm's removidas no ultimo dia, favor realizar ajustes de DNS,Backup,PMP,Zabbix,Ipam.";

    write-host "Anexando arquivo" -ForegroundColor Red
    $file = "CAMINHODOSEUARQUIVO\vmsremovidas.csv"
    
    $att = new-object Net.Mail.Attachment($file)
    $message.Attachments.Add($file)
	
    $smtp = new-object Net.Mail.SmtpClient("SEUSERVIDORSMTP", "PORTA"); 
    $smtp.EnableSSL = $false;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);

    write-host "Enviando mensagem" -ForegroundColor Cyan
    $smtp.send($message);
    write-host "Pre disparo" -ForegroundColor Cyan
    $att.Dispose()
    write-host "email enviado" -ForegroundColor Cyan ; 
 }
 
Send-ToEmail -email "EXAMPLE@EXAMPLE.COM";

sleep 60

write-host "Removendo arquivo" -ForegroundColor Cyan

remove-item SEUDIRETORIO\vmsremovidas.csv
