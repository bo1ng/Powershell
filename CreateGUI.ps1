#��������� ������ System.Windows.Forms
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#������� ������� �����
$form = New-Object Windows.Forms.Form
#��������� �����
$form.Text = "�������� �����"

$Month = New-Object Windows.Forms.Text
#������� ������-������
$button = New-Object Windows.Forms.Button
#������ ����� ������
$button.Text = "Press The Button"
#���������� ������������ ������
$Button.Dock = "bottom"

#���������� ���������� ������� ������
$button.Add_Click({$form.Close()})
#��������� ������ �� �����
$form.Controls.Add($button)
#���������� ���������� ������� Shown ��� ����������� �����
$form.Add_Shown({$form.Activate()})

#������� ������ �� �����
$form.ShowDialog()