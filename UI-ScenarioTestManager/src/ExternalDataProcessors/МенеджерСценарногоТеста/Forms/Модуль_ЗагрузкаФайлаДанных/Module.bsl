&НаКлиенте
Перем Модуль_СервисныеФункции;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьДанные(Знач ПутьКФайлу) Экспорт
	
	Данные = новый Массив;
	
	Файл = новый Файл(ПутьКФайлу);
	
	Если НЕ Файл.Существует() Тогда
		// проблема
		Возврат Данные;
	КонецЕсли;
	
	Если Файл.Расширение=".txt" Тогда
	ИначеЕсли Файл.Расширение=".xlsx" Тогда
	ИначеЕсли Файл.Расширение=".xml" Тогда
	ИначеЕсли Файл.Расширение=".csv" Тогда
	ИначеЕсли Файл.Расширение=".mxl" Тогда
		Данные = ЗагрузитьMXL(ПутьКФайлу); 
	КонецЕсли;
	
	Возврат Данные;
КонецФункции

#Область MXL

&НаКлиенте
Функция ЗагрузитьMXL(ПутьКФайлу)
	
	ДвоичныеДанные = новый ДвоичныеДанные(ПутьКФайлу);
	АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	МассивСтруктур = ПолучитьТаблицуЗначенийИзТабличногоДокумента(АдресХранилища,Истина,Истина);
	
	Возврат МассивСтруктур;
	
КонецФункции

&НаСервере
Функция ЗагрузитьТабличныйДокумент(АдресХранилища)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	Поток = ДвоичныеДанные.ОткрытьПотокДляЧтения();
	ТабличныйДокумент = новый ТабличныйДокумент();
	ТабличныйДокумент.Прочитать(Поток);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти 

#Область EXCEL


#КонецОбласти

// портирован из Functest
&НаКлиенте
Функция ПолучитьТаблицуЗначенийИзТабличногоДокумента(АдресХранилища, УчитыватьТолькоВидимыеКолонки = Ложь, УчитыватьТолькоВидимыеСтроки = Ложь) Экспорт

	// 1)
	ТабличныйДокумент = ЗагрузитьТабличныйДокумент(АдресХранилища);
	ТипТабличногоДокумента = ТипЗнч(ТабличныйДокумент);
	Если ТипТабличногоДокумента <> Тип("ТабличныйДокумент") И ТипТабличногоДокумента <> Тип("ПолеТабличногоДокумента") Тогда
		ВызватьИсключение "ПолучитьТаблицуЗначенийИзТабличногоДокумента: Требуется тип ТабличныйДокумент или ПолеТабличногоДокумента";
	КонецЕсли;
	
	НомерПоследнейКолонки = ТабличныйДокумент.ШиринаТаблицы;
	НомерПоследнейСтроки = ТабличныйДокумент.ВысотаТаблицы;
	
	НоваяТаблицаЗначений = Новый Массив;
	Колонки = новый Массив();
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	// TODO При определении видимости не учитывается наличие нескольких форматов строк, сейчас видимоcть колонки определяется по формату первой строки
	УчитываемыеКолонки = Новый Массив;
	УчитываемыеКолонкиИмена = Новый Массив;
	Для НомерКолонки = 1 По НомерПоследнейКолонки Цикл
		ОбластьКолонки = ТабличныйДокумент.Область(0, НомерКолонки, 1, НомерКолонки);
		Если НЕ ЗначениеЗаполнено(ОбластьКолонки.Текст) Тогда
			Продолжить;
		КонецЕсли;
		
		УчитыватьКолонку = Не УчитыватьТолькоВидимыеКолонки Или ОбластьКолонки.Видимость;
		Если УчитыватьКолонку Тогда
			УчитываемыеКолонки.Добавить(НомерКолонки);
			ШиринаКолонки = ОбластьКолонки.ШиринаКолонки;
			Если ШиринаКолонки <= 1 Тогда
				ШиринаКолонки = 1;
			КонецЕсли;
			ИмяКолонки = ОбластьКолонки.Текст;
			УчитываемыеКолонкиИмена.Добавить(ИмяКолонки);
			//Колонки.Добавить(новый Структура("ИмяКолонки,ТипСтрока,ШиринаКолонки",ИмяКолонки, ТипСтрока, ШиринаКолонки));
		КонецЕсли;
	КонецЦикла;
	
	ГраницаКолонок = УчитываемыеКолонки.ВГраница();
	Для НомерСтроки = 2 По НомерПоследнейСтроки Цикл
		
		Если УчитыватьТолькоВидимыеСтроки И Не ТабличныйДокумент.Область(НомерСтроки,, НомерСтроки).Видимость Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = новый Структура();
		
		ЕстьДанныеВЯчейках = Ложь;
		
		Для Индекс = 0 По ГраницаКолонок Цикл
			НомерКолонки = УчитываемыеКолонки[Индекс];
			ИмяКолонки = УчитываемыеКолонкиИмена[Индекс];
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			НоваяСтрока.Вставить(ИмяКолонки,Область.Текст);
			ЕстьДанныеВЯчейках = ЕстьДанныеВЯчейках ИЛИ ЗначениеЗаполнено(Область.Текст);
		КонецЦикла;
		
		Если ЕстьДанныеВЯчейках=Истина Тогда
			НоваяТаблицаЗначений.Добавить(НоваяСтрока);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НоваяТаблицаЗначений;
	
КонецФункции

#Область Вспомогательные

&НаКлиенте
Процедура ЗагрузитьБиблиотеки()
	
	Если Модуль_СервисныеФункции=Неопределено Тогда
		Модуль_СервисныеФункции = ПолучитьФорму("ВнешняяОбработка.МенеджерСценарногоТеста.Форма.Модуль_СервисныеФункции");
	КонецЕсли;		
	
КонецПроцедуры

#КонецОбласти