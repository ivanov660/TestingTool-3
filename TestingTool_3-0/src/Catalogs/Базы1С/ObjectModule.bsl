
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	ЭтоНовыйОбъект = ЭтоНовый();
	
	ДополнительныеСвойства.Вставить("ЭтоНовыйОбъект", ЭтоНовыйОбъект);
	
	Если ЭтоНовыйОбъект И НЕ ЗначениеЗаполнено(ДатаСоздания) И НЕ ЭтоГруппа Тогда
		ДатаСоздания = ТекущаяДата();
		//Автор        = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли