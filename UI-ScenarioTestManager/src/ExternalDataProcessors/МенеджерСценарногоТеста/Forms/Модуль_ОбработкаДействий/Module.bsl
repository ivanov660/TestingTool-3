&НаКлиенте
Перем Модуль_СервисныеФункции;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры


#Область Команды

&НаКлиенте
Процедура мСценСкрипт_GenerateClientConnection(ТестовоеПриложение,ОписаниеОшибки,мПараметры) Экспорт
	
	СвойстваПодключенияКлиентаТестирования = мПараметры.СвойстваПодключенияКлиентаТестирования;
	ПараметрыСценария = мПараметры.ПараметрыСценария;
	НомерПорта = мПараметры.НомерПорта;
	Интервал = мПараметры.Интервал;
	
	ТестовоеПриложение = Неопределено;
	
	Если Найти(СвойстваПодключенияКлиентаТестирования,"&") Тогда
		ИмяПараметра = СокрЛП(СтрЗаменить(СвойстваПодключенияКлиентаТестирования,"&",""));
		СвойстваПодключенияКлиентаТестирования = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра,ПараметрыСценария);
	КонецЕсли;	
	
	Попытка
		ОписаниеПодключения = мЗначениеИзСтрокиВнутр(СвойстваПодключенияКлиентаТестирования);
		Если ТипЗнч(ОписаниеПодключения)=Тип("Соответствие") Тогда
			Если ОписаниеПодключения.Получить("НомерПорта")<>Неопределено Тогда
				НомерПорта = Число(ОписаниеПодключения.Получить("НомерПорта"));
			КонецЕсли;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	//Если ПуллТестируемыхПриложений=Неопределено Тогда
	//	ПуллТестируемыхПриложений = новый Соответствие;
	//Иначе
	//	ТестовоеПриложение = ПуллТестируемыхПриложений.Получить(НомерПорта);
	//КонецЕсли; 	
	
	//Если НЕ ТестовоеПриложение=Неопределено Тогда
	//	Возврат;
	//КонецЕсли;     

	
	Выполнить("ТестовоеПриложение = Новый ТестируемоеПриложение(,НомерПорта,);");
	//ТестовоеПриложение = Новый ТестируемоеПриложение(,НомерПорта,);
	Если Интервал=0 Тогда
		Интервал = 50;
	КонецЕсли;
	ВремяОкончанияОжидания = ТекущаяДата() + Интервал;
	Подключен = Ложь;
	ОписаниеОшибкиСоединения = "";
	Пока Не ТекущаяДата() >= ВремяОкончанияОжидания Цикл
		Попытка
			ТестовоеПриложение.УстановитьСоединение();
			Подключен = Истина;
			Прервать;
		Исключение
			ОписаниеОшибкиСоединения = ОписаниеОшибки();
		КонецПопытки;
	КонецЦикла;
	Если Не Подключен Тогда
		ТестовоеПриложение = Неопределено;
		ОписаниеОшибки = "Не смогли установить соединение! " + Символы.ПС + ОписаниеОшибкиСоединения;
		Сообщить(ОписаниеОшибки);
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
	//ПуллТестируемыхПриложений.Вставить(НомерПорта,ТестовоеПриложение);

КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_GenerateClientDisconnection(ТестовоеПриложение, ОписаниеОшибки, мПараметры) Экспорт	
	
		
	ИнформацияОбОшибке = ТестовоеПриложение.ПолучитьТекущуюИнформациюОбОшибке();
	Если ИнформацияОбОшибке<>Неопределено Тогда
		Сообщить(НСтр("ru='Описание=';en='Description='") + ИнформацияОбОшибке.Описание + "'");
    	Сообщить(НСтр("ru='ИмяМодуля=';en='ModuleName='") + ИнформацияОбОшибке.ИмяМодуля + "'");
    	Сообщить(НСтр("ru='НомерСтроки=';en='LineNumber='") + ИнформацияОбОшибке.НомерСтроки + "'");
   		Сообщить(НСтр("ru='ИсходнаяСтрока=';en='SourceLine='") + ИнформацияОбОшибке.ИсходнаяСтрока + "'");
	КонецЕсли;
	
	ТестовоеПриложение.РазорватьСоединение();
	
	//Если НЕ ПуллТестируемыхПриложений=Неопределено Тогда
	//	// найдем и удалим это соединение
	//	Для каждого стр из ПуллТестируемыхПриложений Цикл
	//		Если ТестовоеПриложение=стр.Значение Тогда
	//			ПуллТестируемыхПриложений.Удалить(стр.Ключ);
	//			ТестовоеПриложение = Неопределено;
	//			Прервать;
	//		КонецЕсли;
	//	КонецЦикла;
	//КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_ПолучитьПредставлениеДанных(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,ТекущаяПеременная,мПараметры,ПараметрыСценария) Экспорт
	
	ПредставлениеДанных = мПараметры.ПредставлениеДанных;
	ИмяПараметра = мПараметры.ИмяПараметра;
	ЗначениеПараметра = мПараметры.ЗначениеПараметра;

	
	Попытка
		Если ТекущаяПеременная=Неопределено Тогда
			ОписаниеОшибки = "Переменная не задана";
			ВызватьИсключение ОписаниеОшибки;
		Иначе
			Если ТекущаяПеременная.Вид=ВидПоляФормы.ПолеВвода Тогда
				ПредставлениеДанных = ТекущаяПеременная.ПолучитьТекстРедактирования();
			ИначеЕсли ТекущаяПеременная.Вид=ВидПоляФормы.ПолеТабличногоДокумента Тогда
				ПредставлениеДанных = ТекущаяПеременная.ПолучитьТекстОбласти();
			ИначеЕсли ТекущаяПеременная.Вид=ВидКнопкиФормы.Гиперссылка
			 ИЛИ ТекущаяПеременная.Вид=ВидКнопкиФормы.КнопкаКоманднойПанели
			 ИЛИ ТекущаяПеременная.Вид=ВидКнопкиФормы.ОбычнаяКнопка
			 ИЛИ ТекущаяПеременная.Вид=ВидКнопкиФормы.ГиперссылкаКоманднойПанели
			Тогда
				ПредставлениеДанных = ТекущаяПеременная.ТекстЗаголовка;
			Иначе
				ПредставлениеДанных = ТекущаяПеременная.ПолучитьПредставлениеДанных();
			КонецЕсли;
			мПараметрыКлиент.Вставить("ПоследнееПредставлениеДанных",ПредставлениеДанных);
			ЗначениеПараметра = ПредставлениеДанных; 
			мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ЗначениеПараметра,ПараметрыСценария);
		КонецЕсли; 	
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
	мПараметры.ПредставлениеДанных = ПредставлениеДанных;
	мПараметры.ЗначениеПараметра = ЗначениеПараметра;
	
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_СравнитьСПредставлениемДанных(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,ТекущаяПеременная, мПараметры, ПараметрыСценария) Экспорт

	ЗагрузитьБиблиотеки();

	ПредставлениеДанных = мПараметры.ПредставлениеДанных;
	УсловиеСравнения 	= мПараметры.УсловиеСравнения;
	
	Попытка
		Если ТекущаяПеременная=Неопределено Тогда
			ОписаниеОшибки = "Переменная не задана";
		Иначе
			ТекущееПредставлениеДанных = Неопределено;
			
			Если ТекущаяПеременная.Вид=ВидПоляФормы.ПолеВвода Тогда
				ТекущееПредставлениеДанных = ТекущаяПеременная.ПолучитьТекстРедактирования();
			ИначеЕсли ТекущаяПеременная.Вид=ВидПоляФормы.ПолеТабличногоДокумента Тогда
				ТекущееПредставлениеДанных = ТекущаяПеременная.ПолучитьТекстОбласти();
			Иначе
				ТекущееПредставлениеДанных = ТекущаяПеременная.ПолучитьПредставлениеДанных();
			КонецЕсли;
			мПараметрыКлиент.Вставить("ПоследнееПредставлениеДанных",ТекущееПредставлениеДанных);
			
			// Если ПредставлениеДанных это параметр, то попробуем его найти
			ИмяПараметра = СокрЛП(СтрЗаменить(ПредставлениеДанных,"&",""));
			ПараметрПредставлениеДанных = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра,ПараметрыСценария);
			Если ПараметрПредставлениеДанных<>Неопределено Тогда
				ОжидаемоеЗначение = ПараметрПредставлениеДанных;
			Иначе
				ОжидаемоеЗначение = ПредставлениеДанных;
			КонецЕсли;
			
			ОписаниеОшибки = Модуль_СервисныеФункции.СравнитьСПредставлениемДанных(УсловиеСравнения, ОжидаемоеЗначение, ТекущееПредставлениеДанных);
			
			Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
				ВызватьИсключение ОписаниеОшибки;
			КонецЕсли;
			
		КонецЕсли; 	
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
	
КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_ExecuteCustomCodeClient(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,мПараметрыКлиентСервер,CustomCode) Экспорт
	
	Попытка
		Выполнить(CustomCode);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура мСценСкрипт_ExecuteCustomCodeServer(ОписаниеОшибки,мПараметрыКлиентСервер,CustomCode) Экспорт
	
	Попытка
		УстановитьБезопасныйРежим(Истина);
		Выполнить(CustomCode);
		УстановитьБезопасныйРежим(Ложь);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		УстановитьБезопасныйРежим(Ложь);
		ВызватьИсключение ОписаниеОшибки;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ОбработатьУсловие(ТестовоеПриложение,ОписаниеОшибки, Узел, ИмяПараметра, ИмяПараметра2, ЗначениеПараметра,УсловиеСравнения, ПараметрыСценария, ОсуществитьПереходСТекущегоШага) Экспорт
	
	ЗагрузитьБиблиотеки();

	ЗначениеПараметраТаблицыПараметров = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра, ПараметрыСценария);
	
	Если ЗначениеЗаполнено(ИмяПараметра2) Тогда
		ЗначениеПараметраТаблицыПараметров2 = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра2, ПараметрыСценария);
		РезультатСравенения = Модуль_СервисныеФункции.СравнитьСПредставлениемДанных(УсловиеСравнения, ЗначениеПараметраТаблицыПараметров2, ЗначениеПараметраТаблицыПараметров);
	Иначе
		РезультатСравенения = Модуль_СервисныеФункции.СравнитьСПредставлениемДанных(УсловиеСравнения, ЗначениеПараметра, ЗначениеПараметраТаблицыПараметров);
	КонецЕсли;

	// сравним
	Если НЕ ЗначениеЗаполнено(РезультатСравенения) Тогда
	// все хорошо продолжаем выполнение
	Иначе
	// переходим на следующий узел по уровню
		ОсуществитьПереходСТекущегоШага = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_setFileDialogResult(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиентСервер,filename) Экспорт
	
	ТестовоеПриложение.УстановитьРезультатДиалогаВыбораФайла(true,filename,10);
	
КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_НайтиОсновноеОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная, мПараметры) Экспорт
	
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	
	
	ТекущаяПеременная = Неопределено;
	КлиентсткиеОкнаТестируемогоПриложения = ТестовоеПриложение.ПолучитьПодчиненныеОбъекты();
	Для Каждого ТестируемоеОкно Из КлиентсткиеОкнаТестируемогоПриложения Цикл
		Если ТестируемоеОкно.Основное Тогда
			ТекущаяПеременная = ТестируемоеОкно;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ТекущаяПеременная=Неопределено Тогда
		ОписаниеОшибки = "Не нашли объект";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиОкно(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры) Экспорт
	
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	Интервал = мПараметры.Интервал;
	
	// пробуем искать по условию или "|" разделитель
	Если ИспользоватьВариантыПоиска=Истина Тогда
		МассивЗаголовковОбъектов = СтрРазделить(ЗаголовокОбъекта,"|",Ложь);
		
		Для ш=0 по МассивЗаголовковОбъектов.Количество()-1 Цикл
			
			ЗаголовокОбъекта = "";
			Если ш<МассивЗаголовковОбъектов.Количество() Тогда
				ЗаголовокОбъекта = СокрЛП(МассивЗаголовковОбъектов.Получить(ш));
			КонецЕсли;
			
			ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ЗаголовокОбъекта , , ?(Интервал=0,5,Интервал));
			
			Если НЕ ТекущаяПеременная=Неопределено Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе 	
		ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемоеОкноКлиентскогоПриложения"), ЗаголовокОбъекта , , ?(Интервал=0,5,Интервал));
	КонецЕсли;

	Если ТекущаяПеременная=Неопределено Тогда
		ОписаниеОшибки = "Не нашли окно";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиФорму(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры) Экспорт
	
	РодительПеременная = мПараметры.РодительПеременная;
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	Интервал = мПараметры.Интервал;
	
	// пробуем искать по условию или "|" разделитель
	Если ИспользоватьВариантыПоиска=Истина Тогда
		МассивЗаголовковОбъектов = СтрРазделить(ЗаголовокОбъекта,"|",Ложь);
		
		Для ш=0 по МассивЗаголовковОбъектов.Количество()-1 Цикл
			
			ЗаголовокОбъекта = "";
			Если ш<МассивЗаголовковОбъектов.Количество() Тогда
				ЗаголовокОбъекта = СокрЛП(МассивЗаголовковОбъектов.Получить(ш));
			КонецЕсли;
			
			ТекущаяПеременная = РодительПеременная.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокОбъекта,,?(Интервал=0,5,Интервал));
			
			Если НЕ ТекущаяПеременная=Неопределено Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе 		
		ТекущаяПеременная = РодительПеременная.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокОбъекта,,?(Интервал=0,5,Интервал));
	КонецЕсли;

	Если ТекущаяПеременная=Неопределено Тогда
		ОписаниеОшибки = "Не нашли форму";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура мСценСкрипт_ПолучитьКомандныйИнтерфейс(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,РодительПеременная) Экспорт
	
	ТекущаяПеременная = РодительПеременная.ПолучитьКомандныйИнтерфейс();

	Если ТекущаяПеременная=Неопределено Тогда
		ОписаниеОшибки = "Не нашли командный интерфейс";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_НайтиОбъект(ТестовоеПриложение,ОписаниеОшибки,ТекущаяПеременная,мПараметры) Экспорт
	
	ТипОбъекта = мПараметры.ТипОбъекта;
	РодительПеременная = мПараметры.РодительПеременная;
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИмяОбъекта = мПараметры.ИмяОбъекта;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска;
	Интервал = мПараметры.Интервал;
	
	Тип = "";
	
	Если ТипОбъекта="CommandInterfaceButton" Тогда
		Тип = "ТестируемаяКнопкаКомандногоИнтерфейса";
	ИначеЕсли ТипОбъекта="CommandInterfaceGroup" Тогда
		Тип = "ТестируемаяГруппаКомандногоИнтерфейса";
	ИначеЕсли ТипОбъекта="FormTable" Тогда
		Тип = "ТестируемаяТаблицаФормы";
	ИначеЕсли ТипОбъекта="FormField" Тогда
		Тип = "ТестируемоеПолеФормы";
	ИначеЕсли ТипОбъекта="FormGroup" Тогда
		Тип = "ТестируемаяГруппаФормы";  
	ИначеЕсли ТипОбъекта="FormButton" Тогда
		Тип = "ТестируемаяКнопкаФормы";  		
	ИначеЕсли ТипОбъекта="FormDecoration" Тогда
		Тип = "ТестируемаяДекорацияФормы";  		
	ИначеЕсли ТипОбъекта="" Тогда  // любой тип
		Тип = "";  		
	Иначе
		Тип = "Tested"+ТипОбъекта;
		Сообщить("ТипОбъекта: "+ТипОбъекта);
	КонецЕсли;	  
	
	// пробуем искать по условию или "|" разделитель
	Если ИспользоватьВариантыПоиска=Истина Тогда
		МассивИменОбъектов = СтрРазделить(ИмяОбъекта,"|",Ложь);
		МассивЗаголовковОбъектов = СтрРазделить(ЗаголовокОбъекта,"|",Ложь);
		
		Для ш=0 по Макс(МассивИменОбъектов.Количество(),МассивЗаголовковОбъектов.Количество())-1 Цикл
			
			ЗаголовокОбъекта = "";
			ИмяОбъекта = "";
			Если ш<МассивИменОбъектов.Количество() Тогда
				ИмяОбъекта = СокрЛП(МассивИменОбъектов.Получить(ш));
			КонецЕсли;			
			Если ш<МассивЗаголовковОбъектов.Количество() Тогда
				ЗаголовокОбъекта = СокрЛП(МассивЗаголовковОбъектов.Получить(ш));
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Тип) Тогда
				ТекущаяПеременная = РодительПеременная.НайтиОбъект(Тип(Тип), ?(ЗаголовокОбъекта<>"",ЗаголовокОбъекта,Неопределено),?(ИмяОбъекта<>"",ИмяОбъекта,Неопределено),?(Интервал=0,5,Интервал));
			Иначе
				ТекущаяПеременная = РодительПеременная.НайтиОбъект(,ЗаголовокОбъекта,,?(Интервал=0,5,Интервал));
			КонецЕсли;
			
			Если НЕ ТекущаяПеременная=Неопределено Тогда
				Прервать;
			КонецЕсли;
		
		КонецЦикла;
		
	Иначе 		
		Если ЗначениеЗаполнено(Тип) Тогда
			ТекущаяПеременная = РодительПеременная.НайтиОбъект(Тип(Тип), ?(ЗаголовокОбъекта<>"",ЗаголовокОбъекта,Неопределено),?(ИмяОбъекта<>"",ИмяОбъекта,Неопределено),?(Интервал=0,5,Интервал));
		Иначе
			ТекущаяПеременная = РодительПеременная.НайтиОбъект(,ЗаголовокОбъекта,,?(Интервал=0,5,Интервал));
		КонецЕсли;
	КонецЕсли;
	
	Если ТекущаяПеременная=Неопределено Тогда		
		ОписаниеОшибки = "Не нашли объект. Тип("+Тип+"). ЗаголовокОбъекта("+ЗаголовокОбъекта+")";
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ПроверкаНаличияЭлемента(ТестовоеПриложение, ОписаниеОшибки, мПараметры, ПараметрыСценария) Экспорт
	
	ТипОбъекта = мПараметры.ТипОбъекта;
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	ИмяОбъекта = мПараметры.ИмяОбъекта;
	ИмяПараметра = мПараметры.ИмяПараметра;
	ИспользоватьВариантыПоиска = мПараметры.ИспользоватьВариантыПоиска; 	
	
	ОбъектНайден = Ложь;
	ТекущаяПеременная = Неопределено;
	Тип = "";
	
	Если ТипОбъекта="Form" или ТипОбъекта="ClientApplicationWindow" Тогда
		
		// пробуем искать по условию или "|" разделитель
		Если ИспользоватьВариантыПоиска=Истина Тогда
			МассивЗаголовковОбъектов = СтрРазделить(ЗаголовокОбъекта,"|",Ложь);
			
			Для ш=0 по МассивЗаголовковОбъектов.Количество()-1 Цикл
				
				ЗаголовокОбъекта = "";
				Если ш<МассивЗаголовковОбъектов.Количество() Тогда
					ЗаголовокОбъекта = СокрЛП(МассивЗаголовковОбъектов.Получить(ш));
				КонецЕсли;
				
				ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокОбъекта);
				
				Если НЕ ТекущаяПеременная=Неопределено Тогда
					ОбъектНайден = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе 		
			ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип("ТестируемаяФорма"), ЗаголовокОбъекта);
			Если НЕ ТекущаяПеременная=Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		
		Если ТипОбъекта="CommandInterfaceButton" Тогда
			Тип = "ТестируемаяКнопкаКомандногоИнтерфейса";
		ИначеЕсли ТипОбъекта="CommandInterfaceGroup" Тогда
			Тип = "ТестируемаяГруппаКомандногоИнтерфейса";
		ИначеЕсли ТипОбъекта="FormTable" Тогда
			Тип = "ТестируемаяТаблицаФормы";
		ИначеЕсли ТипОбъекта="FormField" Тогда
			Тип = "ТестируемоеПолеФормы";
		ИначеЕсли ТипОбъекта="FormGroup" Тогда
			Тип = "ТестируемаяГруппаФормы";  
		ИначеЕсли ТипОбъекта="FormButton" Тогда
			Тип = "ТестируемаяКнопкаФормы";  		
		ИначеЕсли ТипОбъекта="FormDecoration" Тогда
			Тип = "ТестируемаяДекорацияФормы";  		
		ИначеЕсли ТипОбъекта="" Тогда  // любой тип
			Тип = "";  		
		Иначе
			Тип = "Tested"+ТипОбъекта;
			Сообщить("ТипОбъекта: "+ТипОбъекта);
		КонецЕсли;	  
		
		
		// пробуем искать по условию или "|" разделитель
		Если ИспользоватьВариантыПоиска=Истина Тогда
			МассивИменОбъектов = СтрРазделить(ИмяОбъекта,"|",Ложь);
			МассивЗаголовковОбъектов = СтрРазделить(ЗаголовокОбъекта,"|",Ложь);
			
			Для ш=0 по Макс(МассивИменОбъектов.Количество(),МассивЗаголовковОбъектов.Количество())-1 Цикл
				
				ЗаголовокОбъекта = "";
				ИмяОбъекта = "";
				Если ш<МассивИменОбъектов.Количество() Тогда
					ИмяОбъекта = СокрЛП(МассивИменОбъектов.Получить(ш));
				КонецЕсли;			
				Если ш<МассивЗаголовковОбъектов.Количество() Тогда
					ЗаголовокОбъекта = СокрЛП(МассивЗаголовковОбъектов.Получить(ш));
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Тип) Тогда
					ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип(Тип), ?(ЗаголовокОбъекта<>"",ЗаголовокОбъекта,Неопределено),?(ИмяОбъекта<>"",ИмяОбъекта,Неопределено));
				Иначе
					ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(,ЗаголовокОбъекта);
				КонецЕсли;
				
				Если НЕ ТекущаяПеременная=Неопределено Тогда
					ОбъектНайден = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
			
		Иначе 		
			Если ЗначениеЗаполнено(Тип) Тогда
				ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(Тип(Тип), ?(ЗаголовокОбъекта<>"",ЗаголовокОбъекта,Неопределено),?(ИмяОбъекта<>"",ИмяОбъекта,Неопределено));
			Иначе
				ТекущаяПеременная = ТестовоеПриложение.НайтиОбъект(,ЗаголовокОбъекта);
			КонецЕсли;
			Если НЕ ТекущаяПеременная=Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;		
		КонецЕсли;  	
		
	КонецЕсли;
	
	
	Значение = мСцен_ПолучитьЗначениеПараметра(ИмяПараметра,ПараметрыСценария);
	Если ТипЗнч(Значение)=Тип("Строка") Тогда
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,Строка(ОбъектНайден),ПараметрыСценария);
	ИначеЕсли ТипЗнч(Значение)=Тип("Число") Тогда
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,?(ОбъектНайден,1,0),ПараметрыСценария);	
	Иначе
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ОбъектНайден,ПараметрыСценария);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мСценСкрипт_ПерейтиКСтроке(ТестовоеПриложение,ОписаниеОшибки,ТипОбъекта,ТекущаяПеременная,РодительПеременная,ЗаголовокОбъекта,Direction,RowDescription,SwitchSelection,ПараметрыСценария) Экспорт
	
	ОписаниеСтроки = мЗначениеИзСтрокиВнутр(RowDescription);
	мНаправлениеПереходаКСтроке = Неопределено;
	
	Если ТипЗнч(ОписаниеСтроки)=Тип("Соответствие") Тогда
		Для каждого стр из ОписаниеСтроки Цикл
			Значение = стр.Значение;
			мСценСкрипт_ПодставитьЗначениеПараметра(Значение,ПараметрыСценария);
			ОписаниеСтроки.Вставить(стр.Ключ,Значение);
		КонецЦикла;
	КонецЕсли;
	
	Если Direction="Вверх" Тогда
		Выполнить("мНаправлениеПереходаКСтроке = НаправлениеПереходаКСтроке.Вверх;");
	Иначе
		Выполнить("мНаправлениеПереходаКСтроке = НаправлениеПереходаКСтроке.Вниз;");
	КонецЕсли;
	
	РезультатШага = ТекущаяПеременная.ПерейтиКСтроке(ОписаниеСтроки, мНаправлениеПереходаКСтроке,SwitchSelection);
	
	Если РезультатШага=Ложь Тогда
		ОписаниеОшибки = "Не нашли строку";
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция мЗначениеИзСтрокиВнутр(Значение) Экспорт
	Возврат ЗначениеИзСтрокиВнутр(Значение);
КонецФункции

&НаКлиенте
Процедура мСценСкрипт_ВыполнитьКоманду(ТестовоеПриложение,ОписаниеОшибки,мПараметрыКлиент,ТекущаяПеременная, мПараметры) Экспорт
	
	
	ИмяКоманды = мПараметры.ИмяКоманды;
	ТипОбъекта = мПараметры.ТипОбъекта;
	РодительПеременная = мПараметры.РодительПеременная;
	ЗаголовокОбъекта = мПараметры.ЗаголовокОбъекта;
	OutputText = мПараметры.OutputText;
	CommandRef = мПараметры.CommandRef;
	Presentation = мПараметры.Presentation;
	Direction = мПараметры.Direction;
	RowDescription = мПараметры.RowDescription;
	SwitchSelection = мПараметры.SwitchSelection;
	Cancel = мПараметры.Cancel;
	Area = мПараметры.Area;
	ИмяПараметра = мПараметры.ИмяПараметра;
	ЗначениеПараметра = мПараметры.ЗначениеПараметра;
	ПараметрыСценария = мПараметры.ПараметрыСценария;
	Интервал = мПараметры.Интервал;
	
	// простые команды без параметров
	Если ИмяКоманды = "Нажать" Тогда
		ТекущаяПеременная.Нажать();
	ИначеЕсли ИмяКоманды = "Активизировать" Тогда
		ТекущаяПеременная.Активизировать();
	ИначеЕсли ИмяКоманды = "Выбрать" Тогда
		ТекущаяПеременная.Выбрать();
	ИначеЕсли ИмяКоманды = "ВыбратьИзСпискаВыбора" Тогда
		ТекущаяПеременная.ВыбратьИзСпискаВыбора();		
	ИначеЕсли ИмяКоманды = "Закрыть" Тогда
		ТекущаяПеременная.Закрыть();		
	ИначеЕсли ИмяКоманды = "Создать" Тогда
		ТекущаяПеременная.Создать();
	ИначеЕсли ИмяКоманды = "Открыть" Тогда
		ТекущаяПеременная.Открыть(); 		
	ИначеЕсли ИмяКоманды = "Очистить" Тогда
		ТекущаяПеременная.Очистить();		
	ИначеЕсли ИмяКоманды = "ОтменитьРедактирование" Тогда
		ТекущаяПеременная.ОтменитьРедактирование();		
	ИначеЕсли ИмяКоманды = "УстановитьОтметку" ИЛИ ИмяКоманды = "SetCheck" Тогда
		ТекущаяПеременная.УстановитьОтметку();
	ИначеЕсли ИмяКоманды = "Развернуть" Тогда
		ТекущаяПеременная.Развернуть();		
	ИначеЕсли ИмяКоманды = "Свернуть" Тогда
		ТекущаяПеременная.Свернуть();		
	ИначеЕсли ИмяКоманды = "ОткрытьВыпадающийСписок" Тогда
		ТекущаяПеременная.ОткрытьВыпадающийСписок();	
	ИначеЕсли ИмяКоманды = "ЗакрытьВыпадающийСписок" Тогда
		ТекущаяПеременная.ЗакрытьВыпадающийСписок();
		
		
	ИначеЕсли ИмяКоманды = "ПерейтиКНачальнойСтранице" ИЛИ ИмяКоманды = "GotoStartPage" Тогда
		ТекущаяПеременная.ПерейтиКНачальнойСтранице();	
	ИначеЕсли ИмяКоманды = "ПерейтиКСледующемуОкну" ИЛИ ИмяКоманды = "GotoNextWindow" Тогда
		ТекущаяПеременная.ПерейтиКСледующемуОкну();	
	ИначеЕсли ИмяКоманды = "ПерейтиКПредыдущемуОкну" ИЛИ ИмяКоманды = "GotoPreviousWindow" Тогда
		ТекущаяПеременная.ПерейтиКПредыдущемуОкну();	
		
	ИначеЕсли ИмяКоманды = "ПерейтиНаУровеньВверх" ИЛИ ИмяКоманды = "GoOneLevelUp" Тогда
		ТекущаяПеременная.ПерейтиНаУровеньВверх();	
	ИначеЕсли ИмяКоманды = "ПерейтиНаУровеньВниз" ИЛИ ИмяКоманды = "GoOneLevelDown" Тогда
		ТекущаяПеременная.ПерейтиНаУровеньВниз();	
	ИначеЕсли ИмяКоманды = "ПерейтиКСледующемуЭлементу" ИЛИ ИмяКоманды = "GotoNextItem" Тогда
		ТекущаяПеременная.ПерейтиКСледующемуЭлементу();	
	ИначеЕсли ИмяКоманды = "ПерейтиКПредыдущемуЭлементу" ИЛИ ИмяКоманды = "GotoPreviousItem" Тогда
		ТекущаяПеременная.ПерейтиКПредыдущемуЭлементу();			
		
	ИначеЕсли ИмяКоманды = "УменьшитьЗначение" ИЛИ ИмяКоманды = "DecreaseValue" Тогда
		ТекущаяПеременная.УменьшитьЗначение();		
	ИначеЕсли ИмяКоманды = "УвеличитьЗначение" ИЛИ ИмяКоманды = "IncreaseValue" Тогда
		ТекущаяПеременная.УвеличитьЗначение();	
		
	ИначеЕсли ИмяКоманды = "НажатьНаГиперссылкуВФорматированнойСтроке" ИЛИ ИмяКоманды = "clickFormattedStringHyperlink" Тогда
		
		Попытка
			// если передано число?
			Число = Число(Presentation);
			Если XMLСтрока(Число)=Presentation Тогда
				Presentation = Число;
			КонецЕсли;
		Исключение
		КонецПопытки;
			
		ТекущаяПеременная.НажатьНаГиперссылкуВФорматированнойСтроке(Presentation);
		
		
	ИначеЕсли ИмяКоманды = "ПерейтиКДате" ИЛИ ИмяКоманды = "GotoDate" Тогда
		ТекущаяПеременная.ПерейтиКДате(XMLЗначение(Тип("Дата"), Presentation));
	ИначеЕсли ИмяКоманды = "ПерейтиКЗначению" ИЛИ ИмяКоманды = "GotoValue" Тогда
		ТекущаяПеременная.ПерейтиКЗначению(XMLЗначение(Тип("Число"), Presentation));
		
		//	работа с областью
	ИначеЕсли ИмяКоманды = "НачатьРедактированиеТекущейОбласти" ИЛИ ИмяКоманды = "BeginEditingCurrentArea" Тогда
		ТекущаяПеременная.НачатьРедактированиеТекущейОбласти();		
	ИначеЕсли ИмяКоманды = "УстановитьТекущуюОбласть" ИЛИ ИмяКоманды = "SetCurrentArea" Тогда
		Если НЕ ЗначениеЗаполнено(Area) Тогда
			ТекущаяПеременная.УстановитьТекущуюОбласть();
		Иначе
			ТекущаяПеременная.УстановитьТекущуюОбласть(Area);		
		КонецЕсли;
	ИначеЕсли ИмяКоманды = "ЗавершитьРедактированиеТекущейОбласти" ИЛИ ИмяКоманды = "EndEditingCurrentArea" Тогда
		ТекущаяПеременная.ЗавершитьРедактированиеТекущейОбласти(Cancel);		
	
		
		// работа со строками
	ИначеЕсли ИмяКоманды = "ДобавитьСтроку" ИЛИ ИмяКоманды = "AddRow" Тогда
		ТекущаяПеременная.ДобавитьСтроку();		
	ИначеЕсли ИмяКоманды = "УдалитьСтроку" ИЛИ ИмяКоманды = "DeleteRow" Тогда
		ТекущаяПеременная.УдалитьСтроку();		
	ИначеЕсли ИмяКоманды = "ВыделитьВсеСтроки" ИЛИ ИмяКоманды = "SelectAllRows" Тогда
		ТекущаяПеременная.ВыделитьВсеСтроки();	
	ИначеЕсли ИмяКоманды = "ИзменитьСтроку" ИЛИ ИмяКоманды = "ChangeRow" Тогда
		ТекущаяПеременная.ИзменитьСтроку();			
	ИначеЕсли ИмяКоманды = "ПерейтиКПервойСтроке" ИЛИ ИмяКоманды = "GotoFirstRow" Тогда
		ТекущаяПеременная.ПерейтиКПервойСтроке(SwitchSelection);	
	ИначеЕсли ИмяКоманды = "ПерейтиКПоследнейСтроке" ИЛИ ИмяКоманды = "GotoLastRow" Тогда
		ТекущаяПеременная.ПерейтиКПоследнейСтроке(SwitchSelection);	
	ИначеЕсли ИмяКоманды = "ПерейтиКСледующейСтроке" ИЛИ ИмяКоманды = "GotoNextRow" Тогда
		ТекущаяПеременная.ПерейтиКСледующейСтроке(SwitchSelection);	
	ИначеЕсли ИмяКоманды = "ПерейтиКПредыдущейСтроке" ИЛИ ИмяКоманды = "GotoPreviousRow" Тогда
		ТекущаяПеременная.ПерейтиКПредыдущейСтроке(SwitchSelection);	
	ИначеЕсли ИмяКоманды = "ЗакончитьРедактированиеСтроки" ИЛИ ИмяКоманды = "EndEditRow" Тогда
		ТекущаяПеременная.ЗакончитьРедактированиеСтроки(Cancel);	
	ИначеЕсли ИмяКоманды = "ПерейтиКСтроке" ИЛИ ИмяКоманды = "GotoRow" Тогда 
		мСценСкрипт_ПерейтиКСтроке(ТестовоеПриложение,ОписаниеОшибки,ТипОбъекта,ТекущаяПеременная,РодительПеременная,ЗаголовокОбъекта,Direction,RowDescription,SwitchSelection,ПараметрыСценария);
		
		
		

	// сложные команды с параметрами
	ИначеЕсли ИмяКоманды = "ВвестиТекст" Тогда
		ТекущаяПеременная.ВвестиТекст("" + OutputText + "");	
	ИначеЕсли ИмяКоманды = "ВыполнитьКоманду" Тогда
		ТекущаяПеременная.ВыполнитьКоманду("" + CommandRef + "");
	ИначеЕсли ИмяКоманды = "ВыполнитьВыборИзВыпадающегоСписка" ИЛИ ИмяКоманды = "ExecuteChoiceFromDropList" Тогда
		ТекущаяПеременная.ОжидатьФормированияВыпадающегоСписка();
		ТекущаяПеременная.ВыполнитьВыборИзВыпадающегоСписка("" + Presentation + "");
	ИначеЕсли ИмяКоманды = "ВыполнитьВыборИзМеню" ИЛИ ИмяКоманды = "ExecuteChoiceFromMenu" Тогда
		ТекущаяПеременная.ВыполнитьВыборИзМеню("" + Presentation + "");
	ИначеЕсли ИмяКоманды = "ВыполнитьВыборИзСпискаВыбора" ИЛИ ИмяКоманды = "ExecuteChoiceFromChoiceList" Тогда
		ТекущаяПеременная.ОжидатьФормированияВыпадающегоСписка();
		ТекущаяПеременная.ВыполнитьВыборИзСпискаВыбора("" + Presentation + "");
	ИначеЕсли ИмяКоманды = "ВыбратьВариант" ИЛИ ИмяКоманды = "SelectOption" Тогда 
		ТекущаяПеременная.ВыбратьВариант("" + Presentation + "");
		
	ИначеЕсли ИмяКоманды = "ЗакрытьПанельСообщенийПользователю" ИЛИ ИмяКоманды = "CloseUserMessagesPanel" Тогда
		ТекущаяПеременная.ЗакрытьПанельСообщенийПользователю();
	ИначеЕсли ИмяКоманды = "ПолучитьТекстыСообщенийПользователю" ИЛИ ИмяКоманды = "GetUserMessageTexts" Тогда
		МассивСообщений = ТекущаяПеременная.ПолучитьТекстыСообщенийПользователю();
		ТекстСообщения = "";
		Для каждого стр из МассивСообщений Цикл
			Если ТекстСообщения="" Тогда
				ТекстСообщения = стр;
			Иначе
				ТекстСообщения = ТекстСообщения+Символы.ПС+стр;
			КонецЕсли;
		КонецЦикла;
		ЗначениеПараметра = ТекстСообщения; 
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ЗначениеПараметра,ПараметрыСценария);		
	ИначеЕсли ИмяКоманды = "ПолучитьПредставлениеДанных" ИЛИ ИмяКоманды = "GetDataPresentation" Тогда
		ТекстСообщения = ТекущаяПеременная.ПолучитьТекстыСообщенийПользователю();
		ЗначениеПараметра = ТекстСообщения; 
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ЗначениеПараметра,ПараметрыСценария);
	ИначеЕсли ИмяКоманды = "ПолучитьТекстРедактирования" ИЛИ ИмяКоманды = "GetEditText" Тогда
		ТекстСообщения = ТекущаяПеременная.ПолучитьТекстРедактирования();
		ЗначениеПараметра = ТекстСообщения; 
		мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ЗначениеПараметра,ПараметрыСценария);

	ИначеЕсли ИмяКоманды = "УстановитьМаксимальноеВремяВыполненияДействия" Тогда
		ТестовоеПриложение.УстановитьМаксимальноеВремяВыполненияДействия(Интервал);
	ИначеЕсли ИмяКоманды = "ПолучитьТекущуюИнформациюОбОшибке" Тогда
		РезультатОбработки = ТестовоеПриложение.ПолучитьТекущуюИнформациюОбОшибке();
		Если НЕ РезультатОбработки=Неопределено Тогда
			ТекстСообщения = "Описание: "+РезультатОбработки.Описание+Символы.ПС
				+"ИмяМодуля: "+РезультатОбработки.ИмяМодуля+Символы.ПС
				+"НомерСтроки: "+РезультатОбработки.НомерСтроки+Символы.ПС 
				+"ИсходнаяСтрока: "+РезультатОбработки.ИсходнаяСтрока +Символы.ПС;
			ЗначениеПараметра = ТекстСообщения; 
			мСцен_УстановитьЗначениеПараметра(ИмяПараметра,ЗначениеПараметра,ПараметрыСценария);	
		КонецЕсли;
		
		
	КонецЕсли;

КонецПроцедуры






#КонецОбласти


#Область Вспомогательные

&НаКлиенте
Процедура ЗагрузитьБиблиотеки()
	
	Если Модуль_СервисныеФункции=Неопределено Тогда
		Модуль_СервисныеФункции = ПолучитьФорму("ВнешняяОбработка.МенеджерСценарногоТеста.Форма.Модуль_СервисныеФункции");
	КонецЕсли;		
	
КонецПроцедуры	

// Функция - Установить значение параметра
//
// Параметры:
//  ИмяПараметра		 - строка	 - Имя параметра, как в таблице параметров
//  ЗначениеПараметра	 - строка, булево, число, дата	 - Значение устанавливаемого параметра
// 
// Возвращаемое значение:
//  Булево - Истина, при удачной установке параметра; Ложь, в случае ошибки
//
&НаКлиенте
Функция мСцен_УстановитьЗначениеПараметра(Знач ИмяПараметра,ЗначениеПараметра,ПараметрыСценария) Экспорт
	
	РезультатОперации = Ложь;
	
	Для каждого стр из ПараметрыСценария Цикл
		Если ВРег(стр.Имя)=Врег(ИмяПараметра) Тогда
			стр.Значение = ЗначениеПараметра;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РезультатОперации;
	
КонецФункции

// Функция - Установить значение параметра
//
// Параметры:
//  ИмяПараметра		 - строка	 - Имя параметра, как в таблице параметров
// 
// 
// Возвращаемое значение:
//  Произвольный - в случае ошибки будет возврат Неопределено
//
&НаКлиенте
Функция мСцен_ПолучитьЗначениеПараметра(Знач ИмяПараметра,ПараметрыСценария) Экспорт
	
	Для каждого стр из ПараметрыСценария Цикл
		Если ВРег(стр.Имя)=Врег(ИмяПараметра) Тогда
			Возврат стр.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции


&НаКлиенте
Процедура мСценСкрипт_ПодставитьЗначениеПараметра(ПолеСтроки,ПараметрыСценария)
	
	Перем стр;
	МассивСовпадений = новый Массив;
	КешПеременных = новый Соответствие;	
	// обработка заголовка клиента с параметрами  &Параметр
	//Для каждого стр из ПараметрыСценария Цикл
	//	Если Найти(ПолеСтроки,"&"+стр.Имя) Тогда
	//		ПолеСтроки = СтрЗаменить(ПолеСтроки,"&"+стр.Имя,стр.Значение);
	//	КонецЕсли;
	//КонецЦикла;
	
	Если ПараметрыСценария=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// 1 запоминаем совпадения
	Для каждого стр из ПараметрыСценария Цикл
		Если Найти(ПолеСтроки,"&"+стр.Имя) Тогда
			//Структура = новый Структура("стр,длина",стр,СтрДлина(стр.Имя));
			МассивСовпадений.Добавить(стр.Имя);
			КешПеременных.Вставить(стр.Имя,стр);
		КонецЕсли;
	КонецЦикла;
	
	// 2 отлавливаем простые случаи
	Если МассивСовпадений.Количество()=0 Тогда	
		Возврат;
	ИначеЕсли МассивСовпадений.Количество()=1 Тогда
		стр = КешПеременных.Получить(МассивСовпадений[0]);
		ПолеСтроки = СтрЗаменить(ПолеСтроки,"&"+стр.Имя,стр.Значение);
		Возврат;
	КонецЕсли;
	
	// 3 сортируем по длине
	МассивСовпаденийПоУбыв = СортировкаСпискомЗначений(МассивСовпадений);
	Для каждого совпад из МассивСовпаденийПоУбыв Цикл
		стр = КешПеременных.Получить(совпад);
		Если стр<>Неопределено Тогда
			ПолеСтроки = СтрЗаменить(ПолеСтроки,"&"+стр.Имя,стр.Значение);
		КонецЕсли;
	КонецЦикла;

	

КонецПроцедуры

//Сортировка списком значений {---
Функция СортировкаСпискомЗначений(Знач Массив,Знач ПоВозрастанию=Ложь)	
	мСписокЗнч = Новый СписокЗначений;
	мСписокЗнч.ЗагрузитьЗначения(Массив);
	
	мСписокЗнч.СортироватьПоЗначению(?(ПоВозрастанию=Истина,НаправлениеСортировки.Возр,НаправлениеСортировки.Убыв));    
	Возврат мСписокЗнч.ВыгрузитьЗначения();
КонецФункции
//---}

#КонецОбласти