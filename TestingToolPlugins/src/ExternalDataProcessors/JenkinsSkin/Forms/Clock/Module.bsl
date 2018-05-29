&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ДобавитьМеню(ЭтаФорма,"Clock");
	
	ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Clock";
	
	ЗаполнитьЗначенияСвойств(Объект,Параметры);
	
	
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ГруппаЗадания",Справочники.ГруппыЗаданий.ПустаяСсылка());
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ВсеЗадания",Ложь);
	СписокПуллЗаданий.Параметры.УстановитьЗначениеПараметра("Задание",Справочники.Задания.ПустаяСсылка());
	СписокПуллЗаданий.Параметры.УстановитьЗначениеПараметра("Сборка",ПредопределенноеЗначение("Справочник.Сборки.ПустаяСсылка"));
	СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Задание",Справочники.Задания.ПустаяСсылка());
	СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Сборка",ПредопределенноеЗначение("Справочник.Сборки.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеню(Команда)
	ИмяКоманды = Команда.Имя;
	мПараметры = новый Структура();
	ОткрытьФорму("ВнешняяОбработка.JenkinsSkin.Форма."+ИмяКоманды,мПараметры,ЭтаФорма,ЭтаФорма.УникальныйИдентификатор,ЭтаФорма.Окно);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗагрузитьНастройкиПользователя();
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ГруппаЗадания",ОтборПоГруппамЗаданий);
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ВсеЗадания",ВсеЗадания);
	СформироватьОписаниеПанелей();
КонецПроцедуры

&НаСервере
Процедура СформироватьОписаниеПанелей()

	
КонецПроцедуры



&НаСервере
Процедура СохранитьНастройкиПользователя(ИмяНастройки="",ЗначениеНастройки="")
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.СохранитьНастройкиПользователя(Объект,ИмяНастройки,ЗначениеНастройки);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ЗагрузитьНастройкиПользователя(Объект);
	ВсеЗадания = мОбъект.ЗагрузитьНастройкиПользователя(Объект,"ВсеЗадания");
	
КонецПроцедуры

#Область ПриАктивации

&НаКлиенте
Процедура ПланировщикЗаданийПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ПланировщикЗаданий.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьОтборыДляПодчиненныхСписков();
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПуллЗаданийПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СписокПуллЗаданий.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Задание",ТекущиеДанные.ПодчиненноеЗадание);
	СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Сборка",ТекущиеДанные.Сборка);
	
КонецПроцедуры

#КонецОбласти


&НаКлиенте
Процедура СписокПуллЗаданийОбработкаЗапросаОбновления()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервереБезконтекста
Функция ПуллЗаданияПустой(Знач Задание)
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	Т.Задание
	|ИЗ
	|	РегистрСведений.СоставЗаданийПулл КАК Т
	|ГДЕ
	|	Т.Задание = &Задание";
	Запрос.УстановитьПараметр("Задание",Задание);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ОтборПоГруппамЗаданийПриИзменении(Элемент)
	
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ГруппаЗадания",ОтборПоГруппамЗаданий);
	УстановитьОтборыДляПодчиненныхСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборыДляПодчиненныхСписков()
	
	ТекущиеДанные = Элементы.ПланировщикЗаданий.ТекущиеДанные;
	
	Если ТекущиеДанные<>Неопределено Тогда
		СписокПуллЗаданий.Параметры.УстановитьЗначениеПараметра("Задание",ТекущиеДанные.Задание);
		СписокПуллЗаданий.Параметры.УстановитьЗначениеПараметра("Сборка",ПредопределенноеЗначение("Справочник.Сборки.ПустаяСсылка"));
	КонецЕсли;
	
	ТекущиеДанные = Элементы.СписокПуллЗаданий.ТекущиеДанные;
	
	Если ТекущиеДанные<>Неопределено Тогда
		СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Задание",ТекущиеДанные.ПодчиненноеЗадание);
		СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Сборка",ПредопределенноеЗначение("Справочник.Сборки.ПустаяСсылка"));
	Иначе
		СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Задание",ПредопределенноеЗначение("Справочник.Задания.ПустаяСсылка"));
		СписокПуллЗаданийПоследнийУровень.Параметры.УстановитьЗначениеПараметра("Сборка",ПредопределенноеЗначение("Справочник.Сборки.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры



&НаСервере
Процедура ВыполнитьСейчасСервер(Задание)
	ОписаниеОшибки = "";
	Если ПланировщикЗаданийСервер.ДобавитьЗаданиеВПуллНемедленно(Задание,ОписаниеОшибки)=Истина Тогда
		Сообщить("Успешно!");
	Иначе
		Сообщить("Ошибка!"+Символы.ПС+ОписаниеОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСейчас(Команда)
	ТекущиеДанные = Элементы.ПланировщикЗаданий.ТекущиеДанные;
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	ВыполнитьСейчасСервер(ТекущиеДанные.Задание);
КонецПроцедуры

&НаКлиенте
Процедура ВсеЗаданияПриИзменении(Элемент)
	ПланировщикЗаданий.Параметры.УстановитьЗначениеПараметра("ВсеЗадания",ВсеЗадания);
	СохранитьНастройкиПользователя("ВсеЗадания",ВсеЗадания);
КонецПроцедуры
