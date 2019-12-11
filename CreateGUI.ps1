#Загружаем сборку System.Windows.Forms
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#Создаем главную форму
$form = New-Object Windows.Forms.Form
#Заголовок формы
$form.Text = "Название формы"

$Month = New-Object Windows.Forms.Text
#Создаем объект-кнопку
$button = New-Object Windows.Forms.Button
#Задаем текст кнопки
$button.Text = "Press The Button"
#Определяем расположение кнопки
$Button.Dock = "bottom"

#Определяем обработчик нажатия кнопки
$button.Add_Click({$form.Close()})
#Добавляем кнопку на форму
$form.Controls.Add($button)
#Определяем обработчик события Shown для активизации формы
$form.Add_Shown({$form.Activate()})

#Выводим кнопку на экран
$form.ShowDialog()