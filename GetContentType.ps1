#Connect to the Site        
Connect-PnPOnline -Url "https://site.com/sites/site" -UseWebLogin

#Get All Lists
$Lists = Get-PnPList -Includes RootFolder | Where-Object {$_.Hidden -eq $False}
  
#Get content types of each list from the web
$ContentTypeUsages=@()
ForEach($List in $Lists)
{
    Write-host -f Yellow "Scanning List:" $List.Title
    $ListURL =  $List.RootFolder.ServerRelativeUrl

    #get all content types from the list
    $ContentType = Get-PnPContentType -List $List | Where {$_.Name -eq $ContentTypeName}

    #Collect list details
    If($ContentType)
    {
        $ContentTypeUsage = New-Object PSObject
        $ContentTypeUsage | Add-Member NoteProperty SiteURL("https://site.com/sites/site")
        $ContentTypeUsage | Add-Member NoteProperty ListName($List.Title)
        $ContentTypeUsage | Add-Member NoteProperty ListURL($ListURL)
        $ContentTypeUsage | Add-Member NoteProperty ContentTypeName($ContentType.Name)
        Write-host -f Green "`tFound the Content Type in Use!"

        #Export the result to CSV file
        $ContentTypeUsage | Export-CSV $ReportOutput -NoTypeInformation -Append
    }
}
#$reportoutput = C:\\Temp\\SharePoint_Content_TypesNew.csv
#$contenttypeusage | export-csv $ReportOutput -NoTypeInformation
$ReportOutput = "c:\temp\CT.csv"
$contenttypeusage = Get-PnpContentType -Identity "Identity of Content Type"
$contenttypeusage | export-csv $ReportOutput -NoTypeInformation