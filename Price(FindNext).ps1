#$ErrorActionPreference = "SilentlyContinue"
$PricePath = "D:\temp\4k\Price ACO ALU.xls"
$ALLPath = "D:\temp\4k\newnewALL.xlsx"
$rows = 350
$ResultPath = "D:\temp\4k\newnewnewALL.xlsx"

$Price = New-Object -ComObject Excel.Application
$Pricebook = $Price.Workbooks.Open($PricePath)
$PriceSheet = $Pricebook.sheets.item("Лист1")

$ALL = New-Object -ComObject Excel.Application
$ALLbook = $All.Workbooks.Open($ALLPath)
$ALLSheet = $Allbook.sheets.item("ALL")

$n=1
do {
    Write-Host ("Обработка строки " + $n + " PN " + $PN)
    $PN = $PriceSheet.Range("A$n").Text
    #$find = $All.Cells.Find($PN)
    $find = $ALL.Range("D1:D6113").Find($PN)
    $first = $find
        if ($find -ne $null -and $PN -ne "") {
            $Cost = $PriceSheet.Range("C$n").Text
            #$find.Row
            $ALLSheet.Cells.Item($find.Row,16) = $Cost
            $ALLSheet.Cells.Item($find.Row,17) = "$"
            Write-Host ("Значение " + $Cost + " проставлено в ячейке " + $find.Row + " для " + $PN)
            #$find = $null
            Do
            {
                $find = $All.Range("D1:D6113").FindNext($find)
                if ($find -ne $null -and $find.AddressLocal() -ne $first.AddressLocal()) {
                    #$Cost = $PriceSheet.Range("C$n").Text
                    $ALLSheet.Cells.Item($find.Row,16) = $Cost
                    $ALLSheet.Cells.Item($find.Row,17) = "$"
                    Write-Host ("Проставлено ЕЩЕ ОДНО значение " + $Cost + " в ячейке " + $find.Row + " для " + "$PN")
                    #$findnext = $null
                    }
                }
                While ($find -ne $null -and $find.AddressLocal() -ne $first.AddressLocal())
            $find = $null
            }
            $find = $null
            
         
         $n = $n+1
}
while ($n -lt $rows)

$Allsheet.SaveAs($ResultPath)
$ALL.Quit()