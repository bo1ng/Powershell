$region = read-host "������� ��� �������"
add-computer -domainname svk.$region.cbr.ru -cred SVK\Administrator
restart-computer
