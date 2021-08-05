$Dir = get-childitem CAMINHO DA PASTA -recurse
$List = $Dir | where {$_.extension -eq ".nooa"}
$List |ft fullname |out-file C:\Users\Paulo\Desktop\teste.txt
