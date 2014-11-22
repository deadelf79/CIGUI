CIGUI
=====

Installation
---
 1. Open RPG Maker VX Ace
 2. Open Script Editor (hotkey is F11)
 3. Open 'cigui.rb' in Notepad
 4. Copy all text from this file
 5. Paste in new page in <Material> section
 
OR

 1. Download test project from here: https://github.com/deadelf79/CIGUI/tree/master/test
 2. Test cigui working (if not - [e-mail it to me](mailto:deadelf79@gmail.com))
 3. Copy script 'CIGUI' into your project
 
Simple configurations
---
I will write later on

FAQ
---
#What is it?
 - Command interpreter for graphics user interface made for use in:
   - RGSS3 projects
   - 'Rogue Project' projects (in future version)
#How to use help?
 - Open 'doc' dir, find 'index.html' file and open it in any browser
#How to update help?
 - Install [last stable version of Ruby](http://rubyinstaller.org/ ) (this link for Windows)
 - Run 'make.bat' in root OR open command line, move to dir where cigui is and call command like this:
`rdoc --format=darkfish --encoding=UTF-8 --line-numbers cigui.rb`