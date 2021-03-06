
Функция НайтиЗаданиеПоID(Знач ID) Экспорт
	
	Задание = Справочники.Задания.ПустаяСсылка();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Задания.Ссылка
	|ИЗ
	|	Справочник.Задания КАК Задания
	|ГДЕ
	|	Задания.ID = &ID";
	Запрос.УстановитьПараметр("ID",ID);

	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Задание = Выборка.Ссылка;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Задание;
	
КонецФункции