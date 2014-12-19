var search_data = {"index":{"searchIndex":["cigui","ciguierr","cannotcreatewindow","cantinterpretcommand","cantreadnumber","cantreadstring","cantstart","wrongwindowindex","color","rect","spr3","text","tone","win3","add_item()","add_text()","alpha()","blue()","blue()","boolean()","dec()","decimal()","default_colorset()","dispose()","dispose()","draw_items()","empty()","empty()","enable_item()","frac()","fraction()","gray()","green()","green()","inspect()","label=()","last()","new()","new()","new()","new()","new()","new()","rect()","red()","red()","refresh()","refresh()","resize()","set()","set()","set()","setup()","substr()","substring()","update()","update()","update()","update_by_user()","update_internal_objects()"],"longSearchIndex":["cigui","ciguierr","ciguierr::cannotcreatewindow","ciguierr::cantinterpretcommand","ciguierr::cantreadnumber","ciguierr::cantreadstring","ciguierr::cantstart","ciguierr::wrongwindowindex","color","rect","spr3","text","tone","win3","win3#add_item()","win3#add_text()","color#alpha()","color#blue()","tone#blue()","cigui#boolean()","cigui#dec()","cigui#decimal()","text#default_colorset()","spr3#dispose()","win3#dispose()","win3#draw_items()","rect#empty()","text#empty()","win3#enable_item()","cigui#frac()","cigui#fraction()","tone#gray()","color#green()","tone#green()","win3#inspect()","win3#label=()","cigui#last()","color::new()","rect::new()","spr3::new()","text::new()","tone::new()","win3::new()","cigui#rect()","color#red()","tone#red()","spr3#refresh()","win3#refresh()","win3#resize()","color#set()","rect#set()","tone#set()","cigui#setup()","cigui#substr()","cigui#substring()","cigui#update()","spr3#update()","win3#update()","cigui#update_by_user()","cigui#update_internal_objects()"],"info":[["CIGUI","","CIGUI.html","","<p>Основной модуль, обеспечивающий работу Cigui.<br> Для передачи команд\nиспользуйте массив $do, например:\n<p>$do&lt;&lt;“команда” …\n"],["CIGUIERR","","CIGUIERR.html","","<p>Модуль, содержащий данные обо всех возможных ошибках, которые может выдать\nCIGUI при некорректной работе. …\n"],["CIGUIERR::CannotCreateWindow","","CIGUIERR/CannotCreateWindow.html","","<p>Ошибка создания окна.\n"],["CIGUIERR::CantInterpretCommand","","CIGUIERR/CantInterpretCommand.html","","<p>Ошибка, которая появляется при попытке работать с Cigui после вызова\nкоманды <em>cigui finish</em>.\n"],["CIGUIERR::CantReadNumber","","CIGUIERR/CantReadNumber.html","","<p>Ошибка, которая появляется, если в строке не было обнаружено числовое\nзначение.<br> Правила оформления строки …\n"],["CIGUIERR::CantReadString","","CIGUIERR/CantReadString.html","","<p>Ошибка, которая появляется, если в строке не было обнаружено строчное\nзначение.<br> Правила оформления строки …\n"],["CIGUIERR::CantStart","","CIGUIERR/CantStart.html","","<p>Ошибка, которая появляется при неудачной попытке запуска интерпретатора\nCigui\n"],["CIGUIERR::WrongWindowIndex","","CIGUIERR/WrongWindowIndex.html","","<p>Ошибка, которая появляется при попытке обращения к несуществующему индексу\nв массиве <em>windows</em><br> Вызывается …\n"],["Color","","Color.html","","<p>Класс, хранящий данные о цвете в формате RGBA (красный, зеленый, синий и\nпрозрачность). Каждое значение …\n"],["Rect","","Rect.html","","<p>Хранит значения о положении и размере прямоугольника\n"],["Spr3","","Spr3.html","","<p>Класс спрайта со всеми параметрами, доступными в RGSS3. Пока пустой,\nожидается обновление во время работы …\n"],["Text","","Text.html","","<p>Класс, хранящий данные о тексте в окне. Создается для каждого окна\nотдельно, имеет индивидуальные настройки. …\n"],["Tone","","Tone.html","","<p>Класс, хранящий данные о тонировании в ввиде четырех значений: красный,\nзеленый, синий и насыщенность. …\n"],["Win3","","Win3.html","","<p>Класс окна с реализацией всех возможностей, доступных при помощи Cigui.<br>\nРеализация выполнена для RGSS3 …\n"],["add_item","Win3","Win3.html#method-i-add_item","(command,procname,enabled=true)","<p>Этот метод добавляет команду во внутренний массив <em>items</em>. Команды\nиспользуются для отображения кнопок. …\n"],["add_text","Win3","Win3.html#method-i-add_text","(text)","<p>Этот метод позволяет добавить текст в окно.<br> Принимает в качестве\nпараметра значение класса Text\n"],["alpha","Color","Color.html#method-i-alpha","()","<p>Возвращает значение прозрачности\n"],["blue","Color","Color.html#method-i-blue","()","<p>Возвращает значение синего цвета\n"],["blue","Tone","Tone.html#method-i-blue","()","<p>Возвращает значение синего цвета\n"],["boolean","CIGUI","CIGUI.html#method-i-boolean","(source_string)","<p>Данный метод производит поиск булевого значения (true или false) в строке и\nвозвращает его. Если булевое …\n"],["dec","CIGUI","CIGUI.html#method-i-dec","(source_string, prefix='', postfix='', std_conversion=true)","<p>Данный метод работает по аналогии с #decimal, но производит поиск в строке\nс учетом указанных префикса …\n"],["decimal","CIGUI","CIGUI.html#method-i-decimal","(source_string, std_conversion=true)","<p>Данный метод возвращает первое попавшееся целое число, найденное в строке\nsource_string.<br> Производит …\n"],["default_colorset","Text","Text.html#method-i-default_colorset","()","<p>Восстанавливает первоначальные значения цвета. По возможности, эти данные\nзагружаются из файла\n"],["dispose","Spr3","Spr3.html#method-i-dispose","()","<p>Удаляет спрайт\n"],["dispose","Win3","Win3.html#method-i-dispose","()","<p>Удаляет окно и все связанные с ним ресурсы\n"],["draw_items","Win3","Win3.html#method-i-draw_items","(ignore_disabled=false)","<p>С помощью этого метода производится полная отрисовка всех элементов из\nмассива <em>items</em>.<br> Параметр ignore_disabled …\n"],["empty","Rect","Rect.html#method-i-empty","()","<p>Устанавливает все параметры прямоугольника равными нулю.\n"],["empty","Text","Text.html#method-i-empty","()","<p>Сбрасывает все данные, кроме colorset, на значения по умолчанию\n"],["enable_item","Win3","Win3.html#method-i-enable_item","(commandORindex)","<p>Включает кнопку.<br> В параметр commandORindex помещается либо строковое\nзначение, являющееся названием кнопки, …\n"],["frac","CIGUI","CIGUI.html#method-i-frac","(source_string, prefix='', postfix='', std_conversion=true)","<p>Данный метод работает по аналогии с #fraction, но производит поиск в строке\nс учетом указанных префикса …\n"],["fraction","CIGUI","CIGUI.html#method-i-fraction","(source_string, std_conversion=true)","<p>Данный метод работает по аналогии с #decimal, но возвращает рациональное\nчисло (число с плавающей запятой …\n"],["gray","Tone","Tone.html#method-i-gray","()","<p>Возвращает значение насыщенности\n"],["green","Color","Color.html#method-i-green","()","<p>Возвращает значение зеленого цвета\n"],["green","Tone","Tone.html#method-i-green","()","<p>Возвращает значение зеленого цвета\n"],["inspect","Win3","Win3.html#method-i-inspect","()","<p>Возврашает полную информацию обо всех параметрах в формате строки\n"],["label=","Win3","Win3.html#method-i-label-3D","(string)","<p>Задает метку окну, проверяя ее на правильность перед этим:\n<p>удаляет круглые и квадратгые скобки\n<p>удаляет …\n"],["last","CIGUI","CIGUI.html#method-i-last","()","<p>Возвращает сообщение о последнем произведенном действии или классе\nпоследнего использованного объекта, …\n"],["new","Color","Color.html#method-c-new","(r,g,b,a=255.0)","<p>Создает экземпляр класса.\n<p>r, g, b - задает изначальные значения красного, зеленого и синего цветов\n<p>a - …\n"],["new","Rect","Rect.html#method-c-new","(x,y,width,height)","<p>Создание прямоугольника\n<p>x, y - назначает положение прямоуголника в пространстве\n<p>width, height - устанавливает …\n"],["new","Spr3","Spr3.html#method-c-new","()","<p>Создает новый спрайт\n"],["new","Text","Text.html#method-c-new","(string, font_family=['Tahoma'], font_size=20, bold=false, italic=false, underline=false)","<p>Создает экземпляр класса.<br> <strong>Параметры:</strong>\n<p>string - строка текста\n<p>font_family - массив названий (гарнитур) шрифта, …\n"],["new","Tone","Tone.html#method-c-new","(r,g,b,gs=0.0)","<p>Создает экземпляр класса.\n<p>r, g, b - задает изначальные значения красного, зеленого и синего цветов\n<p>gs - …\n"],["new","Win3","Win3.html#method-c-new","(x=0,y=0,w=192,h=64)","<p>Создает окно. По умолчанию задается размер 192х64 и помещается в координаты\n0, 0\n"],["rect","CIGUI","CIGUI.html#method-i-rect","(source_string)","<p>Возвращает массив из четырех значений для передачи в качестве параметра в\nобъекты класса Rect. Массив …\n"],["red","Color","Color.html#method-i-red","()","<p>Возвращает значение красного цвета\n"],["red","Tone","Tone.html#method-i-red","()","<p>Возвращает значение красного цвета\n"],["refresh","Spr3","Spr3.html#method-i-refresh","()","<p>Производит повторную отрисовку содержимого спрайта\n"],["refresh","Win3","Win3.html#method-i-refresh","()","<p>Обновляет окно. В отличие от #update, влияет только на содержимое окна\n(производит повторную отрисовку). …\n"],["resize","Win3","Win3.html#method-i-resize","(new_width, new_height)","<p>Устанавливает новые размеры окна дополнительно изменяя также и размеры\nсодержимого (contents).<br> Все части …\n"],["set","Color","Color.html#method-i-set","(*args)","<p>Задает новые значения цвета и прозрачности.<br> <strong>Варианты\nпараметров:</strong>\n<p>set(Color) - в качестве параметра задан …\n\n"],["set","Rect","Rect.html#method-i-set","(*args)","<p>Задает все параметры единовременно Может принимать значения:\n<p>Rect - другой экземпляр класса Rect, все …\n"],["set","Tone","Tone.html#method-i-set","(*args)","<p>Задает новые значения цвета и насыщенности.<br> <strong>Варианты\nпараметров:</strong>\n<p>set(Tone) - в качестве параметра задан …\n\n"],["setup","CIGUI","CIGUI.html#method-i-setup","()","<p>Требуется выполнить этот метод перед началом работы с CIGUI.<br>\nИнициализирует массив $do, если он еще не …\n"],["substr","CIGUI","CIGUI.html#method-i-substr","(source_string, prefix='', postfix='')","<p>Данный метод работает по аналогии с #substring, но производит поиск в\nстроке с учетом указанных префикса …\n"],["substring","CIGUI","CIGUI.html#method-i-substring","(source_string)","<p>Данный метод производит поиск подстроки, используемой в качестве\nпараметра.<br> Строка должна быть заключена …\n"],["update","CIGUI","CIGUI.html#method-i-update","(clear_after_update=true)","<p>Вызывает все методы обработки команд, содержащиеся в массиве $do.<br>\nВызовет исключение CIGUIERR::CantInterpretCommand …\n"],["update","Spr3","Spr3.html#method-i-update","()","<p>Производит обновление спрайта\n"],["update","Win3","Win3.html#method-i-update","()","<p>Обновляет окно. Влияет только на положение курсора (параметр cursor_rect),\nпрозрачность и цветовой тон …\n"],["update_by_user","CIGUI","CIGUI.html#method-i-update_by_user","(string)","<p>Метод обработки текста, созданный для пользовательских модификаций, не\nвлияющих на работу встроенных …\n"],["update_internal_objects","CIGUI","CIGUI.html#method-i-update_internal_objects","()","<p>Вызывает обновление всех объектов из внутренних массивов ::windows и\n::sprites.<br> Вызывается автоматически …\n"]]}}