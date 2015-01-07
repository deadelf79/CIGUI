![logotip](/logoCIGUI.png)
CIGUI
=====

Installation
---
 1. Open RPG Maker VX Ace
 2. Open Script Editor (hotkey is **F11**)
 3. Open `cigui.rb` with Notepad (or with any other text editor)
 4. Copy **all** text from this file
 5. Paste in new page in <Material> section
 
OR

 1. Download test project from here: [https://github.com/deadelf79/CIGUI/tree/master/test](http://https://github.com/deadelf79/CIGUI/tree/master/tes)
 2. Test cigui working (if not - [e-mail it to me](mailto:deadelf79@gmail.com))
 3. Copy script `CIGUI` into your project and paste above `Main`
 
Simple configurations
---

```
there is not a single configuration yet
```
FAQ
---
###What is it?
 - Command interpreter for graphics user interface made for use in:
   - RGSS3 projects
   - 'Rogue Project' projects (in future version)



###How to use help?
 - Open `doc` dir, find `index.html` file and open it in any browser - you can you search feature here
 - Open last version of `CIGUI.chm`



###How to update help?
####Download pregenerated help
 - [Just download it from 'doc' directory](https://github.com/deadelf79/CIGUI/tree/work-with-text/doc)
 
OR
 
- [Download CHM version](https://github.com/deadelf79/CIGUI/blob/work-with-text/CIGUI.chm)


####Generate manually from code
#####HTML version
 - Install [last stable version of Ruby](http://rubyinstaller.org/ ) (this link for Windows)
 - Run 'gendoc.bat' in root OR open command line, move to dir where cigui is and call command like this:

`rdoc --format=darkfish --encoding=UTF-8 --line-numbers cigui.rb`


#####CHM version
 - Install [last stable version of Ruby](http://rubyinstaller.org/ )
 - Install  gem `rdoc_chm` with command prompt with this command:

`gem install rdoc_chm`

(May cause bugs with download and install, read manual for rdoc_chm).
 
 - Install last version of Microsoft HTML Help Workshop [from here](http://www.microsoft.com/en-us/download/confirmation.aspx?id=21138)
 - Run `genchm.bat` from dir where cigui is
 
If you have problem with CHM generating then try to use HTM2CHM to compile `CIGUI.chm` using source file from `chmdoc` directory
