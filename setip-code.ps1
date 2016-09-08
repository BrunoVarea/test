#region Mes Fonctions

function valid
{
$dns = "$dns1", "$dns2"
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "InterfaceIndex='$int'";
$wmi.EnableStatic("$ip", "$mask");
$wmi.SetGateways("$gw", 1);
$wmi.SetDNSServerSearchOrder($dns);
}

function dhcp
{
$dhcpenable=Get-NetIPInterface -InterfaceIndex $int;
$dhcpenable | Set-NetIPInterface -Dhcp Enabled;
$dhcpenable | Set-DnsClientServerAddress -ResetServerAddresses;
$dhcpenable | Remove-NetRoute -Confirm:$false;
}
function off
{
$carteoff = Get-NetAdapter | where {$_.InterfaceIndex -eq $int};
Disable-NetAdapter -Name $carteoff.name –Confirm:$false
}
function on
{
$carteon = Get-NetAdapter | where {$_.InterfaceIndex -eq $int};
Enable-NetAdapter -Name $carteon.name –Confirm:$false
}

function rename
{
$rename = Get-NetAdapter | where {$_.InterfaceIndex -eq $int};
Get-NetAdapter -Name $rename.Name | Rename-NetAdapter -NewName $new
}
function Get-NIC { 
    $array = New-Object System.Collections.ArrayList;
    $Script:mescartes = get-wmiobject win32_networkadapter | where {$_.netconnectionid -ne $null} | select @{label="Nom";expression={($_.netconnectionid)}},@{label="carte";expression={($_.name)}},@{label="N°";expression={($_.InterfaceIndex)}},@{label="status";expression={($_.netconnectionstatus)}};
#    $Script:mescartes = get-wmiobject win32_networkadapter | where {$_.netconnectionid -ne $null} | select @{label="Nom";expression={($_.netconnectionid)}},@{label="carte";expression={($_.name)}},@{label="N°";expression={($_.InterfaceIndex)}},@{label="status";expression={($_.netconnectionstatus)}};
	$array.AddRange($mescartes);
    $magrid.DataSource = $array;
    $maforme.refresh();
	} 

$OnLoadForm_UpdateGrid= 
{ 
    Get-NIC
} 

#$button2_OnClick=  
#{ 
#    $selectedRow = $magrid.CurrentRow.Cells[2];
#    if (($procid=$Script:mescartes[$selectedRow].netconnectionid)) { 
#            Disable-NetAdapter -Name $procid –Confirm:$false
#        } 
#} 

#endregion Mes fonctions
#region Import assemblees
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#endregion #region Import assemblees
#region Mes formes
$maforme = New-Object System.Windows.Forms.Form
$maforme.Size = New-Object System.Drawing.Size(1000,400)
$maforme.Text = "SetIP By Bruno VAREA"
$magrid = New-Object System.Windows.Forms.datagridview
$RenameForm = New-Object System.Windows.Forms.Form
$RenameForm.Size = New-Object System.Drawing.Size(300,100)
$RenameForm.Text = "Nouveau nom de carte"
$ChangeIpForm = New-Object System.Windows.Forms.Form
$ChangeIpForm.Size = New-Object System.Drawing.Size(600,400)
$ChangeIpForm.Text = "Vos reglages IP"

$maforme.add_load($OnLoadForm_UpdateGrid)
#endregion Mes formes
#region Mes textbox
#textbox interfaceindex
$Labelint = New-Object System.Windows.Forms.Label
$Labelint.Location = New-Object System.Drawing.Point(650,30)
#$Labelint.Location = New-Object System.Drawing.Size(650,30) 
$Labelint.Size = New-Object System.Drawing.Size(150,20) 
$Labelint.Text = "Carte N°:"
$maforme.Controls.Add($Labelint) 

$TBint = New-Object System.Windows.Forms.TextBox 
$TBint.Location = New-Object System.Drawing.Size(650,50) 
$TBint.Size = New-Object System.Drawing.Size(20,20) 
$maforme.Controls.Add($TBint) 

##textbox adresse ip
$Labelip = New-Object System.Windows.Forms.Label
$Labelip.Location = New-Object System.Drawing.Size(50,75) 
$Labelip.Size = New-Object System.Drawing.Size(150,20) 
$Labelip.Text = "Adresse IP:"
$ChangeIpForm.Controls.Add($Labelip) 

$TBip = New-Object System.Windows.Forms.TextBox 
$TBip.Location = New-Object System.Drawing.Size(50,95) 
$TBip.Size = New-Object System.Drawing.Size(120,20) 
$ChangeIpForm.Controls.Add($TBip) 

##textbox masque sous reseau
$Labelmask = New-Object System.Windows.Forms.Label
$Labelmask.Location = New-Object System.Drawing.Size(50,120) 
$Labelmask.Size = New-Object System.Drawing.Size(150,20) 
$Labelmask.Text = "Masque de sous réseau:"
$ChangeIpForm.Controls.Add($Labelmask) 

$TBmask = New-Object System.Windows.Forms.TextBox 
$TBmask.Location = New-Object System.Drawing.Size(50,140) 
$TBmask.Size = New-Object System.Drawing.Size(120,20) 
$ChangeIpForm.Controls.Add($TBmask) 

##textbox gateway
$Labelgw = New-Object System.Windows.Forms.Label
$Labelgw.Location = New-Object System.Drawing.Size(50,165) 
$Labelgw.Size = New-Object System.Drawing.Size(150,20) 
$Labelgw.Text = "Paserelle :"
$ChangeIpForm.Controls.Add($Labelgw) 

$TBgw = New-Object System.Windows.Forms.TextBox 
$TBgw.Location = New-Object System.Drawing.Size(50,185) 
$TBgw.Size = New-Object System.Drawing.Size(120,20) 
$ChangeIpForm.Controls.Add($TBgw) 

##textbox DNS1
$Labeldns1 = New-Object System.Windows.Forms.Label
$Labeldns1.Location = New-Object System.Drawing.Size(50,210) 
$Labeldns1.Size = New-Object System.Drawing.Size(150,20) 
$Labeldns1.Text = "DNS Primaire:"
$ChangeIpForm.Controls.Add($Labeldns1) 

$TBdns1 = New-Object System.Windows.Forms.TextBox 
$TBdns1.Location = New-Object System.Drawing.Size(50,230) 
$TBdns1.Size = New-Object System.Drawing.Size(120,20) 
$ChangeIpForm.Controls.Add($TBdns1) 

##textbox dns2
$Labeldns2 = New-Object System.Windows.Forms.Label
$Labeldns2.Location = New-Object System.Drawing.Size(50,255) 
$Labeldns2.Size = New-Object System.Drawing.Size(150,20) 
$Labeldns2.Text = "DNS Secondaire:"
$ChangeIpForm.Controls.Add($Labeldns2) 

$TBdns2 = New-Object System.Windows.Forms.TextBox 
$TBdns2.Location = New-Object System.Drawing.Size(50,275) 
$TBdns2.Size = New-Object System.Drawing.Size(120,20) 
$ChangeIpForm.Controls.Add($TBdns2) 

##textbox Rename carte
$LabelRename = New-Object System.Windows.Forms.Label
$LabelRename.Location = New-Object System.Drawing.Size(10,10) 
$LabelRename.Size = New-Object System.Drawing.Size(200,20) 
$LabelRename.Text = "Saisir le nouveau nom:"
$RenameForm.Controls.Add($LabelRename) 
$TBRename = New-Object System.Windows.Forms.TextBox 
$TBRename.Location = New-Object System.Drawing.Size(10,30) 
$TBRename.Size = New-Object System.Drawing.Size(200,20) 
$RenameForm.Controls.Add($TBRename)


#endregion Mes textbox
#region Mes boutons
##bouton Activer
$activer = New-Object System.Windows.Forms.Button
$activer.Location = New-Object System.Drawing.Size(800,30)
$activer.Size = New-Object System.Drawing.Size(100,25)
$activer.Text = "Activer carte"
#$activer.Backcolor = "#FE0000"
$activer.Add_Click({$int=$TBint.Text; on; Get-NIC})
$maforme.Controls.Add($activer)

##bouton Desactiver
$desactiver = New-Object System.Windows.Forms.Button
$desactiver.Location = New-Object System.Drawing.Size(800,60)
$desactiver.Size = New-Object System.Drawing.Size(100,25)
$desactiver.Text = "Désactiver carte"
$desactiver.Add_Click({$int=$TBint.Text; off; Get-NIC})
#$desactiver.Add_Click({$button2_OnClick; Get-NIC})
$maforme.Controls.Add($desactiver)

###Bouton DHCP
$dhcp = New-Object System.Windows.Forms.Button
$dhcp.Location = New-Object System.Drawing.Size(800,120)
$dhcp.Size = New-Object System.Drawing.Size(100,25)
$dhcp.Text = "DHCP"
$dhcp.Add_Click({$int=$TBint.Text; dhcp; Get-NIC})
$maforme.Controls.Add($dhcp)

##Bouton Valider
$ok = New-Object System.Windows.Forms.Button
$ok.Location = New-Object System.Drawing.Size(800,90)
$ok.Size = New-Object System.Drawing.Size(100,25)
$ok.Text = "Changer IP"
#$ok.Add_Click({$int=$TBint.Text;$ip=$TBip.Text;$mask=$TBmask.Text;$gw=$TBgw.Text;$dns1=$TBdns1.Text;$dns2=$TBdns2.Text; valid; Get-NIC})
$ok.Add_Click({$ChangeIpForm.showdialog()})
$maforme.Controls.Add($ok)

##Bouton Renommer
$RenameButton = New-Object System.Windows.Forms.Button
$RenameButton.Location = New-Object System.Drawing.Size(800,150)
$RenameButton.Size = New-Object System.Drawing.Size(100,25)
#$RenameButton.Backcolor = "#FFFE0000"
$RenameButton.Text = "Renommer"
$RenameButton.Add_Click({$int=$TBint.Text; $RenameForm.showdialog()})
$maforme.Controls.Add($RenameButton)

##Bouton Fermer
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(880,325)
$CancelButton.Size = New-Object System.Drawing.Size(100,25)
$CancelButton.Backcolor = "#FFFE0000"
$CancelButton.Text = "Fermer"
$CancelButton.Add_Click({$maforme.Close()})
$maforme.Controls.Add($CancelButton)

##Bouton OK renameform
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(220,30)
$OKButton.Size = New-Object System.Drawing.Size(35,20)
#$OKButton.Backcolor = "#FFFE0000"
$OKButton.Text = "Ok"
$OKButton.Add_Click({$new=$TBRename.Text; rename; $RenameForm.Close(); Get-NIC})
$RenameForm.Controls.Add($OKButton)

#endregion Mes boutons
#region Ma datagrid
$magrid.dock=[System.Windows.Forms.DockStyle]::left
$magrid.ReadOnly=$True
$magrid.Size=New-Object System.Drawing.Size(600,500)
$magrid.AutoSizeColumnsMode=[System.Windows.Forms.DataGridViewAutoSizeColumnsMode]::DisplayedCells
$maforme.controls.add($magrid)
#$mescartes=New-Object system.Collections.ArrayList
#$mescartes.addrange([array]$(get-wmiobject win32_networkadapter | where {$_.netconnectionid -ne $null} | select @{label="Nom";expression={($_.netconnectionid)}},@{label="carte";expression={($_.name)}},@{label="N°";expression={($_.InterfaceIndex)}},@{label="status";expression={($_.netconnectionstatus)}}))
#$magrid.datasource=$mescartes
#endregion Ma datagrid
$maforme.showdialog()
