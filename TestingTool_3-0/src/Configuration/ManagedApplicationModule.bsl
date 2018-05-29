
Процедура ПередНачаломРаботыСистемы(Отказ)
	
	Если ПользователиВызовСервера.ВходЗапрещен() Тогда
		ВызватьИсключение "Вход в программу запрещен";
		Отказ = истина;
	КонецЕсли;
	
	// ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазыКлиент.ВыполнитьОбновлениеИнформационнойБазы();
	// Конец ОбновлениеВерсииИБ
	
	СлужебныйКлиент.УстановитьЗаголовок();
	
	#Если ВебКлиент Тогда
		СлужебныйКлиент.УстановитьИмяКомпьютера("Браузер");
	#Иначе
		СлужебныйКлиент.УстановитьИмяКомпьютера(ИмяКомпьютера());
	#КонецЕсли
	
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
	
	Если ОсновноеРабочееМестоВызовСервера.УстановленоОсновноеРабочееМесто() И
		ОсновноеРабочееМестоВызовСервера.ОткрыватьОсновноеРабочееМестоПриЗапускеСистемы() Тогда
		ОткрытьФорму("Обработка.ОсновноеРабочееМестоПользователя.Форма.ОсновноеРабочееМесто");
	КонецЕсли;
	
КонецПроцедуры
