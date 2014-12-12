module CIGUI
	# Смотри файл localize.rb<br>
	# Метод, который добавляет русский перевод команд
	# Cigui, дополняя текущий массив VOCAB
	def localize_ru
		original_VOCAB||=VOCAB
		puts original_VOCAB
	end
	
	# Смотри файл localize.rb<br>
	# Вносит вызов метода localize_ru в инициализацию модуля
	alias original_setup setup
	def setup
		localize_ru
		original_setup
		puts 'some'
	end
end