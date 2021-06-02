$nome = Get-content "C:\temp\lista.txt"

foreach ($nome in $nome){
  if (Test-Connection -ComputerName $nome -Count 1 -ErrorAction SilentlyContinue){
    Write-Host "$nome,RESPONDENDO"
  }
  else{
    Write-Host "$nome,SEM RESPOSTA"
  }
}
