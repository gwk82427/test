$repoResult = Invoke-RestMethod "http://rnotfsat:8080/tfs/_apis/git/repositories?api-version=1.0" -Method Get -UseDefaultCredentials

$releases = @()

$repoResult.value | % {

    $project = $_.name
    $repo = $_.id

    Write-Host $project $repo  

   $url = "http://rnotfsat:8080/tfs/_apis/git/repositories/$repo/commits?searchCriteria.fromDate=1/1/2021&searchCriteria.toDate=12/31/2021"

    $result = Invoke-RestMethod $url -Method Get -UseDefaultCredentials

    if ($result.count -gt 0){
        
        $result.value | % {
            
            $releases += [pscustomobject]@{ 
                Project = $project 
                #Branch = $_.name 
                #RefId = $_.objectId 
                Commit=$_.committer.name
                Email=$_.committer.email
                Date=$_.committer.date
                Comment=$_.comment

               
            }
        }
    }

}

#$releases | Export-csv -Path D:\2017\2017-TFSProject_History.csv |Sort-Object -Property Project | Format-Table -AutoSize
$releases | Sort-Object -Property Project | Format-Table -AutoSize