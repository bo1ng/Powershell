Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Создание формы
$form = New-Object System.Windows.Forms.Form 
$form.Text = "Data Entry Form"
$form.Size = New-Object System.Drawing.Size(1366,768) 
$form.StartPosition = "CenterScreen"

#Создание кнопки Проверка
$CheckButton = New-Object System.Windows.Forms.Button
$CheckButton.Location = New-Object System.Drawing.Point(75,120)
$CheckButton.Size = New-Object System.Drawing.Size(75,23)
$CheckButton.Text = "Проверка"
$form.Controls.Add($CheckButton)

$CheckButton.add_click({
if ($1textBox.Text -eq "Хан Соло")
    {
        $1textBox.backcolor = 'lightgreen'
        $2label.Visible = $true
        $2textBox.Visible = $true
    }
    else {$1textBox.backcolor = 'red'}
})


#создание кнопки Отмена
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Отмена"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

#Создание надписи 1
$1label = New-Object System.Windows.Forms.Label
$1label.Location = New-Object System.Drawing.Point(10,20) 
$1label.Size = New-Object System.Drawing.Size(150,20) 
$1label.Text = "Кто недавно умер?:"
$form.Controls.Add($1label) 


#Создание текстбокса 1
$1textBox = New-Object System.Windows.Forms.TextBox 
$1textBox.Location = New-Object System.Drawing.Point(10,40) 
$1textBox.Size = New-Object System.Drawing.Size(120,20) 
$form.Controls.Add($1textBox) 

#Создание надписи 2
$2label = New-Object System.Windows.Forms.Label
$2label.Location = New-Object System.Drawing.Point(10,220) 
$2label.Size = New-Object System.Drawing.Size(150,20) 
$2label.Text = "Как зовут Павла?:"
$form.Controls.Add($2label)
$2label.Visible = $false


#Создание текстбокса 2
$2textBox = New-Object System.Windows.Forms.TextBox 
$2textBox.Location = New-Object System.Drawing.Point(10,240) 
$2textBox.Size = New-Object System.Drawing.Size(120,20) 
$form.Controls.Add($2textBox)
$2textBox.Visible = $false




$form.Topmost = $True

#Добавление боксов на форму
$form.Add_Shown({$1textBox.Select()})
$form.Add_Shown({$1labelBox.Select()})
$form.Add_Shown({$2textBox.Select()})
$form.Add_Shown({$2labelBox.Select()})
$result = $form.Showdialog()