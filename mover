<#
This program is a file mover for movies and TV shows. It takes all the shows out of a "dump" folder, copies and organizes them
the destination location
#>
<#
Declaration of variables.
$encodedDirectory is the dump folder location, all your files go here.
$encodedDirectoryArray is the array that all the file information gets stored into when it's read by the program
$movieDirectory is the destination movie directory
$TVDirectory is the destination TV directory
#>
$encodedDirectory = "C:\Users\dptjb\Desktop\Test Folder"
$encodedDirectoryArray = @(Get-ChildItem $encodedDirectory)
$movieDirectory = "C:\Users\dptjb\Desktop\Movies Test"
$TVDirectory = "C:\Users\dptjb\Desktop\TV Show Test"

#if statement to see if there is any information stores in the array.
if($encodedDirectoryArray.count -ne 0){
    #for loop to start looping through all of the files in the array
    for($i=0; $i -lt $encodedDirectoryArray.count; $i++){
        <#
        $fileNameBase is the filename without the extention
        $fileNameExt is the filename with the extention
        $currentItemPath is the path to the file in the dump folder
        $destMovieDirectoryPath is the path to the folder that the movie file will be stored in
        #>
        $fileNameBase = $encodedDirectoryArray[$i].Basename
        $fileNameExt = $encodedDirectoryArray[$i].Name
        $currentItemPath = $encodedDirectory + "\" + $fileNameExt
        $destMovieDirectoryPath = $movieDirectory + "\" + $fileNameBase
        
        #check to see if the file is a movie or TV show by looking for -sxxexx where xx are numbers.
        if($fileNameBase -match "-s..e.."){
            #splitting the tv show at the hyphen
            $tvSplit = $fileNameBase.split("-")
            #split the split that way we can isolate the season and episode numbers
            $tvSplitTwo = $tvSplit[1].split("e")
            #storing the tv show name from the initial array
            $tvShowName = $tvSplit[0]
            #storing the season number and romoving the s character
            $tvShowSeason = $tvSplitTwo[0] -replace '[s]'
            #storing the episode number **UNSURE IF NEEDED WILL REVIEW**
            $tvShowEpisode = $tvSplitTwo[1]
            #storing the root tv show folder and then the season folder
            $destTVShowNameDirectoryPath = $TVDirectory + "\" + $tvShowName
            $destTVShowSeasonDirectoryPath = $destTVShowNameDirectoryPath + "\Season " + $tvShowSeason
            
            #testing to see if the season folder exists, if it does, copy the file into it.
            if(Test-Path $destTVShowSeasonDirectoryPath){
                Copy-Item $currentItemPath -Destination $destTVShowSeasonDirectoryPath
            } else {
                #if the season folder does not exist, check to see if the tv show folder exists, if it does then create the season folder
                #and then copy the file, if it does not then create the root folder, create season folder, then copy
                if (Test-Path $destTVShowNameDirectoryPath){
                    New-Item $destTVShowSeasonDirectoryPath -type directory
                    Copy-Item $currentItemPath -Destination $destTVShowSeasonDirectoryPath
                } else {
                    New-Item $destTVShowNameDirectoryPath -type directory
                    New-Item $destTVShowSeasonDirectoryPath -type directory
                    Copy-Item $currentItemPath -Destination $destTVShowSeasonDirectoryPath
                }
            }
        } else {
            #test if movie folder exists, if it does then remove it... the logic here being that if you have a replacement movie then
            #you already know it exists
            if(Test-Path $destMovieDirectoryPath){
                Remove-Item $destMovieDirectoryPath -Recurse
            }
            #create the new movie folder and copy the file into it
            New-Item $destMovieDirectoryPath -type directory
            Copy-Item $currentItemPath -Destination $destMovieDirectoryPath
        }
    #delete the current file from the dump folder.
    Remove-Item $currentItemPath
    }
}
