# Адд-он русификации для CIGUI
# Требует обязательной установки оригинального скрипта.
# Дополняет текущий словарь VOCAB словами на русском языке:
# можно использовать как русские, так и английские версии слов.<br>
# <b>Данные команды работают аналогично, например:</b>
#	create window
#	создать окно

#
module CIGUI
	class << self
		#:nodoc:
		# Метод, который добавляет русский перевод команд
		# Cigui, дополняя текущий массив VOCAB
		def localize_ru
			@original_VOCAB||=VOCAB
			#--COMMON unbranch
			VOCAB[:please]   = @original_VOCAB[:please]+'|п[оа]жал[у]?[й]?ста'
			VOCAB[:last]     = @original_VOCAB[:last]  +'|последн(?:ее|юю|яя)|это'
			VOCAB[:select]   = @original_VOCAB[:select]+'|выбор'
			VOCAB[:true]     = @original_VOCAB[:true]  +'|истин[н]*[аоея]|вкл(?:юч(?:ен[ноаыяе]*|ит[ь]?)?)'
			VOCAB[:false]    = @original_VOCAB[:false] +'|ло(?:ж|ш)[ъь]*||выкл(?:юч(?:ен[ноаыяе]*|ит[ь]?)?)'
			VOCAB[:equal]    = @original_VOCAB[:equal] +''
			#--CIGUI branch
			VOCAB[:cigui][:main]    = @original_VOCAB[:cigui][:main] +'|сигуи'
			VOCAB[:cigui][:start]   = @original_VOCAB[:cigui][:start]+'|запус(?:ти(?:т[ь]?)?|к)'
			VOCAB[:cigui][:finish]  = @original_VOCAB[:cigui][:equal]+'|заверш(?:и(?:т[ь]?)?|ен[иемя]*)?'
			VOCAB[:cigui][:flush]   = @original_VOCAB[:cigui][:equal]+'|очист(?:к[аойеу]|[ить])'
			VOCAB[:cigui][:restart] = @original_VOCAB[:cigui][:equal]+'|перезапус(?:ти(?:ть)?|к)|ре[\s_-]*старт|ре[\s_-]*сет'
			#--EVENT branch
			# nothing change at this moment
			#--MAP branch
			# nothing change at this moment
			#--PICTURE branch
			# nothing change at this moment
			#--SPRITE branch
			# nothing change at this moment
			#--TEXT branch
			# nothing change at this moment
			#--WINDOW branch
			VOCAB[:window][:main]      = @original_VOCAB[:window][:main]    +'|ок[оа]?н[оуами]'
			VOCAB[:window][:create]    = @original_VOCAB[:window][:create]  +'|созда(?:[йть]|ва[йть])?'
			VOCAB[:window][:at]        = @original_VOCAB[:window][:at]      +'|(?:в)|(?:к)|[\s]*'
			VOCAB[:window][:with]      = @original_VOCAB[:window][:with]    +'|(?:c[о]?)|[\s]*'
			VOCAB[:window][:dispose]   = @original_VOCAB[:window][:dispose] +'|удал[яий](?:ть)?|уничтож[итьай]?'
			VOCAB[:window][:move]      = @original_VOCAB[:window][:move]    +'|(?:пере)?дви(?:н[ь]?|нут[ьоаы]?)|(?:пере|по)мести[ть]?'
			VOCAB[:window][:to]        = @original_VOCAB[:window][:to]      +'|(?:в)|(?:к)|[\s]*'
			VOCAB[:window][:speed]     = @original_VOCAB[:window][:speed]   +'|скорость[ю]?'
			VOCAB[:window][:auto]      = @original_VOCAB[:window][:auto]    +'|авто(?:мат(?:ом|ическ[иойая]))'
			VOCAB[:window][:resize]    = @original_VOCAB[:window][:resize]  +''# не знаю, как сказать "изменить размер" в одно слово Т_Т (увеличить/уменьшить не универсальны)
			VOCAB[:window][:set]       = @original_VOCAB[:window][:set]     +'|установ(?:и(?:ть)|ка)'
			VOCAB[:window][:x]         = @original_VOCAB[:window][:x]       +'|х|икс|аб[с]*ци[с]*а'
			VOCAB[:window][:y]         = @original_VOCAB[:window][:y]       +'|у|игр[еэ]к|орд[ие]ната'
			VOCAB[:window][:z]         = @original_VOCAB[:window][:z]       +'|зе[тд]|глубина'
			VOCAB[:window][:ox]        = @original_VOCAB[:window][:ox]      +''
			VOCAB[:window][:oy]        = @original_VOCAB[:window][:oy]      +''
			VOCAB[:window][:tone]      = @original_VOCAB[:window][:tone]    +'|тон'
			VOCAB[:window][:width]     = @original_VOCAB[:window][:width]   +'|шир[ие]н[аойеуы]'
			VOCAB[:window][:height]    = @original_VOCAB[:window][:height]  +'|выс[оа]т[аойеуы]'
		end
		
		#:nodoc:
		# Вносит вызов метода localize_ru в инициализацию модуля
		alias original_setup setup
		def setup
			localize_ru
			original_setup
		end
	end# END OF CLASS
end# END OF MODULE