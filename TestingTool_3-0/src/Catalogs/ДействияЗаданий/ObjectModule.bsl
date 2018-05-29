
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа=Истина Тогда
		Возврат;
	КонецЕсли;
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка=Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа=Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовыйОбъект = ЭтоНовый();
	
	ДополнительныеСвойства.Вставить("ЭтоНовыйОбъект", ЭтоНовыйОбъект);
	
	// преобразуем в мил сек
	ИнтервалСек = ПланировщикЗаданийКлиентСервер.ПреобразоватьДатуВСек(Интервал);
	ВремяСек = ПланировщикЗаданийКлиентСервер.ПреобразоватьДатуВСек(Время);
	ДатаВремяСек = ПланировщикЗаданийКлиентСервер.ПреобразоватьДатуВСек(ДатаВремя);
	
	
	// очистим некоторые поля
	Если ИспользоватьАлгоритм=Истина Тогда
		Код1С="";
	Иначе
		Алгоритм = Справочники.Алгоритмы.ПустаяСсылка();
	КонецЕсли;
	
	Если ИспользоватьШаблонКоманды=Истина Тогда
		КоманднаяСтрока = "";
	Иначе
		ШаблонКоманды = Справочники.ШаблоныКоманд.ПустаяСсылка();
	КонецЕсли;
	
	Если ИспользоватьКомандуПлатформыЗапуститьПриложение=Истина Тогда
		РабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка=Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа=Истина Тогда
		Возврат;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли