
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Попытка
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);	
		КонецЕсли;		
		
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий", ПериодАвтообновленияСпискаФоновыхЗаданий);	
		КонецЕсли;		
		
		ОбновитьСписокРегламентныхЗаданий();
		ОбновитьСписокФоновыхЗаданий();
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокРегламентныхЗаданий()
	Перем ТекущийИдентификатор;
	
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;
	
	СписокРегламентныхЗаданий.Очистить();
	
	Отбор = Неопределено;
	Если ОтборРегламентныхЗаданийВключен = Истина Тогда
		Отбор = ОтборРегламентныхЗаданий;
	КонецЕсли;
	
	Попытка
		Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Исключение
		//Элементы.СписокРегламентныхЗаданий.Доступность = Ложь;
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокРегламентныхЗаданий.Доступность = Истина;
	
	Для Каждого Регламентное из Регламентные Цикл
		НоваяСтрока = СписокРегламентныхЗаданий.Добавить();
		НоваяСтрока.Метаданные = Регламентное.Метаданные.Представление();
		НоваяСтрока.Наименование = Регламентное.Наименование;
		НоваяСтрока.Ключ = Регламентное.Ключ;
		НоваяСтрока.Расписание = Регламентное.Расписание;
		НоваяСтрока.Пользователь = Регламентное.ИмяПользователя;
		НоваяСтрока.Предопределенное = Регламентное.Предопределенное;
		НоваяСтрока.Использование = Регламентное.Использование;
		НоваяСтрока.Идентификатор = Регламентное.УникальныйИдентификатор;
		
		Попытка
			ПоследнееЗадание = Регламентное.ПоследнееЗадание;
		Исключение
			ПоследнееЗадание = Неопределено;
		КонецПопытки;
		
		Если ПоследнееЗадание <> Неопределено Тогда
			НоваяСтрока.Выполнялось = ПоследнееЗадание.Начало;
			НоваяСтрока.Состояние = ПоследнееЗадание.Состояние;
		КонецЕсли;
	КонецЦикла;
	
	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
	
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФоновыхЗаданий()
	Перем ТекущийИдентификатор;
	
	ТекущаяСтрока = Элементы.СписокФоновыхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;
	
	Идентификаторы = Новый Массив;
	
	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока из ВыделенныеСтроки Цикл
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;

	СписокФоновыхЗаданий.Очистить();
	
	Отбор = Неопределено;
	Если ОтборФоновыхЗаданийВключен = Истина Тогда
		Отбор = ОтборФоновыхЗаданий;
	КонецЕсли;
	
	Попытка
		Фоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Исключение
		//Элементы.СписокФоновыхЗаданий.Доступность = Ложь;
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокФоновыхЗаданий.Доступность = Истина;
	
	Для Каждого Фоновое из Фоновые Цикл
		НоваяСтрока = СписокФоновыхЗаданий.Добавить();
		
		РегламентноеЗадание = Фоновое.РегламентноеЗадание;
		Если РегламентноеЗадание <> Неопределено Тогда
			Строка = РегламентноеЗадание.Метаданные.Представление();
			Если РегламентноеЗадание.Наименование <> "" Тогда
				Строка = Строка + ":" +	РегламентноеЗадание.Наименование;
			КонецЕсли;
			
			НоваяСтрока.Регламентное = Строка;
		КонецЕсли;
			
		НоваяСтрока.Наименование = Фоновое.Наименование;
		НоваяСтрока.Ключ = Фоновое.Ключ;
		НоваяСтрока.Метод = Фоновое.ИмяМетода;
		НоваяСтрока.Состояние = Фоновое.Состояние;
		НоваяСтрока.Начало = Фоновое.Начало;
		НоваяСтрока.Конец = Фоновое.Конец;
		НоваяСтрока.Сервер = Фоновое.Расположение;
		
		Если Фоновое.ИнформацияОбОшибке <> Неопределено Тогда
			НоваяСтрока.Ошибки = Фоновое.ИнформацияОбОшибке.Описание;
		КонецЕсли;
		
		НоваяСтрока.Идентификатор = Фоновое.УникальныйИдентификатор;
		НоваяСтрока.СостояниеЗадания = Фоновое.Состояние;
	КонецЦикла;
	
	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокФоновыхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;
	
	Для Каждого Идентификатор из Идентификаторы Цикл
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРегламентныеЗадания(Команда)
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура Расписание(Команда)
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
		Расписание = ПолучитьРасписаниеРегламентногоЗадания(Строка.Идентификатор);
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
		
		Если Диалог.ОткрытьМодально() Тогда
			Расписание = Диалог.Расписание;
			УстановитьРасписаниеРегламентногоЗадания(Строка.Идентификатор, Строка.Наименование, Расписание, Строка.Метаданные);
			Строка.Расписание = Расписание;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");
	
	Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогРегламентногоЗадания", СтруктураПараметров);
	Если Диалог.ОткрытьМодально() <> Неопределено Тогда
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда
		
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
		
		СтруктураПараметров = Новый Структура;
		Ид = Строка.Идентификатор;
		СтруктураПараметров.Вставить("ИдентификаторЗадания", Ид);
		
		Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогРегламентногоЗадания", СтруктураПараметров);
		Если Диалог.ОткрытьМодально() <> Неопределено Тогда
			ОбновитьСписокРегламентныхЗаданий();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередУдалением(Элемент, Отказ)
	Попытка
		Отказ = Истина;
		УдалитьРегламентноеЗадание();
		
		ОбновитьСписокРегламентныхЗаданий();
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура УдалитьРегламентноеЗадание()
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);
		
		ДанныйОбъект = РеквизитФормыВЗначение("ОбработкаОбъект");
		РегламентноеЗадание = ДанныйОбъект.ПолучитьОбъектРегламентногоЗадания(Строка.Идентификатор);
		Если РегламентноеЗадание.Предопределенное Тогда
			ВызватьИсключение("Нельзя удалить предопределенное задание: " + РегламентноеЗадание.Наименование);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);
		ДанныйОбъект = РеквизитФормыВЗначение("ОбработкаОбъект");
		РегламентноеЗадание = ДанныйОбъект.ПолучитьОбъектРегламентногоЗадания(Строка.Идентификатор);
		РегламентноеЗадание.Удалить();
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФоновыеЗадания(Команда)
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");
	
	Попытка
		Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогФоновогоЗадания", СтруктураПараметров);
		Если Диалог.ОткрытьМодально() <> Неопределено Тогда
		    ОбновитьСписокФоновыхЗаданий();			
		КонецЕсли;
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Функция ПолучитьРасписаниеРегламентногоЗадания(УникальныйНомерЗадания)
	ДанныйОбъект = РеквизитФормыВЗначение("ОбработкаОбъект");
	ОбъектЗадания = ДанныйОбъект.ПолучитьОбъектРегламентногоЗадания(УникальныйНомерЗадания);
	Если ОбъектЗадания = Неопределено Тогда
		Возврат Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Возврат ОбъектЗадания.Расписание;
КонецФункции

&НаСервере
Функция УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Наименование, Расписание, ИмяЗадания)
	
	ДанныйОбъект = РеквизитФормыВЗначение("ОбработкаОбъект");
	ОбъектЗадания = ДанныйОбъект.ПолучитьОбъектРегламентногоЗадания(Идентификатор);		
	Если ОбъектЗадания = Неопределено Тогда
		РедОбъектЗадания = РегламентныеЗадания.СоздатьРегламентноеЗадание(ИмяЗадания);
		РедОбъектЗадания.Наименование = Наименование;
		РедОбъектЗадания.Использование = Истина;
	Иначе
		РедОбъектЗадания = ОбъектЗадания;
	КонецЕсли;
	
	РедОбъектЗадания.Расписание = Расписание;
	Попытка
		РедОбъектЗадания.Записать();
	Исключение
		ВызватьИсключение "Произошла ошибка при сохранении расписания выполнения обменов. Возможно данные расписания были изменены. Закройте форму настройки и повторите попытку изменения расписания еще раз.
		|Подробное описание ошибки: " + ОписаниеОшибки();
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьФоновоеЗадание(Команда)
	Отказ = Истина;
	Попытка
		ОтменитьФоновыеЗадания();
		ОбновитьСписокФоновыхЗаданий();
	Исключение	
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ОтменитьФоновыеЗадания()
	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр из ВыделенныеСтроки Цикл
		Строка = СписокФоновыхЗаданий.НайтиПоИдентификатору(Стр);
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(новый UUID(Строка.Идентификатор));
		ФоновоеЗадание.Отменить();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаРегламентныхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаРегламентныхЗаданий);
	
	Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогНастроекСписка", СтруктураПараметров);
	Результат = Диалог.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		АвтообновлениеСпискаРегламентныхЗаданий = Результат.Автообновление;
		ПериодАвтообновленияСпискаРегламентныхЗаданий = Результат.ПериодАвтообновления;
		
		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий");
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий", ПериодАвтообновленияСпискаРегламентныхЗаданий);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаФоновыхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаФоновыхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаФоновыхЗаданий);
	
	Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогНастроекСписка", СтруктураПараметров);
	Результат = Диалог.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		АвтообновлениеСпискаФоновыхЗаданий = Результат.Автообновление;
		ПериодАвтообновленияСпискаФоновыхЗаданий = Результат.ПериодАвтообновления;
		
		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий");
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий", ПериодАвтообновленияСпискаФоновыхЗаданий);	
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияФоновыхЗаданий()
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияРегламентныхЗаданий()
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборРегламентныхЗаданий);
	
	Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогОтбораРегламентногоЗадания", СтруктураПараметров);
	Результат = Диалог.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ОтборРегламентныхЗаданий = Результат;
		ОтборРегламентныхЗаданийВключен = Истина;
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборРегламентныхЗаданий(Команда)
	ОтборРегламентныхЗаданийВключен = Ложь;
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборФоновыхЗаданий(Команда)
	ОтборФоновыхЗаданийВключен = Ложь;
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборФоновыхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборФоновыхЗаданий);
	
	Диалог = ПолучитьФорму("Обработка.КонсольЗаданий.Форма.ДиалогОтбораФоновогоЗадания", СтруктураПараметров);
	Результат = Диалог.ОткрытьМодально();
	Если Результат <> Неопределено Тогда
		ОтборФоновыхЗаданий = Результат;
		ОтборФоновыхЗаданийВключен = Истина;
		ОбновитьСписокФоновыхЗаданий();
	КонецЕсли;
КонецПроцедуры
