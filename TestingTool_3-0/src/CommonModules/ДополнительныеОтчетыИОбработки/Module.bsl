#Область ПрограммныйИнтерфейс


// Подключает и возвращает имя, под которым подключен внешний отчет или обработка.
//   После подключения отчет или обработка регистрируется в программе под определенным именем,
//   используя которое можно создавать объект или открывать формы отчета или обработки.
//
// Параметры:
//   Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Подключаемая обработка.
//
// Возвращаемое значение: 
//   * Строка       - Имя подключенного отчета или обработки.
//   * Неопределено - Если передана некорректная ссылка.
//
// Важно:
//   Проверка функциональной опции "ИспользоватьДополнительныеОтчетыИОбработки"
//     должна выполняться вызывающим кодом.
//
Функция ПодключитьВнешнююОбработку(Ссылка) Экспорт
	
	СтандартнаяОбработка = Истина;
	Результат = Неопределено;
	
	//ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
	//	"СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки\ПриПодключенииВнешнейОбработки");
	//
	//Для каждого Обработчик Из ОбработчикиСобытия Цикл
	//	
	//	Обработчик.Модуль.ПриПодключенииВнешнейОбработки(Ссылка, СтандартнаяОбработка, Результат);
	//	
	//	Если Не СтандартнаяОбработка Тогда
	//		Возврат Результат;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	// Проверка корректности переданных параметров.
	Если ТипЗнч(Ссылка) <> Тип("СправочникСсылка.ДополнительныеОтчетыИОбработки") 
		Или Ссылка = Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// Подключение
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ИмяОбработки = ПолучитьИмяВременногоФайла();
		ХранилищеОбработки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ХранилищеОбработки");
		ДвоичныеДанные = ХранилищеОбработки.Получить();
		ДвоичныеДанные.Записать(ИмяОбработки);
		Возврат ИмяОбработки;
	#КонецЕсли
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
		Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Менеджер = ВнешниеОтчеты;
	Иначе
		Менеджер = ВнешниеОбработки;
	КонецЕсли;
	
	ПараметрыЗапуска = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "БезопасныйРежим, ХранилищеОбработки");
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПараметрыЗапуска.ХранилищеОбработки.Получить());
	
	//Если ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности") Тогда
	//	
	//	БезопасныйРежим = РаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Ссылка);
	//	
	//	Если БезопасныйРежим = Неопределено Тогда
	//		БезопасныйРежим = Истина;
	//	КонецЕсли;
	//	
	//Иначе
		
		БезопасныйРежим = ПараметрыЗапуска.БезопасныйРежим;
		
		Если БезопасныйРежим Тогда
			ЗапросРазрешений = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	ДополнительныеОтчетыИОбработкиРазрешения.НомерСтроки,
				|	ДополнительныеОтчетыИОбработкиРазрешения.ВидРазрешения
				|ИЗ
				|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
				|ГДЕ
				|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка = &Ссылка");
			ЗапросРазрешений.УстановитьПараметр("Ссылка", Ссылка);
			ЕстьРазрешений = Не ЗапросРазрешений.Выполнить().Пустой();
			
			РежимСовместимости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "РежимСовместимостиРазрешений");
			Если РежимСовместимости = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2
				И ЕстьРазрешений Тогда
				БезопасныйРежим = Ложь;
			КонецЕсли;
		КонецЕсли;
		
	//КонецЕсли;
	
	ЗаписатьПримечание(Ссылка, НСтр("ru = 'Подключение, БезопасныйРежим = ""%1"".'"), БезопасныйРежим);
	
	ИмяОбработки = Менеджер.Подключить(АдресВоВременномХранилище, , БезопасныйРежим);
	
	Возврат ИмяОбработки;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Регламентные задания

// Обработчик экземпляра регламентного задания ЗапускОбработок.
//   Запускает обработчик глобальной обработки по регламентному заданию,
//   с указанным идентификатором команды.
//
// Параметры:
//   ВнешняяОбработка     - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка выполняемой обработки.
//   ИдентификаторКоманды - Строка - Идентификатор выполняемой команды.
//
Процедура ВыполнитьОбработкуПоРегламентномуЗаданию(ВнешняяОбработка, ИдентификаторКоманды) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок);
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, НСтр("ru = 'Команда %1: Запуск.'"), ИдентификаторКоманды);
	
	// Выполнение команды
	Попытка
		//ВыполнитьКоманду(Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды", ВнешняяОбработка, ИдентификаторКоманды), Неопределено);
	Исключение
		ЗаписатьОшибку(
			ВнешняяОбработка,
			НСтр("ru = 'Команда %1: Ошибка выполнения:%2'"),
			ИдентификаторКоманды,
			Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	// Запись журнала регистрации
	ЗаписатьИнформацию(ВнешняяОбработка, НСтр("ru = 'Команда %1: Завершение.'"), ИдентификаторКоманды);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Формирует запрос для получения таблицы команд дополнительных отчетов или обработок.
//
// Параметры:
//   ВидОбработок - ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - Вид обработки.
//   ПолноеИмяИлиСсылкаРодителяИлиРаздела - СправочникСсылка.ИдентификаторыОбъектовМетаданных, Строка -
//       Объект метаданных (Ссылка или ПолноеИмя).
//       Для назначаемых обработок - справочника или документа.
//       Для глобальных обработок - подсистемы.
//   ЭтоФормаОбъекта - Булево - Необязательный.
//       Истина - для формы объекта.
//       Ложь - для формы списка.
//
// Возвращаемое значение: 
//   ТаблицаЗначений - Команды дополнительных отчетов или обработок.
//       * Ссылка - СправочникСсылка.ДополнительныеОтчетыИОбработки - Ссылка дополнительного отчета или обработки.
//       * Идентификатор - Строка - Идентификатор команды, как он задан разработчиком дополнительного объекта.
//       * ВариантЗапуска - ПеречислениеСсылка.СпособыВызоваДополнительныхОбработок -
//           Способ вызова команды дополнительного объекта.
//       * Представление - Строка - Наименование команды в пользовательском интерфейсе.
//       * ПоказыватьОповещение - Булево - Показывать оповещение пользователю после выполнения команды.
//       * Модификатор - Строка - Модификатор команды.
//
Функция НовыйЗапросПоДоступнымКомандам(ВидОбработок, ПолноеИмяИлиСсылкаРодителяИлиРаздела, ЭтоФормаОбъекта = Неопределено) Экспорт
	ЭтоГлобальныеОбработки = (
		ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет
		ИЛИ ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка);
	
	Если ТипЗнч(ПолноеИмяИлиСсылкаРодителяИлиРаздела) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		СсылкаРодителяИлиРаздела = ПолноеИмяИлиСсылкаРодителяИлиРаздела;
	Иначе
		СсылкаРодителяИлиРаздела = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ПолноеИмяИлиСсылкаРодителяИлиРаздела);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	// Запросы принципиально отличаются для глобальных обработок и назначаемых.
	Если ЭтоГлобальныеОбработки Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	БыстрыйДоступ.ДополнительныйОтчетИлиОбработка КАК Ссылка,
		|	БыстрыйДоступ.ИдентификаторКоманды
		|ПОМЕСТИТЬ втБыстрыйДоступ
		|ИЗ
		|	РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК БыстрыйДоступ
		|ГДЕ
		|	БыстрыйДоступ.Пользователь = &ТекущийПользователь
		|	И БыстрыйДоступ.Доступно = ИСТИНА
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаБыстрыйДоступ.Ссылка,
		|	ТаблицаБыстрыйДоступ.ИдентификаторКоманды
		|ПОМЕСТИТЬ втСсылкиИКоманды
		|ИЗ
		|	втБыстрыйДоступ КАК ТаблицаБыстрыйДоступ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО ТаблицаБыстрыйДоступ.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы
		|		ПО ТаблицаБыстрыйДоступ.Ссылка = ТаблицаРазделы.Ссылка
		|			И (ТаблицаРазделы.Раздел = &СсылкаРаздела)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ДопОтчетыИОбработки.Ссылка,
		|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|			И (ДополнительныеОтчетыИОбработкиКоманды.ПросмотрВсе = ИСТИНА)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы
		|		ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ТаблицаРазделы.Ссылка
		|			И (ТаблицаРазделы.Раздел = &СсылкаРаздела)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаКоманды.Ссылка,
		|	ТаблицаКоманды.Идентификатор,
		|	ТаблицаКоманды.ЗаменяемыеКоманды,
		|	ТаблицаКоманды.ВариантЗапуска,
		|	ТаблицаКоманды.Представление КАК Представление,
		|	ТаблицаКоманды.ПоказыватьОповещение,
		|	ТаблицаКоманды.Модификатор,
		|	ВЫБОР
		|		КОГДА (ВЫРАЗИТЬ(ТаблицаКоманды.Описание КАК СТРОКА(150))) = """"
		|			ТОГДА ТаблицаКоманды.Ссылка.Информация
		|		ИНАЧЕ ТаблицаКоманды.Описание
		|	КОНЕЦ КАК Описание,
		|	ТаблицаКоманды.Ссылка.Версия КАК Версия
		|ИЗ
		|	втСсылкиИКоманды КАК ТаблицаСсылкиИКоманды
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ТаблицаКоманды
		|		ПО ТаблицаСсылкиИКоманды.Ссылка = ТаблицаКоманды.Ссылка
		|			И ТаблицаСсылкиИКоманды.ИдентификаторКоманды = ТаблицаКоманды.Идентификатор
		|			И (ТаблицаКоманды.Скрыть = ЛОЖЬ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Запрос.УстановитьПараметр("СсылкаРаздела", СсылкаРодителяИлиРаздела);
		
	Иначе
		
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ТаблицаНазначение.Ссылка
		|ПОМЕСТИТЬ втСсылки
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ТаблицаНазначение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
		|		ПО (ТаблицаНазначение.ОбъектНазначения = &СсылкаРодителя)
		|			И ТаблицаНазначение.Ссылка = ДопОтчетыИОбработки.Ссылка
		|			И (ДопОтчетыИОбработки.ПометкаУдаления = ЛОЖЬ)
		|			И (ДопОтчетыИОбработки.Вид = &Вид)
		|			И (ДопОтчетыИОбработки.Публикация = &Публикация)
		|			И (ДопОтчетыИОбработки.ИспользоватьДляФормыСписка = ИСТИНА)
		|			И (ДопОтчетыИОбработки.ИспользоватьДляФормыОбъекта = ИСТИНА)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ТаблицаКоманды.Ссылка,
		|	ТаблицаКоманды.Идентификатор,
		|	ТаблицаКоманды.ЗаменяемыеКоманды,
		|	ТаблицаКоманды.ВариантЗапуска,
		|	ТаблицаКоманды.Представление КАК Представление,
		|	ТаблицаКоманды.ПоказыватьОповещение,
		|	ТаблицаКоманды.Модификатор
		|ИЗ
		|	втСсылки КАК ТаблицаСсылки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ТаблицаКоманды
		|		ПО ТаблицаСсылки.Ссылка = ТаблицаКоманды.Ссылка
		|			И (ТаблицаКоманды.Скрыть = ЛОЖЬ)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Представление";
		
		Запрос.УстановитьПараметр("СсылкаРодителя", СсылкаРодителяИлиРаздела);
		
		// Отключение отборов по форме списка и объекта.
		Если ЭтоФормаОбъекта <> Истина Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (ДопОтчетыИОбработки.ИспользоватьДляФормыОбъекта = ИСТИНА)", "");
		КонецЕсли;
		Если ЭтоФормаОбъекта <> Ложь Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (ДопОтчетыИОбработки.ИспользоватьДляФормыСписка = ИСТИНА)", "");
		КонецЕсли;
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Вид", ВидОбработок);
	Запрос.УстановитьПараметр("ТекущийПользователь", ПользователиКлиентСервер.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("Публикация",Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос;
КонецФункции

// Запись ошибки в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьОшибку(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Ошибка;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры


// Запись информации в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьИнформацию(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Информация;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры

// Запись примечания в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьПримечание(Ссылка, ТекстСообщения, Реквизит1 = Неопределено, Реквизит2 = Неопределено, Реквизит3 = Неопределено) Экспорт
	Уровень = УровеньЖурналаРегистрации.Примечание;
	ЗаписатьВЖурнал(Уровень, Ссылка, ТекстСообщения, Реквизит1, Реквизит2, Реквизит3);
КонецПроцедуры

// Запись события в журнал регистрации по дополнительному отчету или обработке.
Процедура ЗаписатьВЖурнал(Уровень, Ссылка, Текст, Параметр1, Параметр2, Параметр3)
	Текст = СтрЗаменить(Текст, "%1", Параметр1); // Переход на СтрШаблон невозможен.
	Текст = СтрЗаменить(Текст, "%2", Параметр2);
	Текст = СтрЗаменить(Текст, "%3", Параметр3);
	ЗаписьЖурналаРегистрации(
		ДополнительныеОтчетыИОбработкиКлиентСервер.НаименованиеПодсистемы(Ложь),
		Уровень,
		Метаданные.Справочники.ДополнительныеОтчетыИОбработки,
		Ссылка,
		Текст);
КонецПроцедуры

#КонецОбласти