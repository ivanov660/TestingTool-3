&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Если НЕ ЗначениеЗаполнено(Запись.ПутьКВременномуКаталогуФайлов) Тогда
	//	Запись.ПутьКВременномуКаталогуФайлов = КаталогВременныхФайлов();
	//КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УстановитьСвойстваОформлениякЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеНастройкиПриИзменении(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура КлючНастройкиПриИзменении(Элемент)
	УстановитьСвойстваОформлениякЗначения();
	Запись.ЗначениеНастройки = Неопределено;
КонецПроцедуры


&НаСервере
Процедура УстановитьСвойстваОформлениякЗначения()
	
	Расширение = "";
	
	Если Запись.КлючНастройки.ТипНастройки=ПредопределенноеЗначение("Перечисление.ТипыКлючейНастроек.Каталог") Тогда
		Элементы.ЗначениеНастройки.КнопкаВыбора=Истина;	
		Элементы.ЗначениеНастройки.УстановитьДействие("НачалоВыбора","ПутьККаталогуНачалоВыбора");
	ИначеЕсли Запись.КлючНастройки.ТипНастройки=ПредопределенноеЗначение("Перечисление.ТипыКлючейНастроек.Файл") Тогда
		Элементы.ЗначениеНастройки.КнопкаВыбора=Истина;	
		Элементы.ЗначениеНастройки.УстановитьДействие("НачалоВыбора","ПутьКФайлуНачалоВыбора");
		Расширение = Запись.КлючНастройки.Расширение;	
	Иначе
		Элементы.ЗначениеНастройки.КнопкаВыбора=Ложь;
		Элементы.ЗначениеНастройки.УстановитьДействие("НачалоВыбора","");
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога); 
	Диалог.Заголовок = "Выберите каталог"; 
	Если ЗначениеЗаполнено(Запись.ЗначениеНастройки) Тогда
		Диалог.Каталог = Запись.ЗначениеНастройки;
	КонецЕсли;
	Диалог.МножественныйВыбор = Ложь; 
	ВыборФайлаОткрытияФайла = новый ОписаниеОповещения("ВыборФайлаОткрытияФайла",ЭтотОбъект,Новый Структура("ИмяЭлемента","ЗначениеНастройки"));
	Диалог.Показать(ВыборФайлаОткрытияФайла);

КонецПроцедуры

&НаКлиенте
Процедура ПутьКФайлуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
	Диалог.Заголовок = "Выберите файл"; 
	Если ЗначениеЗаполнено(Запись.ЗначениеНастройки) Тогда
		Диалог.Каталог = ОбщегоНазначенияКлиентСервер.ПолучитьКаталогПоПутиФайла(Запись.ЗначениеНастройки);
	КонецЕсли;
	Диалог.ПолноеИмяФайла = ""; 
	Фильтр = "*-файл (*.*)|*.*"; 
	Если ЗначениеЗаполнено(Расширение) Тогда
		Фильтр = ""+Расширение+"-файл|*."+Расширение;
	КонецЕсли;
	Диалог.Фильтр = Фильтр; 
	Диалог.МножественныйВыбор = Ложь; 
	ВыборФайлаОткрытияКаталога = новый ОписаниеОповещения("ВыборФайлаОткрытияКаталога",ЭтотОбъект,новый Структура("ИмяЭлемента","ЗначениеНастройки"));
	Диалог.Показать(ВыборФайлаОткрытияКаталога);

КонецПроцедуры


&НаКлиенте
Процедура ВыборФайлаОткрытияФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ИмяЭлемента = "";		
		Если ДополнительныеПараметры.Свойство("ИмяЭлемента",ИмяЭлемента) Тогда
			ИмяЭлемента = ДополнительныеПараметры.ИмяЭлемента;
			Запись[ИмяЭлемента] = ВыбранныеФайлы[0]; 
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаОткрытияКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ИмяЭлемента = "";
		Если ДополнительныеПараметры.Свойство("ИмяЭлемента",ИмяЭлемента) Тогда
			Запись[ИмяЭлемента] = ВыбранныеФайлы[0]; 
		КонецЕсли;
	КонецЕсли; 
	
КонецПроцедуры

