#Область ДополнительныеОбработки

Функция СведенияОВнешнейОбработке() Экспорт
	
	МассивНазначений = Новый Массив;
	
	ПараметрыРегистрации = Новый Структура;
	ПараметрыРегистрации.Вставить("Вид", "ДополнительнаяОбработка");
	ПараметрыРегистрации.Вставить("Назначение", МассивНазначений);
	ПараметрыРегистрации.Вставить("Наименование", "Allure Skin");
	ПараметрыРегистрации.Вставить("Версия", "2018.02.20");
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Ложь);
	ПараметрыРегистрации.Вставить("Информация", ИнформацияПоИсторииИзменений());
	ПараметрыРегистрации.Вставить("ВерсияБСП", "1.2.1.4");
	ТаблицаКоманд = ПолучитьТаблицуКоманд();
	ДобавитьКоманду(ТаблицаКоманд,
	                "Allure Skin",
					"AllureSkin",
					"ОткрытиеФормы",
					Истина,
					);
	ПараметрыРегистрации.Вставить("Команды", ТаблицаКоманд);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Функция ПолучитьТаблицуКоманд()
	
	Команды = Новый ТаблицаЗначений;
	Команды.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Использование", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("ПоказыватьОповещение", Новый ОписаниеТипов("Булево"));
	Команды.Колонки.Добавить("Модификатор", Новый ОписаниеТипов("Строка"));
	Команды.Колонки.Добавить("Описание", Новый ОписаниеТипов("Строка"));
	
	Возврат Команды;
	
КонецФункции

Процедура ДобавитьКоманду(ТаблицаКоманд, Представление, Идентификатор, Использование, ПоказыватьОповещение = Ложь, Модификатор = "",Описание = "")
	
	НоваяКоманда = ТаблицаКоманд.Добавить();
	НоваяКоманда.Представление = Представление;
	НоваяКоманда.Идентификатор = Идентификатор;
	НоваяКоманда.Использование = Использование;
	НоваяКоманда.ПоказыватьОповещение = ПоказыватьОповещение;
	НоваяКоманда.Модификатор = Модификатор;
	НоваяКоманда.Описание = Описание;
	
КонецПроцедуры

Функция ИнформацияПоИсторииИзменений()
	Возврат
	" <div style='text-indent: 25px;'>Обработка предназначена для удобного и наглядного отображения результатов проведения тестов.</div>
	| <div style='text-indent: 25px;'>Работает в разрезе тестируемого клиента и отображает информацию по последней проверке.</div>
	| <div style='text-indent: 25px;'>Пользователю доступны следующие варианты экранов:
	| <li><span style='color:blue;font-weight:bold;'>Домой</span> - начальная страница с общей сводкой инфорации;  </li>
	| <li><span style='color:blue;font-weight:bold;'>Дефекты</span> - показывает ошибки объекта тестирования и ошибки тестов;</li> 
	| <li><span style='color:blue;font-weight:bold;'>xUnit</span> - показывает информацию в списках по всем тестам, шагам;</li>
	| <li><span style='color:blue;font-weight:bold;'>Графики</span> - показывает сводную инфорацию на графиках о результатах тестов; </li>
	| <li><span style='color:blue;font-weight:bold;'>Поведение</span> - показывает изменения результатов тестов относительно предыдущих проверок.</li></div>
	| <hr />
	| Подробную информацию смотрите по адресу интернет: <a target='_blank' href='https://github.com/ivanov660/TestingTool-3/wiki/Allure-Skin'>https://github.com/ivanov660/TestingTool-3/wiki/Allure-Skin</a>";

КонецФункции

#КонецОбласти

#область ПрограммноеДобавлениеМеню

&НаСервере
Процедура ДобавитьМеню(ЭтаФорма,ИмяТекущегоМеню) Экспорт
	
	
	// добавили группу
	ВставитьЭлемент(ЭтаФорма,"ГруппаМеню",Тип("ГруппаФормы"),
		Новый Структура("ИмяСледующегоЭлемента,Вид,Группировка,ОтображатьЗаголовок,РастягиватьПоГоризонтали,РастягиватьПоВертикали","ГруппаТело",ВидГруппыФормы.ОбычнаяГруппа,ГруппировкаПодчиненныхЭлементовФормы.Вертикальная,Ложь,Ложь,Истина));
		
	ЭтаФорма.Элементы.ГруппаМеню.ЦветФона = новый Цвет(251, 237, 158);
		
	// добавим кнопки
	
	// добавляем кнопку Overview
	ДобавитьНаМенюКнопку(ЭтаФорма,"Overview","Обзор","КнопкаМеню","Дом_32х32",ИмяТекущегоМеню="Overview");
	
	// Defects
	ДобавитьНаМенюКнопку(ЭтаФорма,"Defects","Defects","КнопкаМеню","Паук_32х33",ИмяТекущегоМеню="Defects");
	
	// добавляем кнопку xUnit
	ДобавитьНаМенюКнопку(ЭтаФорма,"xUnit","xUnit","КнопкаМеню","Портфель_32х32",ИмяТекущегоМеню="xUnit");

	// Graphs
	ДобавитьНаМенюКнопку(ЭтаФорма,"Graphs","Graphs","КнопкаМеню","График_32х32",ИмяТекущегоМеню="Graphs");
	
	// Behaviors
	ДобавитьНаМенюКнопку(ЭтаФорма,"Behaviors","Behaviors","КнопкаМеню","Планировщик_32х32",ИмяТекущегоМеню="Behaviors");
	
	// TimeLine
	//ДобавитьНаМенюКнопку(ЭтаФорма,"TimeLine","TimeLine","КнопкаМеню","Часы_32х32",ИмяТекущегоМеню="TimeLine");
	
	
	// Options
	//ДобавитьНаМенюКнопку(ЭтаФорма,"Options","Options","КнопкаМеню","Настройка_32х34",ИмяТекущегоМеню="Options");
	  
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНаМенюКнопку(ЭтаФорма,ИмяКнопки,СинонимКнопки,ИмяФункции,ИмяКартинки,ЭтоТекущаяФорма=Ложь)  Экспорт
	
	Перем Команда_Overview;
		
	Команда_Overview = ЭтаФорма.Команды.Добавить(ИмяКнопки);
	Команда_Overview.Заголовок = СинонимКнопки;
	Команда_Overview.Подсказка = СинонимКнопки;
	Команда_Overview.Действие = ИмяФункции;
	Команда_Overview.Картинка = БиблиотекаКартинок[ИмяКартинки];
	Команда_Overview.Отображение = ОтображениеКнопки.Картинка;
	
	ВставитьЭлемент(ЭтаФорма,ИмяКнопки,Тип("КнопкаФормы"),
	Новый Структура("ИмяРодителя,Вид,ИмяКоманды","ГруппаМеню",ВидКнопкиФормы.ОбычнаяКнопка,Команда_Overview.Имя));	
	
	Если ЭтоТекущаяФорма=Истина Тогда
		ЭтаФорма.Элементы[ИмяКнопки].ЦветФона = новый Цвет(255, 255, 255);
	Иначе
		ЭтаФорма.Элементы[ИмяКнопки].ЦветФона = новый Цвет(251, 237, 158);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ВставитьЭлемент(Форма, Имя, Тип, СтруктураЭлемента) Экспорт
	
	Родитель=Форма;
	ИмяРодителя="";
	Если СтруктураЭлемента.Свойство("ИмяРодителя", ИмяРодителя)	И ЗначениеЗаполнено(ИмяРодителя) Тогда 
		Родитель = Форма.Элементы[ИмяРодителя];
	КонецЕсли;
	
	СледующийЭлемент=Неопределено;
	ИмяСледующегоЭлемента="";
	Если СтруктураЭлемента.Свойство("ИмяСледующегоЭлемента", ИмяСледующегоЭлемента)
		И ЗначениеЗаполнено(ИмяСледующегоЭлемента) Тогда 
		СледующийЭлемент=Форма.Элементы[ИмяСледующегоЭлемента];
	КонецЕсли;
	
	Элемент=Форма.Элементы.Вставить(Имя, Тип, Родитель, СледующийЭлемент);
	
	ЗаполнитьЗначенияСвойств(Элемент,СтруктураЭлемента);
	
	Возврат Элемент;
	
КонецФункции

&НаСервере
Процедура ДобавитьОсновнойОтбор(ЭтаФорма,ИмяТекущегоМеню) Экспорт
	
КонецПроцедуры

#КонецОбласти


#Область СохранениеЗагрузкаНастроек

&НаСервере
Процедура СохранитьНастройкиПользователя(ОбъектДанных,ИмяНастройки="",ЗначениеНастройки="") Экспорт
	
	Если ИмяНастройки="" Тогда
		ХранилищеОбщихНастроек.Сохранить("Объект.ТестируемыйКлиент", "ТестируемыйКлиент", ОбъектДанных.ТестируемыйКлиент, , Пользователи.ТекущийПользователь());
	Иначе
		ХранилищеОбщихНастроек.Сохранить("Объект.ТестируемыйКлиент", ИмяНастройки, ЗначениеНастройки , , Пользователи.ТекущийПользователь());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузитьНастройкиПользователя(ОбъектДанных,ИмяНастройки="") Экспорт
	
	ЗначениеНастройки = Неопределено;
	
	Если ИмяНастройки="" Тогда 
		ОбъектДанных.ТестируемыйКлиент = ХранилищеОбщихНастроек.Загрузить("Объект.ТестируемыйКлиент", "ТестируемыйКлиент", , Пользователи.ТекущийПользователь());
	Иначе
		ЗначениеНастройки = ХранилищеОбщихНастроек.Загрузить("Объект.ТестируемыйКлиент", ИмяНастройки, , Пользователи.ТекущийПользователь());
	КонецЕсли;
	
	Возврат ЗначениеНастройки;
КонецФункции

#КонецОбласти
