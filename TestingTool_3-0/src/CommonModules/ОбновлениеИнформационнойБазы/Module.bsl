////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ДАННЫХ ИНФОРМАЦИОННОЙ БАЗЫ ПРИ СМЕНЕ ВЕРСИИ КОНФИГУРАЦИИ

// Проверить необходимость обновления информационной базы при смене версии конфигурации.
//
Функция НеобходимоОбновлениеИнформационнойБазы() Экспорт
	
	Возврат НеобходимоВыполнитьОбновление(Метаданные.Версия, ВерсияИБ(Метаданные.Имя));
	
КонецФункции

// Проверить права текущего пользователя на выполнение обновления информационной базы.
//
Функция ЕстьПраваНаОбновлениеИнформационнойБазы() 
	
	Возврат ПравоДоступа("МонопольныйРежим", Метаданные) И ПравоДоступа("Администрирование", Метаданные);
	
КонецФункции	

// Возвращает Истина, если требуется обновление ИБ и у текущего пользователя
// для этого недостаточно прав.
//
Функция ПроверитьНевозможностьОбновленияИнформационнойБазы() Экспорт
	
	Возврат НеобходимоОбновлениеИнформационнойБазы() И НЕ ЕстьПраваНаОбновлениеИнформационнойБазы();
	
КонецФункции	

// Возвращает Истина, если выполняется обновление ИБ
Функция ВыполняетсяОбновлениеИнформационнойБазы() Экспорт
	
	Возврат НеобходимоОбновлениеИнформационнойБазы() И ЕстьПраваНаОбновлениеИнформационнойБазы();
	
КонецФункции

// Выполнить неинтерактивное обновление данных ИБ.
//
// Результат:
//      Неопределено - обновление не выполнялось (не требуется)
//      Строка       - адрес временного хранилища со списком выполненных обработчиков обновления
//
Функция ВыполнитьОбновлениеИнформационнойБазы() Экспорт

	ВерсияМетаданных = Метаданные.Версия;
	ВерсияДанных = ВерсияИБ(Метаданные.Имя);
	Если ПустаяСтрока(ВерсияМетаданных) Тогда
		 ВерсияМетаданных = "0.0.0.0";
	КонецЕсли;
	 
	Если НЕ НеобходимоВыполнитьОбновление(ВерсияМетаданных, ВерсияДанных) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Изменился номер версии конфигурации: с ""%1"" на ""%2"". Будет выполнено обновление информационной базы.'"),
		ВерсияДанных, ВерсияМетаданных);
	ЗаписатьИнформацию(Сообщение);
	
	// Проверка наличия прав для обновления информационной базы.
	Если НЕ ЕстьПраваНаОбновлениеИнформационнойБазы() Тогда
		Сообщение = НСтр("ru = 'Недостаточно прав для выполнения обновления. Обратитесь к системному администратору.'");
		ЗаписатьОшибку(Сообщение);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить("ОбновлениеВерсииИБ", "РежимОтладки");
	РежимОтладки = ЗначениеНастройки = Истина;
	
	// Установка монопольного режима для обновления информационной базы.
	Если НЕ РежимОтладки Тогда
		Попытка
			УстановитьМонопольныйРежим(Истина);
		Исключение
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Невозможно выполнить обновление информационной базы, так как к ней подключены другие сеансы.
					 |Обратитесь к системному администратору.
					 |
					 |Подробности ошибки:
					 |%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписатьОшибку(Сообщение);
			
			ВызватьИсключение Сообщение;
		КонецПопытки;
	КонецЕсли;	
	
	Попытка
		СписокОбработчиковОбновления = ОбновлениеИнформационнойБазыПереопределяемый.ОбработчикиОбновления();
		
		ВыполненныеОбработчики = ВыполнитьИтерациюОбновления(Метаданные.Имя, Метаданные.Версия,
			СписокОбработчиковОбновления);
	Исключение
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Обновление информационной базы на версию ""%1"" завершилось с ошибками: 
				|%2'"), ВерсияМетаданных, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписатьОшибку(Сообщение);
		// Отключение монопольного режима.
		Если НЕ РежимОтладки Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;	
		ВызватьИсключение;
	КонецПопытки;
	
	// Отключение монопольного режима.
	Если НЕ РежимОтладки Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;	
	
	Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Обновление информационной базы на версию ""%1"" выполнено успешно.'"), ВерсияМетаданных);
	ЗаписатьИнформацию(Сообщение);
	
	ВыводитьОписаниеОбновлений = ВерсияДанных <> "0.0.0.0";
	ОбновлениеИнформационнойБазыПереопределяемый.ПослеОбновления(ВерсияДанных, ВерсияМетаданных, 
		ВыполненныеОбработчики, ВыводитьОписаниеОбновлений);
	
	Адрес = "";
	Если ВыводитьОписаниеОбновлений Тогда
		Адрес = ПоместитьВоВременноеХранилище(ВыполненныеОбработчики, Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат Адрес;

КонецФункции

// Выполнить обработчики обновления из списка ОбработчикиОбновления 
// для библиотеки ИдентификаторБиблиотеки до версии ВерсияМетаданныхИБ.
//
// Параметры
//  ИдентификаторБиблиотеки  – Строка – имя конфигурации или идентификатор библиотеки.
//  ВерсияМетаданныхИБ       – Строка – версия метаданных, до которой необходимо
//                                      выполнить обновление.
//  ОбработчикиОбновления    – Соответствие – список обработчиков обновления.
//
// Возвращаемое значение:
//   ДеревоЗначений   – выполненные обработчики обновления.
//
Функция ВыполнитьИтерациюОбновления(Знач ИдентификаторБиблиотеки, Знач ВерсияМетаданныхИБ, 
	Знач ОбработчикиОбновления) Экспорт
	
	ТекущаяВерсияИБ = ВерсияИБ(ИдентификаторБиблиотеки);
	Если ПустаяСтрока(ТекущаяВерсияИБ) Тогда
		 ТекущаяВерсияИБ = "0.0.0.0";
	КонецЕсли;
	НоваяВерсияИБ = ТекущаяВерсияИБ;
	ВерсияМетаданных = ВерсияМетаданныхИБ;
	Если ПустаяСтрока(ВерсияМетаданных) Тогда
		 ВерсияМетаданных = "0.0.0.0";
	КонецЕсли;
	
	ВыполняемыеОбработчики = ОбработчикиОбновленияВИнтервале(ОбработчикиОбновления, ТекущаяВерсияИБ, ВерсияМетаданных);
	Для Каждого Версия Из ВыполняемыеОбработчики.Строки Цикл
		
		Если Версия.Версия = "*" Тогда
			Сообщение = НСтр("ru = 'Выполняются обязательные процедуры обновления информационной базы.'");
		Иначе
			НоваяВерсияИБ = Версия.Версия;
			
			Если ИдентификаторБиблиотеки = Метаданные.Имя Тогда 
				Сообщение = НСтр("ru = 'Выполняется обновление информационной базы с версии %1 на версию %2.'");
			Иначе
				Сообщение = НСтр("ru = 'Выполняется обновление информационной базы родительской конфигурации %3 с версии %1 на версию %2.'");
			КонецЕсли;
			
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение,
			                 ТекущаяВерсияИБ, НоваяВерсияИБ, ИдентификаторБиблиотеки);
			
		КонецЕсли;
		
		ЗаписатьИнформацию(Сообщение);
		
		Для Каждого Обработчик Из Версия.Строки Цикл
			ОбщегоНазначенияСервер.ВыполнитьБезопасно(Обработчик.Процедура);
		КонецЦикла;
		
		Если Версия.Версия = "*" Тогда
			Сообщение = НСтр("ru = 'Выполнены обязательные процедуры обновления информационной базы.'");
		Иначе
			// Установка номера версии информационной базы
			УстановитьВерсиюИБ(ИдентификаторБиблиотеки, НоваяВерсияИБ);
			
			Если ИдентификаторБиблиотеки = Метаданные.Имя Тогда 
				Сообщение = НСтр("ru = 'Выполнено обновление информационной базы с версии %1 на версию %2.'");
			Иначе
				Сообщение = НСтр("ru = 'Выполнено обновление информационной базы родительской конфигурации %3 с версии %1 на версию %2.'");
			КонецЕсли;
			
			Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Сообщение,
			  ТекущаяВерсияИБ, НоваяВерсияИБ, ИдентификаторБиблиотеки);
			
			ТекущаяВерсияИБ = НоваяВерсияИБ;
			
		КонецЕсли;
		ЗаписатьИнформацию(Сообщение);
		
	КонецЦикла;
	
	// Установка номера версии информационной базы
	Если ВерсияИБ(ИдентификаторБиблиотеки) <> ВерсияМетаданныхИБ Тогда
		УстановитьВерсиюИБ(ИдентификаторБиблиотеки, ВерсияМетаданныхИБ);
	КонецЕсли;
	
	Возврат ВыполняемыеОбработчики;
	
КонецФункции

// Возвращает пустую таблицу обработчиков обновления и первоначального заполнения ИБ.
//
// Возвращаемое значение:
//   ТаблицаЗначений   – таблица с колонками:
//                       Версия       - номер версии конфигурации, при переходе на которую должна
//                                      быть выполнена процедура-обработчик обновления
//                       Процедура    - полное имя процедуры-обработчика обновления. 
//                                      Должна быть обязательно экспортной. 
//                       Опциональный - если Истина, то обработчик не должен срабатывать
//                                      при первом запуске на "пустой" базе.
//                       Приоритет    - Число. Для внутреннего использования.
//
Функция НоваяТаблицаОбработчиковОбновления() Экспорт
	
	Обработчики = Новый ТаблицаЗначений;
	Обработчики.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(0)));
	Обработчики.Колонки.Добавить("Процедура", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(0)));
	Обработчики.Колонки.Добавить("Опциональный");
	Обработчики.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2)));
	Возврат Обработчики;
	
КонецФункции

// Получить версию конфигурации или родительской конфигурации (библиотеки),
// которая хранится в информационной базе.
//
// Параметры
//  ИдентификаторБиблиотеки  – Строка – имя конфигурации или идентификатор библиотеки.
//
// Возвращаемое значение:
//   Строка   – версия.
//
// Пример использования:
//   ВерсияКонфигурацииИБ = ВерсияИБ(Метаданные.Имя);
//
Функция ВерсияИБ(Знач ИдентификаторБиблиотеки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВерсииПодсистем.Версия КАК Версия
		|ИЗ
		|	РегистрСведений.ВерсииПодсистем КАК ВерсииПодсистем
		|ГДЕ
		|	ВерсииПодсистем.ИмяПодсистемы = &ИмяПодсистемы");
	Запрос.Параметры.Вставить("ИмяПодсистемы", ИдентификаторБиблиотеки);
	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();
	Результат = "";
	Если ТаблицаЗначений.Количество() > 0 Тогда
		Результат = СокрЛП(ТаблицаЗначений[0].Версия);
	КонецЕсли;
	Возврат ?(ПустаяСтрока(Результат), "0.0.0.0", Результат);
	
КонецФункции

// Возвращает Истина если запуск информационной базы
// выполняется первый раз, иначе возвращает Ложь
//
Функция ПервыйЗапуск() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ Версия ИЗ РегистрСведений.ВерсииПодсистем";
	
	Возврат Запрос.Выполнить().Пустой()
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция НеобходимоВыполнитьОбновление(Знач ВерсияМетаданных, Знач ВерсияДанных) 
	
	Возврат НЕ ПустаяСтрока(ВерсияМетаданных) И ВерсияДанных <> ВерсияМетаданных;
	
КонецФункции

Процедура УстановитьВерсиюИБ(Знач ИдентификаторБиблиотеки, Знач НомерВерсии) 
	
	НаборЗаписей = РегистрыСведений.ВерсииПодсистем.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИмяПодсистемы.Установить(ИдентификаторБиблиотеки);
	
	НоваяЗапись = НаборЗаписей.Добавить();
	
	НоваяЗапись.ИмяПодсистемы = ИдентификаторБиблиотеки;
	НоваяЗапись.Версия = НомерВерсии;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

Функция ОбработчикиОбновленияВИнтервале(Знач ВсеОбработчики, Знач ВерсияОт, Знач ВерсияДо)
	
	ПостроительЗапроса = Новый ПостроительЗапроса();
	Источник = Новый ОписаниеИсточникаДанных(ВсеОбработчики);
	Источник.Колонки.Версия.Измерение = Истина;
	ПостроительЗапроса.ИсточникДанных = Источник;
	ПостроительЗапроса.Измерения.Добавить("Версия");
	ПостроительЗапроса.Выполнить();
	ВыборкаИтоги = ПостроительЗапроса.Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыполняемыеОбработчики = Новый ДеревоЗначений();
	ВыполняемыеОбработчики.Колонки.Добавить("Версия");
	ВыполняемыеОбработчики.Колонки.Добавить("Процедура");
	ВыполняемыеОбработчики.Колонки.Добавить("Приоритет");
	Пока ВыборкаИтоги.Следующий() Цикл
		
		Если ВыборкаИтоги.Версия <> "*" И 
			НЕ (СтроковыеФункцииКлиентСервер.СравнитьВерсии(ВыборкаИтоги.Версия, ВерсияОт) > 0 
				И СтроковыеФункцииКлиентСервер.СравнитьВерсии(ВыборкаИтоги.Версия, ВерсияДо) <= 0) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаВерсии = Неопределено;
		Выборка = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.Прямой);
		Пока Выборка.Следующий() Цикл
			Если Выборка.Процедура = Null Тогда
				Продолжить;
			КонецЕсли;
			Если Выборка.Опциональный = Истина И ВерсияОт = "0.0.0.0" Тогда
				Продолжить;
			КонецЕсли;
			Если СтрокаВерсии = Неопределено Тогда
				СтрокаВерсии = ВыполняемыеОбработчики.Строки.Добавить();
				СтрокаВерсии.Версия = ВыборкаИтоги.Версия;
				СтрокаВерсии.Приоритет = Выборка.Приоритет;
			КонецЕсли;
			Обработчик = СтрокаВерсии.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(Обработчик, Выборка, "Версия,Процедура");
		КонецЦикла;
		
	КонецЦикла;
	
	// упорядочить обработчики по возрастанию версий
	КоличествоСтрок = ВыполняемыеОбработчики.Строки.Количество();
	Для Инд1 = 2 По КоличествоСтрок Цикл
		Для Инд2 = 0 По КоличествоСтрок - Инд1 Цикл
			
			Версия1 = ВыполняемыеОбработчики.Строки[Инд2].Версия;
			Версия2 = ВыполняемыеОбработчики.Строки[Инд2+1].Версия;
			Если Версия1 = "*" И Версия2 = "*" Тогда
				Результат = ВыполняемыеОбработчики.Строки[Инд2].Приоритет - ВыполняемыеОбработчики.Строки[Инд2 + 1].Приоритет;
			ИначеЕсли Версия1 = "*" Тогда
				Результат = -1;
			ИначеЕсли Версия2 = "*" Тогда
				Результат = 1;
			Иначе
				Результат = СтроковыеФункцииКлиентСервер.СравнитьВерсии(Версия1, Версия2);
				Если Результат = 0 Тогда
					Результат = ВыполняемыеОбработчики.Строки[Инд2].Приоритет - ВыполняемыеОбработчики.Строки[Инд2 + 1].Приоритет;
				КонецЕсли;
			КонецЕсли;	
			
			Если Результат > 0  Тогда 
				ВыполняемыеОбработчики.Строки.Сдвинуть(Инд2, 1);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВыполняемыеОбработчики;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОТОКОЛИРОВАНИЕ ХОДА ОБНОВЛЕНИЯ

Функция СобытиеЖурналаРегистрации() Экспорт
	
	Возврат НСтр("ru = 'Обновление информационной базы'");
	
КонецФункции	

Процедура ЗаписатьИнформацию(Знач Текст) 
	
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, Текст);
	
КонецПроцедуры

Процедура ЗаписатьОшибку(Знач Текст) 
	
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, Текст);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОПИСАНИЕ ОБНОВЛЕНИЙ

// Формирует табличный документ с описанием изменений в версиях,
// которые соответствуют переданному списку версий ОбработчикиОбновления.
//
Функция ДокументОписаниеОбновлений(Знач ОбработчикиОбновления) Экспорт
	
	ДокументОписаниеОбновлений = Новый ТабличныйДокумент();
	Если ОбработчикиОбновления = Неопределено Тогда
		Возврат ДокументОписаниеОбновлений;
	КонецЕсли;
	
	МакетОписаниеОбновлений = Метаданные.ОбщиеМакеты.Найти("ОписаниеИзмененийСистемы");
	Если МакетОписаниеОбновлений <> Неопределено Тогда
		МакетОписаниеОбновлений = ПолучитьОбщийМакет(МакетОписаниеОбновлений);
	Иначе	
		МакетОписаниеОбновлений = Новый ТабличныйДокумент();
	КонецЕсли;
	
	Для Каждого Версия Из ОбработчикиОбновления.Строки Цикл
		
		Если Версия.Версия = "*" Тогда
			Продолжить;
		КонецЕсли;
		
		ВывестиОписаниеИзменений(Версия.Версия, ДокументОписаниеОбновлений, МакетОписаниеОбновлений);
		
	КонецЦикла;
	
	Возврат ДокументОписаниеОбновлений;
	
КонецФункции

// Вывести описания изменений в указанной версии
//
// Параметры
//  НомерВерсии  – Строка - номер версии, для которого выводится описание из макета
//                          табличного документа МакетОписаниеОбновлений в табличный документ 
//                          ДокументОписаниеОбновлений.
//
Процедура ВывестиОписаниеИзменений(Знач НомерВерсии, ДокументОписаниеОбновлений, МакетОписаниеОбновлений)
	
	Номер = СтрЗаменить(НомерВерсии, ".", "_");
	
	Если МакетОписаниеОбновлений.Области.Найти("Шапка" + Номер) = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Шапка" + Номер));
	ДокументОписаниеОбновлений.НачатьГруппуСтрок("Версия" + Номер);
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Версия" + Номер));
	ДокументОписаниеОбновлений.ЗакончитьГруппуСтрок();
	ДокументОписаниеОбновлений.Вывести(МакетОписаниеОбновлений.ПолучитьОбласть("Отступ"));
	
КонецПроцедуры
