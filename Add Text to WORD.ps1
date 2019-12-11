#Insert following text

$key = "Enter text here"

#In the below file

$file1 = 'D:\Distributive\Microsoft\SCOM\test1.docx'
$file2 = 'D:\Distributive\Microsoft\SCOM\test2.docx'

#Open Microsoft Word and add text defined in $key then save


[ref]$SaveFormat = "microsoft.office.interop.word.WdSaveFormat" -as [type]

$word = New-Object -ComObject Word.Application

$word.visible = $false

$doc = $word.Documents.Add($file1)
$doc.saveas([ref] $file1, [ref]$SaveFormat::wdFormatDocument)
