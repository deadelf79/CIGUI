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
# * CIGUIERR::CantReadString
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
  
  # Ошибка, которая появляется, если в строке не было обнаружено строчное значение.<br>
  # Правила оформления строки и примеры использования указаны в описании
  # к этому методу: CIGUI.string
  #
  class CantReadString < StandardError
	private
	def message
		'Could not find substring'
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
  
  # Ошибка создания окна.
  #
  class CannotCreateWindow < StandardError
	private
	def message
		'Unable to create window'
	end
  end
  
  # Ошибка, которая появляется при попытке обращения
  # к несуществующему индексу в массиве <i>windows</i><br>
  # Вызывается при некорректном вводе пользователя
  #
  class WrongWindowIndex < StandardError
	private
	def message
		'Index must be included in range of 0 to internal windows array size'
	end
  end
end

# Инициирует классы, если версия Ruby выше 1.9.0
# 
if RUBY_VERSION.to_f>=1.9
	begin
		# Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>
		# Реализация выполнена для RGSS3.
		#
		class Win3 < Window_Selectable
			# Скорость перемещения
			attr_accessor :speed
			# Прозрачность окна. Может принимать значения от 0 до 255
			attr_accessor :opacity
			# Прозрачность фона окна. Может принимать значения от 0 до 255
			attr_accessor :back_opacity
			# Метка окна. Строка, по которой происходит поиск экземпляра
			# в массиве CIGUI.windows при выборе окна по метке (select by label)
			attr_reader :label
			
			# Создает окно. По умолчанию задается размер 192х64 и
			# помещается в координаты 0, 0
			#
			def initialize(x=0,y=0,w=192,h=64)
				super 0,0,192,64
				@label=nil
				@items=[]
				@texts=[]
				@speed=1
			end
			
			# Обновляет окно. Влияет только на положение курсора (параметр cursor_rect),
			# прозрачность и цветовой тон окна.
			def update;end
			
			# Обновляет окно. В отличие от #update, влияет только
			# на содержимое окна (производит повторную отрисовку).
			def refresh
				self.contents.clear
			end
			
			# Задает метку окну, проверяя ее на правильность перед этим:
			# * удаляет круглые и квадратгые скобки
			# * удаляет кавычки
			# * заменяет пробелы и табуляцию на символы подчеркивания
			# * заменяет символы "больше" и "меньше" на символы подчеркивания
			def label=(string)
				# make right label
				string.gsub!(/[\[\]\(\)\'\"]/){''}
				string.gsub!(/[ \t\<\>]/){'_'}
				# then label it
				@label = string
			end
			
			# Этот метод позволяет добавить текст в окно.<br>
			# Принимает в качестве параметра значение класса Text
			def add_text(text)
				
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
			# являющееся названием кнопки, либо целое число - индекс кнопки	во внутреннем массиве <i>items</i>.
			#	enable_item(0) # => @items[0].enabled set 'true'
			#	enable_item('New game') # => @items[0].enabled set 'true'
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
			
			# Устанавливает новые размеры окна дополнительно изменяя
			# также и размеры содержимого (contents).<br>
			# Все части содержимого, которые не помещаются в новые размер,
			# удаляются безвозратно.
			#
			def resize(new_width, new_height)
				temp=Sprite.new
				temp.bitmap=self.contents
				self.contents.dispose
				src_rect(0,0,temp.width,temp.height)
				self.contents=Bitmap.new(
					width - padding * 2,
					height - padding * 2
				)
				self.contents.bit(0,0,temp.bitmap,src_rect,255)
				temp.bitmap.dispose
				temp.dispose
				width=new_width
				height=new_height
			end
			
			# Удаляет окно и все связанные с ним ресурсы
			#
			def dispose
				super
			end
			
			# Возврашает полную информацию обо всех параметрах
			# в формате строки
			#
			def inspect
				"<#{self.class}:"+
				" @back_opacity=#{back_opacity},"+
				" @contents_opacity=#{contents_opacity}"+
				" @height=#{height},"+
				" @opacity=#{opacity},"+
				" @speed=#{@speed},"+
				" @width=#{width},"+
				" @x=#{x},"+
				" @y=#{y}>"
			end
		end
	# Если классы инициировать не удалось (ошибка в отсутствии родительских классов),
	# то в память загружаются исключительно консольные версии (console-only) классов
	# необходимые для работы с командной строкой.
	rescue
		# Класс абстрактного (невизуального) прямоугольника.
		# Хранит значения о положении и размере прямоугольника
		class Rect
			# Координата X
			attr_accessor :x
			# Координата Y
			attr_accessor :y
			# Ширина прямоугольника
			attr_accessor :width
			# Высота прямоугольника
			attr_accessor :height
			
			# Создание прямоугольника
			# * x, y - назначает положение прямоуголника в пространстве
			# * width, height - устанавливает ширину и высоту прямоугольника
			def initialize(x,y,width,height)
				@x,@y,@width,@height = x,y,width,height
			end
			
			# Задает все параметры единовременно
			# Может принимать значения:
			# * Rect - другой экземпляр класса Rect, все значения копируются из него
			# * x, y, width, height - позиция и размер прямоугольника
			#	# Оба варианта работают аналогично:
			#	set(Rect.new(0,0,192,64))
			#	set(0,0,192,64)
			def set(*args)
				if args.size==1
					@x,@y,@width,@height = args[0].x, args[0].y, args[0].width, args[0].height
				elsif args.size==4
					@x,@y,@width,@height = args[0], args[1], args[2], args[3]
				elsif args.size.between?(2,3)
					# throw error, but i don't remember which error O_o
				end
			end
			
			# Устанавливает все параметры прямоугольника равными нулю.
			def empty
				@x,@y,@width,@height = 0, 0, 0, 0
			end
		end
	

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
			# Opacity of window. May be in range of 0 to 255
			attr_accessor :opacity
			# Back opacity of window. May be in range of 0 to 255
			attr_accessor :back_opacity
			# Label of window
			attr_reader :label
			# If window is active then it updates
			attr_accessor :active
			# Openness of window
			attr_accessor :openness
			# Window skin - what window looks like
			attr_accessor :windowskin
			
			# Create window
			def initialize
				@x,@y,@width,@height = 0, 0, 192, 64
				@speed=0
				@opacity, @back_opacity, @contents_opacity = 255, 255, 255
				@z, @tone, @openness = 100, Rect.new(0,0,0,0), 255
				@active, @label = true, nil
				@windowskin='window'
				@items=[]
			end
			
			# Resize (simple)
			def resize(new_width, new_height)
				@width=new_width
				@height=new_height
			end
			
			# Update window (do nothing now)
			def update;end
			
			# Close window
			def close
				@openness=0
			end
			
			# Open window
			def open
				@openness=255
			end
			
			# Dispose window
			def dispose;end
			
			def label=(string)
				# make right label
				string.gsub!(/[\[\]\(\)\'\"]/){''}
				string.gsub!(/[ \t\<\>]/){'_'}
				# then label it
				@label = string
			end
		end
		
		# Класс спрайта со всеми параметрами, доступными в RGSS3. Пока пустой, ожидается обновление во время работы над спрайтами
		# (ветка work-with-sprites в github).
		#
		class Spr3
			# Создает новый спрайт
			def initialize;end
			
			# Производит обновление спрайта
			def update;end
			
			# Производит повторную отрисовку содержимого спрайта
			def refresh;end
			
			# Удаляет спрайт
			def dispose;end
		end
		
		# Класс, хранящий данные о цвете в формате RGBA
		# (красный, зеленый, синий и прозрачность). Каждое значение
		# является рациональным числом (число с плавающей точкой) и
		# имеет значение от 0.0 до 255.0. Все значения, выходящие
		# за указанный интервал, корректируются автоматически.
		#
		class Color
			# Создает экземпляр класса.
			# * r, g, b - задает изначальные значения красного, зеленого и синего цветов
			# * a - задает прозрачность, по умолчанию имеет значение 255.0 (полностью непрозрачный цвет)
			def initialize(r,g,b,a=255.0)
				@r,@g,@b,@a = r.to_f,g.to_f,b.to_f,a.to_f
				_normalize
			end
			
			# Возвращает значение красного цвета
			def red
				@r
			end
			
			# Возвращает значение зеленого цвета
			def green
				@r
			end
			
			# Возвращает значение синего цвета
			def blue
				@r
			end
			
			# Возвращает значение прозрачности
			def alpha
				@r
			end
			
			# Задает новые значения цвета и прозрачности.<br>
			# <b>Варианты параметров:</b>
			# * set(Color) - в качестве параметра задан другой экземпляр класса Color
			# Все значения цвета и прозрачности будут скопированы из него.
			# * set(red, green, blue) - задает новые значения цвета.
			# Прозрачность по умолчанию становится равна 255.0
			# * set(red, green, blue, alpha) - задает новые значения цвета и прозрачности.
			def set(*args)
				if args.size==1
					@r,@g,@b,@a = args[0].red,args[0].green,args[0].blue,args[0].alpha
				elsif args.size==4
					@r,@g,@b,@a = args[0],args[1],args[2],args[3]
				elsif args.size==3
					@r,@g,@b,@a = args[0],args[1],args[2],255.0
				elsif args.size==2
					# throw error like in Rect class
				end
				_normalize
			end
			
			private
			
			def _normalize
				@r=0 if @r<0
				@r=255 if @r>255
				@g=0 if @g<0
				@g=255 if @g>255
				@b=0 if @b<0
				@b=255 if @b>255
				@a=0 if @a<0
				@a=255 if @a>255
			end
		end
	end
end

# Класс, хранящий данные о тексте в окне. Создается для каждого окна отдельно,
# имеет индивидуальные настройки.
class Text
	# Название файла изображения, из которого загружаются данные для отрисовки окон.<br>
	# По умолчанию задан путь 'Graphics\System\Window.png'.
	attr_accessor :windowskin
	
	# Массив цветов для отрисовки текста, по умолчанию содержит 32 цвета
	attr_accessor :colorset
	
	# Переменная класса Color, содержит цвет обводки текста.
	attr_accessor :out_color
	
	# Булевая переменная (принимает только значения true или false),
	# которая отвечает за отрисовку обводки текста. По умолчанию,
	# обводка включена (outline=true)
	attr_accessor :outline
	
	# Булевая переменная (принимает только значения true или false),
	# которая отвечает за отрисовку тени от текста. По умолчанию,
	# тень выключена (shadow=false)
	attr_accessor :shadow
	
	# Устанавливает жирность шрифта для <b>всего</b> текста.<br>
	# Игнорирует тег < b > в тексте
	attr_accessor :bold
	
	# Устанавливает наклон шрифта (курсив) для <b>всего</b> текста.<br>
	# Игнорирует тег < i > в тексте
	attr_accessor :italic
	
	# Устанавливает подчеркивание шрифта для <b>всего</b> текста.<br>
	# Игнорирует тег < u > в тексте
	attr_accessor :underline
	
	# Гарнитура (название) шрифта. По умолчанию - Tahoma
	attr_accessor :font
	
	# Размер шрифта. По умолчанию - 20
	attr_accessor :size
	
	# Строка текста, которая будет отображена при использовании
	# экземпляра класса.
	attr_accessor :string
	
	# Создает экземпляр класса.<br>
	# <b>Параметры:</b>
	# * string - строка текста
	# * font_family - массив названий (гарнитур) шрифта, по умолчанию
	# имеет только "Tahoma".
	# При выборе гарнитуры шрифта, убедитесь в том, что символы, используемые
	# в тексте, корректно отображаются при использовании данного шрифта.
	# * font_size - размер шрифта, по умолчанию равен 20 пунктам
	# * bold - <b>жирный шрифт</b> (по умолчанию - false)
	# * italic - <i>курсив</i> (по умолчанию - false)
	# * underline - <u>подчеркнутый шрифт</u> (по умолчанию - false)
	def initialize(string, font_family=['Tahoma'], font_size=20, bold=false, italic=false, underline=false)
		@string=string
		@font=font_family
		@size=font_size
		@bold, @italic, @underline = bold, italic, underline
		@colorset=[]
		@out_color=Color.new(0,0,0,128)
		@shadow, @outline = false, true
		@windowskin='Graphics\\System\\Window.png'
		default_colorset
	end
	
	# Восстанавливает первоначальные значения цвета. По возможности, эти данные загружаются
	# из файла 
	def default_colorset
		@colorset.clear
		if FileTest.exist?(@windowskin)
			bitmap=Bitmap.new(@windowskin)
			for y in 0..3
				for x in 0..7
					@colorset<<bitmap.get_pixel(x*8+64,y*8+96)
				end
			end
			bitmap.dispose
		else
			# Colors for this set was taken from <RTP path>/Graphics/Window.png file,
			# not just from the sky
			@colorset = [
				# First row
				Color.new(255,255,255), # 1
				Color.new(32, 160,214), # 2
				Color.new(255,120, 76), # 3
				Color.new(102,204, 64), # 4
				Color.new(153,204,255), # 5
				Color.new(204,192,255), # 6
				Color.new(255,255,160), # 7
				Color.new(128,128,128), # 8
				# Second row
				Color.new(192,192,192), # 1
				Color.new(32, 128,204), # 2
				Color.new(255, 56, 16), # 3
				Color.new(  0,160, 16), # 4
				Color.new( 62,154,222), # 5
				Color.new(160,152,255), # 6
				Color.new(255,204, 32), # 7
				Color.new(  0,  0,  0), # 8
				# Third row
				Color.new(132,170,255), # 1
				Color.new(255,255, 64), # 2
				Color.new(255,120, 76), # 3
				Color.new( 32, 32, 64), # 4
				Color.new(224,128, 64), # 5
				Color.new(240,192, 64), # 6
				Color.new( 64,128,192), # 7
				Color.new( 64,192,240), # 8
				# Fourth row
				Color.new(128,255,128), # 1
				Color.new(192,128,128), # 2
				Color.new(128,128,255), # 3
				Color.new(255,128,255), # 4
				Color.new(  0,160, 64), # 5
				Color.new(  0,224, 96), # 6
				Color.new(160, 96,224), # 7
				Color.new(192,128,255)  # 8
			]
		end
	end
	
	# Сбрасывает все данные, кроме colorset, на значения по умолчанию
	def empty
		@string=''
		@font=['Tahoma']
		@size=20
		@bold, @italic, @underline = false, false, false
		@out_color=Color.new(0,0,0,128)
		@shadow, @outline = false, false
		@windowskin='Graphics\\System\\Window.png'
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
  # Специальный словарь, содержащий все используемые команды Cigui.
  # Предоставляет возможности не только внесения новых слов, но и добавление
  # локализации (перевода) имеющихся (см. #update_by_user).<br>
  # Для удобства поиска разбит по категориям: 
  # * common - общие команды, не имеющие категории;
  # * cigui - управление интерпретатором; 
  # * event - событиями на карте;
  # * map - параметрами карты;
  # * picture - изображениями, используемыми через команды событий;
  # * sprite - самостоятельными изображениями;
  # * text - текстом и шрифтами
  # * window - окнами.
  #
  VOCAB={
	#--COMMON unbranch
	:please=>'please',
	:last=>'last|this',
	:select=>'select', # by index or label
	:true=>'true|1', # for active||visible
	:false=>'false|0',
	:equal=>'[\s]*[\=]?[\s]*',
	#--CIGUI branch
    :cigui=>{
      :main=>'cigui',
      :start=>'start',
      :finish=>'finish',
      :flush=>'flush',
	  :restart=>'restart|resetup',
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
		:x=>'x|х|икс',
		:y=>'y|у|игрек',
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
		:main=>'window',
		:create=>'create',
			:at=>'at',
			:with=>'with',
		:dispose=>'dispose|delete',
		:move=>'move',
			:to=>'to',
			:speed=>'speed',
				:auto=>'auto',
		:resize=>'resize',
		:set=>'set',
		:x=>'x',
		:y=>'y',
		:z=>'z',
		:ox=>'ox',
		:oy=>'oy',
		:tone=>'tone',
		:width=>'width',
		:height=>'height',
		:link=>'link', # to use as - set button[DEC] link to switch[DEC] #dunnolol
		:label=>'label',
		:index=>'index',
			:indexed=>'indexed',
		:labeled=>'labeled',
			:as=>'as',
		:opacity=>'opacity',
			:back=>'back', # to use as - set back opacity
			:contents=>'contents', # to use as - set contents opacity
		:open=>'open',
			:openness=>'openness',
		:close=>'close',
		:active=>'active',
		:activate=>'activate',
		:deactivate=>'deactivate',
		:windowskin=>'skin|window[\s_]*skin',
		:cursor=>'cursor',
			:rect=>'rect',
	}
  }
  
  # Хэш-таблица всех возможных сочетаний слов из VOCAB и их положения относительно друг друга в тексте.<br>
  # Именно по этим сочетаниям производится поиск команд Cigui в тексте. Редактировать без понимания правил
  # составления регулярных выражений не рекомендуется.
  CMB={
	#~COMMON unbranch
	:select_window=>"(?:(?:#{VOCAB[:select]})+[\s]*(?:#{VOCAB[:window][:main]})+)|"+
		"(?:(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:select]})+)",
	:select_by_index=>"(?:#{VOCAB[:window][:index]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:select_by_label=>"(?:#{VOCAB[:window][:label]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	#~CIGUI branch
	:cigui_start=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:start]})+)+",
	:cigui_finish=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:finish]})+)+",
	:cigui_flush=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:flush]})+)+",
	:cigui_restart=>"((?:#{VOCAB[:cigui][:main]})+[\s]*(?:#{VOCAB[:cigui][:restart]})+)+",
	#~WINDOW branch
	:window_create=>"(((?:#{VOCAB[:window][:create]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
		"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:create]})+)",
	:window_create_atORwith=>"((?:#{VOCAB[:window][:at]})+[\s]*(#{VOCAB[:window][:x]}|#{VOCAB[:window][:y]})+)|"+
		"((?:#{VOCAB[:window][:with]})+[\s]*(?:#{VOCAB[:window][:width]}|#{VOCAB[:window][:height]}))",
	:window_dispose=>"(((?:#{VOCAB[:window][:dispose]})+[\s]*(?:#{VOCAB[:window][:main]})+)+)|"+
		"((?:#{VOCAB[:window][:main]})+[\s\.\,]*(?:#{VOCAB[:window][:dispose]})+)",
	:window_x_equal=>"(?:#{VOCAB[:window][:x]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_y_equal=>"(?:#{VOCAB[:window][:y]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_w_equal=>"(?:#{VOCAB[:window][:width]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_h_equal=>"(?:#{VOCAB[:window][:height]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_s_equal=>"(?:#{VOCAB[:window][:speed]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_a_equal=>"(?:#{VOCAB[:window][:opacity]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_ba_equal=>"(?:(?:#{VOCAB[:window][:back]})+[\s_]*(?:#{VOCAB[:window][:opacity]}))+(?:#{VOCAB[:equal]}|[\s])+",
	:window_move=>"(?:(?:(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:move]}))|"+
		"(?:(?:#{VOCAB[:window][:move]})+[\s]*(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})))",
	:window_resize=>"(?:(?:(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:resize]}))|"+
		"(?:(?:#{VOCAB[:window][:resize]})+[\s]*(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})))",
	:window_set=>"(?:(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:set]})+)|"+
		"(?:(?:#{VOCAB[:window][:set]})+[\s]*(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+)",
	:window_active_equal=>"(?:#{VOCAB[:window][:active]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_skin_equal=>"(?:#{VOCAB[:window][:windowskin]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_openness_equal=>"(?:#{VOCAB[:window][:openness]})+(?:#{VOCAB[:equal]}|[\s]*)+",
	:window_activate=>"(?:(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:activate]})+)|"+
		"(?:(?:#{VOCAB[:window][:activate]})+[\s]*(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+)",
	:window_deactivate=>"(?:(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:deactivate]})+)|"+
		"(?:(?:#{VOCAB[:window][:deactivate]})+[\s]*(?:#{VOCAB[:last]})+[\s]*(?:#{VOCAB[:window][:main]})+)",
  }
  
  # 
  class <<self
	# Внутренний массив для вывода информации обо всех созданных окнах.<br>
	# Открыт только для чтения.
	# 
	attr_reader :windows
	
	# Внутренний массив для вывода информации обо всех созданных спрайтах.<br>
	# Открыт только для чтения.
	# 
	attr_reader :sprites
	
    # Требуется выполнить этот метод перед началом работы с CIGUI.<br>
	# Инициализирует массив $do, если он еще не был создан. В этот массив пользователь подает
	# команды для исполнения при следующем запуске метода #update.<br>
	# Если даже массив $do был инициализирован ранее,
	# то исполняет команду <i>cigui start</i> прежде всего.
	# <b>Пример:</b>
	#	begin
	#		CIGUI.setup
	#		#~~~ some code fragment ~~~
	#		CIGUI.update
	#		#~~~ some other code fragment ~~~
	#	end
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
			_restart? line
			_common? line
			_cigui? line
			_window? line
			#_
			update_internal_objects
			update_by_user(line)
		end
		$do.clear if clear_after_update
    end
	
	# Вызывает обновление всех объектов из внутренних массивов windows и sprite.
	#
	def update_internal_objects
		@windows.each{ |win|
			win.update if win.is_a? Win3
		}
		@sprites.each{ |spr|
			spr.update if spr.is_a? Spr3
		}
	end
	
	# Метод обработки текста, созданный для пользовательских модификаций, не влияющих на работу
	# встроенных обработчиков.<br>
	# Используйте <i>alias</i> этого метода для добавления обработки собственных команд.<br>
	# <b>Пример:</b>
	#	alias my_update update_by_user
	#	def update_by_user
	#		# add new word
	#		VOCAB[:window][:close]='close'
	#		# add 'window close' combination
	#		CMB[:window_close]="(?:(?:#{VOCAB[:window][:main]})+[\s]*(?:#{VOCAB[:window][:close]})+)"
	#		# call method
	#		window_close? line
	#	end
	#
	def update_by_user(string)
		
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
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{source_string}"
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
	  return source_string.match(/#{match}/i)[1].gsub!(/[\s_]*/){}.to_f if !std_conversion
	  source_string.match(/#{match}/i)[1].to_f
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{source_string}"
	end
	
	# Данный метод производит поиск подстроки, используемой в качестве параметра.<br>
	# Строка должна быть заключена в одинарные или двойные кавычки или же в круглые
	# или квадратные скобки.
	# 	substring('[Hello cruel world!]') # => Hello cruel world!
	#	substring("set window label='SomeSome' and no more else") # => SomeSome
	#
	def substring(source_string)
		match='(?:[\[\(\"\'])[\s]*([\w\s _\!\#\$\%\^\&\*]*)[\s]*(?:[\]|"\)\'])'
		return source_string.match(match)[1]
	rescue
		raise "#{CIGUIERR::CantReadString}\n\tcurrent line of $do: #{source_string}"
	end
	
	# Данный метод производит поиск булевого значения (true или false) в строке и возвращает его.
	# Если булевое значение в строке не обнаружено, по умолчанию возвращает false.
	def boolean(source_string)
		match="((?:#{VOCAB[:true]}|#{VOCAB[:false]}))"
		if source_string.match(match).size>1
			return false if source_string.match(/#{match}/i)[1]==nil
			match2="(#{VOCAB[:true]})"
			return true if source_string.match(/#{match2}/i)[1]
		end
		return false
	end
	
	# Возвращает массив из четырех значений для передачи в качестве параметра
	# в объекты класса Rect. Массив в строке должен быть помещен в квадратные скобки,
	# а значения в нем должны разделяться точкой с запятой.<br>
	# <b>Пример:</b>
	#	rect('[1;2,0;3.5;4.0_5]') # => [ 1, 2.0, 3.5, 4.05 ]
	#
	def rect(source_string)
		read=''
		start=false
		arr=[]
		for index in 0...source_string.size
			char=source_string[index]
			if char=='['
				start=true
				next
			end
			if start
				if char!=';'
					if char!=']'
						read+=char
					else
						arr<<read
				break
					end
				else
					arr<<read
					read=''
				end
			end
		end
		arr.size=4
		for index in 0...arr.size
			arr[index]=dec(arr[index]) if arr[index].is_a? String
			arr[index]=0 if arr[index].is_a? NilClass
		end
		return arr
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
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{source_string}"
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
	  return source_string.match(/#{match}/i)[1].gsub!(/[\s_]*/){}.to_f if !std_conversion
	  source_string.match(/#{match}/i)[1].to_f
	rescue
	  raise "#{CIGUIERR::CantReadNumber}\n\tcurrent line of $do: #{source_string}"
	end
	# Данный метод работает по аналогии с #substring, но производит поиск в строке
	# с учетом указанных префикса (текста перед подстрокой) и постфикса (после подстроки).<br>
	# Метод не требует обязательного указания символов квадратных и круглых скобок,
	# а также одинарных и двойных кавычек вокруг подстроки.<br>
	# prefix и postfix могут содержать символы, используемые в регулярных выражениях
	# для более точного поиска.
	#	puts 'Who can make me strong?'
	#	someone = substring("Make me invincible",'Make','invincible')
	#	puts 'Only'+someone # => 'Only me'
	# Метод работает вне зависимости от работы модуля - нет необходимости
	# запускать для вычисления #setup и #update.
	#
	def substr(source_string, prefix='', postfix='')
		match=prefix+'([\w\s _\!\#\$\%\^\&\*]*)'+postfix
		return source_string.match(match)[1]
	rescue
		raise "#{CIGUIERR::CantReadString}\n\tcurrent line of $do: #{source_string}"
	end
	
	# Возвращает сообщение о последнем произведенном действии
	# или классе последнего использованного объекта, используя метод
	# Kernel.inspect.
	#
	def last
		@last_action.is_a?(String) ? @last_action : @last_action.inspect
	end
    
    private
	
	# SETUP CIGUI / CLEAR FOR RESTART
	def _setup
	  @last_action = nil
	  @finished = false
	  @windows = []
	  @sprites = []
	  @selection = {
		:type => nil, # may be window or sprite
		:index => 0,   # index in internal array
		:label => nil # string in class to find index
	  }
	  @global_text.is_a?(NilClass) ? @global_text=Text.new('') : @global_text.empty
	end
	
	# RESTART
	def _restart?(string)
		matches=string.match(/#{CMB[:cigui_restart]}/)
		if matches
			__flush?('cigui flush') if not finished
			_setup
			@last_action = 'CIGUI restarted'
		else
			raise "#{CIGUIERR::CantInterpretCommand}\n\tcurrent line of $do: #{string}" if @finished
		end
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
			# Read index or label
			if string.match(/#{CMB[:select_by_index]}/)
				index = dec(string,CMB[:select_by_index])
				if index>-1
					@selection[:type]=:window
					@selection[:index]=index
					if index.between?(0...@windows.size)
						@selection[:label]=@windows[index].label if @windows[index]!=nil && @windows[index].is_a?(Win3)
					end
				end
			elsif string.match(/#{CMB[:select_by_label]}/)
				label = substr(string,CMB[:select_by_label])
				if label!=nil
					@selection[:type]=:window
					@selection[:label]=label
					for index in 0...@windows.size
						if @windows[index]!=nil && @windows[index].is_a?(Win3)
							if @windows[index].label==label
								@selection[:index]=index
								break
							end
						end
					end
				end
			end
			@last_action = @selection
		end
	end#--------------------end of '__swindow?'-------------------------
	
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
		__wresize? string
		__wset? string
		__wactivate? string
		__wdeactivate? string
		#__wlabel? string
	end
	
	# create window (default position and size) 
	# create window at x=DEC, y=DEC
	# create window with width=DEC,height=DEC
	# create window at x=DEC, y=DEC with w=DEC, h=DEC
	def __wcreate?(string)
		matches=string.match(/#{CMB[:window_create]}/i)
		# Only create
		if matches
			begin
				begin
					@windows<<Win3.new if RUBY_VERSION.to_f >= 1.9
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
			if string.match(/#{CMB[:window_create_atORwith]}/i)
				# at OR with: check x and y
				new_x = string[/#{CMB[:window_x_equal]}/i] ? dec(string,CMB[:window_x_equal]) : @windows.last.x
				new_y = string[/#{CMB[:window_y_equal]}/i] ? dec(string,CMB[:window_y_equal]) : @windows.last.y
				# at OR with: check w and h
				new_w = string[/#{CMB[:window_w_equal]}/i] ? dec(string,CMB[:window_w_equal]) : @windows.last.width
				new_h = string[/#{CMB[:window_h_equal]}/i] ? dec(string,CMB[:window_h_equal]) : @windows.last.height
				@windows.last.x = new_x
				@windows.last.y = new_y
				@windows.last.width = new_w
				@windows.last.height = new_h
				@last_action = @windows.last
				@selection[:type]=:window
				@selection[:index]=@windows.size-1
			end
		#rescue
			# dunnolol
		end
	end #--------------------end of '__wcreate?'-------------------------
	
	def __wdispose?(string)
		matches=string.match(/#{CMB[:window_dispose]}/i)
		# Only create
		if matches
			begin
				if string.match(/#{CMB[:select_by_index]}/i)
					index=dec(string,CMB[:select_by_index])
					if index.between?(0,@windows.size)
						# Проверка удаления для попавшихся объектов класса Nil
						# в результате ошибки создания окна
						@windows[index].dispose if @windows[index].methods.include? :dispose
						@windows.delete_at(index)
					else
						raise "#{CIGUIERR::WrongWindowIndex}"+
						"\n\tinternal windows size: #{@windows.size} (#{index} is not in range of 0..#{@windows.size})"+
						"\n\tcurrent line of $do: #{string}"
					end
				end
				@last_action = 'CIGUI disposed window'
			end
		end
	end#--------------------end of '__wdispose?'-------------------------
	
	# examples:
	# this move to x=DEC,y=DEC
	# this move to x=DEC,y=DEC with speed=1
	# this move to x=DEC,y=DEC with speed=auto
	def __wmove?(string)
		matches=string.match(/#{CMB[:window_move]}/i)
		# Only move
		if matches
			begin
				# Read params
				new_x = string[/#{CMB[:window_x_equal]}/i] ? dec(string,CMB[:window_x_equal]) : @windows[@selection[:index]].x
				new_y = string[/#{CMB[:window_y_equal]}/i] ? dec(string,CMB[:window_y_equal]) : @windows[@selection[:index]].y
				new_s = string[/#{CMB[:window_s_equal]}/i] ? dec(string,CMB[:window_s_equal]) : @windows[@selection[:index]].speed
				# CHANGED TO SELECTED
				if @selection[:type]==:window
					@windows[@selection[:index]].x = new_x
					@windows[@selection[:index]].y = new_y
					@windows[@selection[:index]].speed = new_s
					@last_action = @windows[@selection[:index]]
				end
			end
		end
	end#--------------------end of '__wmove?'-------------------------
	
	# example:
	# this resize to width=DEC,height=DEC
	def __wresize?(string)
		matches=string.match(/#{CMB[:window_resize]}/)
		# Only move
		if matches
			begin
				# Read params
				new_w = string[/#{CMB[:window_w_equal]}/i] ? dec(string,CMB[:window_w_equal]) : @windows[@selection[:index]].width
				new_h = string[/#{CMB[:window_h_equal]}/i] ? dec(string,CMB[:window_h_equal]) : @windows[@selection[:index]].height
				# CHANGED TO SELECTED
				if @selection[:type]==:window
					@windows[@selection[:index]].resize(new_w,new_h)
					@last_action = @windows[@selection[:index]]
				end
			end
		end
	end#--------------------end of '__wresize?'-------------------------
	
	# examples:
	# this window set x=DEC, y=DEC, z=DEC, width=DEC, height=DEC
	# this window set label=[STR]
	# this window set opacity=DEC
	# this window set back opacity=DEC
	# this window set active=BOOL
	# this window set skin=[STR]
	# this window set openness=DEC
	# this window set cursor rect=[RECT]
	# this window set tone=[RECT]
	def __wset?(string)
		matches=string.match(/#{CMB[:window_set]}/)
		# Only move
		if matches
			begin
				# Read params
				new_x = string[/#{CMB[:window_x_equal]}/i] ? dec(string,CMB[:window_x_equal]) : @windows[@selection[:index]].x
				new_y = string[/#{CMB[:window_y_equal]}/i] ? dec(string,CMB[:window_y_equal]) : @windows[@selection[:index]].y
				new_w = string[/#{CMB[:window_w_equal]}/i] ? dec(string,CMB[:window_w_equal]) : @windows[@selection[:index]].width
				new_h = string[/#{CMB[:window_h_equal]}/i] ? dec(string,CMB[:window_h_equal]) : @windows[@selection[:index]].height
				new_s = string[/#{CMB[:window_s_equal]}/i] ? dec(string,CMB[:window_s_equal]) : @windows[@selection[:index]].speed
				new_a = string[/#{CMB[:window_a_equal]}/i] ? dec(string,CMB[:window_a_equal]) : @windows[@selection[:index]].opacity
				new_ba = string[/#{CMB[:window_ba_equal]}/i] ? dec(string,CMB[:window_ba_equal]) : @windows[@selection[:index]].back_opacity
				new_act = string[/#{CMB[:window_active_equal]}/i] ? boolean(string,CMB[:window_active_equal]) : @windows[@selection[:index]].active
				new_skin = string[/#{CMB[:window_skin_equal]}/i] ? substr(string,CMB[:window_skin_equal]) : @windows[@selection[:index]].windowskin
				new_open = string[/#{CMB[:window_openness_equal]}/i] ? dec(string,CMB[:window_openness_equal]) : @windows[@selection[:index]].openness
				new_label = string[/#{CMB[:select_by_label]}/i] ? substr(string,CMB[:select_by_label]) : @windows[@selection[:index]].label
				# Change it
				if @selection[:type]==:window
					@windows[@selection[:index]].x = new_x
					@windows[@selection[:index]].y = new_y
					@windows[@selection[:index]].resize(new_w,new_h)
					@windows[@selection[:index]].speed = new_s
					@windows[@selection[:index]].opacity = new_a
					@windows[@selection[:index]].back_opacity = new_ba
					@windows[@selection[:index]].active = new_act
					@windows[@selection[:index]].windowskin = new_skin
					@windows[@selection[:index]].openness = new_open
					@windows[@selection[:index]].label = new_label
					@selection[:label] = new_label
					@last_action = @windows[@selection[:index]]
				end
			end
		end
	end#--------------------end of '__wset?'-------------------------
	
	def __wactivate?(string)
		matches=string.match(/#{CMB[:window_activate]}/)
		if matches
			if @selection[:type]==:window
				@windows[@selection[:index]].active=true
				@last_action = @windows[@selection[:index]]
			end
		end
	end#--------------------end of '__wactivate?'-------------------------
	
	def __wdeactivate?(string)
		matches=string.match(/#{CMB[:window_deactivate]}/)
		if matches
			if @selection[:type]==:window
				@windows[@selection[:index]].active=false
				@last_action = @windows[@selection[:index]]
			end
		end
	end#--------------------end of '__wdeactivate?'-------------------------
  end# END OF CIGUI CLASS
end# END OF CIGUI MODULE

# test zone
# delete this when copy to 'Script editor' in RPG Maker
begin
	$do=[
		'CreAte WinDow At X=2_4, Y=3_2',
		'this window set label=something'
	]
	CIGUI.setup
	CIGUI.update
	puts CIGUI.last
end