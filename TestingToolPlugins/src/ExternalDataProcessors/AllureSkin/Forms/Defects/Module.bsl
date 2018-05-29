
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.ДобавитьМеню(ЭтаФорма,"Defects");
	
	ЭтаФорма.КоманднаяПанель.Видимость = Ложь;
	ЭтаФорма.АвтоЗаголовок = Ложь;
	ЭтаФорма.Заголовок = "Defects";
	
	
	СписокДефектыПродукта.Параметры.УстановитьЗначениеПараметра("ТестируемыйКлиент",Справочники.ТестируемыеКлиенты.ПустаяСсылка());
	СписокДефектыПродукта.Параметры.УстановитьЗначениеПараметра("Проверка",Справочники.Проверки.ПустаяСсылка());

	СписокДефектыТестов.Параметры.УстановитьЗначениеПараметра("ТестируемыйКлиент",Справочники.ТестируемыеКлиенты.ПустаяСсылка());
	СписокДефектыТестов.Параметры.УстановитьЗначениеПараметра("Проверка",Справочники.Проверки.ПустаяСсылка());
	
	ЗаполнитьЗначенияСвойств(Объект,Параметры);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПараметрыСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеню(Команда)
	ИмяКоманды = Команда.Имя;
	мПараметры = новый Структура("Проверка,ТестируемыйКлиент",Объект.Проверка,Объект.ТестируемыйКлиент);
	ОткрытьФорму("ВнешняяОбработка.AllureSkin.Форма."+ИмяКоманды,мПараметры,ЭтаФорма,ЭтаФорма.УникальныйИдентификатор,ЭтаФорма.Окно);
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПользователя()
	
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.СохранитьНастройкиПользователя(Объект);
	
КонецПроцедуры

Процедура УстановитьПараметрыСписков()
	
	Объект.Проверка = ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Объект.ТестируемыйКлиент);
	
	СписокДефектыПродукта.Параметры.УстановитьЗначениеПараметра("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	СписокДефектыПродукта.Параметры.УстановитьЗначениеПараметра("Проверка",Объект.Проверка);

	СписокДефектыТестов.Параметры.УстановитьЗначениеПараметра("ТестируемыйКлиент",Объект.ТестируемыйКлиент);
	СписокДефектыТестов.Параметры.УстановитьЗначениеПараметра("Проверка",Объект.Проверка);
КонецПроцедуры 	

&НаСервереБезКонтекста
Функция ПолучитьПоследнююПроверкуДляТестируемогоКлиента(Знач ТестируемыйКлиент)
	
	Проверка = Справочники.Проверки.ПустаяСсылка();
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	Т.Проверка КАК Проверка
	|ИЗ
	|	РегистрСведений.ПротоколыВыполненияТестов КАК Т
	|ГДЕ
	|	Т.ТестируемыйКлиент = &ТестируемыйКлиент
	|
	|УПОРЯДОЧИТЬ ПО
	|	Т.Проверка.Код УБЫВ";
	Запрос.УстановитьПараметр("ТестируемыйКлиент",ТестируемыйКлиент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Проверка = Выборка.Проверка;
		КонецЕсли;
		
	КонецЕсли;
	
	
	Возврат Проверка;
	
КонецФункции

&НаКлиенте
Процедура ТестируемыйКлиентПриИзменении(Элемент)
	СохранитьНастройкиПользователя();
	УстановитьПараметрыСписков();
КонецПроцедуры

&НаКлиенте
Процедура СписокДефектыПродуктаПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СписокДефектыПродукта.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияHTML = СформироватьИнформациюHTML(ТекущиеДанные.Тест,ТекущиеДанные.ТестовыйСлучай,ТекущиеДанные.ОписаниеОшибки,ТекущиеДанные.РезультатВыполнения);
	
	
	Если НЕ ТекущаяСтрокаСпискаДефектов=Элементы.СписокДефектыПродукта.ТекущаяСтрока Тогда
		Элементы.ГруппаДетализация.Видимость = Истина;
		ТекущаяСтрокаСпискаДефектов=Элементы.СписокДефектыПродукта.ТекущаяСтрока;
	КонецЕсли;


КонецПроцедуры

&НаКлиенте
Процедура СписокДефектыТестовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СписокДефектыТестов.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнформацияHTML = СформироватьИнформациюHTML(ТекущиеДанные.Тест,ТекущиеДанные.ТестовыйСлучай,ТекущиеДанные.ОписаниеОшибки,ТекущиеДанные.РезультатВыполнения);
	
	Если НЕ ТекущаяСтрокаСпискаДефектов=Элементы.СписокДефектыТестов.ТекущаяСтрока Тогда
		Элементы.ГруппаДетализация.Видимость = Истина;
		ТекущаяСтрокаСпискаДефектов=Элементы.СписокДефектыТестов.ТекущаяСтрока;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция СформироватьИнформациюHTML(Знач Тест,Знач Представление,Знач Информация,Знач Статус)
	
	HTML = "<html><head></head><body>";
	
	HTML = HTML+"<h2>"+Представление+" ("+Статус+")</h2>";
	Информация = СтрЗаменить(Информация,"Шаг №","</br><hr>Шаг №");
	HTML = HTML+Информация;
	
	Если Найти(Информация,"Шаг №") Тогда
		HTML = HTML+"</br><hr>";
	КонецЕсли;
	
	
	HTML = HTML+"</body></html>";
	
	Возврат HTML;
	
	
КонецФункции

&НаКлиенте
Процедура СкрытьДетализацию(Команда)
	Элементы.ГруппаДетализация.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокДефектыТестовПриАктивизацииПоля(Элемент)
	СписокДефектыТестовПриАктивизацииСтроки(Элемент);
КонецПроцедуры


&НаКлиенте
Процедура СписокДефектыПродуктаПриАктивизацииПоля(Элемент)
	СписокДефектыПродуктаПриАктивизацииСтроки(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВсе(Команда)
	Элементы.СписокДефектыПродукта.Обновить();
	Элементы.СписокДефектыТестов.Обновить();
КонецПроцедуры