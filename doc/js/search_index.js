var search_data = {"index":{"searchIndex":["cigui","ciguierr","cannotcreatewindow","cantinterpretcommand","cantreadnumber","cantreadstring","cantstart","wrongwindowindex","rect","spr3","win3","add_item()","boolean()","close()","dec()","decimal()","dispose()","dispose()","draw_items()","empty()","enable_item()","frac()","fraction()","inspect()","last()","localize_ru()","new()","new()","new()","open()","rect()","refresh()","refresh()","resize()","set()","setup()","substr()","substring()","update()","update()","update()","update_by_user()","update_internal_objects()"],"longSearchIndex":["cigui","ciguierr","ciguierr::cannotcreatewindow","ciguierr::cantinterpretcommand","ciguierr::cantreadnumber","ciguierr::cantreadstring","ciguierr::cantstart","ciguierr::wrongwindowindex","rect","spr3","win3","win3#add_item()","cigui#boolean()","win3#close()","cigui#dec()","cigui#decimal()","spr3#dispose()","win3#dispose()","win3#draw_items()","rect#empty()","win3#enable_item()","cigui#frac()","cigui#fraction()","win3#inspect()","cigui#last()","cigui#localize_ru()","rect::new()","spr3::new()","win3::new()","win3#open()","cigui#rect()","spr3#refresh()","win3#refresh()","win3#resize()","rect#set()","cigui#setup()","cigui#substr()","cigui#substring()","cigui#update()","spr3#update()","win3#update()","cigui#update_by_user()","cigui#update_internal_objects()"],"info":[["CIGUI","","CIGUI.html","","<p>Основной модуль, обеспечивающий работу Cigui.<br> Для передачи команд\nиспользуйте массив $do, например:\n<p>$do&lt;&lt;“команда” …\n"],["CIGUIERR","","CIGUIERR.html","","<p>Модуль, содержащий данные обо всех возможных ошибках, которые может выдать\nCIGUI при некорректной работе. …\n"],["CIGUIERR::CannotCreateWindow","","CIGUIERR/CannotCreateWindow.html","","<p>Ошибка создания окна.\n"],["CIGUIERR::CantInterpretCommand","","CIGUIERR/CantInterpretCommand.html","","<p>Ошибка, которая появляется при попытке работать с Cigui после вызова\nкоманды <em>cigui finish</em>.\n"],["CIGUIERR::CantReadNumber","","CIGUIERR/CantReadNumber.html","","<p>Ошибка, которая появляется, если в строке не было обнаружено числовое\nзначение.<br> Правила оформления строки …\n"],["CIGUIERR::CantReadString","","CIGUIERR/CantReadString.html","","<p>Ошибка, которая появляется, если в строке не было обнаружено строчное\nзначение.<br> Правила оформления строки …\n"],["CIGUIERR::CantStart","","CIGUIERR/CantStart.html","","<p>Ошибка, которая появляется при неудачной попытке запуска интерпретатора\nCigui\n"],["CIGUIERR::WrongWindowIndex","","CIGUIERR/WrongWindowIndex.html","","<p>Ошибка, которая появляется при попытке обращения к несуществующему индексу\nв массиве <em>windows</em><br> Вызывается …\n"],["Rect","","Rect.html","","<p>Хранит значения о положении и размере прямоугольника\n"],["Spr3","","Spr3.html","","<p>Класс спрайта со всеми параметрами, доступными в RGSS3. Пока пустой,\nожидается обновление во время работы …\n"],["Win3","","Win3.html","","<p>Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>\nРеализация выполнена для RGSS3 …\n"],["add_item","Win3","Win3.html#method-i-add_item","(command,procname,enabled=true)","<p>Этот метод добавляет команду во внутренний массив <em>items</em>. Команды\nиспользуются для отображения кнопок. …\n"],["boolean","CIGUI","CIGUI.html#method-i-boolean","(source_string)","<p>Данный метод производит поиск булевого значения (true или false) в строке и\nвозвращает его. Если булевое …\n"],["close","Win3","Win3.html#method-i-close","()","<p>Close window\n"],["dec","CIGUI","CIGUI.html#method-i-dec","(source_string, prefix='', postfix='', std_conversion=true)","<p>Данный метод работает по аналогии с #decimal, но производит поиск в строке\nс учетом указанных префикса …\n"],["decimal","CIGUI","CIGUI.html#method-i-decimal","(source_string, std_conversion=true)","<p>Данный метод возвращает первое попавшееся целое число, найденное в строке\nsource_string.<br> Производит …\n"],["dispose","Spr3","Spr3.html#method-i-dispose","()","<p>Удаляет спрайт\n"],["dispose","Win3","Win3.html#method-i-dispose","()","<p>Удаляет окно и все связанные с ним ресурсы\n"],["draw_items","Win3","Win3.html#method-i-draw_items","(ignore_disabled=false)","<p>С помощью этого метода производится полная отрисовка всех элементов из\nмассива <em>items</em>.<br> Параметр ignore_disabled …\n"],["empty","Rect","Rect.html#method-i-empty","()","<p>Устанавливает все параметры прямоугольника равными нулю.\n"],["enable_item","Win3","Win3.html#method-i-enable_item","(commandORindex)","<p>Включает кнопку.<br> В параметр commandORindex помещается либо строковое\nзначение, являющееся названием кнопки, …\n"],["frac","CIGUI","CIGUI.html#method-i-frac","(source_string, prefix='', postfix='', std_conversion=true)","<p>Данный метод работает по аналогии с #fraction, но производит поиск в строке\nс учетом указанных префикса …\n"],["fraction","CIGUI","CIGUI.html#method-i-fraction","(source_string, std_conversion=true)","<p>Данный метод работает по аналогии с #decimal, но возвращает рациональное\nчисло (число с плавающей запятой …\n"],["inspect","Win3","Win3.html#method-i-inspect","()","<p>Возврашает полную информацию обо всех параметрах в формате строки\n"],["last","CIGUI","CIGUI.html#method-i-last","()","<p>Возвращает сообщение о последнем произведенном действии или классе\nпоследнего использованного объекта, …\n"],["localize_ru","CIGUI","CIGUI.html#method-i-localize_ru","()","<p>Смотри файл <strong>localize.rb</strong><br> Метод, который добавляет\nрусский перевод команд Cigui, дополняя текущий массив …\n"],["new","Rect","Rect.html#method-c-new","(x,y,width,height)","<p>Создание прямоугольника\n<p>x, y - назначает положение прямоуголника в пространстве\n<p>width, height - устанавливает …\n"],["new","Spr3","Spr3.html#method-c-new","()","<p>Создает новый спрайт\n"],["new","Win3","Win3.html#method-c-new","(x=0,y=0,w=192,h=64)","<p>Создает окно. По умолчанию задается размер 192х64 и помещается в координаты\n0, 0\n"],["open","Win3","Win3.html#method-i-open","()","<p>Open window\n"],["rect","CIGUI","CIGUI.html#method-i-rect","(source_string)","<p>Возвращает массив из четырех значений для передачи в качестве параметра в\nобъекты класса Rect. Массив …\n"],["refresh","Spr3","Spr3.html#method-i-refresh","()","<p>Производит повторную отрисовку содержимого спрайта\n"],["refresh","Win3","Win3.html#method-i-refresh","()","<p>Обновляет окно. В отличие от #update, влияет только на содержимое окна\n(производит повторную отрисовку). …\n"],["resize","Win3","Win3.html#method-i-resize","(new_width, new_height)","<p>Устанавливает новые размеры окна дополнительно изменяя также и размеры\nсодержимого (contents).<br> Все части …\n"],["set","Rect","Rect.html#method-i-set","(*args)","<p>Задает все параметры единовременно Может принимать значения:\n<p>Rect - другой экземпляр класса Rect, все …\n"],["setup","CIGUI","CIGUI.html#method-i-setup","()","<p>Требуется выполнить этот метод перед началом работы с CIGUI.<br>\nИнициализирует массив $do, если он еще не …\n"],["substr","CIGUI","CIGUI.html#method-i-substr","(source_string, prefix='', postfix='')","<p>Данный метод работает по аналогии с #substring, но производит поиск в\nстроке с учетом указанных префикса …\n"],["substring","CIGUI","CIGUI.html#method-i-substring","(source_string)","<p>Данный метод производит поиск подстроки, используемой в качестве\nпараметра.<br> Строка должна быть заключена …\n"],["update","CIGUI","CIGUI.html#method-i-update","(clear_after_update=true)","<p>Вызывает все методы обработки команд, содержащиеся в массиве $do.<br>\nВызовет исключение CIGUIERR::CantInterpretCommand …\n"],["update","Spr3","Spr3.html#method-i-update","()","<p>Производит обновление спрайта\n"],["update","Win3","Win3.html#method-i-update","()","<p>Обновляет окно. Влияет только на положение курсора (параметр cursor_rect),\nпрозрачность и цветовой тон …\n"],["update_by_user","CIGUI","CIGUI.html#method-i-update_by_user","(string)","<p>Метод обработки текста, созданный для пользовательских модификаций, не\nвлияющих на работу встроенных …\n"],["update_internal_objects","CIGUI","CIGUI.html#method-i-update_internal_objects","()","<p>Вызывает обновление всех объектов из внутренних массивов windows и sprite.\n"]]}}