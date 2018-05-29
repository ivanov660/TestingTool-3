
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Действие = Параметры.Действие;
	ТекущийПуть = Параметры.ТекущийПуть;
	
	// заполним другие параметры
	ЗаполнитьЗначенияСвойств(Объект,Параметры);
	
	// свойство это новый
	Параметры.Свойство("ЭтоНовый",ЭтоНовый);
	
	Элементы.ТипФайлаСценария.СписокВыбора.Добавить("XML","XML");
	Объект.ТипФайлаСценария = "XML";
	
	Если Действие="Новый сценарий" Тогда
		Объект.GUID = строка(новый УникальныйИдентификатор());
		Попытка
			Выполнить("Объект.Автор = Строка(ПользователиКлиентСервер.ТекущийПользователь());");
		Исключение
			Объект.Автор = "Аноним";
		КонецПопытки;
		Объект.Наименование = "";
		Объект.НаименованиеНабораСценариев = "Без названия";
		Элементы.РасположениеПоУмолчанию.Видимость = Истина;
		РасположениеПоУмолчанию = "РабочийКаталог";
	ИначеЕсли Действие="Изменить сценарий" Тогда
		Элементы.РасположениеПоУмолчанию.Видимость = Ложь;
		Элементы.ПутьКФайлуСценария.ТолькоПросмотр = Истина;
		Элементы.ФормаСоздатьИЗакрыть.Заголовок = "Принять изменения";
	ИначеЕсли Действие="Новый каталог" Тогда
		Объект.Наименование = "";
		РасположениеПоУмолчанию = "РабочийКаталог";
	КонецЕсли;
	
	Если Найти(Действие,"каталог") Тогда
		Элементы.ИдентификаторТеста.Видимость = ложь;
		Элементы.ПутьКФайлуСценария.Заголовок = "Путь к каталогу";
		Элементы.Severity.Видимость = ложь;
		Элементы.ДополнительныеПараметры.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.Severity.СписокВыбора.Добавить("Блокирующая","Блокирующая");
	Элементы.Severity.СписокВыбора.Добавить("Критическая","Критическая");
	Элементы.Severity.СписокВыбора.Добавить("Значительная","Значительная");
	Элементы.Severity.СписокВыбора.Добавить("Незначительная","Незначительная");
	Элементы.Severity.СписокВыбора.Добавить("Тривиальная","Тривиальная");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Вставить содержимое обработчика
КонецПроцедуры


&НаКлиенте
Процедура СоздатьИЗакрыть(Команда)
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Сообщить("Указание наименования сценария обязательно!");
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Объект.ПутьКФайлуСценария) Тогда
		Сообщить("Указание пути к файлу сценария обязательно!");
		Возврат;
	КонецЕсли;
	
	Если НЕ Найти(Действие,"каталог") Тогда
		мПараметры = новый Структура("Наименование,НаименованиеНабораСценариев,Автор,GUID,ПутьКФайлуСценария,ТипФайлаСценария,Комментарий,ИдентификаторТеста,Severity");
		ЗаполнитьЗначенияСвойств(мПараметры,Объект);
		Оповестить(Действие,мПараметры,ЭтаФорма);
	Иначе		
		// создадим каталог
		ВыборСозданиеКаталога = новый ОписаниеОповещения("ВыборСозданиеКаталога",ЭтотОбъект);
		НачатьСозданиеКаталога(ВыборСозданиеКаталога,Объект.ПутьКФайлуСценария+"\"+Объект.Наименование);	
	КонецЕсли;
	ЭтаФорма.Закрыть();
КонецПроцедуры



&НаКлиенте
Процедура ПутьКФайлуСценарияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Найти(Действие,"каталог") Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога); 
		Диалог.Заголовок = "Выберите каталог"; 
	Иначе
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
		Диалог.Заголовок = "Выберите файл"; 
		Диалог.ПолноеИмяФайла = ""; 
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ПутьКФайлуСценария) Тогда
		Диалог.Каталог = ПолучитьКаталогПоПутиФайла(Объект.ПутьКФайлуСценария);
		Если Найти(Действие,"каталог") Тогда
			Диалог.ПолноеИмяФайла = ПолучитьИмяПоПутиФайла(Объект.ПутьКФайлуСценария); 
		КонецЕсли;
	ИначеЕсли ЗначениеЗаполнено(ТекущийПуть) Тогда
		Если Найти(ТекущийПуть,".") Тогда
			Диалог.Каталог = ПолучитьКаталогПоПутиФайла(ТекущийПуть);
			Если Найти(Действие,"каталог") Тогда
				Диалог.ПолноеИмяФайла = ПолучитьИмяПоПутиФайла(ТекущийПуть); 
			КонецЕсли;
		Иначе
			Диалог.Каталог = ПолучитьКаталогПоПутиФайла(ТекущийПуть+"\");
		КонецЕсли;
	КонецЕсли;
	
	Фильтр = "XML-файл (*.xml)|*.xml"; 
	Диалог.Фильтр = Фильтр; 
	Диалог.МножественныйВыбор = Ложь; 
	ВыборФайлаОткрытияСтруктурыКонфигурации = новый ОписаниеОповещения("ВыборФайлаОткрытияСтруктурыКонфигурации",ЭтотОбъект);
	Диалог.Показать(ВыборФайлаОткрытияСтруктурыКонфигурации);

КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаОткрытияСтруктурыКонфигурации(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	 Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		Объект.ПутьКФайлуСценария = ВыбранныеФайлы[0]; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборСозданиеКаталога(ИмяКаталога, ДополнительныеПараметры) Экспорт

КонецПроцедуры

&НаКлиенте
Функция  ПолучитьКаталогПоПутиФайла(Знач ПутьКФайлу)
	Файл = новый Файл(ПутьКФайлу);
	Возврат Файл.Путь;	
КонецФункции


&НаКлиенте
Функция  ПолучитьИмяПоПутиФайла(Знач ПутьКФайлу)
	Файл = новый Файл(ПутьКФайлу);
	Возврат Файл.ИмяБезРасширения;	
КонецФункции

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// если нет идентификатора
	Если НЕ ЗначениеЗаполнено(Объект.ИдентификаторТеста) Тогда
		Объект.ИдентификаторТеста = СформироватьАвтоматическиИдентификаторТеста(Объект.Наименование);
	КонецЕсли;
	
	// если не указан путь
	Если НЕ ЗначениеЗаполнено(Объект.ПутьКФайлуСценария) Тогда
		Если РасположениеПоУмолчанию="РабочийКаталог" Тогда
			Объект.ПутьКФайлуСценария = Объект.ПутьККаталогуНаборовСценариев+"\"+?(Найти(Действие,"каталог"),"",УдалитьНедопустимыеСимволыДляПутиФайла(Объект.Наименование)+".xml");
		Иначе
			Объект.ПутьКФайлуСценария = Объект.ПутьККаталогуБиблиотекиСценариев+"\"+?(Найти(Действие,"каталог"),"",УдалитьНедопустимыеСимволыДляПутиФайла(Объект.Наименование)+".xml");
		КонецЕсли;
	КонецЕсли;
	
	// если путь менялся, тогда попробуем поменять имя
	Если ЗначениеЗаполнено(СтароеИмяФайла) И Найти(Врег(Объект.ПутьКФайлуСценария),Врег(СтароеИмяФайла+".xml")) Тогда 
		Объект.ПутьКФайлуСценария = СтрЗаменить(Объект.ПутьКФайлуСценария,СтароеИмяФайла+".xml",Объект.Наименование+".xml");
	КонецЕсли;
		
	СтароеИмяФайла = Объект.Наименование; 
	
КонецПроцедуры

&НаКлиенте
Функция УдалитьНедопустимыеСимволыДляПутиФайла(Знач ПутьКФайлу)
	
	КорректныйПутьКФайлу = ПутьКФайлу;
	
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"*","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"|","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"\","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"/","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,":","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"""","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"<","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,">","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"?","");
	КорректныйПутьКФайлу = СтрЗаменить(КорректныйПутьКФайлу,"+","");
	
	Возврат КорректныйПутьКФайлу;
	
КонецФункции

&НаКлиенте
Функция СформироватьАвтоматическиИдентификаторТеста(Знач Наименование)
	Ключ = Наименование;
	Ключ = СтрЗаменить(Ключ," ","_");
	Возврат Ключ;
КонецФункции

&НаКлиенте
Процедура РасположениеПоУмолчаниюПриИзменении(Элемент)
	Если РасположениеПоУмолчанию="РабочийКаталог" Тогда
		Если Найти(Объект.ПутьКФайлуСценария,Объект.ПутьККаталогуБиблиотекиСценариев) Тогда
			Объект.ПутьКФайлуСценария = СтрЗаменить(Объект.ПутьКФайлуСценария,Объект.ПутьККаталогуБиблиотекиСценариев,Объект.ПутьККаталогуНаборовСценариев);
		КонецЕсли;
	Иначе
		Если Найти(Объект.ПутьКФайлуСценария,Объект.ПутьККаталогуНаборовСценариев) Тогда
			Объект.ПутьКФайлуСценария = СтрЗаменить(Объект.ПутьКФайлуСценария,Объект.ПутьККаталогуНаборовСценариев,Объект.ПутьККаталогуБиблиотекиСценариев);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
