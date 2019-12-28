; LISTENNING for CTRL+Q (this is your hotkey)
^q::


; Default. SELECTS title between "...\" and " -" 
YourRegx := "(?<=\.\.\.\\)(.*)(\.[a-z]*)(?=.*)"

; If your ide title bar doesn't contain root path SELECTS first occurence with any character + a dot + letters and cut when there isn't anymore letters
AlternativeRegx := "(.*)(\.[a-z]*)(?=.*)" 

; To be used only if your ide window displays you file name without a path. Write in your project's root folder. For example C:\xampp\htdocs\. Duplicate filees may cause false redirect
LocalDir := ""

; Set your project's root address trough your local server
ServerUrl := "http://localhost/DEV/" 


; SAVES the current file
Send ^{s}

; GETS the title of your IDE's window
WinGetTitle, Title, A 


; IF local directory var has been mentionned
If (LocalDir) {
Msgbox test
	RegExMatch(Title,AlternativeRegx,File) ; GETS the address of your file
	MostRecentTime :=

	Loop, Files, %LocalDir%*%File%, R ; SEEKS the mmost recently edited file with the name picked in title bar
	{
    		FileGetTime, ThisFileTime

   		if (MostRecentTime < ThisFileTime)
    		{

        		MostRecentTime := ThisFileTime
        		FilePath:=A_LoopFileFullPath
    		}
	}

	FileName := StrReplace(FilePath, LocalDir, "") ; GET the file's path trough your drive
	AddressBar := StrReplace(FileName, "\", "/") ; CONVERTS backslashes into inverted

}else{

RegExMatch(Title,YourRegx,File) ; GETS the address of your file
AddressBar := StrReplace(File, "\", "/") ; CONVERTS backslashes into inverted
}


; SWITCHES your desktop
Send ^#{Right} 

; WAITS a moment can be less or more depending on the browser
sleep, 500

; SELECTS the address bar with ALT+Q
Send !{d}

; USE YOUR ROOT ADDRESS
SendInput %ServerUrl%%AddressBar%

; PRESS Enter
Send {Enter}
