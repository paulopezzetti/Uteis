Import-module ActiveDirectory

$list_txt="C:\usuarios.txt";
$while=Get-Content $list_txt

foreach( $list_txt in $while ){
  Add-ADGroupMember -Identity "NOME DO GRUPO" $list_txt

}
