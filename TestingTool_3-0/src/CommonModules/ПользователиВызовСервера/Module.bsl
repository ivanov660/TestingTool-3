
// Возвращает текущего авторизованного пользователя.
Функция АвторизованныйПользователь() Экспорт
	Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции


Процедура УстановитьПараметры(ПараметрыСеанса) Экспорт
	
	// определим пользователя
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();
	// найдем пользователя
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Пользователи.Ссылка
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|ГДЕ
	|	Пользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ",ПользовательИБ.УникальныйИдентификатор);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ПараметрыСеанса.ТекущийПользователь = Выборка.Ссылка;
		Иначе
			ПараметрыСеанса.ТекущийПользователь =  Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
	Иначе
		// пользователь по умолчанию
		ПараметрыСеанса.ТекущийПользователь =  Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	
	// Текущее рабочее место
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	РабочиеМеста.Ссылка
	|ИЗ
	|	Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|	РабочиеМеста.ИмяКомпьютера = &ИмяКомпьютера";
	Запрос.УстановитьПараметр("ИмяКомпьютера",ПараметрыСеанса.ИмяСервера);
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ПараметрыСеанса.ТекущийРабочийСервер = Выборка.Ссылка;
			ПараметрыСеанса.ТекущееРабочееМесто = Выборка.Ссылка;
		Иначе
			ПараметрыСеанса.ТекущийРабочийСервер =  Справочники.РабочиеМеста.ПустаяСсылка();
			ПараметрыСеанса.ТекущееРабочееМесто = Справочники.РабочиеМеста.ПустаяСсылка();
		КонецЕсли;
	Иначе
		// рабочее место не указано/создадим
		РабочееМесто = РабочееМестоСервер.СоздатьРабочееМесто(ПараметрыСеанса.ИмяСервера);
		ПараметрыСеанса.ТекущееРабочееМесто = РабочееМесто;
		ПараметрыСеанса.ТекущийРабочийСервер =  Справочники.РабочиеМеста.ПустаяСсылка();
	КонецЕсли;
	
КонецПроцедуры

Функция ТекущееРабочееМесто() Экспорт
	Возврат ПараметрыСеанса.ТекущееРабочееМесто;
КонецФункции

Функция ТекущийПользователь() Экспорт
	Возврат ПараметрыСеанса.ТекущийПользователь;
КонецФункции

Функция ВходЗапрещен() Экспорт
	
	Возврат ПользователиСервер.ВходЗапрещен();
	
КонецФункции

Процедура УстановитьГлавныйСтильИзНастроек() Экспорт
	
	ПользователиСервер.УстановитьГлавныйСтильИзНастроек();
	
КонецПроцедуры