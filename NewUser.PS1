# Define variables for the new user
$employeeName = Read-Host "Enter Employee Name (e.g., John Doe)"
$department = Read-Host "Enter Department (e.g., IT, HR)"
$userPrincipalName = "$($employeeName.Replace(' ', '.').ToLower())@melmel.local"
$password = "TempP@ssword!" | ConvertTo-SecureString -AsPlainText -Force

# Determine the OU based on the department
$ouPath = "OU=$department,DC=yourdomain,DC=com"

# Create the new AD user
New-ADUser -Name $employeeName -GivenName $employeeName.Split(' ')[0] -Surname $employeeName.Split(' ')[1] `
           -UserPrincipalName $userPrincipalName -Path $ouPath -AccountPassword $password `
           -Enabled $true -ChangePasswordAtLogon $true

# Add the user to the department-specific group
Add-ADGroupMember -Identity "$department Department" -Members $userPrincipalName
