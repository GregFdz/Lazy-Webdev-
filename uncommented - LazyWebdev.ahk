^q::

YourIde := "PhpStorm"

YourBrowser := "Firefox"

YourRegx := "(?<=\.\.\.\\)(.*)(\.[a-z]*)(?=.*)"

AlternativeRegx := "(.*)(\.[a-z]*)(?=.*)" 

LocalDir := ""

ServerUrl := "http://localhost/DEV/" 

WinGetTitle, IdeTitle, A 
IfNotInString IdeTitle, %YourIde%
{
Exit
}

Send ^{s}


If (LocalDir) {
Msgbox test
	RegExMatch(IdeTitle,AlternativeRegx,File)
	MostRecentTime :=

	Loop, Files, %LocalDir%*%File%, R
	{
    		FileGetTime, ThisFileTime

   		if (MostRecentTime < ThisFileTime)
    		{

        		MostRecentTime := ThisFileTime
        		FilePath:=A_LoopFileFullPath
    		}
	}

	FileName := StrReplace(FilePath, LocalDir, "")
	AddressBar := StrReplace(FileName, "\", "/")

}else{

RegExMatch(IdeTitle,YourRegx,File)
AddressBar := StrReplace(File, "\", "/")
}


Send ^#{Right} 

sleep, 500

WinGetTitle, BrowserTitle, A 
IfNotInString BrowserTitle, %YourBrowser%
{
Msgbox Error : %YourBrowser% is not the active window.
Exit
}

Send !{d}

SendInput %ServerUrl%%AddressBar%

Send {Enter}
