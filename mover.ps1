<#
This program is a file mover for movies and TV shows. It takes all the shows out of a "dump" folder, copies and organizes them
the destination location
#>

#storing the dump directory
$dumpDirectory = "C:\Users\dptjb\Desktop\Test Folder"
#storing the files in the dump directory into an array
$dumpDirectoryArray = @(Get-ChildItem $dumpDirectory)
#storing the remote movie and tv show directories
$movieDirectory = "C:\Users\dptjb\Desktop\Movies Test"
$TVDirectory = "C:\Users\dptjb\Desktop\TV Show Test"

#if statement to see if there is any information stores in the array. If non, exit the script
if($dumpDirectoryArray.count -ne 0){
    #for loop to start looping through all of the files in the array
    for($i=0; $i -lt $dumpDirectoryArray.count; $i++){
        #storing the filename without the extension
        $fileNameBase = $dumpDirectoryArray[$i].Basename
        #storing the filname with the extension
        $fileNameExt = $dumpDirectoryArray[$i].Name
        #storing the current location of the file as well as the destination directory
        $currentItemPath = $dumpDirectory + "\" + $fileNameExt
        $destMovieDirectoryPath = $movieDirectory + "\" + $fileNameBase
        
        #check to see if the file is a movie or TV show by looking for -sxxexx where xx are season and episode numbers.
        if($fileNameBase -match "-s..e.."){
            #splitting the tv show at the hyphen
            $tvSplit = $fileNameBase.split("-")
            #split the split that way we can isolate the season and episode numbers
            $tvSplitTwo = $tvSplit[1].split("e")
            #storing the tv show name from the initial array
            $tvShowName = $tvSplit[0]
            #storing the season number and romoving the s character
            $tvShowSeason = $tvSplitTwo[0] -replace '[s]'
            #storing the root tv show folder and then the season folder
            $destTvShowNameDirectory = $TVDirectory + "\" + $tvShowName
            $destTvShowSeasonDirectory = $destTvShowNameDirectory + "\Season " + $tvShowSeason
            
            #testing to see if the season folder exists, if it does, copy the file into it.
            if(Test-Path $destTvShowSeasonDirectory){
                Copy-Item $currentItemPath -Destination $destTvShowSeasonDirectory
            } else {
                #if the season folder does not exist, check to see if the tv show folder exists, if it does then create the season folder
                #and then copy the file, if it does not then create the root folder, create season folder, then copy
                if (Test-Path $destTvShowNameDirectory){
                    New-Item $destTvShowSeasonDirectory -type directory
                    Copy-Item $currentItemPath -Destination $destTvShowSeasonDirectory
                } else {
                    New-Item $destTvShowNameDirectory -type directory
                    New-Item $destTvShowSeasonDirectory -type directory
                    Copy-Item $currentItemPath -Destination $destTvShowSeasonDirectory
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
