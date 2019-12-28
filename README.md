# Lazy-Webdev-
A snippet for lazy web developpers

After an unsuccesful search for an PHP IDE that embeds an efficient live preview, I just realized that I was the only one who could provide it to myself. Here's how it works :
- Your IDE is on a windows' desktop
- Your browser (Firefox, Edge, Chrome or whatever) is on a secondary virtual windows' desktop.

Basically, to review any change, you'd need at least : To press CTRL + S ; then to press CTRL + ALT + RigthArrow ; then too press F5.

And if you switched your currently-edited file, you're screwed : you'll have to type the file's address in the browser's addres bar.

Thanks to AutoHotKey, you won't. With this script, what you only have to do is pressing CTRL + Q and your file will be saved, your desktop will switch to the next one and your browser will refresh to the file that you're editing. It's been created for PHPStorm but it can be used or adapted to any IDE. IDEs usually display the full path from the root to the current file in their window title ; if yours doesn't and if it displays the file's name, Lazy Wedev script will look for it in your root directory and select the occurence with the most recent last-edited date.


# HOW TO USE IT

**1) First of all : Instal AutoHotkey**

Link : https://www.autohotkey.com/download/ahk-install.exe

**2) Have a look at AHK's wiki, if needed**

https://www.autohotkey.com/docs/Tutorial.htm#s12

**3) Download the script and edit it if needed**

Let's look at the settings that you can change with the initial variables of the script :

- `YourRegx` is the default regular expression used to get the file's path in the window's title. We'll later see how it works.
- `AlternativeRegx` is an alternative regular expression that is used if your IDE's title bar doesn't display the project's root-path to the file
- `LocalDir` this variable must be left blank if your IDE displays the root-path to the file. If it doesn't, fill it with your project's root folder's full path. Example : `C:\xampp\htdocs\`
- `ServerUrl` is your root folder trough HTTP. It must but the path to your project's root

`YourRegx` to its default value will select the file's path after "...\" and before " -", just as this "DEV (C:\xampp\htdocs\DEV\) - ...\ `my_folder\my-file.php` - PhpStorm" .

`AlternativeReg` to its default value will select anything before a combination of a point and letters that is followed by any non-letter character, like a whitespace or "-". See the example "`my_test-file222.php` - Notepad".

**4) If you need to build you own RegEx, have a look at this AHK RegEx tester :**
https://autohotkey.com/board/topic/16400-ahk-regex-tester-v21/

**5) When AHK is installed, double-click your script to launch it**
If you want to edit it afterwise, right-click AHK's tray icon, then "Edit script". Once you saved it, don't forget to right-click AHK's icon and "Reload script".

# The code
The full commented code :
```
^q:: ; LISTENNING for CTRL+Q (this is your hotkey)


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
```
