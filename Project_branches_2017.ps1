$repoResult = Invoke-RestMethod "http://rnop-tfsa10:8080/tfs/CMS/_apis/git/repositories?api-version=1.0" -Method Get -UseDefaultCredentials

$releases = @()

$repoResult.value | % {

    $project = $_.name
    $repo = $_.id
    Write-Host $project $repo  

    #Invoke-RestMethod "http://rnop-tfsa10:8080/tfs/CMS/_apis/git/repositories/fb13e7b7-d47e-43b7-bc7f-b3db0ab91338/refs?api-version=2.0" -Method Get -UseDefaultCredentials |ConvertTo-Json -Depth 10

   $url = "http://rnop-tfsa10:8080/tfs/CMS/_apis/git/repositories/$repo/refs?api-version=2.0"

    $result = Invoke-RestMethod $url -Method Get -UseDefaultCredentials

    if ($result.count -gt 0){
        
        $result.value | % {
            
            $releases += [pscustomobject]@{ 
                Project = $project 
                Branch = $_.name 
                RefId = $_.objectId 
            }
        }
    }

}

$releases | Export-csv -Path D:\2017\Project_Branches_ref.csv |Sort-Object -Property Project | Format-Table -AutoSize
#$releases | Sort-Object -Property Project | Format-Table -AutoSize