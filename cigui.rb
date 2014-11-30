# = Руководство Cigui
# В данном руководстве описана работа модуля CIGUI,
# а также методы для управления его работой.<br>
# Рекомендуется к прочтению пользователям, имеющим навыки программирования
# (написания скриптов) на Ruby.<br>
# Для получения помощи по командам, обрабатываемым Cigui,
# перейдите по адресу: <https://github.com/deadelf79/CIGUI/wiki>
# ---
# Author:: Sergey 'DeadElf79' Anikin (mailto:deadelf79@gmail.com)
# License:: Public Domain (see <http://unlicense.org> for more information)

# Модуль, содержащий данные обо всех возможных ошибках, которые
# может выдать CIGUI при некорректной работе.<br>
# Включает в себя:
# * CIGUIERR::CantStart
# * CIGUIERR::CantReadNumber
# * CIGUIERR::CantInterpretCommand
# * CIGUIERR::CannotCreateWindow
# * CIGUIERR::WrongWindowIndex
#
module CIGUIERR
  # Ошибка, которая появляется при неудачной попытке запуска интерпретатора Cigui
  # 
  class CantStart < StandardError
	private
	def message
		'Could not initialize module'
	end
  end
  
  # Ошибка, которая появляется, если в строке не было обнаружено числовое значение.<br>
  # Правила оформления строки указаны для каждого типа значений отдельно:
  # * целые числа - CIGUI.decimal
  # * дробные числа - CIGUI.fraction
  #
  class CantReadNumber < StandardError
	private
	def message
		'Could not find numerical value in this string'
	end
  end
  
  # Ошибка, которая появляется при попытке работать с Cigui после
  # вызова команды <i>cigui finish</i>.
  #
  class CantInterpretCommand < StandardError
	private
	def message
		'Unable to process the command after CIGUI was finished'
	end
  end
  
  # Ошибка создания окна
  #
  class CannotCreateWindow < StandardError
	private
	def message
		'Unable to create window'
	end
  end
  
  # Ошибка, которая появляется при попытке обращения
  # к несуществующему индексу в массиве <i>windows</i></br>
  # Вызывается при некорректном вводе пользователя
  #
  class WrongWindowIndex < StandardError
	private
	def message
		'Index must be included in range of 0 to internal windows array size'
	end
  end
end

if RUBY_VERSION.to_f>1.9
	begin
		# Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>
		# Реализация выполнена для RGSS3.
		#
		class Win3 < Window
			# Создает окно. По умолчанию задается размер 192х64 и
			# помещается в координаты 0,0
			#
			def initialize(x=0,y=0,w=192,h=64)
				super 0,0,192,64
				@items=[]
			end
			
			# Этот метод добавляет команду во внутренний массив <i>items</i>.
			# Команды используются для отображения кнопок.<br>
			# * command - отображаемый текст кнопки
			# * procname - название вызываемого метода
			# По умолчанию значение enable равно true, что значит,
			# что кнопка включена и может быть нажата.
			# 
			def add_item(command,procname,enabled=true)
				@items+=[
					{
						:command=>command,
						:procname=>procname,
						:enabled=>enabled,
						:x=>:auto,
						:y=>:auto
					}
				]
			end
			
			# Включает кнопку.<br>
			# В параметр commandORindex помещается либо строковое значение,
			# являющееся названием кнопки, либо целое число - индекс кнопки			
			# во внутреннем массиве <i>items</i>.
			#
			def enable_item(commandORindex)
				case commandORindex.class
				when Integer, Float
					@items[commandORindex.to_i][:enabled]=true if (0...@items.size).include? commandORindex.to_i
				when String
					@items.times{|index|@items[index][:enabled]=true if @items[index][:command]==commandORindex}
				else
					raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{string}"
				end
			end
			
			# С помощью этого метода производится полная отрисовка всех
			# элементов из массива <i>items</i>.<br>
			# Параметр ignore_disabled отвечает за отображение выключенных 
			# команд из массива <i>items</i>. Если его значение равно true,
			# то отрисовка выключенных команд производиться не будет.
			#
			def draw_items(ignore_disabled=false)
				
			end
			
			# Удаляет окно и все связанные с ним ресурсы
			#
			def dispose
				super
			end
		end
	rescue

		# Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>
		# Реализация выполнена для RGSS3.
		#
		class Win3
			# X Coordinate of Window
			attr_accessor :x
			# Y Coordinate of Window
			attr_accessor :y
			# Width of Window
			attr_accessor :width
			# Height of Window
			attr_accessor :height
			# Speed movement
			attr_accessor :speed
			def initialize
				@x,@y,@width,@height = 0,0,192,64
				@speed=0
				@items=[]
			end
			
			#
			def dispose
				super
			end
		end
	end
end

# Основной модуль, обеспечивающий работу Cigui.<br>
# Для передачи команд используйте массив $do, например:
# * $do<<"команда"
# * $do.push("команда")
# Оба варианта имеют одно и то же действие.<br>
# Перед запуском модуля вызовите метод CIGUI.setup.<br>
# Для исполнения команд вызовите метод CIGUI.update.<br>
#
module CIGUI
  # Специальный словарь, содержащий все используемые команды Cigui.<br>
  # Для удобства поиска разбит по категориям:
  # * cigui - управление интерпретатором; 
  # * window - окнами;
  # * sprite - изображениями;
  # * text - текстом и шрифтами
  # 
  VOCAB={
	#--COMMON unbranch
	:please=>'please|п[оа]жал[у]?[й]?ста',
	:last=>'last|this|последн(?:ее|юю|яя)|это',
	:select=>'select', # by index or label
	#--CIGUI branch
    :cigui=>{
      :main=>'cigui|сигуи',
      :start=>'start|запус(?:ти(?:ть)?|к)',
      :finish=>'finish|завершить',
      :flush=>'flush|очист(?:к[аойеу]|[ить])'
    },
	#--EVENT branch
	:event=>{
		:main=>'event|char(?:acter)?',
		:create=>'create|созда(?:[йть]|ва[йть])',
			:at=>'at',
			:with=>'with',
		:dispose=>'dispose|delete',
		:load=>'load',
		# TAB #1
		#~MESSAGE group
		:show=>'show',
			:message=>'message|text',
			:choices=>'choices',
			:scroll=>'scro[l]*(?:ing|er|ed)?',
		:input=>'input',
			:key=>'key|bu[t]*on',
			:number=>'number',
		:item=>'item', #to use as - select key item || condition branch item
		#~GAME PROGRESSION group
		:set=>'set|cotrol', # other word - see at :condition
		#~FLOW CONTROL group
		:condition=>'condition|if|case',
			:branch=>'bran[ch]|when',
			:switch=>'swit[ch]',
			:variable=>'var(?:iable)?',
			:self=>'self', # to use as - self switch
			:timer=>'timer',
				:min=>'min(?:ute[s]?)?',
				:sec=>'sec(?:[ou]nds)?',
				:ORmore=>'or[\s]*more',
				:ORless=>'or[\s]*less',
			:actor=>'actor',
				:in_party=>'in[\s]*party',
				:name=>'name',
					:applied=>'a[p]*lied',
				:class=>'cla[s]*',
				:skill=>'ski[l]*',
				:weapon=>'wea(?:p(?:on)?)?|wip(?:on)?',
				:armor=>'armo[u]?r',
				:state=>'stat(?:e|us)?',
			:enemy=>'enemy',
				:appeared=>'a[p]*eared',
				:inflicted=>'inflicted', # to use as - state inflicted
			:facing=>'facing', # to use as - event facing
				:up=>'up',
				:down=>'down',
				:left=>'left',
				:right=>'right',
			:vehicle=>'vehicle',
			:gold=>'gold|money',
			:script=>'script|code',
		:loop=>'loop',
			:break=>'break',
		:exit=>'exit', # to use as - exit event processing
		:call=>'call',
			:common=>'common',
		:label=>'label|link',
			:jump=>'jump(?:[\s]*to)?',
		:comment=>'comment',
		#~PARTY group
		:change=>'change',
			:party=>'party',
				:member=>'member',
		#~ACTOR group
		:hp=>'hp',
		:sp=>'[ms]p',
		:recover=>'recover', # may be used for one member
			:all=>'a[l]*',
		:exp=>'exp(?:irience)?',
		:level=>'l[e]?v[e]?l',
		:params=>'param(?:et[e]?r)s',
		:nickname=>'nick(?:name)?',
		# TAB#2
		#~MOVEMENT group
		:transfer=>'transfer|teleport(?:ate|ion)',
			:player=>'player',
		:map=>'map', # to use as - scroll map || event map x
			:x=>'x',
			:y=>'y',
		:screen=>'scr[e]*n', # to use as - event screen x
		:route=>'rout(?:e|ing)?',
			:move=>'move|go',
				:forward=>'forward|в[\s]*пер[её][дт]',
				:backward=>'backward|н[ао][\s]*за[дт]',
				:lower=>'lower',
				:upper=>'upper',
			:random=>'rand(?:om[ed]*)?',
			:toward=>'toward',
			:away=>'away([\s]*from)?',
			:step=>'step',
		:get=>'get',
			:on=>'on',
			:off=>'off', # to use as - get on/off vehicle
		
		:turn=>'turn',
			:clockwise=>'clockwise', # по часовой
			:counterclockwise=>'counter[\s]clockwise', # против часовой
		:emulate=>'emulate',
			:click=>'click|tap',
			:touch=>'touch|enter',
				:by_event=>'by[\s]*event',
			:autorun=>'auto[\s]*run',
			:parallel=>'para[ll]*el',
		
		:wait=>'wait',
			:frames=>'frame[s]?',
	},
	#--MAP branch
	:map=>{
		:main=>'map',
		:name=>'name',
		:width=>'width',
		:height=>'height',
		
	},
	#--PICTURE branch
	:picture=>{
		:maybe=>'in future versions'
	},
	#--SPRITE branch
	:sprite=>{
		:main=>'sprite|спрайт',
		:create=>'create|созда(?:[йть]|ва[йть])',
		:dispose=>'dispose|delete',
		:move=>'move',
		:resize=>'resize',
		:set=>'set',
		:x=>'(?:x|х|икс)',
		:y=>'(?:y|у|игрек)',
		:width=>'width',
		:height=>'height',
	},
	#--TEXT branch
	:text=>{
		:main=>'text',
		:make=>'make',
		:bigger=>'bigger',
		:smaller=>'smaller',
		:set=>'set',
		:font=>'font',
		:size=>'size',
	},
	#--WINDOW branch
	:window=>{
		:main=>'window|окно',
		:create=>'create|созда(?:[йть]|ва[йть])',
			:at=>'at',
			:with=>'with',
		:dispose=>'dispose|delete',
		:move=>'move',
			:to=>'to',
			:speed=>'speed',
				:auto=>'auto',
		:resize=>'resize',
		:set=>'set',
		:x=>'(?:x|х|икс)',
		:y=>'(?:y|у|игрек)',
		:width=>'width',
		:height=>'height',
		:label=>'label|link',
		:index=>'index',
			:indexed=>'indexed',
		:labeled=>'labeled|linked',
			:as=>'as',
		:opacity=>'opacity',
			:back=>'back', # to use as - set back opacity
	}
  }
  
  # Хэш-таблица всех возможных сочетаний слов из VOCAB.<br>
  # На данный момент почти не используется, создан для будущих версий.
  CMB={
	#~COMMON unbranch
	:select_window=>"(?:(?:#{VOCAB[:select]}#{VOCAB[:window][:main]})|"+
		"(?:#{VOCAB[:window][:main]}#{VOCAB[:select]}))",
	:select_by_index=>"(?:#{VOCAB[:window][:index]}\=)",
	:select_by_label=>"(?:#{VOCAB[:window][:label]}\=)",
	#~CIGUI branch
	:cigui_start=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:start]})+)+",
	:cigui_finish=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:finish]})+)+",
	:cigui_flush=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:flush]})+)+",
	#~WINDOW branch
	:window_create=>"(((?:#{VOCAB[:window][:create]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
		"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:create]})+)",
	:window_create_atORwith=>"((?:#{VOCAB[:window][:at]})+[\s]*(#{VOCAB[:window][:x]}|#{VOCAB[:window][:y]})+)|"+
		"((?:#{VOCAB[:window][:with]})+[\s]*(?:#{VOCAB[:window][:width]}|#{VOCAB[:window][:height]}))",
	:window_dispose=>"(((?:#{VOCAB[:window][:dispose]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
		"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:dispose]})+)",
	:window_dispose_index=>"((((?:#{VOCAB[:window][:dispose]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
		"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:dispose]})+))"+
		"[\s]*#{VOCAB[:window][:index]}\=",
	:window_x_equal=>"#{VOCAB[:window][:x]}=",
	:window_y_equal=>"#{VOCAB[:window][:y]}\=",
	:window_w_equal=>"#{VOCAB[:window][:width]}=",
	:window_h_equal=>"#{VOCAB[:window][:height]}\=",
	:window_move=>"(?:(?:#{VOCAB[:last]}#{VOCAB[:window][:main]}#{VOCAB[:window][:move]})|"+
		"(?:#{VOCAB[:window][:move]}#{VOCAB[:last]}#{VOCAB[:window][:main]}))",
	:window_s_equal=>"#{VOCAB[:window][:speed]}\=",
  }
  
  # 
  class <<self
	# Внутренний массив для вывода информации обо всех созданных окнах.</br>
	# Открыт только для чтения.
	# 
	attr_reader :windows
	
	# Внутренний массив для вывода информации обо всех созданных спрайтах.</br>
	# Открыт только для чтения.
	# 
	attr_reader :sprites
	
    # Требуется выполнить этот метод перед началом работы с CIGUI.<br>
	# Пример:
	#	begin
	#		CIGUI.setup
	#		#~~~ some code fragment ~~~
	#		CIGUI.update
	#		#~~~ some other code fragment ~~~
	#	end
    # Инициализирует массив $do, если он еще не был создан. В этот массив пользователь подает
	# команды для исполнения при следующем запуске метода #update.<br>
	# Если даже массив $do был инициализирован ранее,
	# то исполняет команду <i>cigui start</i> прежде всего.
	#
	def setup
	  $do||=[]
	  $do.insert 0,'cigui start'
	  _setup
	end	
	
	# Вызывает все методы обработки команд, содержащиеся в массиве $do.<br>
	# Вызовет исключение CIGUIERR::CantInterpretCommand в том случае,
	# если после выполнения <i>cigui finish</i> в массиве $do будут находится
	# новые команды для обработки.<br>
	# По умолчанию очищает массив $do после обработки всех команд. Если clear_after_update
	# поставить значение false, то все команды из массива $do будут выполнены повторно
	# при следующем запуске этого метода.<br>
	# Помимо приватных методов обработки вызывает также метод #update_by_user, который может быть
	# модифицирован пользователем (подробнее смотри в описании метода).<br>
	#
    def update(clear_after_update=true)
		$do.each do |line|
			raise CIGUIERR::CantInterpretCommand if @finished
			_common? line
			_cigui? line
			_window? line
			#_create? line
			#_move? line
			#_rotate? line
			#_scale? line
			#_
			update_by_user
		end
		$do.clear if clear_after_update
    end
	
	# Метод обработки текста, созданный для пользовательских модификаций, не влияющих на работу
	# встроенных обработчиков.
	# Используйте <i>alias</i> этого метода для добавления обработки собственных команд.
	#
	def update_by_user
	
	end
	
	# Данный метод возвращает первое попавшееся целое число, найденное в строке source_string.<br>
	# Производит поиск только в том случае, если число записано:
	# * в скобки, например (10);
	# * в квадратные скобки, например [23];
	# * в кавычки(апострофы), например '45';
	# * в двойные кавычки, например "8765".
    # Также, вернет всю целую часть числа записанную:
	# * до точки, так здесь [1.35] вернет 1;
	# * до запятой, так здесь (103,81) вернет 103;
	# * до первого пробела (при стандартной конвертации в целое число), так здесь "816 586,64" вернет только 816;
	# * через символ подчеркивания, так здесь '1_000_0_0_0,143' вернет ровно один миллион (1000000).
	# Если присвоить std_conversion значение false, то это отменит стандартную конвертацию строки,
	# встроенную в Ruby, и метод попробует найти число, игнорируя пробелы, табуляцию
	# и знаки подчеркивания.
	# Выключение std_conversion может привести к неожиданным последствиям.
	#	decimal('[10,25]') # => 10
	#	decimal('[1 0 2]',false) # => 102
	#	decimal('[1_234_5678 89]',false) # => 123456789
	# <br>
	# Метод работает вне зависимости от работы модуля - нет необходимости
	# запускать для вычисления #setup и #update.
	#
    def decimal(source_string, std_conversion=true)
	  fraction(source_string, std_conversion).to_i
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{string}"
    end
	
	# Данный метод работает по аналогии с #decimal, но возвращает рациональное число
	# (число с плавающей запятой или точкой).<br>
	# Имеется пара замечаний к правилам использования в дополнение к  упомянутым в #decimal:
	# * Все цифры после запятой или точки считаются дробной частью и также могут содержать помимо цифр символ подчёркивания;
	# * При наличии между цифрами в дробной части пробела вернет ноль (в стандартной конвертации в целое или дробное число).
	# Если присвоить std_conversion значение false, то это отменит стандартную конвертацию строки,
	# встроенную в Ruby, и метод попробует найти число, игнорируя пробелы, табуляцию
	# и знаки подчеркивания.
	# Выключение std_conversion может привести к неожиданным последствиям.
	#	fraction('(109,86)') # => 109.86
	#	fraction('(1 0 9 , 8 6)',false) # => 109.86
	# <br>
	# Метод работает вне зависимости от работы модуля - нет необходимости
	# запускать для вычисления #setup и #update.
	#
	def fraction(source_string, std_conversion=true)
	  match='(?:[\[|"\(\'])[\s]*([\d\s_]*(?:[\s]*[\,\.][\s]*(?:[\d\s_]*))*)(?:[\]|"\)\'])'
	  return source_string.match(match)[1].gsub!(/[\s_]*/){}.to_f if !std_conversion
	  source_string.match(match)[1].to_f
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{string}"
	end
	
	# Данный метод работает по аналогии с #decimal, но производит поиск в строке
	# с учетом указанных префикса (текста перед числом) и постфикса (после числа).<br>
	# Метод не требует обязательного указания символов квадратных и круглых скобок,
	# а также одинарных и двойных кавычек вокруг числа.<br>
	# prefix и postfix могут содержать символы, используемые в регулярных выражениях
	# для более точного поиска.
	#	dec('x=1cm','x=','cm') # => 1
	#	dec('y=120 m','[xy]=','[\s]*(?:cm|m|km)') # => 120
	# В отличие от #frac, возвращает целое число.
	# <br>
	# Метод работает вне зависимости от работы модуля - нет необходимости
	# запускать для вычисления #setup и #update.
	#
	def dec(source_string, prefix='', postfix='', std_conversion=true)
	  frac(source_string, prefix, postfix, std_conversion).to_i
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{string}"
	end
	# Данный метод работает по аналогии с #fraction, но производит поиск в строке
	# с учетом указанных префикса (текста перед числом) и постфикса (после числа).<br>
	# Метод не требует обязательного указания символов квадратных и круглых скобок,
	# а также одинарных и двойных кавычек вокруг числа.<br>
	# prefix и postfix могут содержать символы, используемые в регулярных выражениях
	# для более точного поиска.
	#	frac('x=31.2mm','x=','mm') # => 31.2
	#	frac('y=987,67 m','[xy]=','[\s]*(?:cm|m|km)') # => 987.67
	# В отличие от #dec, возвращает рациональное число.
	# <br>
	# Метод работает вне зависимости от работы модуля - нет необходимости
	# запускать для вычисления #setup и #update.
	# 
	def frac(source_string, prefix='', postfix='', std_conversion=true)
	  match=prefix+'([\d\s_]*(?:[\s]*[\,\.][\s]*(?:[\d\s_]*))*)'+postfix
	  return source_string.match(match)[1].gsub!(/[\s_]*/){}.to_f if !std_conversion
	  source_string.match(match)[1].to_f
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{string}"
	end
	
	# Возвращает сообщение о последнем произведенном действии
	# или классе последнего использованного объекта, используя метод
	# Kernel.inspect.
	#
	def last
		@last_action.is_a?(String) ? @last_action : @last_action.inspect
	end
    
    private
	
	def _setup
	  @last_action = nil
	  @finished = false
	  @windows = []
	  @sprites = []
	  @selection = {
		:type => nil, # may be window or sprite
		:index => 0  # index in internal array
	  }
	end
	
	# COMMON UNBRANCH
	def _common?(string)
		# select, please and other
		__swindow? string
	end
	
	def __swindow?(string)
		matches=string.match(/#{CMB[:select_window]}/)
		# Only match
		if matches
			begin
				# Read index or label
				if string.match(/#{CMB[:select_by_index]}/)
					index = 
					@selection[:type]=:window
					@selection[:index]=index
				elsif string.match(/#{CMB[select_by_label]}/)
				
				end
				@last_action = @selection
			rescue
				# do nothing, maybe? 
			end
		end
	end
	
	# CIGUI BRANCH
    def _cigui?(string)
		__start? string
		__finish? string
		__flush? string
    end
	
	def __start?(string)
		matches=string.match(/#{CMB[:cigui_start]}/)
		if matches
			begin
				@finished = false
				@last_action = 'CIGUI started'
			rescue
				raise "#{CIGUIERR::CantStart}\n\tcurrent line of $do: #{string}"
			end
		end
	end
	
	def __finish?(string)
		matches=string.match(/#{CMB[:cigui_finish]}/)
		if matches
			@finished = true
			@last_action = 'CIGUI finished'
		end
	end
	
	def __flush?(string)
		matches=string.match(/#{CMB[:cigui_flush]}/)
		if matches
			@windows.each{|item|item.dispose}
			@windows.clear
			@sprites.each{|item|item.dispose}
			@sprites.clear
			@last_action = 'CIGUI cleared'
		end
	end
	
	# WINDOW BRANCH
	def _window?(string)
		__wcreate? string
		__wdispose? string
		__wmove? string
	end
	
	# create window (default position and size) 
	# create window at x=DEC, y=DEC
	# create window with width=DEC,height=DEC
	# create window at x=DEC, y=DEC with w=DEC, h=DEC
	def __wcreate?(string)
		matches=string.match(/#{CMB[:window_create]}/)
		# Only create
		if matches
			begin
				begin
					@windows<<Win3.new if RUBY_VERSION.to_f > 1.9
				rescue
					@windows<<NilClass
				end
				@last_action = @windows.last
			rescue
				raise "#{CIGUIERR::CannotCreateWindow}\n\tcurrent line of $do: #{string}"
			end
		end
		# Read params
		begin
			if string.match(/#{CMB[:window_create_atORwith]}/)
				# at OR with: check x and y
				new_x = string[/#{CMB[:window_x_equal]}/] ? dec(string,CMB[:window_x_equal]) : @windows.last.x
				new_y = string[/#{CMB[:window_y_equal]}/] ? dec(string,CMB[:window_y_equal]) : @windows.last.y
				# at OR with: check w and h
				new_w = string[/#{CMB[:window_w_equal]}/] ? dec(string,CMB[:window_w_equal]) : @windows.last.width
				new_h = string[/#{CMB[:window_h_equal]}/] ? dec(string,CMB[:window_h_equal]) : @windows.last.height
				@windows.last.x = new_x
				@windows.last.y = new_y
				@windows.last.width = new_w
				@windows.last.height = new_h
				@last_action = @windows.last
			end
		rescue
			# dunnolol
		end
	end
	
	# this move to x=DEC,y=DEC
	# this move to x=DEC,y=DEC with speed=1
	# this move to x=DEC,y=DEC with speed=auto
	def __wmove?(string)
		matches=string.match(/#{CMB[:window_move]}/)
		# Only move
		if matches
			begin
				# Read params
				new_x = string[/#{CMB[:window_x_equal]}/] ? dec(string,CMB[:window_x_equal]) : @windows.last.x
				new_y = string[/#{CMB[:window_y_equal]}/] ? dec(string,CMB[:window_y_equal]) : @windows.last.y
				new_s = string[/#{CMB[:window_s_equal]}/] ? dec(string,CMB[:window_s_equal]) : @windows.last.speed
				@window.last.x = new_x
				@window.last.x = new_y
				@window.last.speed = new_s
				@last_action = @window.last
			rescue
				# dunnolol
				#raise "#{CIGUIERR::CannotCreateWindow}\n\tcurrent line of $do: #{string}"
			end
		end
	end
	
	def __wdispose?(string)
		matches=string.match(/#{CMB[:window_dispose]}/)
		# Only create
		if matches
			begin
				if string.match(/#{CMB[:window_dispose_index]}/)
					index=dec(string,CMB[:window_dispose_index])
					if (0...@windows.size).include? index
						@windows[index].dispose
						@windows.delete_at(index)
					else
						raise "#{CIGUIERR::WrongWindowIndex}\n\tcurrent line of $do: #{string}"
					end
				end
				@last_action = 'CIGUI disposed window'
			rescue
				# don't know what error you want to see
				#raise "#{CIGUIERR::CannotDisposeThisStupidWindow}"
			end
		end
	end
	def __wmove?(string);end
  end
end

# test zone
begin
	$do=[
		'create window at x=200, y=100 with height=300,width=500',
		'this move to x=150,y=124'
	]
	CIGUI.setup
	CIGUI.update
	puts CIGUI.last
end