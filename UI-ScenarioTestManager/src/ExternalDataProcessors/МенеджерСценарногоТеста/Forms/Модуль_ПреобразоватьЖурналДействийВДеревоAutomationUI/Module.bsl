&НаКлиенте
Перем Модуль_СервисныеФункции;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры

&НаКлиенте
Процедура мСцен_ПреобразоватьВДеревоСценарияНаКлиенте(Знач ТекстСценария,
		ДеревоСценария, мПараметры, ЭтоБуфер = Ложь) Экспорт

	ЗагрузитьБиблиотеки();
	
	ИсключатьКомандуFocus = мПараметры.ИсключатьКомандуFocus;
	Исключать_xPath		= мПараметры.Исключать_xPath;
	
	ТребуетяОбвязкаПодключения = Истина;
	
	Если ЭтоБуфер=Истина Тогда
		ТребуетяОбвязкаПодключения = Ложь;
	Иначе
		ДеревоСценария.ПолучитьЭлементы().Очистить();
	КонецЕсли;
	

	// преобразуем текст в массив структур
	РезультатПреобразования = Модуль_СервисныеФункции.ОбработкаJSON(ТекстСценария);
	
	ТаблицаДанныхСценария.Очистить();

	// перенесем в таблицу	
	Для каждого стр из РезультатПреобразования Цикл		
			
		стр_н = ТаблицаДанныхСценария.Добавить();
		стр_н.ЗаголовокОбъекта = стр.element_name;
		стр_н.ИмяОбъекта = стр.element_name;
		стр_н.ИмяКлассаОбъекта = стр.element_class_name;
		стр_н.Действие = ПреобразоватьНаименованиеДействия(стр.action);
		стр_н.Команда = стр.command;
		стр_н.ТипОбъекта = стр.element_type;
		стр_н.ИдентификаторОбъекта = стр.element_id;
		Если ЗначениеЗаполнено(стр_н.ЗаголовокОбъекта) Тогда 
			Если стр_н.Действие="Команда" Тогда
				стр_н.Наименование = стр_н.Действие+" """+стр_н.Команда+"""";
			Иначе
				стр_н.Наименование = стр_н.Действие+" """+стр_н.ЗаголовокОбъекта+"""";
			КонецЕсли;
		Иначе
			Если стр_н.Действие="Команда" Тогда
				стр_н.Наименование = стр_н.Действие+" """+стр_н.Команда+"""";
			Иначе
				стр_н.Наименование = стр_н.Действие+" """+стр_н.ТипОбъекта+" : "+стр_н.ИмяКлассаОбъекта+"""";				
			КонецЕсли;
		КонецЕсли;		
		стр_н.API = "AutomationUI";
		стр_н.UID = Строка(новый УникальныйИдентификатор());
		стр_н.ClickX = стр.clickX;
		стр_н.ClickY = стр.clickY;
		Если стр.Свойство("element_XPath") И НЕ Исключать_xPath=Истина Тогда
			стр_н.xPath = стр.element_XPath;
		Иначе
			стр_н.xPath = "";
		КонецЕсли;
		
		
		стр_н.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(новый Структура("Действие,ТипОбъекта",стр_н.Действие,""));
		
	КонецЦикла;
	
	
	Если ТребуетяОбвязкаПодключения=Истина Тогда
		мСцен_GenerateClientConnectionScript(ДеревоСценария);
	КонецЕсли;
	
	
	// отправим в дерево
	ИмяОкна = новый Структура;
	ИмяОбъекта = новый Структура;
	ИмяОсновногоОкна = Новый Структура;
	ЭлементОсновноеОкно = Неопределено;
	ЭлементОкно = Неопределено;
	ЭлементОбъект = Неопределено;
	СбросОкна = Истина;
	Для каждого стр из ТаблицаДанныхСценария Цикл
		
		КлючОбъекта = новый Структура("Действие,Команда,ТипОбъекта,ИмяКлассаОбъекта,ИмяОбъекта,ЗаголовокОбъекта");
		ЗаполнитьЗначенияСвойств(КлючОбъекта,стр);
		
		// добавляем основное окно
		Если стр.Действие="НайтиОсновноеОкно" Тогда
			СбросОкна=Истина;
			Если НЕ СравнитьСтруктуры(ИмяОсновногоОкна,КлючОбъекта) Тогда
				ИмяОсновногоОкна = КлючОбъекта;
				ЭлементОсновноеОкно = ДеревоСценария.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(ЭлементОсновноеОкно, стр);
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		// добавляем новое окно, если оно меняет заголовок
		Если стр.Действие="НайтиОкно" Тогда
			СбросОкна = Ложь;
			Если НЕ СравнитьСтруктуры(ИмяОкна,КлючОбъекта) Тогда
				ИмяОкна = КлючОбъекта;
				ЭлементОкно = ЭлементОсновноеОкно.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(ЭлементОкно, стр);
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если стр.Действие="НайтиОбъект" Тогда
			Если СбросОкна=Истина Тогда
				ИмяОкна = Новый Структура;
				ЭлементОкно = Неопределено;
			КонецЕсли;			
			Если НЕ СравнитьСтруктуры(ИмяОбъекта,КлючОбъекта) Тогда
				ИмяОбъекта = КлючОбъекта;
				Если ЭлементОкно=Неопределено Тогда
					Если ЭлементОсновноеОкно=Неопределено Тогда
						ЭлементОсновноеОкно = ДеревоСценария.ПолучитьЭлементы().Добавить();
						Сообщить("Не смог найти основное окно при записи. Возможно вы работали с рабочим столом
						|или с панелью рабочего стола, с этими элементами работа не поддерживается. Исправьте вручную!");
						ЭлементОсновноеОкно.ЗаголовокОбъекта = "Рабочий стол";	
					КонецЕсли;
					ЭлементОбъект = ЭлементОсновноеОкно.ПолучитьЭлементы().Добавить();
				Иначе
					ЭлементОбъект = ЭлементОкно.ПолучитьЭлементы().Добавить();
				КонецЕсли;	
				ЗаполнитьЗначенияСвойств(ЭлементОбъект, стр);
				Продолжить;
			Иначе
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		ЭлементКоманда = ЭлементОбъект.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементКоманда, стр);
		
	КонецЦикла;
	
	
	Если ТребуетяОбвязкаПодключения=Истина Тогда
		мСцен_GenerateClientDisconnectionScript(ДеревоСценария);
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Функция СравнитьСтруктуры(Исходное,Сравниваемое)
	
	РезультатСравнения = Истина;
	
	Попытка
		Если Исходное.количество()<>Сравниваемое.Количество() Тогда
			РезультатСравнения = Ложь;
		Иначе
			Для каждого КлючИЗначение из Исходное Цикл
				Если КлючИЗначение.Значение <> Сравниваемое[КлючИЗначение.Ключ] Тогда
					РезультатСравнения = Ложь;
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	Исключение
		РезультатСравнения = Ложь;
	КонецПопытки;
	
	Возврат РезультатСравнения;
КонецФункции

&НаКлиенте
Функция ПреобразоватьНаименованиеДействия(Знач Наименование)
	
	Представление = Наименование;
	
	Если Наименование="find main window" Тогда
		Представление = "НайтиОсновноеОкно";
	ИначеЕсли Наименование="find window" Тогда
		Представление = "НайтиОкно";
	ИначеЕсли Наименование="find element" Тогда
		Представление = "НайтиОбъект";
	ИначеЕсли Наименование="command" Тогда
		Представление = "Команда";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаСервереБезКонтекста
Функция мСцен_ПолучитьДанныеКартинки_НаКлиенте(Узел) Экспорт
	
	Действие = "";
	ТипОбъекта = "";

	
	Попытка
		Действие = Узел.Действие;
		ТипОбъекта = Узел.ТипОбъекта;
	Исключение
	КонецПопытки;
	
	
	// Картинка в поле Картинка
	Если Действие = "" ИЛИ Действие = "UnknownNode" ИЛИ Действие = "НеизвестныйУзел" Тогда
		ДанныеКартинки = 1;
		
	ИначеЕсли Действие = "НайтиОкно" ИЛИ Действие = "НайтиОсновноеОкно" Тогда
		ДанныеКартинки = 2;
		
	ИначеЕсли Действие = "НайтиФорму" Тогда
		ДанныеКартинки = 3;
		
	ИначеЕсли Действие = "Команда" И (ТипОбъекта ="FormButton" ИЛИ ТипОбъекта = "CommandInterfaceButton") Тогда
		ДанныеКартинки = 4;
		
	ИначеЕсли Действие = "НайтиОбъект" Тогда
		ДанныеКартинки = 5;
		
	ИначеЕсли Действие = "Условие" Тогда
		ДанныеКартинки = 6;
		
	ИначеЕсли Действие = "Команда" Тогда
		ДанныеКартинки = 7;
		
	ИначеЕсли Действие = "ПолучитьКомандныйИнтерфейс" Тогда
		ДанныеКартинки = 8;
		
	ИначеЕсли Действие = "GenerateClientConnectionScript" ИЛИ Действие = "ПодключитьТестируемоеПриложение" Тогда
		ДанныеКартинки = 9;
		
	ИначеЕсли Действие = "ЗакрытьТестируемоеПриложение" ИЛИ Действие = "GenerateClientDisconnectionScript" Тогда
		ДанныеКартинки = 10;
		
	ИначеЕсли Действие = "Комментарий" Тогда
		ДанныеКартинки = 11;
		
	ИначеЕсли Действие = "ВыполнитьПроизвольныйКодСервер" Тогда
		ДанныеКартинки = 12;
		
	ИначеЕсли Действие = "ВыполнитьПроизвольныйКодКлиент" Тогда
		ДанныеКартинки = 13;
		
	ИначеЕсли Действие = "Стоп" Тогда
		ДанныеКартинки = 14;
		
	ИначеЕсли Действие = "Пауза" Тогда
		ДанныеКартинки = 15;
		
	ИначеЕсли Действие = "СравнитьСПредставлениемДанных" Тогда
		ДанныеКартинки = 16;
		
	ИначеЕсли Действие = "ПолучитьПредставлениеДанных" Тогда
		ДанныеКартинки = 17;
		
	ИначеЕсли Действие = "ГотовыйБлокШагов" Тогда
		ДанныеКартинки = 18;
		
	ИначеЕсли Действие = "ТестовыйСлучай" Тогда
		ДанныеКартинки = 19;
		
	ИначеЕсли Действие = "ДилогВыбораФайла" Тогда
		ДанныеКартинки = 0;
		
	ИначеЕсли Действие = "Timer" ИЛИ Действие = "Таймер" Тогда
		ДанныеКартинки = 20;		
		
	ИначеЕсли Действие = "ИзПараметра1ВПараметр2" Тогда
		ДанныеКартинки = 21;
		
	ИначеЕсли Действие = "ПроверкаНаличияЭлемента" Тогда
		ДанныеКартинки = 22;
		
	ИначеЕсли Действие = "ВызватьИсключение" ИЛИ Действие="ThrowExeption" Тогда
		ДанныеКартинки = 23;
		
	ИначеЕсли Действие = "СделатьСнимокОкна" ИЛИ Действие="MakeScreenShot" Тогда
		ДанныеКартинки = 24;
		
	ИначеЕсли Действие = "Память" ИЛИ Действие="Memory" Тогда
		ДанныеКартинки = 25;
		
	ИначеЕсли Действие = "Логика" ИЛИ Действие="Logic" Тогда
		ДанныеКартинки = 26;
		
	ИначеЕсли Действие = "ЦиклДляКаждого" ИЛИ Действие="OperatorForEach" Тогда
		ДанныеКартинки = 35;		
		
	КонецЕсли;
	
	Возврат ДанныеКартинки;
	
КонецФункции

&НаСервере
Процедура мСцен_ПреобразоватьВДеревоСценарияНаСервере(ТекстСценария,
		ДеревоСценария, мПараметры, ЭтоБуфер = Ложь) Экспорт
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьБиблиотеки()

	Если Модуль_СервисныеФункции = Неопределено Тогда
		Модуль_СервисныеФункции = ПолучитьФорму("ВнешняяОбработка.МенеджерСценарногоТеста.Форма.Модуль_СервисныеФункции");
	КонецЕсли;

КонецПроцедуры		

#Область ДополнительныеКоманды

&НаКлиенте
Процедура мСцен_GenerateClientConnectionScript(РодительВетка)
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеПоТегу("ПодключитьТестируемоеПриложение");
    ТекущаяВетка.Действие = "ПодключитьТестируемоеПриложение";
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(новый Структура("Действие,ТипОбъекта",ТекущаяВетка.Действие,""));
	ТекущаяВетка.API="AutomationUI";
	
КонецПроцедуры

&НаКлиенте
Процедура мСцен_GenerateClientDisconnectionScript(РодительВетка)
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеПоТегу("ЗакрытьТестируемоеПриложение");
    ТекущаяВетка.Действие = "ЗакрытьТестируемоеПриложение";
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(новый Структура("Действие,ТипОбъекта",ТекущаяВетка.Действие,""));
	ТекущаяВетка.API="AutomationUI";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция мСцен_ПолучитьНаименованиеПоТегу(ИмяТега)
	
	Представление = ИмяТега;
	
	Если ИмяТега="ClientApplicationWindow" Тогда
		Представление = "Окно клиентского приложения";
	ИначеЕсли ИмяТега = "Form" Тогда
		Представление = "Форма";
	ИначеЕсли ИмяТега = "CommandInterface" Тогда
		Представление = "Командный интерфейс";		
	ИначеЕсли ИмяТега = "FormField" Тогда
		Представление = "Поле формы";		
	ИначеЕсли ИмяТега = "FormTable" Тогда
		Представление = "Таблица формы";		
	ИначеЕсли ИмяТега = "FormDecoration" Тогда
		Представление = "Декорация формы";		
	ИначеЕсли ИмяТега = "FormButton" Тогда
		Представление = "Кнопка формы";		
	ИначеЕсли ИмяТега = "FormGroup" Тогда
		Представление = "Группа формы";		
	ИначеЕсли ИмяТега = "CommandInterfaceButton" Тогда
		Представление = "Кнопка командный интерфейс";		
	ИначеЕсли ИмяТега = "CommandInterfaceGroup" Тогда
		Представление = "Группа командный интерфейс";
		
	// служебные мои
	ИначеЕсли ИмяТега = "ПодключитьТестируемоеПриложение" Тогда
		Представление = "Подключение к тестируемому приложению";
	// служебные мои
	ИначеЕсли ИмяТега = "ЗакрытьТестируемоеПриложение" Тогда
		Представление = "Отключиться от тестируемого приложения";
		
		
		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	Иначе
		Представление = "Неопознанный узел";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции



#КонецОбласти
