#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	ТекстОшибки = "";
	Отказ = Справочники.ИменаПеременных.ЕстьНаличиеДубляНаименования(Наименование,Ссылка,ТекстОшибки);
	Если Отказ=Истина И ТекстОшибки<>"" Тогда
		ЗаписьЖурналаРегистрации("Справочник.ИменаПеременных.МодульОбъекта.ПриЗаписи",УровеньЖурналаРегистрации.Ошибка,Метаданные.Справочники.ИменаПеременных,Неопределено,ТекстОшибки);
		Сообщить(ТекстОшибки);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	
КонецПроцедуры


#КонецОбласти

#КонецЕсли