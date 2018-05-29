
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДействиеИзСценария = Параметры.Действие;
	КомандаИзСценария = Параметры.Команда;
	ИмяТаблицы	= Параметры.ИмяТаблицы;
	
	// получим свойство
	Параметры.Свойство("Свойство",Свойство);
	
	Если Параметры.Свойство("CustomCodeClient") Тогда
		Код1СИзСценария = Параметры.CustomCodeClient;
	КонецЕсли;
	
	Если Параметры.Свойство("CustomCodeServer") Тогда
		Код1СИзСценария = Параметры.CustomCodeServer;
	КонецЕсли;
	
	Если Параметры.Свойство("RowDescription") Тогда
		RowDescription = Параметры.RowDescription;
	КонецЕсли;
	
	Если Параметры.Свойство("СвойстваПодключенияКлиентаТестирования") Тогда
		СвойстваПодключенияКлиентаТестирования = Параметры.СвойстваПодключенияКлиентаТестирования;
	КонецЕсли;	
	
	Если Параметры.Свойство("ПутьБлокШагов") Тогда
		ПутьБлокШагов = Параметры.ПутьБлокШагов;
	КонецЕсли;
	
	Если Параметры.Свойство("Library") Тогда
		Library = Параметры.Library;
	КонецЕсли;
	
	Если Параметры.Свойство("УсловиеСравнения") Тогда
		УсловиеСравнения = Параметры.УсловиеСравнения;
	КонецЕсли;
	
	Элементы.ГруппаСвойства.ОтображениеСтраниц=ОтображениеСтраницФормы.Нет;
	
	Если ДействиеИзСценария="ВыполнитьПроизвольныйКодКлиент" ИЛИ ДействиеИзСценария="ВыполнитьПроизвольныйКодСервер" Тогда
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаРедактированиеКода1С;
	ИначеЕсли ДействиеИзСценария="ПодключитьТестируемоеПриложение" Тогда
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаСвойстваТаблицей;
		
		СвойстваТаблицей.Очистить();
		
		// Настройки по умолчанию
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "НастройкиПоУмолчанию";
		стр_н.Синоним = "Настройки по умолчанию";
		стр_н.Значение = Истина;
		стр_н.ТолькоЧтение = Ложь;
		стр_н.Видимость = Истина;
		
		// СтрокаПодключения
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "СтрокаПодключения";
		стр_н.Синоним = "Строка подключения";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// ЭтоФайловаяБаза
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "ЭтоФайловаяБаза";
		стр_н.Синоним = "Это файловая база";
		стр_н.Значение = Ложь;
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Сервер
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "Сервер";
		стр_н.Синоним = "Сервер";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// База
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "ИмяБазы";
		стр_н.Синоним = "Имя базы";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Путь к файлу
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "ПутьКФайловойБазе";
		стр_н.Синоним = "Путь к файловой базе";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Пользователь
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "Пользователь1С";
		стр_н.Синоним = "Пользователь 1С";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Пароль
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "Пароль1С";
		стр_н.Синоним = "Пароль 1С";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Порт подключения
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "НомерПорта";
		стр_н.Синоним = "Номер порта (клиент тестирования)";
		стр_н.Значение = 1538;
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		// Порт подключения
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "ДополнительныеОпцииЗапуска";
		стр_н.Синоним = "Дополнительные опции запуска";
		стр_н.Значение = "";
		стр_н.ТолькоЧтение = Ложь;
		стр_н.Видимость = Истина;
		
		
		
		Попытка
			ОписаниеСвойствПодключения = мЗначениеИзСтрокиВнутр(СвойстваПодключенияКлиентаТестирования);
			
			// заполним данными
			Если ТипЗнч(ОписаниеСвойствПодключения)=Тип("Соответствие") Тогда
				Для каждого стр из СвойстваТаблицей Цикл
					Значение = ОписаниеСвойствПодключения.Получить(стр.Свойство);
					Если НЕ Значение=Неопределено Тогда
						стр.Значение = Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	ИначеЕсли  ДействиеИзСценария="ЗакрытьТестируемоеПриложение" Тогда
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаСвойстваТаблицей;
		
		СвойстваТаблицей.Очистить();
		
		// Настройки по умолчанию
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "НастройкиПоУмолчанию";
		стр_н.Синоним = "Настройки по умолчанию";
		стр_н.Значение = Истина;
		стр_н.ТолькоЧтение = Ложь;
		стр_н.Видимость = Истина;
		
		// Порт подключения
		стр_н = СвойстваТаблицей.Добавить();
		стр_н.Свойство = "НомерПорта";
		стр_н.Синоним = "Номер порта (клиент тестирования)";
		стр_н.Значение = 1538;
		стр_н.ТолькоЧтение = Истина;
		стр_н.Видимость = Истина;
		
		Попытка
			ОписаниеСвойствПодключения = мЗначениеИзСтрокиВнутр(СвойстваПодключенияКлиентаТестирования);
			
			// заполним данными
			Если ТипЗнч(ОписаниеСвойствПодключения)=Тип("Соответствие") Тогда
				Для каждого стр из СвойстваТаблицей Цикл
					Значение = ОписаниеСвойствПодключения.Получить(стр.Свойство);
					Если НЕ Значение=Неопределено Тогда
						стр.Значение = Значение;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	ИначеЕсли ДействиеИзСценария="Команда" И КомандаИзСценария="ПерейтиКСтроке" Тогда 
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаСвойстваТаблицей;
		
		Попытка
			ОписаниеСтроки = ЗначениеИзСтрокиВнутр(RowDescription);
			
			// заполним данными
			Если ТипЗнч(ОписаниеСтроки)=Тип("Соответствие") Тогда
				Для каждого стр из ОписаниеСтроки Цикл
					стр_н = СвойстваТаблицей.Добавить();
					стр_н.Свойство = стр.Ключ;
					стр_н.Синоним = стр.Ключ;
					стр_н.Значение = стр.Значение;
					стр_н.ТолькоЧтение = Ложь;
					стр_н.Видимость = Истина; 				
				КонецЦикла;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	ИначеЕсли ДействиеИзСценария="ГотовыйБлокШагов" Тогда
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаПодборБлокаШагов;
		
	ИначеЕсли ДействиеИзСценария="Условие" ИЛИ ДействиеИзСценария="ПолучитьПредставлениеДанных" ИЛИ ДействиеИзСценария="ПроверкаНаличияЭлемента" Тогда
		Если Параметры.Свойство("МассивСтруктурПараметров") Тогда
			ПараметрыСценария.Очистить();
			Для каждого стр из Параметры.МассивСтруктурПараметров Цикл
				стр_н = ПараметрыСценария.Добавить();
				ЗаполнитьЗначенияСвойств(стр_н,стр);
			КонецЦикла;
			Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаМассивСтруктурПараметров;
		ИначеЕсли ДействиеИзСценария="Условие" И Свойство="УсловиеСравнения" Тогда
			ЗаполнениеУсловияСравнения(УсловиеСравнения);
		КонецЕсли;
		
	ИначеЕсли ДействиеИзСценария="ВыборПроектаПоДереву" Тогда
		
		АдресХранилища = Параметры.АдресХранилища;
		ДеревоИзХранилища = ПолучитьИзВременногоХранилища(АдресХранилища);
		// продублируем таблицу по нужным полям, ключ это путь к файлу
		СкопироватьТаблицу(ДеревоИзХранилища,ДеревоПроектов,"Наименование,ПутьКфайлу,ДанныеКартинки","Наименование,Ключ,ДанныеКартинки","ЭтоГруппа",Истина);		
		Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаДеревоПроектов;
		
	ИначеЕсли ДействиеИзСценария="СравнитьСПредставлениемДанных" ИЛИ ДействиеИзСценария="Условие" Тогда
		
		ЗаполнениеУсловияСравнения(УсловиеСравнения);
		
	Иначе		
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнениеУсловияСравнения(Знач УсловиеСравнения)
	
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("Равно","Равно");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("НеРавно","НеРавно");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("Заполнено","Заполнено");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("НеЗаполнено","НеЗаполнено");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("Содержит","Содержит");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("НеСодержит","НеСодержит");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("RegExp","RegExp");
	Элементы.УсловиеСравнения.СписокВыбора.Добавить("НеRegExp","НеRegExp");
	//Элементы.УсловиеСравнения.СписокВыбора.Добавить("Больше","Больше");
	//Элементы.УсловиеСравнения.СписокВыбора.Добавить("БольшеРавно","БольшеРавно");
	//Элементы.УсловиеСравнения.СписокВыбора.Добавить("Меньше","Меньше");
	//Элементы.УсловиеСравнения.СписокВыбора.Добавить("МеньшеРавно","МеньшеРавно");
	
	Элементы.ГруппаСвойства.ТекущаяСтраница=Элементы.СтраницаУсловиеСравнения;	
	Если НЕ ЗначениеЗаполнено(УсловиеСравнения) Тогда
		УсловиеСравнения = "Равно";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если (ДействиеИзСценария="ПодключитьТестируемоеПриложение" ИЛИ ДействиеИзСценария="ЗакрытьТестируемоеПриложение") Тогда
		мИзменитьВидимостьДоступностьСвойствПоУмолчанию();
	ИначеЕсли ДействиеИзСценария="ВыборПроектаПоДереву" Тогда
		Для каждого стр из ДеревоПроектов.ПолучитьЭлементы() Цикл
			Элементы.ДеревоПроектов.Развернуть(стр.ПолучитьИдентификатор(),Истина);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриянтьИЗакрыть(Команда)
	
	мПараметры = новый Структура("Действие,Команда",ДействиеИзСценария,КомандаИзСценария);
	
	Если ДействиеИзСценария="ВыполнитьПроизвольныйКодКлиент"   Тогда
		
		мПараметры.Вставить("CustomCodeClient",Код1СИзСценария);
		
	ИначеЕсли ДействиеИзСценария="ВыполнитьПроизвольныйКодСервер" Тогда
		
		мПараметры.Вставить("CustomCodeServer",Код1СИзСценария);
		
	ИначеЕсли ДействиеИзСценария="ПодключитьТестируемоеПриложение" ИЛИ ДействиеИзСценария="ЗакрытьТестируемоеПриложение" Тогда
		
		ОписаниеСвойствПодключения = новый Соответствие;
		
		Для каждого стр из СвойстваТаблицей Цикл
			ОписаниеСвойствПодключения.Вставить(стр.Свойство,стр.Значение);
		КонецЦикла;
		
		мПараметры.Вставить("СвойстваПодключенияКлиентаТестирования",мЗначениеВСтрокуВнутр(ОписаниеСвойствПодключения));
		
	ИначеЕсли ДействиеИзСценария="Команда" И КомандаИзСценария="ПерейтиКСтроке" Тогда
		
		ОписаниеСтроки = новый Соответствие;
		
		Для каждого стр из СвойстваТаблицей Цикл
			Если НЕ ЗначениеЗаполнено(стр.Свойство) Тогда
				ОписаниеСтроки.Вставить(стр.Синоним,стр.Значение);
			Иначе
				ОписаниеСтроки.Вставить(стр.Свойство,стр.Значение);
			КонецЕсли;	
		КонецЦикла;
		
		мПараметры.Вставить("RowDescription",мЗначениеВСтрокуВнутр(ОписаниеСтроки));
		
	ИначеЕсли ДействиеИзСценария="ГотовыйБлокШагов" Тогда
		
		мПараметры.Вставить("ПутьБлокШагов",ПутьБлокШагов);
		мПараметры.Вставить("Library",Library);
		
	ИначеЕсли ДействиеИзСценария="Условие" ИЛИ ДействиеИзСценария="ПолучитьПредставлениеДанных" ИЛИ ДействиеИзСценария="ПроверкаНаличияЭлемента" Тогда
		
		ПараметрыСценарияОбработкаВыбораПараметра(мПараметры);
		Если Свойство="УсловиеСравнения" Тогда
			мПараметры.Вставить("УсловиеСравнения",УсловиеСравнения);
		КонецЕсли;
		
	ИначеЕсли ДействиеИзСценария="ВыборПроектаПоДереву"  Тогда
		
		ТекущиеДанные = Элементы.ДеревоПроектов.ТекущиеДанные;
		
		Если ТекущиеДанные=Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		мПараметры = новый Структура("Действие,Команда",ДействиеИзСценария,КомандаИзСценария);
		мПараметры.Вставить("Наименование",ТекущиеДанные.Наименование);
		мПараметры.Вставить("Ключ",ТекущиеДанные.Ключ);
		
		Оповестить(ДействиеИзСценария,мПараметры,ЭтаФорма);
		ЭтаФорма.Закрыть();	
		Возврат;
	ИначеЕсли ДействиеИзСценария="СравнитьСПредставлениемДанных" Тогда
		
		мПараметры.Вставить("УсловиеСравнения",УсловиеСравнения);
		
	КонецЕсли;		
		
	
	Оповестить(ИмяТаблицы,мПараметры,ЭтаФорма);
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция мЗначениеВСтрокуВнутр(Значение)
	Возврат ЗначениеВСтрокуВнутр(Значение);
КонецФункции

&НаСервереБезКонтекста
Функция мЗначениеИзСтрокиВнутр(Строка)
	Возврат ЗначениеИзСтрокиВнутр(Строка);
КонецФункции

&НаКлиенте
Процедура СвойстваТаблицейПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СвойстваТаблицей.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ДействиеИзСценария="ПодключитьТестируемоеПриложение" ИЛИ ДействиеИзСценария="ЗакрытьТестируемоеПриложение") И ТекущиеДанные.Свойство="НастройкиПоУмолчанию" Тогда
		мИзменитьВидимостьДоступностьСвойствПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура мИзменитьВидимостьДоступностьСвойствПоУмолчанию()
	
	НастройкиПоУмолчанию = Истина;
	мОтбор = новый Структура("Свойство","НастройкиПоУмолчанию");
	н_стр = СвойстваТаблицей.НайтиСтроки(мОтбор);
	
	Если н_стр.Количество()=1 Тогда			
			НастройкиПоУмолчанию = н_стр[0].Значение; 
	КонецЕсли;
	
	Для каждого стр из СвойстваТаблицей Цикл
		Если НЕ стр.Свойство="НастройкиПоУмолчанию" Тогда 			
			стр.Видимость = НЕ НастройкиПоУмолчанию; 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


&НаКлиенте
Процедура ПутьБлокШаговНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие); 
	Диалог.Заголовок = "Выберите файл"; 
	Диалог.ПолноеИмяФайла = ""; 
	Фильтр = "XML-файл (*.xml)|*.xml"; 
	Диалог.Фильтр = Фильтр; 
	Диалог.МножественныйВыбор = Ложь; 
	ВыборФайлаОткрытияСтруктурыКонфигурации = новый ОписаниеОповещения("ВыборФайлаОткрытияСтруктурыКонфигурации",ЭтотОбъект);
	Диалог.Показать(ВыборФайлаОткрытияСтруктурыКонфигурации);

КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаОткрытияСтруктурыКонфигурации(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	 Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ПутьБлокШагов = ВыбранныеФайлы[0]; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваТаблицейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока=Истина Тогда
		Элемент.ТекущиеДанные.Видимость = Истина;
		Элемент.ТекущиеДанные.Значение = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСценарияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	мПараметры = новый Структура("Действие,Команда",ДействиеИзСценария,КомандаИзСценария);
	
	Если ДействиеИзСценария="Условие" ИЛИ ДействиеИзСценария="ПолучитьПредставлениеДанных" ИЛИ ДействиеИзСценария="ПроверкаНаличияЭлемента" Тогда
		
		ПараметрыСценарияОбработкаВыбораПараметра(мПараметры);
		
	КонецЕсли;
	
	Оповестить(ИмяТаблицы,мПараметры,ЭтаФорма);
	ЭтаФорма.Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыСценарияОбработкаВыбораПараметра(Знач мПараметры)
	
	Перем ИмяПараметраСценария, ТекущиеДанные;
	
	ТекущиеДанные = Элементы.ПараметрыСценария.ТекущиеДанные;
	ИмяПараметраСценария = Неопределено;
	
	Если ТекущиеДанные<>Неопределено Тогда
		ИмяПараметраСценария = ТекущиеДанные.Имя;
	КонецЕсли;
	
	мПараметры.Вставить("ИмяПараметра",ИмяПараметраСценария);
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьТаблицу(Источник,Приемник,ПоляИсточника,ПоляПриемника,ИмяПоляФильтра="",ЗначениеФильтра="")
	
	Если Источник = Неопределено ИЛИ Приемник=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоляИдентичны = Истина;
	МассивПолейИсточника = новый массив;
	МассивПолейПриемника = новый массив;
	Если Врег(ПоляИсточника)<>Врег(ПоляПриемника) Тогда
		ПоляИдентичны = Ложь;
		МассивПолейИсточника = СтрРазделить(ПоляИсточника,",",Ложь);
		МассивПолейПриемника = СтрРазделить(ПоляПриемника,",",Ложь);
	КонецЕсли;
	
	Если ТипЗнч(Источник)=Тип("ДеревоЗначений") Тогда
		ЭлементыДерева = Источник.Строки;
	ИначеЕсли ТипЗнч(Источник)=Тип("СтрокаДереваЗначений") Тогда
		ЭлементыДерева = Источник.Строки;
	ИначеЕсли ТипЗнч(Источник)=Тип("ДанныеФормыДерево") Тогда
		ЭлементыДерева = Источник.ПолучитьЭлементы();
	ИначеЕсли ТипЗнч(Источник)=Тип("ДанныеФормыЭлементДерева") Тогда
		ЭлементыДерева = Источник.ПолучитьЭлементы();
	КонецЕсли;
	
	Для каждого стр из ЭлементыДерева Цикл
		
		Если ЗначениеЗаполнено(ИмяПоляФильтра) Тогда 
			Если НЕ стр[ИмяПоляФильтра]=ЗначениеФильтра Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(Приемник)=Тип("ДеревоЗначений") Тогда 
			стр_н = Приемник.Добавить();
		ИначеЕсли ТипЗнч(Приемник)=Тип("СтрокаДереваЗначений") Тогда
			стр_н = Приемник.Добавить();
		ИначеЕсли ТипЗнч(Приемник)=Тип("ДанныеФормыДерево") Тогда
			стр_н = Приемник.ПолучитьЭлементы().Добавить();
		ИначеЕсли ТипЗнч(Приемник)=Тип("ДанныеФормыЭлементДерева") Тогда
			стр_н = Приемник.ПолучитьЭлементы().Добавить();
		КонецЕсли;
		Если ПоляИдентичны=Истина Тогда
			ЗаполнитьЗначенияСвойств(стр_н,стр,ПоляИсточника);
		Иначе
			КоличествоПолей = МассивПолейИсточника.Количество();
			Если МассивПолейПриемника.Количество()<КоличествоПолей Тогда
				КоличествоПолей = МассивПолейПриемника.Количество();
			КонецЕсли;
			Для ш=0 по МассивПолейИсточника.Количество()-1 Цикл
				стр_н[МассивПолейПриемника[ш]] = стр[МассивПолейИсточника[ш]];
			КонецЦикла;
		КонецЕсли;
		
		СкопироватьТаблицу(стр,стр_н,ПоляИсточника,ПоляПриемника,ИмяПоляФильтра,ЗначениеФильтра);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПроектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДеревоПроектов.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	мПараметры = новый Структура("Действие,Команда",ДействиеИзСценария,КомандаИзСценария);
	мПараметры.Вставить("Наименование",ТекущиеДанные.Наименование);
	мПараметры.Вставить("Ключ",ТекущиеДанные.Ключ);
		
	Оповестить(ДействиеИзСценария,мПараметры,ЭтаФорма);
	ЭтаФорма.Закрыть();	
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьНаименованиеПоля(Команда)
	ТекущиеДанные = Элементы.СвойстваТаблицей.ТекущиеДанные;
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Свойство = "";
	ТекущиеДанные.Синоним = "";
	
КонецПроцедуры
