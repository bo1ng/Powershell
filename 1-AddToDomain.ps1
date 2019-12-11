$region = read-host "¬ведите им€ региона"
add-computer -domainname svk.$region.cbr.ru -cred SVK\Administrator
restart-computer
