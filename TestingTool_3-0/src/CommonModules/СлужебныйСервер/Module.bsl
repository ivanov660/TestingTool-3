
Функция СоздатьНовоеРабочееМесто(ИмяКомпьютера,ОперационнаяСистема,КаталогПоУмолчанию,Пользователь) Экспорт
	
	РезультатОперации = Ложь;
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	РабочиеМеста.Ссылка
	               |ИЗ
	               |	Справочник.РабочиеМеста КАК РабочиеМеста
	               |ГДЕ
	               |	РабочиеМеста.ИмяКомпьютера = &ИмяКомпьютера";
	Запрос.УстановитьПараметр("ИмяКомпьютера",ИмяКомпьютера);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		РабочееМестоОбъект = Справочники.РабочиеМеста.СоздатьЭлемент();
		РабочееМестоОбъект.ИмяКомпьютера = ИмяКомпьютера;
		РабочееМестоОбъект.ОперационнаяСистема = ОперационнаяСистема;		
		
		Попытка
			РабочееМестоОбъект.Записать();
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
		
		МенеджерНабораЗаписей = РегистрыСведений.НастройкиРаботыПользователяНаРабочемМесте.СоздатьМенеджерЗаписи();
		МенеджерНабораЗаписей.Пользователь = Пользователь;
		МенеджерНабораЗаписей.РабочееМесто = РабочееМестоОбъект.Ссылка;
		МенеджерНабораЗаписей.КлючНастройки = Справочники.КлючиНастроек.ПутьКВременномуКаталогуФайлов;
		МенеджерНабораЗаписей.ЗначениеНастройки = КаталогПоУмолчанию;
		
		МенеджерНабораЗаписей.Записать();

		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат РезультатОперации;
КонецФункции

