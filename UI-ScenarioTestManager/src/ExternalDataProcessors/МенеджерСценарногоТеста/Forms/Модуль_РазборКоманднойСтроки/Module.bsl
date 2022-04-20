
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // не открываем форму
КонецПроцедуры


&НаКлиенте
Функция РазобратьСтрокуКомандИзПараметраЗапуска(Знач КоманднаяСтрока,Знач ВыводитьСообщения=Ложь) Экспорт
	
	СтруктураРазбора = новый Структура();
	
	// 1) установим параметры по умолчанию
	СтруктураРазбора.Вставить("TestUI",Ложь);
	СтруктураРазбора.Вставить("ПутьККаталогу","");
	СтруктураРазбора.Вставить("ПутьКФайлу","");
	СтруктураРазбора.Вставить("РежимScreenShot","None");
	СтруктураРазбора.Вставить("ЭтоНеПредприятие1С",Ложь); // по дефолту считаем, что 1С
	
	
	
	// по заданию
	СтруктураРазбора.Вставить("НомерПроверки",0);  
	СтруктураРазбора.Вставить("ИмяЛога","");
	СтруктураРазбора.Вставить("ФорматФайлаОтчета","JUnitXML");
	
	// по менеджеру тестирования
	СтруктураРазбора.Вставить("НомерПорта",1538);
	СтруктураРазбора.Вставить("ПутьКИсполняемомуФайлу1С","");
		
	// по сценарию
	СтруктураРазбора.Вставить("ПутьККаталогуБиблиотекиСценариев","");   
	СтруктураРазбора.Вставить("ПутьККаталогуОтчетовВыполненияТестов","");
	СтруктураРазбора.Вставить("ТипФайлаСценария","XML");
	
	// параметры подключения к базе 1С     
	СтруктураРазбора.Вставить("ПутьПодключенияКлиентаТестирования","");
	СтруктураРазбора.Вставить("ФайловаяБаза",Ложь); 
	СтруктураРазбора.Вставить("Пароль1С",""); 
	СтруктураРазбора.Вставить("Пользователь1С",""); 
	СтруктураРазбора.Вставить("Пароль1С",""); 
	
	// режим агента
	СтруктураРазбора.Вставить("КаталогДляОбмена","");
	СтруктураРазбора.Вставить("ИдентификаторЭкземпляраАгента",""); 
	СтруктураРазбора.Вставить("РежимРаботаАгента",Ложь);
	
	// внешнее приложение
	СтруктураРазбора.Вставить("НомерПортаExternAutomationUI",8080);
	СтруктураРазбора.Вставить("ПутьКФайлуExternAutomationUI","");
	СтруктураРазбора.Вставить("АдресИнтернетExternAutomationUI","http://localhost");
	СтруктураРазбора.Вставить("Браузер","Chrome");
	
	// data driven test
	СтруктураРазбора.Вставить("DataDrivenTest",Ложь);
	СтруктураРазбора.Вставить("ПутьКФайлуДанных","");
	
	// TestID
	СтруктураРазбора.Вставить("TestID","");
	
	// ИспользуемыйAPI
	СтруктураРазбора.Вставить("ИспользуемыйAPI","1cClientApp");
	
	
	
	
	// 2) дробим на набор строк, первая пустая, если есть параметр
	КоманднаяСтрока = ПараметрЗапуска;
	// удалим переносы строки, для корректного разбора 
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,Символы.ПС," "); 	
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestUI",Символы.ПС+"TestUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestLogUI",Символы.ПС+"TestLogUI");	
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestLibDirUI",Символы.ПС+"TestLibDirUI");	
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestWorkDirUI",Символы.ПС+"TestWorkDirUI");	
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestConnectionStringUI",Символы.ПС+"TestConnectionStringUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestFileBase1CUI",Символы.ПС+"TestFileBase1CUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestUser1CUI",Символы.ПС+"TestUser1CUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestPass1CUI",Символы.ПС+"TestPass1CUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestPortUI",Символы.ПС+"TestPortUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestProg1C",Символы.ПС+"TestProg1C");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestParamProg1C",Символы.ПС+"TestParamProg1C");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestNumberUI",Символы.ПС+"TestNumberUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestReportNameUI",Символы.ПС+"TestReportNameUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestNumberUI",Символы.ПС+"TestNumberUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestReportFormatUI",Символы.ПС+"TestReportFormatUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestExchangeCatalogUI",Символы.ПС+"TestExchangeCatalogUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestExchangeID",Символы.ПС+"TestExchangeID");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestCommandUI",Символы.ПС+"TestCommandUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestPortExternAutomationUI",Символы.ПС+"TestPortExternAutomationUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestPathExternAutomationUI",Символы.ПС+"TestPathExternAutomationUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestUrlExternAutomationUI",Символы.ПС+"TestUrlExternAutomationUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestScreenShotUI",Символы.ПС+"TestScreenShotUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestIsNot1CEnterpriseUI",Символы.ПС+"TestIsNot1CEnterpriseUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestBrowserUI",Символы.ПС+"TestBrowserUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestDataDrivenUI",Символы.ПС+"TestDataDrivenUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestDataFileNameUI",Символы.ПС+"TestDataFileNameUI");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestID",Символы.ПС+"TestID");
	КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestDefaultAPIUI",Символы.ПС+"TestDefaultAPIUI");
	
	
	// 3) парсим командную строку
	Для Индекс = 1 По СтрЧислоСтрок(КоманднаяСтрока) Цикл
		Подстрока = СтрПолучитьСтроку(КоманднаяСтрока, Индекс);
		Если Найти(Подстрока,"TestUI") Тогда
			СтруктураРазбора.ПутьКФайлу = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestUI",""));
			СтруктураРазбора.TestUI = Истина;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestUI. Будет произведен автотест.");
				Сообщить(Подстрока);
			КонецЕсли;
						
		ИначеЕсли Найти(Подстрока,"TestNumberUI") Тогда
			
			Попытка
				СтруктураРазбора.НомерПроверки = Число(СтрЗаменить(СтрЗаменить(Подстрока,"TestNumberUI",""),Символы.НПП,""));
				Если ВыводитьСообщения=Истина Тогда
					Сообщить("Обнаружен параметр номера проверки TestNumberUI. ");
					Сообщить(Подстрока);				
				КонецЕсли;
			Исключение
				Если ВыводитьСообщения=Истина Тогда
					Сообщить("Ошибка определения номера проверки. Установлен по умолчанию 0.");
					Сообщить(ОписаниеОшибки());
				КонецЕсли;
			КонецПопытки; 				
			
		ИначеЕсли Найти(Подстрока,"TestLogUI") Тогда
			СтруктураРазбора.ПутьККаталогуОтчетовВыполненияТестов = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestLogUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestLogUI (директория выгрузки логов).");
				Сообщить(СтруктураРазбора.ПутьККаталогуОтчетовВыполненияТестов);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestLibDirUI") Тогда
			СтруктураРазбора.ПутьККаталогуБиблиотекиСценариев = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestLibDirUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestLibDirUI (директория библиотека сценариев).");
				Сообщить(СтруктураРазбора.ПутьККаталогуБиблиотекиСценариев);	
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestConnectionStringUI") Тогда
			СтруктураРазбора.ПутьПодключенияКлиентаТестирования = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestConnectionStringUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestConnectionStringUI (строка подялючения 1С).");
				Сообщить(СтруктураРазбора.ПутьПодключенияКлиентаТестирования);   			
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestFileBase1CUI") Тогда
			Значение = Врег(СокрЛП(СтрЗаменить(Подстрока,"TestFileBase1CUI","")));
			Если Значение=Врег("Истина") или Значение=Врег("True") или Значение=Врег("Да") или Значение=Врег("Yes") Тогда
				СтруктураРазбора.ФайловаяБаза = Истина;
			Иначе
				СтруктураРазбора.ФайловаяБаза = Ложь;
			КонецЕсли;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestFileBase1CUI (это файловая база?).");
				Сообщить(СтруктураРазбора.ФайловаяБаза);   			
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestIsNot1CEnterpriseUI") Тогда
			
			Значение = Врег(СокрЛП(СтрЗаменить(Подстрока,"TestIsNot1CEnterpriseUI","")));
			Если Значение=Врег("Истина") или Значение=Врег("True") или Значение=Врег("Да") или Значение=Врег("Yes") Тогда
				СтруктураРазбора.ЭтоНеПредприятие1С = Истина;
			Иначе
				СтруктураРазбора.ЭтоНеПредприятие1С = Ложь;
			КонецЕсли;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestIsNot1CEnterpriseUI (Это не предприятие 1С?).");
				Сообщить(СтруктураРазбора.ЭтоНеПредприятие1С);   			
			КонецЕсли;				
			
		ИначеЕсли Найти(Подстрока,"TestUser1CUI") Тогда
			СтруктураРазбора.Пользователь1С = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestUser1CUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestUser1CUI (имя пользователя базы 1С).");
				Сообщить(СтруктураРазбора.Пользователь1С);   			
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestPass1CUI") Тогда
			СтруктураРазбора.Пароль1С = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestPass1CUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestPass1CUI (пароль пользователя базы 1С).");
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestPortUI") Тогда
			Попытка
				СтруктураРазбора.НомерПорта = Число(СтрЗаменить(Подстрока,"TestPortUI",""));
				Если ВыводитьСообщения=Истина Тогда
					Сообщить("Обнаружена параметр запуска автотест TestPortUI (порт клиента тестирования).");
					Сообщить(СтруктураРазбора.НомерПорта);
				КонецЕсли;
			Исключение
				Если ВыводитьСообщения=Истина Тогда
					Сообщить("Ошибка в расшифровке порта. Установлен по умолчанию 1538!");
					Сообщить(ОписаниеОшибки());
				КонецЕсли;
			Конецпопытки;
			
		ИначеЕсли Найти(Подстрока,"TestReportNameUI") Тогда
			СтруктураРазбора.ИмяЛога = СокрЛП(СтрЗаменить(Подстрока,"TestReportNameUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestReportNameUI - имя отчета.");
				Сообщить(СтруктураРазбора.ИмяЛога);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestProg1C") Тогда
			СтруктураРазбора.ПутьКИсполняемомуФайлу1С = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestProg1C",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestProg1C (путь к исполняемому файлу 1С).");
				Сообщить(СтруктураРазбора.ПутьКИсполняемомуФайлу1С);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestParamProg1C") Тогда
			СтруктураРазбора.ПутьКИсполняемомуФайлу1С = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestParamProg1C",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestParamProg1C (дополнительные параметры запуска).");
				Сообщить(СтруктураРазбора.ПутьКИсполняемомуФайлу1С);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestReportFormatUI") Тогда
			СтруктураРазбора.ФорматФайлаОтчета =ОбработатьСтроку(СтрЗаменить(Подстрока,"TestReportFormatUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест TestReportFormatUI (дополнительные параметры запуска).");
				Сообщить(СтруктураРазбора.ФорматФайлаОтчета);
			КонецЕсли;
			Если СтруктураРазбора.ФорматФайлаОтчета="JUnitXML" или СтруктураРазбора.ФорматФайлаОтчета="AllureXML" Тогда
			Иначе
				СтруктураРазбора.ФорматФайлаОтчета = "JUnitXML";
				Если ВыводитьСообщения=Истина Тогда
					Сообщить("Неизвестный формат, установлен по умолчанию JUnitXML!");
				КонецЕсли;
			КонецЕсли;
			
			
		ИначеЕсли Найти(Подстрока,"TestPortExternAutomationUI") Тогда
			Попытка
				СтруктураРазбора.НомерПортаExternAutomationUI = Число(СтрЗаменить(СтрЗаменить(Подстрока,"TestPortExternAutomationUI",""),Символы.НПП,""));
			Исключение
			КонецПопытки;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска идентификатор экземпляра агента.");
				Сообщить(СтруктураРазбора.НомерПортаExternAutomationUI);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestPathExternAutomationUI") Тогда
			СтруктураРазбора.ПутьКФайлуExternAutomationUI = СокрЛП(СтрЗаменить(Подстрока,"TestPathExternAutomationUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска идентификатор экземпляра агента.");
				Сообщить(СтруктураРазбора.ПутьКФайлуExternAutomationUI);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestUrlExternAutomationUI")  ИЛИ Найти(Подстрока,"TestUrlExternalAutomationUI") Тогда
			ПутьСервис = Подстрока;
			ПутьСервис = СокрЛП(СтрЗаменить(ПутьСервис,"TestUrlExternAutomationUI",""));
			ПутьСервис = СокрЛП(СтрЗаменить(ПутьСервис,"TestUrlExternalAutomationUI",""));
			СтруктураРазбора.АдресИнтернетExternAutomationUI = ПутьСервис;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска идентификатор экземпляра агента.");
				Сообщить(СтруктураРазбора.АдресИнтернетExternAutomationUI);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestBrowserUI") Тогда
			СтруктураРазбора.Браузер = СокрЛП(СтрЗаменить(Подстрока,"TestBrowserUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр тип браузера по умолчанию.");
				Сообщить(СтруктураРазбора.Браузер);
			КонецЕсли;
			
			
		ИначеЕсли Найти(Подстрока,"TestScreenShotUI") Тогда
			СтруктураРазбора.РежимScreenShot = СокрЛП(СтрЗаменить(Подстрока,"TestScreenShotUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр ражима создания снимков экрана.");
				Сообщить(СтруктураРазбора.РежимScreenShot);
			КонецЕсли;	
				
			// Сбросим если не известный параметр
			Если НЕ (СтруктураРазбора.РежимScreenShot = "None"
					ИЛИ СтруктураРазбора.РежимScreenShot = "Errors"
					ИЛИ СтруктураРазбора.РежимScreenShot = "Actions"
					ИЛИ СтруктураРазбора.РежимScreenShot = "All") Тогда
				СтруктураРазбора.РежимScreenShot = "None";
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestDataDrivenUI") Тогда
			Значение = Врег(СокрЛП(СтрЗаменить(Подстрока,"TestDataDrivenUI","")));
			Если Значение=Врег("Истина") или Значение=Врег("True") или Значение=Врег("Да") или Значение=Врег("Yes") Тогда
				СтруктураРазбора.DataDrivenTest = Истина;
			Иначе
				СтруктураРазбора.DataDrivenTest = Ложь;
			КонецЕсли;
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска автотест DataDrivenTest ?.");
				Сообщить(СтруктураРазбора.DataDrivenTest);   			
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestDataFileNameUI") Тогда
			СтруктураРазбора.ПутьКФайлуДанных = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestDataFileNameUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска ПутьКФайлуДанных.");
				Сообщить(СтруктураРазбора.ПутьКФайлуДанных);
			КонецЕсли;
			
		ИначеЕсли Найти(Подстрока,"TestDefaultAPIUI") Тогда
			СтруктураРазбора.ИспользуемыйAPI = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestDefaultAPIUI",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска TestDefaultAPIUI.");
				Сообщить(СтруктураРазбора.ИспользуемыйAPI);
			КонецЕсли;
			
			// сбросим на по умолчанию если хз
			Если НЕ (СтруктураРазбора.ИспользуемыйAPI = "Selenium"
					ИЛИ СтруктураРазбора.ИспользуемыйAPI = "AutomationUI"
					ИЛИ СтруктураРазбора.ИспользуемыйAPI = "Automation UI"
					ИЛИ СтруктураРазбора.ИспользуемыйAPI = "1cClientApp") Тогда
				Сообщить("Не известный API сброс на по умолчанию '1cClientApp'");
				СтруктураРазбора.ИспользуемыйAPI = "1cClientApp";
			КонецЕсли; 
						
		ИначеЕсли Найти(Подстрока,"TestID") Тогда
			СтруктураРазбора.TestID = ОбработатьСтроку(СтрЗаменить(Подстрока,"TestID",""));
			Если ВыводитьСообщения=Истина Тогда
				Сообщить("Обнаружена параметр запуска TestID.");
				Сообщить(СтруктураРазбора.TestID);
			КонецЕсли;			
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураРазбора;
	
КонецФункции

&НаКлиенте
Функция ОбработатьСтроку(Знач Источник) Экспорт
	
	Ответ = СтрЗаменить(Источник,Символы.ПС,"");
	Ответ = СтрЗаменить(Ответ,Символы.ВК,"");
	Ответ = СтрЗаменить(Ответ,Символы.ПФ,"");
	Ответ = СокрЛП(Ответ);	
	
	Возврат Ответ;
	
КонецФункции