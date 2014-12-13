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
		# Смотри файл <b>localize.rb</b><br>
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
			#--WINDOW branch
			
		end
		
		# Смотри файл <b>localize.rb</b><br>
		# Вносит вызов метода localize_ru в инициализацию модуля
		alias original_setup setup
		def setup
			localize_ru
			original_setup
		end
	end# END OF CLASS
end# END OF MODULE