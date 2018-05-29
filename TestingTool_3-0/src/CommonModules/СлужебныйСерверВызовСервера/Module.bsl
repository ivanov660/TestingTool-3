
Процедура УстановитьИмяКомпьютера(ИмяКомпьютера) Экспорт
	
	ПараметрыСеанса.ИмяКомпьютера = ИмяКомпьютера;
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	РабочиеМеста.Ссылка
	|ИЗ
	|	Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|	РабочиеМеста.ИмяКомпьютера = &ИмяКомпьютера";
	Запрос.УстановитьПараметр("ИмяКомпьютера",ПараметрыСеанса.ИмяКомпьютера);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ПараметрыСеанса.ТекущееРабочееМесто = Выборка.Ссылка;
		Иначе
			ПараметрыСеанса.ТекущееРабочееМесто =  Справочники.РабочиеМеста.ПустаяСсылка();
		КонецЕсли;
	Иначе
		// рабочее место не указано/создадим
		РабочееМесто = РабочееМестоСервер.СоздатьРабочееМесто(ПараметрыСеанса.ИмяКомпьютера);
		ПараметрыСеанса.ТекущееРабочееМесто =  Справочники.РабочиеМеста.ПустаяСсылка();
	КонецЕсли;	
	
КонецПроцедуры
