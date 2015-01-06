gem 'rdoc_chm'
require 'rdoc/rdoc'
RDoc::RDoc.new.document(['--fmt=chm','--encoding=UTF-8','--line-numbers','--op=chmdoc','--exclude=test','--main=cigui.rb'])