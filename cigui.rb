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
  
  class CannotCreateWindow < StandardError
	private
	def message
		'Unable to create window'
	end
  end
end

# Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>
# Реализация выполнена для RGSS3.
if RUBY_VERSION.to_f>1.9
	begin
		class Win3 < Window
			def initialize
				super 0,0,192,64
				@items={}
			end
			
			def add_item(command,procname,enabled=true)
				@items+={
					:command=>command,
					:procname=>procname,
					:enabled=>enabled
				}
			end
		end
	rescue
		puts 'Class \'Window\' not found'
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
	:please=>'please|п[оа]жал[у]?[й]?ста',
	:last=>'last|this|последн(?:ее|юю|яя)|это',
	:select=>'select', # by index or label
    :cigui=>{
      :main=>'cigui|сигуи',
      :start=>'start|запус(?:ти(?:ть)?|к)',
      :finish=>'finish|завершить',
      :flush=>'flush|очист(?:к[аойеу]|[ить])'
    },
	:event=>{
		:maybe=>'in future versions'
	},
	:map=>{
		:maybe=>'in future versions'
	},
	:picture=>{
		:maybe=>'in future versions'
	},
	:sprite=>{
		:main=>'sprite|спрайт',
		:create=>'create|созда(?:[йть]|ва[йть])',
		:dispose=>'dispose|delete',
		:move=>'move',
		:resize=>'resize',
		:set=>'set',
		:x=>'x|х|икс',
		:y=>'y|у|игрек',
		:width=>'width',
		:height=>'height'
	},
	:text=>{
		:main=>'text',
		:make=>'make',
		:bigger=>'bigger',
		:smaller=>'smaller',
		:set=>'set',
		:font=>'font',
		:size=>'size'
		# commented to move in CMB
		#:set_font_size=>'(?:set)*[\s]*font[\s]*size',
		#:set_font=>'(?:set)*[\s]*font',
	},
	:window=>{
		:main=>'window|окно',
		:create=>'create|созда(?:[йть]|ва[йть])',
		:at=>'at',
		:with=>'with',
		:dispose=>'dispose|delete',
		:move=>'move',
		:resize=>'resize',
		:set=>'set',
		:x=>'x|х|икс',
		:y=>'y|у|игрек',
		:width=>'width',
		:height=>'height',
		:label=>'label|link'
	}
  }
  
  # Хэш-таблица всех возможных сочетаний слов из VOCAB.<br>
  # На данный момент почти не используется, создан для будущих версий.
  CMB={
	:cigui_start=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:start]})+)+",
	:cigui_finish=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:finish]})+)+",
	:cigui_flush=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:flush]})+)+",
	:window_create=>"(((?:#{VOCAB[:window][:create]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
	"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:create]})+)",
  }
  
  # 
  class <<self
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
	  raise CIGUIERR::CantReadNumber
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
	  raise CIGUIERR::CantReadNumber
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
	  raise CIGUIERR::CantReadNumber
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
	  raise CIGUIERR::CantReadNumber
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
	end
	
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
	
	def _window?(string)
		__create? string
	end
	
	# create window (default position and size) 
	# create window at x=DEC, y=DEC
	# create window with width=DEC,height=DEC
	# create window at x=DEC, y=DEC with w=DEC, h=DEC
	def __create?(string)
		matches=string.match(/#{CMB[:window_create]}/)
		# Only create
		if matches
			begin
				begin
					@windows<<Win3.new if RUBY_VERSION > 1.9
				rescue
					@windows<<NilClass
				end
				@last_action = @windows.last
			rescue
				raise "#{CIGUIERR::CannotCreateWindow}\n\tcurrent line of $do: #{string}"
			end
		end
		# Read params
		
	end
  end
end

# test zone
begin
	$do=[
		'create window'
	]
	CIGUI.setup
	CIGUI.update
	puts CIGUI.last
end