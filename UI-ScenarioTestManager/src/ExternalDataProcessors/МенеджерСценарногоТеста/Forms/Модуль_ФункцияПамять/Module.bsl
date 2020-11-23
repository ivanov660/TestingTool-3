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
Процедура мСценСкрипт_ОбработатьОперациюРаботыПамяти(ОписаниеОшибки,мПараметрыКлиент,мПараметры) Экспорт
	
	ИмяКоманды = нрег(мПараметры.ИмяКоманды);
	ИмяПараметра = мПараметры.ИмяПараметра;
	mKey = мПараметры.Key;
	Type = мПараметры.Type;
	ПараметрыПодключенияПоУмолчанию = мПараметры.ПараметрыПодключенияПоУмолчанию;
	FileName = мПараметры.FileName;
	СтруктураДанных = Неопределено;
	ПараметрыСценария = мПараметры.ПараметрыСценария;
	
	ПутьКФайлу = "";
	Если Type="TemporaryJSON" Тогда
		Файл = новый Файл(ПолучитьИмяВременногоФайла(".txt"));
		ПутьКФайлу = Файл.Путь + FileName + ?(Найти(ПутьКФайлу,"."),"",".txt");
	ИначеЕсли Type="CatalogJSON" Тогда
		ПутьКФайлу = FileName + ?(Найти(ПутьКФайлу,"."),"",".txt");;
	КонецЕсли;
	
	Если ИмяКоманды="запомнить" Тогда
		
		СтруктураДанных = новый Структура;
		МассивДанных = СтрРазделить(ИмяПараметра,",;:/\",Ложь);
		Для каждого ИмяСтрокой из МассивДанных Цикл
			Для каждого стр из ПараметрыСценария Цикл
				Если нрег(ИмяСтрокой)=нрег(стр.Имя) Тогда
					СтруктураДанных.Вставить(ИмяСтрокой,стр.Значение);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если Type="TemporaryJSON" ИЛИ Type="CatalogJSON" Тогда
			ЗаписатьПараметрыВФайлJSON(ПутьКФайлу,СтруктураДанных);	
		ИначеЕсли Type="1CBase" Тогда
			ЗаписатьПараметрыВБазу(ПутьКФайлу,СтруктураДанных);
		ИначеЕсли Type="1CConnectionProperty" Тогда
			ВызватьИсключение "Нельзя изменять параметры подключения из сценария! Исправьте сценарий тестирования.";
		ИначеЕсли Type="1CScenarioParametersFromBase" Тогда
			ВызватьИсключение "Нельзя изменять параметры сценариев из сценария! Исправьте сценарий тестирования.";
		КонецЕсли;
	ИначеЕсли ИмяКоманды="вспомнить" Тогда
		Если Type="TemporaryJSON" ИЛИ Type="CatalogJSON" Тогда
			СтруктураДанных = ПрочитатьПараметрыИзФайлаJSON(ПутьКФайлу,ИмяПараметра);
		ИначеЕсли Type="1CBase" Тогда
			СтруктураДанных = ПрочитатьПараметрыИзБазы(ПутьКФайлу,ИмяПараметра);
		ИначеЕсли Type="1CConnectionProperty" Тогда
			СтруктураДанных = ПрочитатьПараметрыПодключения(mKey,ИмяПараметра,ПараметрыПодключенияПоУмолчанию);			
		ИначеЕсли Type="1CScenarioParametersFromBase" Тогда
			СтруктураДанных = ПрочитатьПараметрыСценариевИзБазы(mKey,ИмяПараметра);			
		КонецЕсли;
		
		//сохраним в параметрах
		Если НЕ СтруктураДанных=Неопределено Тогда
			Для каждого  элемент из СтруктураДанных Цикл
				Для каждого стр из ПараметрыСценария Цикл
					Если нрег(элемент.Ключ)=нрег(стр.Имя) Тогда
						стр.Значение = Элемент.Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли ИмяКоманды="забыть" Тогда
		Если Type="TemporaryJSON" ИЛИ Type="CatalogJSON" Тогда
		ИначеЕсли Type="1CBase" Тогда
			УдалитьПараметрыИзБазы(ПутьКФайлу,ИмяПараметра);
		ИначеЕсли Type="1CConnectionProperty" Тогда
			ВызватьИсключение "Нельзя изменять параметры подключения из сценария! Исправьте сценарий тестирования.";
		ИначеЕсли Type="1CScenarioParametersFromBase" Тогда
			ВызватьИсключение "Нельзя изменять параметры сценариев из сценария! Исправьте сценарий тестирования.";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


#Область СохранениеЗагрузкаФайл

&НаКлиенте
Функция ПрочитатьПараметрыИзФайлаJSON(Знач ПутьКФайлу, Знач ПараметрыСтрокой) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	СоответствиеДанных = новый Соответствие;
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное! Исправьте сценарий тестирования.";
	КонецЕсли;
	
	ТекстДок = новый ТекстовыйДокумент;
	ТекстДок.Прочитать(ПутьКФайлу,КодировкаТекста.UTF8);
	ДанныеСтрокой = ТекстДок.ПолучитьТекст();
	ТекстДок  =Неопределено;
	
	СтруктураДанных = Модуль_СервисныеФункции.ОбработкаJSON(ДанныеСтрокой);
	
	Возврат СтруктураДанных;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьПараметрыВФайлJSON(Знач ПутьКФайлу, Знач СтруктураДанных) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	// 1. Загрузим что в файле
	МассивСтрок = новый Массив;
	Для каждого стр из СтруктураДанных Цикл
		МассивСтрок.Добавить(стр.Ключ);
	КонецЦикла;
	ПараметрыСтрокой = СтрСоединить(МассивСтрок,",");
	
	Файл = новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		ПолнаяСтруктураДанных = ПрочитатьПараметрыИзФайлаJSON(ПутьКФайлу,ПараметрыСтрокой);
	
		// 2. Дополним значениями
		Для каждого стр из СтруктураДанных Цикл
			ПолнаяСтруктураДанных.Вставить(стр.Ключ,стр.Значение);
		КонецЦикла;
	Иначе
		ПолнаяСтруктураДанных = СтруктураДанных;
	КонецЕсли;
	
	// 3. Сохраним
	Строка = Модуль_СервисныеФункции.ДанныеВJSONСтроку(ПолнаяСтруктураДанных);
	ТекстДок = новый ТекстовыйДокумент;
	ТекстДок.УстановитьТекст(Строка);
	ТекстДок.Записать(ПутьКФайлу,КодировкаТекста.UTF8);
	ТекстДок = Неопределено;	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПараметрыИзФайлаJSON(Знач ПутьКФайлу, Знач ПараметрыСтрокой) Экспорт
	
	ЗагрузитьБиблиотеки();
	
	СоответствиеДанных = новый Соответствие;
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное! Исправьте сценарий тестирования.";
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

#Область СохранениеЗагрузкаПамятьБазы

&НаКлиенте
Функция ПрочитатьПараметрыИзБазы(Знач Ключ, Знач ПараметрыСтрокой) Экспорт
	
	СоответствиеДанных = новый Соответствие;
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное! Исправьте сценарий тестирования.";
	КонецЕсли;
	
	Для каждого стр из МассивПараметров Цикл
		ИмяПараметра = СокрЛП(стр);
		Попытка		
			ЗначениеПараметра = ПланировщикЗаданийВызовСервера.ПолучитьЗначениеПользовательскойПеременной(Неопределено,ИмяПараметра,Ключ);
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			ВызватьИсключение ТекстОшибки;
		Конецпопытки;		
		Если ЗначениеПараметра=Неопределено Тогда
			ВызватьИсключение "Значение параметра '"+ИмяПараметра+"' отсутсвует в базе! Укажите их прежде и перезапустите тест!";
		КонецЕсли;
		СоответствиеДанных.Вставить(ИмяПараметра,ЗначениеПараметра);
	КонецЦикла;	
	
	Возврат СоответствиеДанных;
	
КонецФункции

&НаКлиенте
Процедура ЗаписатьПараметрыВБазу(Знач Ключ, Знач СоответсвиеДанных) Экспорт
	
	Для каждого стр из СоответсвиеДанных Цикл
		
		ИмяПараметра = стр.Ключ;
		ЗначениеПараметра = стр.Значение;
		Попытка		
			ПланировщикЗаданийВызовСервера.УстановитьЗначениеПользовательскойПеременной(Неопределено,ИмяПараметра,ЗначениеПараметра,Ключ);
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			ВызватьИсключение ТекстОшибки;
		Конецпопытки;
		
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПараметрыИзБазы(Знач Ключ, Знач ПараметрыСтрокой) Экспорт
	
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное! Исправьте сценарий тестирования.";
	КонецЕсли;
	
	Для каждого стр из МассивПараметров Цикл
		ИмяПараметра = СокрЛП(стр);
		Попытка		
			ПланировщикЗаданийВызовСервера.УдалитьЗначениеПользовательскойПеременной(Неопределено,ИмяПараметра,Ключ);
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			ВызватьИсключение ТекстОшибки;
		Конецпопытки;		
	КонецЦикла;	
	
КонецПроцедуры


#КонецОбласти

#Область ПараметрыПодключения

Функция ПрочитатьПараметрыПодключения(Знач Ключ, Знач ПараметрыСтрокой, Знач ПараметрыПодключенияПоУмолчанию) Экспорт
	
	СтруктураДанных = Неопределено;
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное!";
	КонецЕсли;
	
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Для загрузки параметров подключения допустимо указать только один параметр";
	КонецЕсли;
	
	ИмяПараметра = ПараметрыСтрокой;
	
	Попытка	
		СтруктураПодключения = ПланировщикЗаданийВызовСервера.ПолучитьДанныеПодключенияПользователяПоКлючу(Ключ,ИмяПараметра);
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		ВызватьИсключение ТекстОшибки;
	Конецпопытки;
	
	Если НЕ СтруктураПодключения=Неопределено Тогда
	
		ОписаниеСвойствПодключения = новый Соответствие;
		
		ОписаниеСвойствПодключения.Вставить("НастройкиПоУмолчанию",Ложь);
		ОписаниеСвойствПодключения.Вставить("СтрокаПодключения",СтруктураПодключения.СтрокаПодключения);
		ОписаниеСвойствПодключения.Вставить("ДополнительныеОпцииЗапуска",СтруктураПодключения.ДополнительныеОпцииЗапуска);
		ОписаниеСвойствПодключения.Вставить("ЭтоФайловаяБаза",СтруктураПодключения.ЭтоФайловаяБаза);
		ОписаниеСвойствПодключения.Вставить("НомерПорта",СтруктураПодключения.НомерПорта);
		ОписаниеСвойствПодключения.Вставить("ЭтоНеПредприятие1С",СтруктураПодключения.ЭтоНеПредприятие1С);
		ОписаниеСвойствПодключения.Вставить("Пароль1С",СтруктураПодключения.Пароль1С);
		ОписаниеСвойствПодключения.Вставить("Пользователь1С",СтруктураПодключения.Пользователь1С);
		ОписаниеСвойствПодключения.Вставить("API","1cClientApp");
		
		// Используем дефолтные параметры, которые пришли в командной строке или из настроек
		Если СтруктураПодключения.ПользовательНеУказан=Истина Тогда
			ОписаниеСвойствПодключения.Вставить("Пароль1С",ПараметрыПодключенияПоУмолчанию.Пароль1С);
			ОписаниеСвойствПодключения.Вставить("Пользователь1С",ПараметрыПодключенияПоУмолчанию.Пользователь1С);
		КонецЕсли;

		// Используем дефолтные параметры базы, которые пришли в командной строке или из настроек
		Если СтруктураПодключения.БазаНеУказана=Истина Тогда
			ОписаниеСвойствПодключения.Вставить("СтрокаПодключения",ПараметрыПодключенияПоУмолчанию.СтрокаПодключения);
			ОписаниеСвойствПодключения.Вставить("ДополнительныеОпцииЗапуска",ПараметрыПодключенияПоУмолчанию.ДополнительныеОпцииЗапуска);
			ОписаниеСвойствПодключения.Вставить("ЭтоФайловаяБаза",ПараметрыПодключенияПоУмолчанию.ЭтоФайловаяБаза);		
		КонецЕсли;
		
		СтруктураДанных = новый  Структура(ИмяПараметра,ЗначениеВСтрокуВнутр(ОписаниеСвойствПодключения));		
		
	КонецЕсли;	
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#Область ПараметрыСценариевИзБазы

Функция ПрочитатьПараметрыСценариевИзБазы(Знач Ключ, Знач ПараметрыСтрокой) Экспорт
	
	СоответствиеДанных = новый Соответствие;
	МассивПараметров = СтрРазделить(ПараметрыСтрокой,",;:/\",Ложь);
	Если МассивПараметров.Количество()=0 Тогда
		ВызватьИсключение "Имя параметров пустое или некорректное! Исправьте сценарий тестирования.";
	КонецЕсли;

	НормированнаяСтрокаПараметров = СтрСоединить(МассивПараметров,",");
	Попытка
		МассивДанных = СценарноеТестированиеВызовСервера.ПолучитьДанныеПараметровСценариевПоКлючу(Ключ,НормированнаяСтрокаПараметров);
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		ВызватьИсключение ТекстОшибки;
	Конецпопытки;
	
	Для каждого стр из МассивДанных Цикл
		ИмяПараметра = СокрЛП(стр.ИмяПараметра);		
		СоответствиеДанных.Вставить(ИмяПараметра,стр.Значение);
	КонецЦикла;
		
	НенайденныеПараметрыСтрокой = "";
	// проверим, что все параметры нашлись
	Для каждого стр из МассивПараметров Цикл
		Если СоответствиеДанных.Получить(стр)=Неопределено Тогда
			НенайденныеПараметрыСтрокой = НенайденныеПараметрыСтрокой + ?(НенайденныеПараметрыСтрокой="","",",") + стр;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ НенайденныеПараметрыСтрокой="" Тогда
		ВызватьИсключение "В базе данных отсутсвуют параметры: "+НенайденныеПараметрыСтрокой+". Укажите их прежде и перезапустите тест!";
	КонецЕсли; 
	
	Возврат СоответствиеДанных;
		
КонецФункции

#КонецОбласти


#Область Вспомогательные

&НаСервереБезКонтекста
Функция мЗначениеИзСтрокиВнутр(Строка)
	Возврат ЗначениеИзСтрокиВнутр(Строка);
КонецФункции

&НаКлиенте
Процедура ЗагрузитьБиблиотеки()
	
	Если Модуль_СервисныеФункции=Неопределено Тогда
		Модуль_СервисныеФункции = ПолучитьФорму("ВнешняяОбработка.МенеджерСценарногоТеста.Форма.Модуль_СервисныеФункции");
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти