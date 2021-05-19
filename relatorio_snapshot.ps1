  
connect-viserver SEUVCENTER -User SEUUSER -Password SEUPASSWORD


get-vm | get-snapshot | select vm, name, description, created, sizegb | export-csv -Encoding UTF8 -path "c:\temp\file.csv" -notypeinformation 
