&Наклиенте
Перем МассивСоотвествийПриложений;

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	АвтозагрузкаЛогов = Ложь;
	АвтоУдалениеФайловЛога = Ложь;
	АтоЗакрытие = Ложь;
	
	// Если запуск автозагрузки
	Если ЗначениеЗаполнено(ПараметрЗапуска) Тогда
		Сообщить("Обнаружены параметры автозапуска!");
		КоманднаяСтрока = СтрЗаменить(ПараметрЗапуска,"¶"," ");
		// удалим переносы строки, для корректного разбора 
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,Символы.ПС," "); 
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestLogUI",Символы.ПС+"TestLogUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestClientIdUI",Символы.ПС+"TestClientIdUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestNumberUI",Символы.ПС+"TestNumberUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestAssemblyUI",Символы.ПС+"TestAssemblyUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestConnectionStringUI",Символы.ПС+"TestConnectionStringUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestCloseUI",Символы.ПС+"TestCloseUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestDeleteLogUI",Символы.ПС+"TestDeleteLogUI");
		КоманднаяСтрока = СтрЗаменить(КоманднаяСтрока,"TestCatalogDeleteUI",Символы.ПС+"TestCatalogDeleteUI");
		
		Для Индекс = 1 По СтрЧислоСтрок(КоманднаяСтрока) Цикл
			Подстрока = СтрПолучитьСтроку(КоманднаяСтрока, Индекс);
			Если Найти(Подстрока,"TestLogUI") Тогда 				
				ПутьКЛогу = СокрЛП(СтрЗаменить(Подстрока,"TestLogUI",""));
				Если Найти(ПутьКЛогу,"*") Тогда
					МассивЧастей = новый Массив;
					Если Найти(ПутьКЛогу,"\") Тогда
						МассивЧастей = СтрРазделить(ПутьКЛогу+"","\",Истина);
					ИначеЕсли Найти(ПутьКЛогу,"/") Тогда
						МассивЧастей = СтрРазделить(ПутьКЛогу+"","/",Истина);
					КонецЕсли;
					Если МассивЧастей.Количество()=0 Тогда
						Возврат;
					КонецЕсли;
					ПутьКаталог = СтрЗаменить(ПутьКЛогу,МассивЧастей[МассивЧастей.Количество()-1],"");
					ШаблонПоиска = СтрЗаменить(ПутьКЛогу,ПутьКаталог,"");
					
					АвтозагрузкаЛогов = Истина;					
					
				Иначе
					//ЗагрузитьЛогПоПути(ПутьКЛогу);
					//ЗавершитьРаботуСистемы(Ложь);
				КонецЕсли;
			ИначеЕсли Найти(Подстрока,"TestNumberUI") Тогда
				
				Попытка
					НомерПроверкиПоУмоланию = Число(СокрЛП(СтрЗаменить(СтрЗаменить(Подстрока,"TestNumberUI",""),Символы.НПП,"")));
				Исключение
					Сообщить(ОписаниеОшибки());
				КонецПопытки;
				
			ИначеЕсли Найти(Подстрока,"TestAssemblyUI") Тогда
				
				Попытка 
					НомерСборки = Число(СокрЛП(СтрЗаменить(СтрЗаменить(Подстрока,"TestAssemblyUI",""),Символы.НПП,""))); 
				Исключение
					Сообщить(ОписаниеОшибки());
				КонецПопытки;
				
				
			ИначеЕсли  Найти(Подстрока,"TestConnectionStringUI") Тогда
				
				СтрокаПодключенияПоУмолчанию = СокрЛП(СтрЗаменить(Подстрока,"TestConnectionStringUI",""));
				
			ИначеЕсли  Найти(Подстрока,"TestClientIdUI") Тогда
				
				СтрокаПодключенияПоУмолчанию = СокрЛП(СтрЗаменить(Подстрока,"TestClientIdUI",""));
				
			ИначеЕсли Найти(Подстрока,"TestCloseUI") Тогда
				
				АтоЗакрытие = Истина;
				
			ИначеЕсли Найти(Подстрока,"TestDeleteLogUI") Тогда
				
				АвтоУдалениеФайловЛога = Истина;
				
			ИначеЕсли Найти(Подстрока,"TestCatalogDeleteUI") Тогда
				
				ПутьККаталогУдаления = СокрЛП(СтрЗаменить(Подстрока,"TestCatalogDeleteUI",""));
				
				Если НЕ ЗначениеЗаполнено(ПутьККаталогУдаления) Тогда
					СообщитьОбОшибке("ПриОткрытии","Путь какталога удаления пустой ("+ПутьККаталогУдаления+")",НомерСборки);
				КонецЕсли;
				
				Если НЕ Найти(ПутьКЛогу,ПутьККаталогУдаления) Тогда
					ПутьККаталогУдаления="";
					СообщитьОбОшибке("ПриОткрытии","Путь какталога удаления ("+ПутьККаталогУдаления+")не совпадает с путем файла лога ("+ПутьКЛогу+")",НомерСборки);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		
		
		Если АвтозагрузкаЛогов=Истина Тогда
			НачатьПоискФайлов(Новый ОписаниеОповещения("ВыборКаталогаЛоговТестированияЗавершение", ЭтаФорма), ПутьКаталог,ШаблонПоиска,Истина);
		Иначе
			ЗагрузитьЛогПоПути(ПутьКЛогу);
			
			Если АвтоУдалениеФайловЛога  = Истина Тогда
				Попытка
					// файлы отчетов
					УдалитьФайлы(ПутьКЛогу);
					// файлы картинок
					Для каждого стр из ТаблицаШагов Цикл
						Если ЗначениеЗаполнено(стр.Attachments) Тогда
							Файлы = СтрРазделить(стр.Attachments,Символы.ПС,Ложь );
							Для каждого файл из Файлы Цикл
								УдалитьФайлы(файл);
							КонецЦикла;
						КонецЕсли;
					КонецЦикла;
					
					Если ЗначениеЗаполнено(ПутьККаталогУдаления) Тогда
						УдалитьФайлы(ПутьККаталогУдаления);
					КонецЕсли;					
				Исключение
					ТекстОшибки = ОписаниеОшибки();
					СообщитьОбОшибке("ПриОткрытии",ТекстОшибки,НомерСборки);
				КонецПопытки;
			КонецЕсли;		
			
			Если АтоЗакрытие=Истина Тогда
				ЗавершитьРаботуСистемы(Ложь);
			КонецЕсли;		
		КонецЕсли;
	КонецЕсли;
	
	РежимПоискаИдентификатораКлиентаПриИзмененииФрагмент();
	РежимПоискаПроверкиПриИзмененииФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКаталогаЛоговТестированияЗавершение(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	ТаблицаТестов.Очистить();
	ТаблицаТестовыхСлучаев.Очистить();
	ТаблицаШагов.Очистить();
	
	Для каждого стр из НайденныеФайлы Цикл
		ЗагрузитьЛогПоПути(стр.ПолноеИмя);
		Если АвтоУдалениеФайловЛога  = Истина Тогда
			Попытка
				УдалитьФайлы(стр.ПолноеИмя);
			Исключение
				ТекстОшибки = ОписаниеОшибки();
				СообщитьОбОшибке("ВыборКаталогаЛоговТестированияЗавершение",ТекстОшибки,НомерСборки);
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
	Если АвтоУдалениеФайловЛога  = Истина Тогда
		Попытка
			Если ЗначениеЗаполнено(ПутьККаталогУдаления) Тогда
				УдалитьФайлы(ПутьККаталогУдаления);
			КонецЕсли;				
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			СообщитьОбОшибке("ВыборКаталогаЛоговТестированияЗавершение",ТекстОшибки,НомерСборки);
		КонецПопытки;
	КонецЕсли;
		
	Если АтоЗакрытие=Истина Тогда
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗагрузитьПоШаблону(Команда)
	Если Найти(ПутьКЛогу,"*") Тогда
		
		МассивЧастей = новый Массив;
		Если Найти(ПутьКЛогу,"\") Тогда
			МассивЧастей = СтрРазделить(ПутьКЛогу+"","\",Истина);
		ИначеЕсли Найти(ПутьКЛогу,"/") Тогда
			МассивЧастей = СтрРазделить(ПутьКЛогу+"","/",Истина);
		КонецЕсли;
		Если МассивЧастей.Количество()=0 Тогда
			Возврат;
		КонецЕсли;
		ПутьКаталог = СтрЗаменить(ПутьКЛогу,МассивЧастей[МассивЧастей.Количество()-1],"");
		ШаблонПоиска = СтрЗаменить(ПутьКЛогу,ПутьКаталог,"");
		
		НачатьПоискФайлов(Новый ОписаниеОповещения("ВыборКаталогаЛоговТестированияЗавершение", ЭтаФорма), ПутьКаталог,ШаблонПоиска,Истина);
	Иначе
		ТаблицаТестов.Очистить();
		ТаблицаТестовыхСлучаев.Очистить();
		ТаблицаШагов.Очистить();		
		ЗагрузитьЛогПоПути(ПутьКЛогу);
		//ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЛог(Команда)
	ТаблицаТестов.Очистить();
	ТаблицаТестовыхСлучаев.Очистить();
	ТаблицаШагов.Очистить();
	ЗагрузитьЛогПоПути(ПутьКЛогу);
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьЛогПоПути(ПутьКФайлу)
	Сообщение = "";
	МассивСоотвествийПриложений = новый Соответствие();
	Если ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML(ПутьКФайлу,Сообщение)=Ложь Тогда
		Возврат Ложь;
	КонецЕсли;
	// поместим приложения в хранилище значений
	НайтиПромежуточныеДанные();
	СформироватьТаблицуИерархии();
	НайтиСопоставленияСервер();
	ОбработатьДанныеСервер();
	АдресХранилищаПриложений = ПоместитьВоВременноеХранилище(МассивСоотвествийПриложений);
	ЗагрузитьДанныеНаСервер();
КонецФункции

&НаКлиенте
Процедура ПутьКЛогуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
	Диалог.Заголовок = "Выберите файл"; 
	Диалог.ПолноеИмяФайла = ""; 
	Фильтр = "XML-файл (*.xml)|*.xml"; 
	Диалог.Фильтр = Фильтр; 
	Если ЗначениеЗаполнено(ПутьКЛогу) Тогда
		Диалог.Каталог = ПолучитьКаталогПоПутиФайла(ПутьКЛогу);
	КонецЕсли;
	Диалог.МножественныйВыбор = Ложь; 
	ВыборФайлаОткрытияСтруктурыКонфигурации = новый ОписаниеОповещения("ВыборФайлаОткрытияСтруктурыКонфигурации",ЭтотОбъект);
	Диалог.Показать(ВыборФайлаОткрытияСтруктурыКонфигурации);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаОткрытияСтруктурыКонфигурации(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ПутьКЛогу = ВыбранныеФайлы[0]; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура НомерПроверкиПриИзменении(Элемент)
	НомерПроверкиПоУмоланию = НомерПроверки;
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаПриИзменении(Элемент)
	
КонецПроцедуры


#Область ЗагрузкаДанныхAllureИзФайла

&НаКлиенте
Функция ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML(ПутьКФайлуОтчета,Сообщение="") Экспорт
	
	// создаем схему и сохраняем
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xsd");
	СхемаAllure = ПолучитьМакетНаСервере("СхемаAllure");
	СхемаAllure.Записать(ИмяФайла);
	
	// создаем фабрику и читаем
	Фабрика = СоздатьФабрикуXDTO(ИмяФайла);
	Попытка
		
		ЧтениеXML = новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(ПутьКФайлуОтчета);
		ПакетОбъект = Фабрика.ПрочитатьXML(ЧтениеXML);	
		
		ЧтениеXML.Закрыть();
		
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		СообщитьОбОшибке("ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML",ТекстОшибки,НомерСборки);
		Возврат Ложь;	
	КонецПопытки;		
	
	стр_тест = ТаблицаТестов.Добавить();
	стр_тест.НомерСтроки = ТаблицаТестов.Количество();
	стр_тест.НаименованиеТеста = ПакетОбъект.name;
	Если НЕ ПакетОбъект.Свойства().Получить("title")=Неопределено Тогда
		стр_тест.ЗаголовокТеста = ПакетОбъект.title;
	Иначе
		стр_тест.ЗаголовокТеста = "";
	КонецЕсли;
	Если НЕ (ПакетОбъект.Свойства().Получить("start")=Неопределено ИЛИ 
		ПакетОбъект.Свойства().Получить("stop")=Неопределено) Тогда
		стр_тест.ВремяВыполнения = (ПакетОбъект.stop-ПакетОбъект.start)/1000;
		стр_тест.ДатаВыполенения = Дата('00010101000000')+ПакетОбъект.start/1000; 
		ВремяВыполнения = (ПакетОбъект.stop-ПакетОбъект.start)/1000;
		ДатаВыполенения = Дата('00010101000000')+ПакетОбъект.start/1000;
	Иначе
		стр_тест.ВремяВыполнения = 0;
	КонецЕсли;
	стр_тест.НомерПроверки = ?(ЗначениеЗаполнено(НомерПроверки),НомерПроверки,НомерПроверкиПоУмоланию);
	стр_тест.Проверка = ПроверкаСФормы; // дефолтные значения с формы
	стр_тест.ТестируемыйКлиент = ТестируемыйКлиентСФормы; // дефолтные значения с формы
	стр_тест.СтрокаПодключения = ?(ЗначениеЗаполнено(СтрокаПодключения),СтрокаПодключения,СтрокаПодключенияПоУмолчанию);
	//стр_тест.СерьезностьДефекта = ПолучитьСерьезностьДефектаПоПредставлению(ПакетОбъект.severity);
	
	
	
	// обрабатываем результат
	Попытка
		Если ТипЗнч(ПакетОбъект.test_cases.test_case)=Тип("СписокXDTO") Тогда
			Для каждого case из ПакетОбъект.test_cases.test_case Цикл
				
				ЗагрузитьТестовыеСлучаи(case, Фабрика,стр_тест.НомерСтроки);
				
			КонецЦикла;
		ИначеЕсли ТипЗнч(ПакетОбъект.test_cases.test_case)=Тип("ОбъектXDTO") Тогда
			
			case = ПакетОбъект.test_cases.test_case;
			ЗагрузитьТестовыеСлучаи(case, Фабрика,стр_тест.НомерСтроки);
			
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		СообщитьОбОшибке("ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML",ТекстОшибки,НомерСборки);
	КонецПопытки;
	
	// получим время из подчиненных, если не задано корневое
	Для каждого стр из ТаблицаТестов Цикл
		Если стр.ВремяВыполнения=0 Тогда
			мОтбор = новый Структура("Тест",стр.Тест);
			н_строки = ТаблицаТестовыхСлучаев.НайтиСтроки(мОтбор);
			Для каждого эл из н_строки Цикл
				стр.ВремяВыполнения = стр.ВремяВыполнения+эл.ВремяВыполнения;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	// удалим файл схемы
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		// не смогли удалить файл
		ТекстОшибки = ОписаниеОшибки();
		СообщитьОбОшибке("ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML",ТекстОшибки,НомерСборки);
		Сообщить(ТекстОшибки);
	КонецПопытки;
	
	РезультатЗагрузки = Истина;	
	
	
	Возврат РезультатЗагрузки;
КонецФункции


&НаКлиенте
Процедура ЗагрузитьТестовыеСлучаи(Знач case, Знач Фабрика, Знач НомерСтрокиВладельца)
	
	стр_тест_сл = ТаблицаТестовыхСлучаев.Добавить();
	стр_тест_сл.НомерСтроки = ТаблицаТестовыхСлучаев.Количество();
	стр_тест_сл.НомерСтрокиТестов = НомерСтрокиВладельца;
	стр_тест_сл.ТестовыйСлучай = case.name;
	Если НЕ case.Свойства().Получить("severity")=Неопределено Тогда
		стр_тест_сл.СерьезностьДефекта = ПолучитьСерьезностьДефектаПоПредставлению(case.severity);
	Иначе
		стр_тест_сл.СерьезностьДефекта = ПолучитьСерьезностьДефектаПоПредставлению("");
	КонецЕсли;
	стр_тест_сл.ВремяВыполнения = (case.stop-case.start)/1000;
	стр_тест_сл.ДатаВыполенения = Дата('00010101000000')+case.start/1000;
	стр_тест_сл.РезультатВыполнения = ПолучитьРезультатВыполненияПоПредставлению(case.status);
	
	Попытка
		Если НЕ case.Свойства().Получить("failure")=Неопределено Тогда
			стр_тест_сл.ОписаниеОшибки = case.failure.message;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	// загрузка шагов
	Если НЕ case.Свойства().Получить("Steps")=Неопределено Тогда
		Если ТипЗнч(case.Steps)=Тип("СписокXDTO") Тогда
			Если case.Steps.Свойства().Количество()<>0 Тогда
				ЗагрузитьШаги(Фабрика,case.Steps,стр_тест_сл.НомерСтроки,0);
			КонецЕсли;
		ИначеЕсли ТипЗнч(case.Steps)=Тип("ОбъектXDTO") Тогда
			ЗагрузитьШаги(Фабрика,case.Steps,стр_тест_сл.НомерСтроки,0);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаги(Знач Фабрика,Знач steps, Знач НомерСтрокиВладельца,Знач НомерСтрокиРодителя)
	
	Попытка
		
		ТипSteps = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "steps");
		ТипStep = Фабрика.Тип("urn:model.allure.qatools.yandex.ru", "step");
		СвойствоSteps = ТипStep.Свойства.Получить("steps"); 
		
		Если ТипЗнч(steps.step)=Тип("СписокXDTO") Тогда
			Для Каждого step из steps.step Цикл
				
				ЗагрузитьШагФрагмент(step, Фабрика, НомерСтрокиВладельца,НомерСтрокиРодителя);
				
			КонецЦикла;
		ИначеЕсли ТипЗнч(steps.step)=Тип("ОбъектXDTO") Тогда
			
			step = steps.step;			
			ЗагрузитьШагФрагмент(step, Фабрика, НомерСтрокиВладельца,НомерСтрокиРодителя);
			
		КонецЕсли;
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПриложениеВХранилище(Знач Ключ, Знач source, Знач type="jpg", Знач title="", Знач size=0)
	
	Попытка
		
		МассивПриложений = МассивСоотвествийПриложений.Получить(Ключ);
		
		Если МассивПриложений=Неопределено Тогда
			МассивПриложений = новый Массив;
		КонецЕсли;
		
		СтруктураПриложения = новый Структура("source,type,title,size,хранилище",source,type,title,size);
		Файл = новый Файл(source);
		Если Файл.ЭтоФайл() Тогда
			СтруктураПриложения.size = Файл.Размер();
			СтруктураПриложения.хранилище = новый ДвоичныеДанные(source);
			МассивПриложений.Добавить(СтруктураПриложения);
			МассивСоотвествийПриложений.Вставить(Ключ,МассивПриложений);
		Иначе
			СообщитьОбОшибке("ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML","Файл не обнаружен:"+source,НомерСборки);
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		СообщитьОбОшибке("ЗагрузитьОтчетВыполненияСценарногоТестированияФорматAllureXML",ТекстОшибки,НомерСборки);
		Сообщить(ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШагФрагмент(Знач step, Знач Фабрика, Знач НомерСтрокиВладельца,Знач НомерСтрокиРодителя)
	
	стр_шаг = ТаблицаШагов.Добавить();
	стр_шаг.НомерСтрокиСлучаев = НомерСтрокиВладельца;
	стр_шаг.НомерСтроки = ТаблицаШагов.Количество();
	стр_шаг.НомерСтрокиРодителя = НомерСтрокиРодителя;
	стр_шаг.Шаг = step.name;
	стр_шаг.ПредставлениеШага = step.title;
	стр_шаг.ВремяВыполнения = (step.stop-step.start)/1000;
	стр_шаг.ДатаВыполенения = Дата('00010101000000')+step.start/1000;
	стр_шаг.РезультатВыполнения = ПолучитьРезультатВыполненияПоПредставлению(step.status);
	стр_шаг.НомерПопорядку = стр_шаг.НомерСтроки;
	стр_шаг.Attachments = "";
	
	// проверим приложения
	Если ТипЗнч(step.attachments) = Тип("ОбъектXDTO") Тогда
		Попытка
			Если ТипЗнч(step.attachments.attachment) = Тип("ОбъектXDTO") Тогда
				стр_шаг.ЕстьПриложение = Истина;
				стр_шаг.Attachments = step.attachments.attachment.source;
				ЗагрузитьПриложениеВХранилище(стр_шаг.НомерСтроки, step.attachments.attachment.source, step.attachments.attachment.type);
			ИначеЕсли ТипЗнч(step.attachments.attachment) = Тип("СписокXDTO") Тогда
				Для каждого attach из step.attachments.attachment Цикл
					стр_шаг.Attachments = стр_шаг.Attachments + attach.source + Символы.ПС;
					ЗагрузитьПриложениеВХранилище(стр_шаг.НомерСтроки, attach.source, attach.type);
				КонецЦикла;
				стр_шаг.ЕстьПриложение = Истина;
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	// если имя шага закодировано, тогда получим номер
	Если Лев(СокрЛП(стр_шаг.Шаг),1)="№" Тогда
		Попытка
			КодированнйШаг = СтрЗаменить(стр_шаг.Шаг," ",Символы.ПС);
			Если СтрЧислоСтрок(КодированнйШаг)>0 Тогда
				стр_шаг.НомерШага = Число(СтрЗаменить(СтрПолучитьСтроку(КодированнйШаг, 1),"№",""));
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Попытка
		Если step.steps.Свойства().Количество()<>0 Тогда
			ЗагрузитьШаги(Фабрика,step.steps,НомерСтрокиВладельца,стр_шаг.НомерСтроки);
		Иначе
			стр_шаг.НетПодчиненных = Истина;
		КонецЕсли;
	Исключение
		стр_шаг.НетПодчиненных = Истина;
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСерьезностьДефектаПоПредставлению(Знач severity)
	
	СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.ПустаяСсылка");
	
	
	Если severity="blocker" Тогда
		СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.Блокирующая");
	ИначеЕсли severity="critical" Тогда
		СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.Критическая");
	ИначеЕсли severity="normal" Тогда
		СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.Значительная");
	ИначеЕсли severity="minor" Тогда
		СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.Незначительная");
	ИначеЕсли severity="trivial" Тогда
		СерьезностьДефекта = ПредопределенноеЗначение("Перечисление.ВариантыСерьезностиДефектов.Тривиальная");
	КонецЕсли;
	
	
	Возврат СерьезностьДефекта;
	
	
КонецФункции

&НаКлиенте
Функция ПолучитьРезультатВыполненияПоПредставлению(Знач severity)
	
	РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.ПустаяСсылка");
	
	
	Если severity="failed" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Провал");
	ИначеЕсли severity="broken" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Ошибка");
	ИначеЕсли severity="passed" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Успешно");
	ИначеЕсли severity="skipped" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Пропуск");
	ИначеЕсли severity="canceled" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Пропуск");
	ИначеЕсли severity="pending" Тогда
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Неопределено");
	Иначе
		РезультатВыполнения = ПредопределенноеЗначение("Перечисление.РезультатыВыполненияШагов.Неопределено");
	КонецЕсли;
	
	
	Возврат РезультатВыполнения;
	
	
КонецФункции

// Функция - Получить макет на сервере
//
// Параметры:
//  ИмяМакета	 - строка	 - имя макета
// 
// Возвращаемое значение:
// макет  - макет
//
&НаСервере
Функция ПолучитьМакетНаСервере(ИмяМакета)
	Макет = Неопределено;
	Попытка
		ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
		Макет = ОбработкаОбъект.ПолучитьМакет(ИмяМакета);
	Исключение
		Сообщить(ОписаниеОшибки());		
	КонецПопытки;
	Возврат Макет;
КонецФункции

#КонецОбласти

&НаСервереБезКонтекста
Функция ПреобразоватьСтрокуВДату(Знач ДатаСтрокой)
	Дата = Дата('00010101000000');
	Попытка
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,"-","");
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,"T","");
		ДатаСтрокой = СтрЗаменить(ДатаСтрокой,":","");
		Дата = Дата(ДатаСтрокой);
	Исключение
		Возврат Дата('00010101000000');
	КонецПопытки;
	Возврат Дата;
КонецФункции

#Область ОбработкаДанных

&НаКлиенте
Процедура НайтиПромежуточныеДанные()
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТаблицуИерархии()
	
	Для каждого стр из ТаблицаШагов Цикл
		стр.Ключ 			= стр.НомерСтроки;
		стр.КлючРодителя 	= стр.НомерСтрокиРодителя;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НайтиСопоставленияСервер()
	
	
	КешТестов = новый Соответствие;
	КешПроверок = новый Соответствие;
	КешТестируемыхКлиентов = новый Соответствие;
	
	Для каждого стр из ТаблицаТестов Цикл
		
		Если НЕ ЗначениеЗаполнено(стр.Проверка) Тогда 		
			
			Проверка = КешПроверок.Получить(стр.НомерПроверки);
			
			Если Проверка=Неопределено Тогда
				
				Запрос = новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	Т.Ссылка
				|ИЗ
				|	Справочник.Проверки КАК Т
				|ГДЕ
				|	Т.Код = &НомерПроверки";
				Запрос.УстановитьПараметр("НомерПроверки",стр.НомерПроверки);
				РезультатЗапроса = Запрос.Выполнить();
				Если НЕ РезультатЗапроса.Пустой() Тогда
					Выборка = РезультатЗапроса.Выбрать();
					Если Выборка.Следующий() Тогда
						Проверка = Выборка.Ссылка;
					КонецЕсли;
				КонецЕсли;
				
				Если Проверка=Неопределено Тогда
					Проверка = Справочники.Проверки.ПустаяСсылка();			
				КонецЕсли;
				
				КешПроверок.Вставить(стр.НомерПроверки,Проверка);
				стр.Проверка = Проверка;
				
			Иначе
				стр.Проверка = Проверка;
			КонецЕсли;
			
		КонецЕсли;
		
		Тест = КешТестов.Получить(стр.НаименованиеТеста);
		
		Если Тест = Неопределено Тогда
			
			Запрос = новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	Т.Ссылка КАК Ссылка,
			|	0 КАК Порядок
			|ИЗ
			|	Справочник.Тесты КАК Т
			|ГДЕ
			|	Т.Наименование = &Наименование
			|	И &Наименование <> """"
			|	И НЕ Т.ПометкаУдаления
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ ПЕРВЫЕ 1
			|	Т.Ссылка,
			|	1
			|ИЗ
			|	Справочник.Тесты КАК Т
			|ГДЕ
			|	Т.Наименование = &Заголовок
			|	И &Заголовок <> """"
			|	И НЕ Т.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	Порядок";
			Запрос.УстановитьПараметр("Наименование",стр.НаименованиеТеста);
			Запрос.УстановитьПараметр("Заголовок",стр.ЗаголовокТеста);
			РезультатЗапроса = Запрос.Выполнить();
			Если НЕ РезультатЗапроса.Пустой() Тогда
				Выборка = РезультатЗапроса.Выбрать();
				Если Выборка.Следующий() Тогда
					Тест = Выборка.Ссылка;
				КонецЕсли;
			КонецЕсли;
			
			Если Тест=Неопределено Тогда
				Тест = Справочники.Тесты.ПустаяСсылка();				
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(Тест) Тогда
				Тест = стр.НаименованиеТеста;
			КонецЕсли;
			КешТестов.Вставить(стр.НаименованиеТеста,Тест);
			стр.Тест = Тест;
			
		Иначе
			стр.Тест = Тест;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(стр.ТестируемыйКлиент) Тогда
			
			ТестируемыйКлиент = КешТестируемыхКлиентов.Получить(стр.СтрокаПодключения);
			
			Если ТестируемыйКлиент= Неопределено Тогда
				
				// сначала ищем по имени, а потом по строке подключения
				Запрос = новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
				|	Т.Ссылка,
				|	0 КАК Порядок
				|ИЗ
				|	Справочник.ТестируемыеКлиенты КАК Т
				|ГДЕ
				|	НЕ Т.ПометкаУдаления
				|	И Т.ID=&СтрокаПодключения
				|
				|ОБЪЕДИНИТЬ ВСЕ
				|
				|ВЫБРАТЬ ПЕРВЫЕ 1
				|	Т.Ссылка,
				|	1
				|ИЗ
				|	Справочник.ТестируемыеКлиенты КАК Т
				|ГДЕ
				|	НЕ Т.ПометкаУдаления
				|	И Т.База1С.ВариантыСтрокПодключения ПОДОБНО ""%"" + &СтрокаПодключения + ""%""
				|
				|УПОРЯДОЧИТЬ ПО
				|	Порядок";
				Запрос.УстановитьПараметр("СтрокаПодключения",стр.СтрокаПодключения);
				РезультатЗапроса = Запрос.Выполнить();
				Если НЕ РезультатЗапроса.Пустой() Тогда
					Выборка = РезультатЗапроса.Выбрать();
					Если Выборка.Следующий() Тогда
						ТестируемыйКлиент = Выборка.Ссылка;
					КонецЕсли;
				КонецЕсли;
				
				Если ТестируемыйКлиент=Неопределено Тогда
					ТестируемыйКлиент = Справочники.ТестируемыеКлиенты.ПустаяСсылка();				
				КонецЕсли;
				
				КешТестируемыхКлиентов.Вставить(стр.СтрокаПодключения,ТестируемыйКлиент);
				стр.ТестируемыйКлиент = ТестируемыйКлиент;			
				
			Иначе
				стр.ТестируемыйКлиент = ТестируемыйКлиент;
			КонецЕсли; 		
		КонецЕсли; 		
		
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДанныеСервер()
	
	ЦенаРезультата = новый Соответствие;
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.ПустаяСсылка(),-1);
	ЦенаРезультата.Вставить(Неопределено,-1);
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.Неопределено,-1);
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.Пропуск,0);
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.Успешно,1);
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.Ошибка,2);
	ЦенаРезультата.Вставить(Перечисления.РезультатыВыполненияШагов.Провал,3);
	
	// обратная цена
	ОбратнаяЦена = новый Соответствие;
	ОбратнаяЦена.Вставить(-1,Перечисления.РезультатыВыполненияШагов.Неопределено);
	ОбратнаяЦена.Вставить(0,Перечисления.РезультатыВыполненияШагов.Пропуск);
	ОбратнаяЦена.Вставить(1,Перечисления.РезультатыВыполненияШагов.Успешно);
	ОбратнаяЦена.Вставить(2,Перечисления.РезультатыВыполненияШагов.Ошибка);
	ОбратнаяЦена.Вставить(3,Перечисления.РезультатыВыполненияШагов.Провал);
	
	ЦенаСерьезности = новый Соответствие;
	ЦенаСерьезности.Вставить(Неопределено,-1);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.ПустаяСсылка(),-1);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.Тривиальная,0);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.Незначительная,1);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.Значительная,2);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.Критическая,3);
	ЦенаСерьезности.Вставить(Перечисления.ВариантыСерьезностиДефектов.Блокирующая,4);
	
	ОбратнаяЦенаСерьезности = новый Соответствие;
	ОбратнаяЦенаСерьезности.Вставить(-1,Перечисления.ВариантыСерьезностиДефектов.ПустаяСсылка());
	ОбратнаяЦенаСерьезности.Вставить(0,Перечисления.ВариантыСерьезностиДефектов.Тривиальная);
	ОбратнаяЦенаСерьезности.Вставить(1,Перечисления.ВариантыСерьезностиДефектов.Критическая);
	ОбратнаяЦенаСерьезности.Вставить(2,Перечисления.ВариантыСерьезностиДефектов.Значительная);
	ОбратнаяЦенаСерьезности.Вставить(3,Перечисления.ВариантыСерьезностиДефектов.Критическая);
	ОбратнаяЦенаСерьезности.Вставить(4,Перечисления.ВариантыСерьезностиДефектов.Блокирующая);
	
	КоличествоПровалов = 0;
	КоличествоОшибок = 0;
	КоличествоПропущенных = 0;
	КоличествоТестов = 0;
	
	// скопируем по таблицам
	Для каждого тест из ТаблицаТестов Цикл
		мОтбор = новый Структура("НомерСтрокиТестов",тест.НомерСтроки);
		
		тест.КоличествоТестовыхСлучаев = 0;
		тест.КоличествоПровалов = 0;
		тест.КоличествоОшибок = 0;
		тест.КоличествоПропущенных = 0;		
		тест.ОписаниеОшибки = "";
		
		н_строки = ТаблицаТестовыхСлучаев.НайтиСтроки(мОтбор);
		ЦенаТестаРезультатВыполнения = -1;
		ЦенаТестаСерьезность = -1;
		
		НомерПоПорядкуСлучая = 0;
		
		Для каждого случай из н_строки Цикл
			
			НомерПоПорядкуСлучая = НомерПоПорядкуСлучая + 1;
			случай.НомерПоПорядку = НомерПоПорядкуСлучая;
			
			Если НЕ ЗначениеЗаполнено(тест.ОписаниеОшибки) Тогда
				тест.ОписаниеОшибки = случай.ОписаниеОшибки;
			Иначе
				тест.ОписаниеОшибки = тест.ОписаниеОшибки+Символы.ПС+случай.ОписаниеОшибки;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(случай,тест,"Проверка,ТестируемыйКлиент,Тест,НаименованиеТеста");				
			Если ЦенаРезультата.Получить(случай.РезультатВыполнения)>ЦенаТестаРезультатВыполнения Тогда
				ЦенаТестаРезультатВыполнения = ЦенаРезультата.Получить(случай.РезультатВыполнения);
				Если ЦенаСерьезности.Получить(случай.СерьезностьДефекта)>ЦенаТестаСерьезность Тогда
					ЦенаТестаСерьезность = ЦенаСерьезности.Получить(случай.СерьезностьДефекта);
				КонецЕсли;				
			КонецЕсли;			
			
			// посчитаем проблемы для теста
			Если случай.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Пропуск Тогда
				тест.КоличествоПропущенных = тест.КоличествоПропущенных + 1;
			КонецЕсли;
			Если случай.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Провал Тогда
				тест.КоличествоПровалов = тест.КоличествоПровалов + 1;
			КонецЕсли;
			Если случай.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Ошибка Тогда
				тест.КоличествоОшибок = тест.КоличествоОшибок + 1;
			КонецЕсли;
			
			тест.КоличествоТестовыхСлучаев = тест.КоличествоТестовыхСлучаев+1;
			
			// посчитаем проблемы по шагам
			// вернем цену
			мОтбор2 = новый Структура("НомерСтрокиСлучаев",случай.НомерСтроки);
			н_строки_шаги = ТаблицаШагов.НайтиСтроки(мОтбор2);
			
			НомерПоПорядкуШага = 0;
			
			случай.КоличествоШагов = 0;
			случай.КоличествоПровалов = 0;
			случай.КоличествоОшибок = 0;
			случай.КоличествоПропущенных = 0;	
			
			
			Для каждого шаг из н_строки_шаги Цикл
				
				НомерПоПорядкуШага = НомерПоПорядкуШага + 1;
				шаг.НомерПоПорядку = НомерПоПорядкуШага;
				
				ЗаполнитьЗначенияСвойств(шаг,случай,"Проверка,ТестируемыйКлиент,Тест,НаименованиеТеста,ТестовыйСлучай");		
				
				// посчитаем проблемы для случая
				Если шаг.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Пропуск Тогда
					случай.КоличествоПропущенных = случай.КоличествоПропущенных + 1;
				КонецЕсли;
				Если шаг.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Провал Тогда
					случай.КоличествоПровалов = случай.КоличествоПровалов + 1;
				КонецЕсли;
				Если шаг.РезультатВыполнения = Перечисления.РезультатыВыполненияШагов.Ошибка Тогда
					случай.КоличествоОшибок = случай.КоличествоОшибок + 1;
				КонецЕсли; 				
				
				случай.КоличествоШагов = случай.КоличествоШагов + 1;
				
			КонецЦикла;
			
			
		КонецЦикла;		
		
		тест.РезультатВыполнения = ОбратнаяЦена.Получить(ЦенаТестаРезультатВыполнения);
		тест.СерьезностьДефекта = ОбратнаяЦенаСерьезности.Получить(ЦенаТестаСерьезность);
		
		Если тест.РезультатВыполнения=Перечисления.РезультатыВыполненияШагов.Провал Тогда
			тест.ИндексКартинки = 4;
		ИначеЕсли тест.РезультатВыполнения=Перечисления.РезультатыВыполненияШагов.Ошибка Тогда
			тест.ИндексКартинки = 3;
		ИначеЕсли тест.РезультатВыполнения=Перечисления.РезультатыВыполненияШагов.Успешно Тогда
			тест.ИндексКартинки = 1;
		Иначе
			тест.ИндексКартинки = 0;
		КонецЕсли;
		
		КоличествоПровалов = КоличествоПровалов+тест.КоличествоПровалов;
		КоличествоОшибок = КоличествоОшибок+тест.КоличествоОшибок;
		КоличествоПропущенных = КоличествоПропущенных+тест.КоличествоПропущенных;
		КоличествоТестов = КоличествоТестов+1;
		
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаРезультатаВБазу

&НаСервере
Процедура ЗагрузитьДанныеНаСервер()
	
	
	Если ТаблицаТестов.Количество()=0 Тогда
		Возврат;
	КонецЕсли;
	
	Период = ДатаВыполенения;
	
	Для каждого тест из ТаблицаТестов Цикл
		
		МенеджерЗаписи = РегистрыСведений.ПротоколыВыполненияТестов.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.ТестируемыйКлиент 	= тест.ТестируемыйКлиент;
		МенеджерЗаписи.Проверка 			= тест.Проверка;
		МенеджерЗаписи.Тест 				= тест.Тест;
		
		МенеджерЗаписи.РезультатВыполнения 	= тест.РезультатВыполнения;
		МенеджерЗаписи.СерьезностьДефекта	= тест.СерьезностьДефекта;
		МенеджерЗаписи.ДатаВыполенения 		= тест.ДатаВыполенения;
		МенеджерЗаписи.ОписаниеОшибки 		= тест.ОписаниеОшибки;
		
		МенеджерЗаписи.ВремяВыполнения 		= тест.ВремяВыполнения;			
		МенеджерЗаписи.НомерПоПорядку 		= тест.НомерПоПорядку;
		МенеджерЗаписи.КоличествоТестовыхСлучаев = тест.КоличествоТестовыхСлучаев;
		МенеджерЗаписи.КоличествоПровалов 	= тест.КоличествоПровалов;
		МенеджерЗаписи.КоличествоОшибок 	= тест.КоличествоОшибок;
		МенеджерЗаписи.КоличествоПропущенных= тест.КоличествоПропущенных;			
			
		Попытка
			МенеджерЗаписи.Записать(Истина);		
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			СообщитьОбОшибке("ЗагрузитьДанныеНаСервер",ТекстОшибки,НомерСборки);
			Сообщить(ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;
	
	Для каждого случай из ТаблицаТестовыхСлучаев Цикл
		
		МенеджерЗаписи = РегистрыСведений.ПротоколыВыполненияТестовыхСлучаев.СоздатьМенеджерЗаписи();
		
		МенеджерЗаписи.ТестируемыйКлиент 	= случай.ТестируемыйКлиент;
		МенеджерЗаписи.Проверка 			= случай.Проверка;
		МенеджерЗаписи.Тест 				= случай.Тест;
		МенеджерЗаписи.ТестовыйСлучай 		= случай.ТестовыйСлучай;
		
		МенеджерЗаписи.РезультатВыполнения 	= случай.РезультатВыполнения;
		МенеджерЗаписи.СерьезностьДефекта	= случай.СерьезностьДефекта;
		МенеджерЗаписи.ДатаВыполенения 		= случай.ДатаВыполенения;
		МенеджерЗаписи.ОписаниеОшибки 		= случай.ОписаниеОшибки;
		
		МенеджерЗаписи.ВремяВыполнения 		= случай.ВремяВыполнения;			
		МенеджерЗаписи.НомерПоПорядку 		= случай.НомерПоПорядку;
		МенеджерЗаписи.КоличествоШагов 		= случай.КоличествоШагов;
		МенеджерЗаписи.КоличествоПровалов 	= случай.КоличествоПровалов;
		МенеджерЗаписи.КоличествоОшибок 	= случай.КоличествоОшибок;
		МенеджерЗаписи.КоличествоПропущенных= случай.КоличествоПропущенных;
					
		Попытка
			МенеджерЗаписи.Записать(Истина);		
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			СообщитьОбОшибке("ЗагрузитьДанныеНаСервер",ТекстОшибки,НомерСборки);
			Сообщить(ТекстОшибки);
		КонецПопытки;
		
	КонецЦикла;
	
	СоотвествиеПриложений = новый Соответствие();
	Попытка
		СоотвествиеПриложений = ПолучитьИзВременногоХранилища(АдресХранилищаПриложений);
	Исключение
	КонецПопытки;
	
	
	Для каждого шаг из ТаблицаШагов Цикл
		
		МенеджерЗаписи = РегистрыСведений.ПротоколыВыполненияШаговТестов.СоздатьМенеджерЗаписи();

		МенеджерЗаписи.ТестируемыйКлиент = шаг.ТестируемыйКлиент;
		МенеджерЗаписи.Проверка = шаг.Проверка;
		МенеджерЗаписи.Тест = шаг.Тест;
		МенеджерЗаписи.ТестовыйСлучай = шаг.ТестовыйСлучай;
		МенеджерЗаписи.Шаг = шаг.Шаг;
		МенеджерЗаписи.ПредставлениеШага = шаг.ПредставлениеШага;

		МенеджерЗаписи.РезультатВыполнения = шаг.РезультатВыполнения;
		МенеджерЗаписи.ДатаВыполенения = шаг.ДатаВыполенения;
		МенеджерЗаписи.ОписаниеОшибки = шаг.ОписаниеОшибки;

		МенеджерЗаписи.ВремяВыполнения = шаг.ВремяВыполнения;
		МенеджерЗаписи.НомерПоПорядку = шаг.НомерПоПорядку;
		МенеджерЗаписи.НомерШага = ?(ЗначениеЗаполнено(шаг.НомерШага), шаг.НомерШага, шаг.НомерПоПорядку);
		МенеджерЗаписи.ЕстьПриложение = шаг.ЕстьПриложение;

		МенеджерЗаписи.Ключ = шаг.Ключ;
		МенеджерЗаписи.КлючРодителя = шаг.КлючРодителя;
			
		Попытка
			МенеджерЗаписи.Записать(Истина);		
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			СообщитьОбОшибке("ЗагрузитьДанныеНаСервер",ТекстОшибки,НомерСборки);
			Сообщить(ТекстОшибки);
		КонецПопытки;
		
		// добавим приложение
		МассивПриложений = СоотвествиеПриложений.Получить(шаг.НомерСтроки);
		Если НЕ МассивПриложений=Неопределено Тогда
			ш=0;
			Для каждого прил из МассивПриложений Цикл
				ш=ш+1; 
				МенеджерЗаписиПриложения = РегистрыСведений.ПриложенияПротоколовВыполненияТестов.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(МенеджерЗаписиПриложения, МенеджерЗаписи);
				МенеджерЗаписиПриложения.Номер = ш;
				МенеджерЗаписиПриложения.ИмяФайла = прил.source;
				МенеджерЗаписиПриложения.ТипФайла = прил.type;
				МенеджерЗаписиПриложения.Размер = прил.size;
				МенеджерЗаписиПриложения.Приложение = новый ХранилищеЗначения(прил.хранилище);
				Попытка
					МенеджерЗаписиПриложения.Записать(Истина);
				Исключение
					ТекстОшибки = ОписаниеОшибки();
					СообщитьОбОшибке("ЗагрузитьДанныеНаСервер", ТекстОшибки, НомерСборки);
					Сообщить(ТекстОшибки);
				КонецПопытки;				 
			КонецЦикла;
		КонецЕсли;
		
	КонецЦикла;
	
	
	Сообщить("Успешно!");
	
КонецПроцедуры


#КонецОбласти

&НаКлиенте
Функция  ПолучитьКаталогПоПутиФайла(Знач ПутьКФайлу)
	Файл = новый Файл(ПутьКФайлу);
	Возврат Файл.Путь;	
КонецФункции


&НаКлиенте
Процедура РежимПоискаИдентификатораКлиентаПриИзменении(Элемент)
	
	РежимПоискаИдентификатораКлиентаПриИзмененииФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаИдентификатораКлиентаПриИзмененииФрагмент()
	
	Перем ВариантСправочник;
	
	ВариантСправочник = Истина;
	Если РежимПоискаТестируемогоКлиента=0 Тогда
		ВариантСправочник = Истина;
	Иначе
		ВариантСправочник = Ложь;
	КонецЕсли;
	
	Элементы.СтрокаПодключения.Видимость = НЕ ВариантСправочник;
	Элементы.ТестируемыйКлиент.Видимость = ВариантСправочник;
	
КонецПроцедуры


&НаКлиенте
Процедура РежимПоискаПроверкиПриИзменении(Элемент)
	РежимПоискаПроверкиПриИзмененииФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура РежимПоискаПроверкиПриИзмененииФрагмент()
	
	Перем ВариантСправочник;
	
	ВариантСправочник = Истина;
	Если РежимПоискаПроверки=0 Тогда
		ВариантСправочник = Истина;
	Иначе
		ВариантСправочник = Ложь;
	КонецЕсли;
	
	Элементы.НомерПроверки.Видимость = НЕ ВариантСправочник;
	Элементы.Проверка.Видимость = ВариантСправочник;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СообщитьОбОшибке(ИмяФункции,Сообщение,НомерСборки=0) Экспорт
	
	ЗаписьЖурналаРегистрации("ЗагрузкаЛогаAllureXMLТеста",УровеньЖурналаРегистрации.Ошибка,Неопределено,Неопределено,ИмяФункции+Символы.ПС+Сообщение);
	
	// Сделаем запись в доп регистр сведений
	Если НомерСборки<>0 Тогда
		
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	Сборки.Ссылка КАК Сборка
		|ИЗ
		|	Справочник.Сборки КАК Сборки
		|ГДЕ
		|	Сборки.Код = &НомерСборки";
		Запрос.УстановитьПараметр("НомерСборки", НомерСборки);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
		
			МенеджерЗаписи = РегистрыСведений.ЛогВыполненныхЗаданийДопИнфо.СоздатьМенеджерЗаписи();
		
			МенеджерЗаписи.Дата = ТекущаяДата();
			МенеджерЗаписи.Сборка = Выборка.Сборка;
			МенеджерЗаписи.Сообщение = Сообщение;
			МенеджерЗаписи.ДополнительноеСообщение = "ИмяОбработки: ЗагрузкаЛогаAllureXML ИмяФункции: "+ ИмяФункции;
			МенеджерЗаписи.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаданий.Ошибка");
			
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
