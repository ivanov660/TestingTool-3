&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Отказ = Истина; // форма не предназначена для открытия
КонецПроцедуры

#Область мСцен

&НаКлиенте
Процедура мСцен_ПреобразоватьВДеревоСценарияНаКлиенте(Знач ТекстСценария,ДеревоСценария,мПараметры,ЭтоБуфер=Ложь) Экспорт
	
	ЗаполнитьЗначенияСвойств(Объект,мПараметры);
	мСцен_ПреобразоватьВДеревоСценарияНаСервере(ТекстСценария,ДеревоСценария,мПараметры,ЭтоБуфер);
	
КонецПроцедуры

// за основу взята идея UILogToScript
&НаСервере
Процедура мСцен_ПреобразоватьВДеревоСценарияНаСервере(Знач ТекстСценария,ДеревоСценария,мПараметры,ЭтоБуфер=Ложь) Экспорт
	
	ТребуетяОбвязкаПодключения = Истина;
	
	ЗаполнитьЗначенияСвойств(Объект,мПараметры);
	
	ДеревоСценария.ПолучитьЭлементы().Очистить();
	
	КорневаяВеткаДереваСценария = ДеревоСценария;
	
	Если ЭтоБуфер=Истина Тогда
		ТребуетяОбвязкаПодключения = Ложь;
		//НулевойУзел = ДеревоСценария.ПолучитьЭлементы().Добавить();
		//НулевойУзел.Наименование = "Буфер";
		//НулевойУзел.Действие = "Комментарий";
		//КорневаяВеткаДереваСценария = НулевойУзел;
	КонецЕсли;
	
	
	
	ЧтениеXML = новый ЧтениеXML();
	ЧтениеXML.УстановитьСтроку(ТекстСценария);

	ЧтениеXML.ПерейтиКСодержимому();

	// Converting the file
	Если ЧтениеXML.ТипУзла = XMLNodeType.StartElement И
		ЧтениеXML.Имя = "uilog" Тогда
 		мСцен_ПреобразоватьВДеревоСценарий(ЧтениеXML,КорневаяВеткаДереваСценария,ТребуетяОбвязкаПодключения); 
	КонецЕсли; 	
	
КонецПроцедуры

&НаСервере
Процедура мСцен_ПреобразоватьВДеревоСценарий(ЧтениеXML,РодительВетка,ТребуетяОбвязкаПодключения)
	
	
	Если ТребуетяОбвязкаПодключения=Истина Тогда
		мСцен_GenerateClientConnectionScript(РодительВетка);
	КонецЕсли;
	
	ЧтениеXML.Прочитать();
	
	Пока ЧтениеXML.ТипУзла <> XMLNodeType.EndElement Цикл

		ТекущаяВетка = РодительВетка;
		
		Если ЧтениеXML.Имя = "ClientApplicationWindow" Тогда
			мСцен_ConvertWindow(ЧтениеXML, ТекущаяВетка);
		ИначеЕсли ЧтениеXML.Имя = "Form" Тогда
			мСцен_ConvertForm(ЧтениеXML, ТекущаяВетка); 
		ИначеЕсли ЧтениеXML.Имя = "setFileDialogResult" Тогда
			мСцен_ConvertFileDialog(ЧтениеXML, ТекущаяВетка);
		Иначе  			
			НеопознанныйУзел = РодительВетка.ПолучитьЭлементы().Добавить();
			НеопознанныйУзел.Наименование = "Неопознанный узел: "+ЧтениеXML.Имя;
			НеопознанныйУзел.Описание = "'Неопознанный узел '" + ЧтениеXML.Имя + ": " + ЧтениеXML.Value;
			ВызватьИсключение "'Неопознанный узел '" + ЧтениеXML.Имя + ": " + ЧтениеXML.Value;
		КонецЕсли;

	КонецЦикла;
	
	Если ТребуетяОбвязкаПодключения=Истина Тогда
		мСцен_GenerateClientDisconnectionScript(РодительВетка);
	КонецЕсли;
	

КонецПроцедуры

&НаСервереБезКонтекста
Функция мСцен_ПолучитьДанныеКартинки_НаКлиенте(Узел) Экспорт
	
	Действие = "";
	ТипОбъекта = "";

	
	Попытка
		Действие = Узел.Действие;
		ТипОбъекта = Узел.ТипОбъекта;
	Исключение
	КонецПопытки;
	
	
	// Картинка в поле Картинка
	Если Действие = "" ИЛИ Действие = "UnknownNode" ИЛИ Действие = "НеизвестныйУзел" Тогда
		ДанныеКартинки = 1;
		
	ИначеЕсли Действие = "НайтиОкно" ИЛИ Действие = "НайтиОсновноеОкно" Тогда
		ДанныеКартинки = 2;
		
	ИначеЕсли Действие = "НайтиФорму" Тогда
		ДанныеКартинки = 3;
		
	ИначеЕсли Действие = "Команда" И (ТипОбъекта ="FormButton" ИЛИ ТипОбъекта = "CommandInterfaceButton") Тогда
		ДанныеКартинки = 4;
		
	ИначеЕсли Действие = "НайтиОбъект" Тогда
		ДанныеКартинки = 5;
		
	ИначеЕсли Действие = "Условие" Тогда
		ДанныеКартинки = 6;
		
	ИначеЕсли Действие = "Команда" Тогда
		ДанныеКартинки = 7;
		
	ИначеЕсли Действие = "ПолучитьКомандныйИнтерфейс" Тогда
		ДанныеКартинки = 8;
		
	ИначеЕсли Действие = "GenerateClientConnectionScript" ИЛИ Действие = "ПодключитьТестируемоеПриложение" Тогда
		ДанныеКартинки = 9;
		
	ИначеЕсли Действие = "ЗакрытьТестируемоеПриложение" ИЛИ Действие = "GenerateClientDisconnectionScript" Тогда
		ДанныеКартинки = 10;
		
	ИначеЕсли Действие = "Комментарий" Тогда
		ДанныеКартинки = 11;
		
	ИначеЕсли Действие = "ВыполнитьПроизвольныйКодСервер" Тогда
		ДанныеКартинки = 12;
		
	ИначеЕсли Действие = "ВыполнитьПроизвольныйКодКлиент" Тогда
		ДанныеКартинки = 13;
		
	ИначеЕсли Действие = "Стоп" Тогда
		ДанныеКартинки = 14;
		
	ИначеЕсли Действие = "Пауза" Тогда
		ДанныеКартинки = 15;
		
	ИначеЕсли Действие = "СравнитьСПредставлениемДанных" Тогда
		ДанныеКартинки = 16;
		
	ИначеЕсли Действие = "ПолучитьПредставлениеДанных" Тогда
		ДанныеКартинки = 17;
		
	ИначеЕсли Действие = "ГотовыйБлокШагов" Тогда
		ДанныеКартинки = 18;
		
	ИначеЕсли Действие = "ТестовыйСлучай" Тогда
		ДанныеКартинки = 19;
		
	ИначеЕсли Действие = "ДилогВыбораФайла" Тогда
		ДанныеКартинки = 0;
		
	ИначеЕсли Действие = "Timer" ИЛИ Действие = "Таймер" Тогда
		ДанныеКартинки = 20;		
		
	ИначеЕсли Действие = "ИзПараметра1ВПараметр2" Тогда
		ДанныеКартинки = 21;
		
	ИначеЕсли Действие = "ПроверкаНаличияЭлемента" Тогда
		ДанныеКартинки = 22;
		
	ИначеЕсли Действие = "ВызватьИсключение" ИЛИ Действие="ThrowExeption" Тогда
		ДанныеКартинки = 23;
		
	ИначеЕсли Действие = "СделатьСнимокОкна" ИЛИ Действие="MakeScreenShot" Тогда
		ДанныеКартинки = 24;
		
	ИначеЕсли Действие = "Память" ИЛИ Действие="Memory" Тогда
		ДанныеКартинки = 25;
		
	ИначеЕсли Действие = "Логика" ИЛИ Действие="Logic" Тогда
		ДанныеКартинки = 26;
		
	ИначеЕсли Действие = "ЦиклДляКаждого" ИЛИ Действие="OperatorForEach" Тогда
		ДанныеКартинки = 35;		
		
		
	КонецЕсли;
	
	Возврат ДанныеКартинки;
	
КонецФункции

&НаСервере
Процедура мСцен_ConvertWindow(ЧтениеXML, РодительВетка)
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Имя;
	ТекущаяВетка.ЗаголовокОбъекта = "";
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ЭтоГлавноеОкно = Ложь;
	
	Пока ЧтениеXML.ReadAttribute() Цикл
		Если ЧтениеXML.Имя = "caption" Тогда
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Значение;
		ИначеЕсли ЧтениеXML.Имя = "isMain" тогда
			ТекущаяВетка.ЭтоГлавноеОкно = Boolean(ЧтениеXML.Значение);
		КонецЕсли;
	КонецЦикла;

	ИмяПеременной = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЭтоГлавноеОкно, "Основное", ТекущаяВетка.ЗаголовокОбъекта));
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	
	
	If ТекущаяВетка.ЭтоГлавноеОкно Then
		ТекущаяВетка.Действие ="НайтиОсновноеОкно";
	Else
		ТекущаяВетка.Действие ="НайтиОкно";
	EndIf; 
	
	// основные элементы отображения  
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);	
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);
	
	ЧтениеXML.Read();
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Имя = "Form" Then
			мСцен_ConvertForm(ЧтениеXML, ТекущаяВетка);
		ElsIf ЧтениеXML.Имя = "CommandInterface" Then
			мСцен_ConvertWindowCommandInterface(ЧтениеXML, ТекущаяВетка);
		Else
			//ТекущаяВетка.Наименование = "Команда";
			IF Not мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				НеопознанныйУзел = РодительВетка.ПолучитьЭлементы().Добавить();
				НеопознанныйУзел.Наименование = "Неопознанный узел: "+ЧтениеXML.Имя;
				НеопознанныйУзел.Описание = "'Неопознанный узел '" + ЧтениеXML.Имя + ": " + ЧтениеXML.Value;
				Raise "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndIf;

	EndDo;

	ЧтениеXML.Read();
	
КонецПроцедуры

&НаСервере
Процедура мСцен_ConvertForm(ЧтениеXML, РодительВетка)

	Если НЕ Объект.ИсключатьПоискФорм = Истина Тогда
		ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
		ТекущаяВетка.ТипОбъекта = ЧтениеXML.Имя;
		ТекущаяВетка.ЗаголовокОбъекта = "";
		ТекущаяВетка.Наименование = "";
	
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "title" Then
				ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
			EndIf;
		EndDo;
	
		LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ТекущаяВетка.ЗаголовокОбъекта);
		ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
		ТекущаяВетка.ИмяПеременной = ИмяПеременной;
		ТекущаяВетка.Действие = "НайтиФорму";
	
		// основные элементы отображения
		ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
		ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);
	Иначе
		ТекущаяВетка = РодительВетка;
	КонецЕсли;

	
	ЧтениеXML.Read();

	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Name = "FormField" Then
			мСцен_ConvertField(ЧтениеXML, ТекущаяВетка);
		ElsIf ЧтениеXML.Name = "FormTable" Then
			мСцен_ConvertTable(ЧтениеXML, ТекущаяВетка);
		ElsIf ЧтениеXML.Name = "FormDecoration" Then
			мСцен_ConvertDecoration(ЧтениеXML, ТекущаяВетка);
		ElsIf ЧтениеXML.Name = "FormButton" Then
			мСцен_ConvertButton(ЧтениеXML, ТекущаяВетка);
		ElsIf ЧтениеXML.Name = "FormGroup" Then
			мСцен_ConvertGroup(ЧтениеXML, ТекущаяВетка);
		Else
			//ТекущаяВетка.Наименование = "Команда";
			If Not мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;

		EndIf;

	EndDo;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertFileDialog(ЧтениеXML, РодительВетка)

	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Имя;
	ТекущаяВетка.ЗаголовокОбъекта = "";
	ТекущаяВетка.Наименование = "";
	
	result = false;
	filterIndex = 0;	

	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "result" Then
			result = ЧтениеXML.Value;
		ElsIF ЧтениеXML.Name = "filterIndex" Then 
			filterIndex = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ТекущаяВетка.ЗаголовокОбъекта);
	ИмяПеременной = LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "ДилогВыбораФайла";	
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);

	
	ЧтениеXML.Read();

	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Name = "filename" Then
			filename = "";
			While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
				ЧтениеXML.Read();
				ТекущаяВетка.filename = ЧтениеXML.Value;
				ЧтениеXML.Read();
			EndDo;
		Else
			Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;
	
	ЧтениеXML.Read();
	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertField(ЧтениеXML, РодительВетка)

	// создадим ветку
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));
	ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	

	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do

		If ЧтениеXML.Name = "FormField" Then			
			мСцен_ConvertField(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		Else 
			//ТекущаяВетка.Наименование = "Команда";
			If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				CommandConverted = True;
			Else
				Raise NStr("en = 'Unknown node'; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndIf;
	EndDo;
	
	//Если CommandConverted = Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertItemAddition(ЧтениеXML, РодительВетка)

	// создадим ветку
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));
	ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	

	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do

		If ЧтениеXML.Name = "FormField" Then			
			мСцен_ConvertField(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormItemAddition" Then			
			мСцен_ConvertItemAddition(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormButton" Then
			мСцен_ConvertButton(ЧтениеXML, ТекущаяВетка);  // GetFullHierarchy
		Else 
			//ТекущаяВетка.Наименование = "Команда";
			If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				CommandConverted = True;
			Else
				Raise NStr("en = 'Unknown node'; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndIf;
	EndDo;
	
	//Если CommandConverted = Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertTable(ЧтениеXML, РодительВетка)

	// создадим ветку
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));
	ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";

	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do

				
		If ЧтениеXML.Name = "FormField" Then
			//мСцен_ConvertField(ЧтениеXML, ТекущаяВетка);  // GetFullHierarchy
			мСцен_ConvertField(ЧтениеXML, ТекущаяВетка);  // GetFullHierarchy
		ElsIf ЧтениеXML.Name="FormItemAddition" Then
			мСцен_ConvertItemAddition(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormGroup" Then
			//мСцен_ConvertGroup(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
			мСцен_ConvertGroup(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		Else
			//ТекущаяВетка.Наименование = "Команда";
			If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				CommandConverted = True;
			Else
				Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
				
			EndIf;
		EndIf;
	EndDo;
	
	//Если CommandConverted = Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь  Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertDecoration(ЧтениеXML, РодительВетка)

	// создадим ветку
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));

	ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do

		If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
			CommandConverted = True;
		Else
			Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;
	
	//Если CommandConverted=Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;	

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertButton(ЧтениеXML, РодительВетка)

	// создадим ветку
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));
	ИмяПеременной =  РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";

	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
			CommandConverted = True;
		Else
			Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;

	//Если CommandConverted = Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;
	
	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertGroup(ЧтениеXML, РодительВетка)
	
	// создадим ветку
	ТекущаяВетка = Неопределено;
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ИмяОбъекта = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "name" Then
			ТекущаяВетка.ИмяОбъекта = ЧтениеXML.Value;
		ElsIf ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;
	
	
	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ? (ТекущаяВетка.ЗаголовокОбъекта = "", ТекущаяВетка.ИмяОбъекта, ТекущаяВетка.ЗаголовокОбъекта));
	ИмяПеременной =  РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Name = "FormField" Then
			мСцен_ConvertField(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormTable" Then
			мСцен_ConvertTable(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormDecoration" Then
			мСцен_ConvertDecoration(ЧтениеXML, ТекущаяВетка);  // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormButton" Then
			мСцен_ConvertButton(ЧтениеXML, ТекущаяВетка);  // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "FormGroup" Then
			// удалим иерархию
			Если Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь И РодительВетка<>ТекущаяВетка Тогда
				Если ТекущаяВетка.ТипОбъекта="FormGroup" И ТекущаяВетка.ПолучитьЭлементы().Количество()=0 Тогда
					РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
					ТекущаяВетка = РодительВетка; 
				КонецЕсли;
			КонецЕсли;			
			мСцен_ConvertGroup(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
			CommandConverted = True;
		Else
			Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;

	// если для группы нет ни одной команды, то мы смело можем удалить
	// но если команда была - активизировать/свернуть/развернуть и др. мы обязаны ее оставить
	Если CommandConverted = Ложь И Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь И РодительВетка<>ТекущаяВетка Тогда
		// Надо перенести элементы на родителя, а узел удалить
		мСценСкопироватьЭлементы(РодительВетка,ТекущаяВетка);
		РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertWindowCommandInterface(ЧтениеXML, РодительВетка)

	// добавим узел
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ЗаголовокОбъекта = "";

	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ТекущаяВетка.ЗаголовокОбъекта);
	ИмяПеременной = РодительВетка.ИмяПеременной + "CommandInterface";
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "ПолучитьКомандныйИнтерфейс";

	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Name = "CommandInterfaceButton" Then
			мСцен_ConvertCommandInterfaceButton(ЧтениеXML, ТекущаяВетка );
		ElsIf ЧтениеXML.Name = "CommandInterfaceGroup" Then
			мСцен_ConvertCommandInterfaceGroup(ЧтениеXML, ТекущаяВетка);
		Else
			//ТекущаяВетка.Наименование = "Команда";
			if Not мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
				ТекущаяВетка.Наименование = "Неопознанный узел"; 	
				ТекущаяВетка.Описание = "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value; 
				Raise "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			Endif;
			
		EndIf;

	EndDo;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Функция мСцен_ConvertCommand(ЧтениеXML, РодительВетка)

	// добавим узел
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "Команда";
	ТекущаяВетка.ИмяПеременной = РодительВетка.ИмяПеременной;
	
	If ЧтениеXML.Name = "activate" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Activate();", ".Активизировать();"), True);
		LastProcessedCommand = "Активизировать";   // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "inputText" Then
		OutputText = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "text" Then
				OutputText = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		ТекущаяВетка.OutputText = OutputText;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".InputText(""", ".ВвестиТекст(""") + DoubleQuotationMarks(OutputText) + """);", True);
		LastProcessedCommand = "ВвестиТекст";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "click" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Click();", ".Нажать();"), True);
		LastProcessedCommand = "Нажать";    // обработано +
		ЧтениеXML.Read();
	
	ElsIf ЧтениеXML.Name = "ClickViewStatusItem" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "item" Then
				Presentation = ЧтениеXML.Value;
			EndIf;
		EndDo;
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "НажатьНаЭлементСостоянияПросмотра";    // обработано +
		ЧтениеXML.Read();
	ElsIf ЧтениеXML.Name = "GetViewStatusItemTexts" Then
		LastProcessedCommand = "ПолучитьТекстыЭлементовСостоянияПросмотра";    // обработано +
		ЧтениеXML.Read();
	ElsIf ЧтениеXML.Name = "DeleteViewStatusItem" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "item" Then
				Presentation = ЧтениеXML.Value;
			EndIf;
		EndDo;
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "УдалитьЭлементСостоянияПросмотра";    // обработано +
		ЧтениеXML.Read();
		
	ElsIf ЧтениеXML.Name = "inputHTML" Then
		
		OutputText = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "HTML" Then
				OutputText = ЧтениеXML.Value;
			//Else
			//	Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		LastProcessedCommand = "inputHTML";    // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "clear" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Clear();", ".Очистить();"), True);
		LastProcessedCommand = "Очистить";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "create" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Create();", ".Создать();"), True);
		LastProcessedCommand = "Создать";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "cancel" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".CancelEdit();", ".ОтменитьРедактирование();"), True);
		LastProcessedCommand = "ОтменитьРедактирование"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "open" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Open();", ".Открыть();"), True);
		LastProcessedCommand = "Открыть";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "startChoosing" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".StartChoosing();", ".Выбрать();"), True);
		LastProcessedCommand = "Выбрать"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "startChoosingFromChoiceList" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".StartChoosingFromChoiceList();", ".ВыбратьИзСпискаВыбора();"), True);
		LastProcessedCommand = "ВыбратьИзСпискаВыбора"; // оббработано +
		ЧтениеXML.Read();
		
	ElsIf ЧтениеXML.Name = "executeChoiceFromMenu" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "presentation" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ВыполнитьВыборИзМеню"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "executeChoiceFromChoiceList" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "presentation" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".WaitForDropDownListGeneration();", ".ОжидатьФормированияВыпадающегоСписка();"), True);
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".ExecuteChoiceFromChoiceList(""", ".ВыполнитьВыборИзСпискаВыбора(""") + DoubleQuotationMarks(Presentation) + """);", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ВыполнитьВыборИзСпискаВыбора"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "openDropList" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".OpenDropList();", ".ОткрытьВыпадающийСписок();"), True);
		LastProcessedCommand = "ОткрытьВыпадающийСписок";    // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "closeDropList" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".CloseDropList();", ".ЗакрытьВыпадающийСписок();"), True);
		LastProcessedCommand = "ЗакрытьВыпадающийСписок";   // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "executeChoiceFromDropList" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "presentation" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".WaitForDropDownListGeneration();", ".ОжидатьФормированияВыпадающегоСписка();"), True);
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".ExecuteChoiceFromDropList(""", ".ВыполнитьВыборИзВыпадающегоСписка(""") + DoubleQuotationMarks(Presentation) + """);", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ВыполнитьВыборИзВыпадающегоСписка";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "increaseValue" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".IncreaseValue();", ".УвеличитьЗначение();"), True);
		LastProcessedCommand = "УвеличитьЗначение"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "decreaseValue" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".DecreaseValue();", ".УменьшитьЗначение();"), True);
		LastProcessedCommand = "УменьшитьЗначение"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "setCheck" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SetCheck();", ".УстановитьОтметку();"), True);
		LastProcessedCommand = "УстановитьОтметку"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "selectOption" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "presentation" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SelectOption(""", ".ВыбратьВариант(""") + DoubleQuotationMarks(Presentation) + """);", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ВыбратьВариант";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoValue" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "value" Then
				Presentation = ЧтениеXML.Value;
			ElsIf ЧтениеXML.Name = "presentation" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoValue(""", ".ПерейтиКЗначению(""") + DoubleQuotationMarks(Presentation) + """);", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ПерейтиКЗначению";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoNextMonth" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoNextMonth();", ".ПерейтиНаМесяцВперед();"), True);
		LastProcessedCommand = "ПерейтиНаМесяцВперед";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoPreviousMonth" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoPreviousMonth();", ".ПерейтиНаМесяцНазад();"), True);
		LastProcessedCommand = "ПерейтиНаМесяцНазад";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoNextYear" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoNextYear();", ".ПерейтиНаГодВперед();"), True);
		LastProcessedCommand = "ПерейтиНаГодВперед";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoPreviousYear" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoPreviousYear();", ".ПерейтиНаГодНазад();"), True);
		LastProcessedCommand = "ПерейтиНаГодНазад";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoDate" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "date" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; 'ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoDate(XMLValue(Type(""Date""), """, ".ПерейтиКДате(XMLЗначение(Тип(""Дата""), """) + Presentation + """));", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "ПерейтиКДате";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "setCurrentArea" Then
		Area = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "area" Then
				Area = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SetCurrentArea(""", ".УстановитьТекущуюОбласть(""") + Area + """);", True);
		ТекущаяВетка.Area = Area;
		LastProcessedCommand = "УстановитьТекущуюОбласть";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "beginEditingCurrentArea" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".BeginEditingCurrentArea();", ".НачатьРедактированиеТекущейОбласти();"), True);
		LastProcessedCommand = "НачатьРедактированиеТекущейОбласти";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "finishEditingCurrentArea" Then
		CancelFlag = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "cancel" Then
				CancelFlag = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".EndEditingCurrentArea(", ".ЗавершитьРедактированиеТекущейОбласти(") + CancelFlag + ");", True);
		Если НЕ ЗначениеЗаполнено(CancelFlag) Тогда
			ТекущаяВетка.Cancel = Ложь;
		ИначеЕсли Врег(CancelFlag)="FALSE" Тогда
			ТекущаяВетка.Cancel = Ложь;
		Иначе 
			ТекущаяВетка.Cancel = Истина;
		КонецЕсли;
		LastProcessedCommand = "ЗавершитьРедактированиеТекущейОбласти";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoNextItem" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoNextItem();", ".ПерейтиКСледующемуЭлементу();"), True);
		LastProcessedCommand = "ПерейтиКСледующемуЭлементу";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoPreviousItem" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoPreviousItem();", ".ПерейтиКПредыдущемуЭлементу();"), True);
		LastProcessedCommand = "ПерейтиКПредыдущемуЭлементу";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "goOneLevelUp" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GoOneLevelUp();", ".ПерейтиНаУровеньВверх();"), True);
		ЧтениеXML.Read();
		мСцен_ConvertCommandPartRowDescriptionPartInt(ЧтениеXML, РодительВетка, ТекущаяВетка);
		LastProcessedCommand = "ПерейтиНаУровеньВверх";

	ElsIf ЧтениеXML.Name = "goOneLevelDown" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GoOneLevelDown();", ".ПерейтиНаУровеньВниз();"), True);
		ЧтениеXML.Read();
		мСцен_ConvertCommandPartRowDescriptionPartInt(ЧтениеXML, РодительВетка, ТекущаяВетка);
		LastProcessedCommand = "ПерейтиНаУровеньВниз";

	ElsIf ЧтениеXML.Name = "gotoNextRow" Then
		SwitchSelection = false;
		мСцен_ConvertCommandPartGotoSpecificRow(ЧтениеXML, РодительВетка, "ПерейтиКСледующейСтроке",SwitchSelection);
		LastProcessedCommand = "ПерейтиКСледующейСтроке";  // обработано +
		ТекущаяВетка.SwitchSelection = SwitchSelection;

	ElsIf ЧтениеXML.Name = "gotoPreviousRow" Then
		SwitchSelection = false;
		мСцен_ConvertCommandPartGotoSpecificRow(ЧтениеXML, РодительВетка, "ПерейтиКПредыдущейСтроке",SwitchSelection);
		LastProcessedCommand = "ПерейтиКПредыдущейСтроке";
		ТекущаяВетка.SwitchSelection = SwitchSelection;   // обработано +

	ElsIf ЧтениеXML.Name = "gotoFirstRow" Then
		SwitchSelection = false;
		мСцен_ConvertCommandPartGotoSpecificRow(ЧтениеXML, РодительВетка, "ПерейтиКПервойСтроке",SwitchSelection);
		LastProcessedCommand = "ПерейтиКПервойСтроке";   // обработано +
		ТекущаяВетка.SwitchSelection = SwitchSelection;

	ElsIf ЧтениеXML.Name = "gotoLastRow" Then
		SwitchSelection = false;
		мСцен_ConvertCommandPartGotoSpecificRow(ЧтениеXML, РодительВетка, "ПерейтиКПоследнейСтроке",SwitchSelection);
		LastProcessedCommand = "ПерейтиКПоследнейСтроке"; // обработано +
		ТекущаяВетка.SwitchSelection = SwitchSelection;

	ElsIf ЧтениеXML.Name = "gotoRow" Then
		Direction = "";
		SwitchSelection = false;
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "direction" Then
				Direction = ? (ЧтениеXML.Value = "up", "Вверх", "Вниз");
			ElsIf ЧтениеXML.Name = "switchSelection" Then
				Если НЕ ЗначениеЗаполнено(ЧтениеXML.Value) Тогда
					SwitchSelection = Ложь;
				ИначеЕсли Врег(ЧтениеXML.Value)="FALSE" Тогда
					SwitchSelection = Ложь;
				Иначе 
					SwitchSelection = Истина;
				КонецЕсли;					
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		ТекущаяВетка.Direction = Direction;
		ТекущаяВетка.SwitchSelection = SwitchSelection;
		ЧтениеXML.Read();
		мСцен_ConvertCommandPartRowDescriptionPartInt(ЧтениеXML, РодительВетка, ТекущаяВетка);
		//AddLine(Writer,
		//		VariableName + ? (ScriptVariant = "en", ".GotoRow(RowDescription", ".ПерейтиКСтроке(ОписаниеСтроки") + ? (Direction = "", "", ", " + Direction) + ");",
		//		True);
		LastProcessedCommand = "ПерейтиКСтроке";

	ElsIf ЧтениеXML.Name = "setOrder" Then
		ColumnTitle = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "columnTitle" Then
				ColumnTitle = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SetOrder(""", ".УстановитьПорядок(""") + DoubleQuotationMarks(ColumnTitle) + """);", True);
		LastProcessedCommand = "УстановитьПорядок";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "choose" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Choose();", ".Выбрать();"), True);
		LastProcessedCommand = "Выбрать";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "selectAllRows" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SelectAllRows();", ".ВыделитьВсеСтроки();"), True);
		LastProcessedCommand = "ВыделитьВсеСтроки";  // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "changeRow" Then
		//AddLine(Writer, VariableName +? (ScriptVariant = "en", ".ChangeRow();", ".ИзменитьСтроку();"), True);
		LastProcessedCommand = "ИзменитьСтроку"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "endEditRow" Then
		CancelFlag = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "cancel" Then
				CancelFlag = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".EndEditRow(", ".ЗакончитьРедактированиеСтроки(") + CancelFlag + ");", True);
		Если НЕ ЗначениеЗаполнено(CancelFlag) Тогда
			ТекущаяВетка.Cancel = Ложь;
		ИначеЕсли Врег(CancelFlag)="FALSE" Тогда
			ТекущаяВетка.Cancel = Ложь;
		Иначе 
			ТекущаяВетка.Cancel = Истина;
		КонецЕсли;
		LastProcessedCommand = "ЗакончитьРедактированиеСтроки";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "addRow" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".AddRow();", ".ДобавитьСтроку();"), True);
		LastProcessedCommand = "ДобавитьСтроку"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "deleteRow" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".DeleteRow();", ".УдалитьСтроку();"), True);
		LastProcessedCommand = "УдалитьСтроку"; // обработано +
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "switchRowDeleteMark" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SwitchRowDeleteMark();", ".ПереключитьПометкуУдаленияСтроки();"), True);
		LastProcessedCommand = "ПереключитьПометкуУдаленияСтроки";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "expand" Then
		If РодительВетка.ТипОбъекта = "FormGroup" Then
			//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Expand();", ".Развернуть();"), True);
			LastProcessedCommand = "Развернуть";
			ЧтениеXML.Read();
		Else
			мСцен_ConvertCommandPartRowDescription(ЧтениеXML, РодительВетка, ТекущаяВетка, "Развернуть");
		Endif;
		LastProcessedCommand = "Развернуть";     // обработано +

	ElsIf ЧтениеXML.Name = "collapse" Then
		If РодительВетка.ТипОбъекта = "FormGroup" Then
			//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Collapse();", ".Свернуть();"), True);
			LastProcessedCommand = "Свернуть";
			ЧтениеXML.Read();
		Else
			мСцен_ConvertCommandPartRowDescription(ЧтениеXML, РодительВетка, ТекущаяВетка, "Свернуть");
		EndIf;
		LastProcessedCommand = "Свернуть";

	ElsIf ЧтениеXML.Name = "close" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".Close();", ".Закрыть();"), True);
		LastProcessedCommand = "Закрыть";
		WindowClosed = True;
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "chooseUserMessage" Then
		MessageText = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "messageText" Then
				MessageText = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".ChooseUserMessage(""", ".ВыбратьСообщениеПользователю(""") + MessageText + """);", True);
		LastProcessedCommand = "ВыбратьСообщениеПользователю";
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "closeUserMessagesPanel" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".CloseUserMessagesPanel();", ".ЗакрытьПанельСообщенийПользователю();"), True);
		LastProcessedCommand = "ЗакрытьПанельСообщенийПользователю";
		WindowClosed = True;
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoStartPage" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoStartPage();", ".ПерейтиКНачальнойСтранице();"), True);
		LastProcessedCommand = "ПерейтиКНачальнойСтранице";
		WindowClosed = True;
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoNextWindow" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoNextWindow();", ".ПерейтиКСледующемуОкну();"), True);
		LastProcessedCommand = "ПерейтиКСледующемуОкну";
		WindowClosed = True;
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "gotoPreviousWindow" Then
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".GotoPreviousWindow();", ".ПерейтиКПредыдущемуОкну();"), True);
		LastProcessedCommand = "ПерейтиКПредыдущемуОкну";
		WindowClosed = True;
		ЧтениеXML.Read();

	ElsIf ЧтениеXML.Name = "executeCommand" Then
		CommandRef = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "url" Then
				CommandRef = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".ExecuteCommand(""", ".ВыполнитьКоманду(""") + CommandRef + """);", True);
		LastProcessedCommand = "ВыполнитьКоманду";
		ЧтениеXML.Read();
	ElsIf ЧтениеXML.Name = "clickFormattedStringHyperlink" Then
		Presentation = "";
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "title" Then
				Presentation = ЧтениеXML.Value;
			Else
				Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			EndIf;
		EndDo;
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", ".SelectOption(""", ".ВыбратьВариант(""") + DoubleQuotationMarks(Presentation) + """);", True);
		ТекущаяВетка.Presentation = Presentation;
		LastProcessedCommand = "НажатьНаГиперссылкуВФорматированнойСтроке";
		ЧтениеXML.Read();

	Else
		Return False;
	EndIf;
	
	ТекущаяВетка.ЗаголовокОбъекта = LastProcessedCommand;
	ТекущаяВетка.Действие = "Команда";
	ТекущаяВетка.Команда = LastProcessedCommand;
	ТекущаяВетка.ТипОбъекта = РодительВетка.ТипОбъекта;
	
	// основные элементы отображения
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	
	
	ЧтениеXML.Read();

	Return True;

EndFunction

&НаСервере
Процедура мСцен_ConvertCommandInterfaceGroup(ЧтениеXML, РодительВетка)

	// добавим узел
	ТекущаяВетка = Неопределено;
	Если Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Истина Тогда 
		ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
		ТекущаяВетка.UID = строка(новый UUID());
		ТекущаяВетка.FUID = ТекущаяВетка.UID;
		ТекущаяВетка.Наименование = "";	
		ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
		ТекущаяВетка.ЗаголовокОбъекта = "";
		
		While ЧтениеXML.ReadAttribute() Do
			If ЧтениеXML.Name = "title" Then
				ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
			EndIf;
		EndDo;
		
		LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ТекущаяВетка.ЗаголовокОбъекта);
		ИмяПеременной = РодительВетка.ИмяПеременной + LastProcessedControl;
		ТекущаяВетка.ИмяПеременной = ИмяПеременной;
		ТекущаяВетка.Действие = "НайтиОбъект";
		
		// основные элементы отображения
		ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
		ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	Иначе
		ТекущаяВетка = РодительВетка;
	КонецЕсли;
	
	ЧтениеXML.Read();

	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		
		If ЧтениеXML.Name = "CommandInterfaceButton" Then
			мСцен_ConvertCommandInterfaceButton(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		ElsIf ЧтениеXML.Name = "CommandInterfaceGroup" Then
			мСцен_ConvertCommandInterfaceGroup(ЧтениеXML, ТекущаяВетка); // GetFullHierarchy
		Else
			ТекущаяВетка.Наименование = "Неопознанный узел";	
			ТекущаяВетка.Описание = "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
			Raise "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;
	
	//Если Объект.ГенерироватьПолучениеРодительскихОбъектовВИерархии=Ложь Тогда
	//	РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	//КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Процедура мСцен_ConvertCommandInterfaceButton(ЧтениеXML, РодительВетка)

	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = "";
	ТекущаяВетка.ТипОбъекта = ЧтениеXML.Name;
	ТекущаяВетка.ЗаголовокОбъекта = "";

	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "title" Then
			ТекущаяВетка.ЗаголовокОбъекта = ЧтениеXML.Value;
		EndIf;
	EndDo;

	LastProcessedControl = ПреобразоватьЗаголовокИмяПеременной(ТекущаяВетка.ТипОбъекта, ТекущаяВетка.ЗаголовокОбъекта);
	ИмяПеременной =  РодительВетка.ИмяПеременной + LastProcessedControl;
	ТекущаяВетка.ИмяПеременной = ИмяПеременной;
	ТекущаяВетка.Действие = "НайтиОбъект";
	
	// основные элементы отображения
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеЧПУ(ТекущаяВетка);
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);	
	
	ЧтениеXML.Read();

	CommandConverted = False;
	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do

		If мСцен_ConvertCommand(ЧтениеXML, ТекущаяВетка) Then
			CommandConverted = True;
		Else
			ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
			ТекущаяВетка.UID = строка(новый UUID());
			ТекущаяВетка.FUID = ТекущаяВетка.UID;
			ТекущаяВетка.Наименование = "Неопознанный узел";
			Raise "'Неопознанный узел '" + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;

	EndDo;
	
	// удалим узел, т.к. не нужна иерархия
	Если CommandConverted=Ложь И Объект.ГенерироватьКодПодключенияКлиента=Ложь Тогда
		РодительВетка.ПолучитьЭлементы().Удалить(ТекущаяВетка); // GetFullHierarchy
	КонецЕсли;

	ЧтениеXML.Read();

EndProcedure

&НаСервере
Procedure мСцен_ConvertCommandPartGotoSpecificRow(ЧтениеXML, РодительВетка, TermRus, SwitchSelection)

	SwitchSelection = false;
	While ЧтениеXML.ReadAttribute() Do
		If ЧтениеXML.Name = "switchSelection" Then
			SwitchSelection = ЧтениеXML.Value;
		Else
			Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;
	EndDo;
	//AddLine(Writer, VariableName + ? (ScriptVariant = "en", "." + TermInt + "(", "." + TermRus + "(") + SwitchSelection + ");", True);
	If ЗначениеЗаполнено(SwitchSelection) Тогда
		SwitchSelection=true;
	Else
		SwitchSelection=false;
	Endif;
	LastProcessedCommand = TermRus;
	ЧтениеXML.Read();

EndProcedure

&НаСервере
Procedure мСцен_ConvertCommandPartRowDescription(ЧтениеXML, РодительВетка, ТекущаяВетка, Val TermRus)

	ЧтениеXML.Read();
	If ЧтениеXML.NodeType = XMLNodeType.StartElement And ЧтениеXML.Name = "Field" Then
		мСцен_ConvertCommandPartRowDescriptionPartInt(ЧтениеXML, РодительВетка, ТекущаяВетка);
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", "." + TermInt + "(RowDescription);", "." + TermRus + "(ОписаниеСтроки);"), True);
	Else
		//AddLine(Writer, VariableName + ? (ScriptVariant = "en", "." + TermInt +"();", "." + TermRus + "();"), True);
	EndIf;

EndProcedure

&НаСервере
Procedure мСцен_ConvertCommandPartRowDescriptionPartInt(ЧтениеXML, РодительВетка, ТекущаяВетка)

	//AddLine(Writer, ? (ScriptVariant = "en", "RowDescription = New Map();", "ОписаниеСтроки = Новый Соответствие();"));
	RowDescription = Новый Соответствие();

	While ЧтениеXML.NodeType <> XMLNodeType.EndElement Do
		If ЧтениеXML.Name = "Field" Then
			ColumnTitle = "";
			CellText = "";
			While ЧтениеXML.ReadAttribute() Do
				If ЧтениеXML.Name = "title" Then
					ColumnTitle = ЧтениеXML.Value;
				ElsIf ЧтениеXML.Name = "cellText" Then
					CellText = ЧтениеXML.Value;
				Else
					Raise NStr("en = 'Unknown attribute '; ru = 'Неопознанный атрибут '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
				EndIf;
			EndDo;
			RowDescription.Вставить(ColumnTitle,"" + DoubleQuotationMarks(CellText) + "");
			//AddLine(Writer, ? (ScriptVariant = "en", "RowDescription.Insert(""", "ОписаниеСтроки.Вставить(""") + 
			//		ColumnTitle + """, """ + DoubleQuotationMarks(CellText) + """);");
			ЧтениеXML.Read();
		Else
			Raise NStr("en = 'Unknown node '; ru = 'Неопознанный узел '") + ЧтениеXML.Name + ": " + ЧтениеXML.Value;
		EndIf;
		ЧтениеXML.Read();
	EndDo;

	ТекущаяВетка.RowDescription = ЗначениеВСтрокуВнутр(RowDescription);
	
EndProcedure

#Область ДополнительныеФункции

&НаСервере
Процедура мСценСкопироватьЭлементы(Родитель,ТекущаяВетка)
	
	
	ЭлементыТекущегоУзла = ТекущаяВетка.ПолучитьЭлементы();
	
	Для каждого ТекущийУзел из ЭлементыТекущегоУзла Цикл
		
		НовыйУзел = Родитель.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НовыйУзел,ТекущийУзел);
		мСценСкопироватьЭлементы(НовыйУзел,ТекущийУзел);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция мСцен_ПолучитьНаименованиеПоТегу(ИмяТега)
	
	Представление = ИмяТега;
	
	Если ИмяТега="ClientApplicationWindow" Тогда
		Представление = "Окно клиентского приложения";
	ИначеЕсли ИмяТега = "Form" Тогда
		Представление = "Форма";
	ИначеЕсли ИмяТега = "CommandInterface" Тогда
		Представление = "Командный интерфейс";		
	ИначеЕсли ИмяТега = "FormField" Тогда
		Представление = "Поле формы";		
	ИначеЕсли ИмяТега = "FormTable" Тогда
		Представление = "Таблица формы";		
	ИначеЕсли ИмяТега = "FormDecoration" Тогда
		Представление = "Декорация формы";		
	ИначеЕсли ИмяТега = "FormButton" Тогда
		Представление = "Кнопка формы";		
	ИначеЕсли ИмяТега = "FormGroup" Тогда
		Представление = "Группа формы";		
	ИначеЕсли ИмяТега = "CommandInterfaceButton" Тогда
		Представление = "Кнопка командный интерфейс";		
	ИначеЕсли ИмяТега = "CommandInterfaceGroup" Тогда
		Представление = "Группа командный интерфейс";
		
	// служебные мои
	ИначеЕсли ИмяТега = "ПодключитьТестируемоеПриложение" Тогда
		Представление = "Подключение к тестируемому приложению";
	// служебные мои
	ИначеЕсли ИмяТега = "ЗакрытьТестируемоеПриложение" Тогда
		Представление = "Отключиться от тестируемого приложения";
		
		
		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	//ИначеЕсли ИмяТега = "" Тогда
	//	Представление = "";		
	Иначе
		Представление = "Неопознанный узел";
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

&НаСервере
Функция мСцен_ПолучитьНаименованиеЧПУ(Узел)
	
	ИмяТега = Узел.ТипОбъекта;
	Действие = Узел.Действие;
	ТипОбъекта = Узел.ТипОбъекта;
	ЗаголовокОбъекта = Узел.ЗаголовокОбъекта;
	
	Представление = мСцен_ПолучитьНаименованиеПоТегу(ТипОбъекта);	
	
	Если ИмяТега="ClientApplicationWindow" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "Form" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "CommandInterface" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "FormField" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "FormTable" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "FormDecoration" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "FormButton" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "FormGroup" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "CommandInterfaceButton" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;
	ИначеЕсли ИмяТега = "CommandInterfaceGroup" Тогда
		Представление = Узел.Действие+" : "+ЗаголовокОбъекта;		
	ИначеЕсли ИмяТега = "setFileDialogResult" Тогда
		Представление = "ДилогВыбораФайла """+ЗаголовокОбъекта+"""";		
		
	КонецЕсли;	
	
	// более правильная обработка
	Если Действие="НайтиОсновноеОкно" Тогда
		Представление = "Найти основное окно """+ЗаголовокОбъекта+"""";
	ИначеЕсли Действие="НайтиОкно" Тогда
		Представление = "Найти окно """+ЗаголовокОбъекта+"""";
	ИначеЕсли Действие="НайтиФорму" Тогда
		Представление = "Найти форму """+ЗаголовокОбъекта+"""";
	ИначеЕсли Действие="НайтиОбъект" Тогда
		Если ТипОбъекта="FormField" Тогда
			Представление = "Найти поле формы """+ЗаголовокОбъекта+"""";
		ИначеЕсли ТипОбъекта="FormDecoration" Тогда
			Представление = "Найти декорацию """+ЗаголовокОбъекта+"""";
		ИначеЕсли ТипОбъекта="FormButton" Тогда
			Представление = "Найти кнопку формы """+ЗаголовокОбъекта+"""";
		ИначеЕсли ТипОбъекта="FormGroup" Тогда
			Представление = "Найти группу формы """+ЗаголовокОбъекта+"""";
		ИначеЕсли ТипОбъекта="FormTable" Тогда
			Представление = "Найти таблицу формы """+ЗаголовокОбъекта+"""";
		ИначеЕсли ИмяТега = "CommandInterfaceButton" Тогда
			Представление = "Найти КИ кнопку """+ЗаголовокОбъекта+"""";
		ИначеЕсли ИмяТега = "CommandInterfaceGroup" Тогда
			Представление = "Найти КИ группу """+ЗаголовокОбъекта+"""";
		Иначе
			Представление = "Найти объект """+ЗаголовокОбъекта+"""";
		КонецЕсли;		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции


// Функция - Получить номер по строке заголовка
//
// Параметры:
//  ЗаголовокОбъекта	 - строка	 - Текст заголовка/строки содержащей номер
//  ПерваяЧастьЗаголовка - строка	 - Текст до номера, будет срезаться
//  ДлинаНомера			 - число	 - Длина номера
// 
// Возвращаемое значение:
//  строка - номер из строки
//
&НаКлиенте
Функция мСцен_ПолучитьНомерПоСтрокеЗаголовка(Знач ЗаголовокОбъекта, Знач ПерваяЧастьЗаголовка, Знач ДлинаНомера)
	
	Номер = "";  
	
	Номер = СокрЛП(СтрЗаменить(ЗаголовокОбъекта,ПерваяЧастьЗаголовка,""));
	Номер = Лев(Номер,ДлинаНомера);
	
	Возврат Номер;
	
КонецФункции

#КонецОбласти

// Служебные
#область Служебные

&НаКлиенте
Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Function DoubleQuotationMarks(OutputString)

	// Doubling quotation marks for correctness during export to a file.
	// Это лишнее
	//Return StrReplace(OutputString, """", """""");
	Return OutputString;

EndFunction


&НаСервере
Функция ПреобразоватьЗаголовокИмяПеременной(ТипОбъекта, ЗаголовокОбъекта)

	// Variable name starts with a type name
	If ТипОбъекта = "ClientApplicationWindow" Then

		VariableName = "ОкноПриложения";
	ElsIf ТипОбъекта = "Form" Then
		VariableName = "Форма";
	ElsIf ТипОбъекта = "FormField" Then
		VariableName = "Поле";
	ElsIf ТипОбъекта = "FormItemAddition" Then
		VariableName = "ДополнениеЭлементаФормы";
	ElsIf ТипОбъекта = "FormButton" Then
		VariableName = "Кнопка";
	ElsIf ТипОбъекта = "FormGroup" Then
		VariableName = "Группа";
	ElsIf ТипОбъекта = "FormTable" Then
		VariableName = "Таблица";
	ElsIf ТипОбъекта = "FormDecoration" Then
		VariableName = "Декорация";
	ElsIf ТипОбъекта = "CommandInterface" Then
		VariableName = "КомандныйИнтерфейс";
	ElsIf ТипОбъекта = "CommandInterfaceGroup" Then
		VariableName = "ГруппаКомандногоИнтерфейса";
	ElsIf ТипОбъекта = "CommandInterfaceButton" Then
		VariableName = "КнопкаКомандногоИнтерфейса";
	ElsIf ТипОбъекта = "setFileDialogResult" Then
		VariableName = "ДилогВыбораФайла";
	Else
		Raise NStr("'Неопознанный узел '") + ТипОбъекта;
	EndIf;

	// Cutting characters except letters and digits
	PreviousCharIsSpace = True;
	StringLength = StrLen(ЗаголовокОбъекта);
	For Index = 1 To StringLength Do
		NextChar = Mid(ЗаголовокОбъекта,Index, 1);
		If IsLetter(NextChar) Or IsDigit(NextChar) Then
			VariableName = VariableName + ? (PreviousCharIsSpace, Upper(NextChar), NextChar);
			PreviousCharIsSpace = False;
		Else
			PreviousCharIsSpace = True;
		EndIf;
	EndDo;

	Return VariableName;

КонецФункции

&НаСервере
Function IsDigit(Char)

	Code = CharCode(Char);
	Return Code >= 48 And Code <= 57;

EndFunction

&НаСервере
Function IsLetter(Char)

	// All non-literal character codes are considered equal
	Return CharCode(Lower(Char)) <> CharCode(Upper(Char));

EndFunction

#КонецОбласти


#Область ДополнительныеКоманды


Процедура мСцен_GenerateClientConnectionScript(РодительВетка)
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеПоТегу("ПодключитьТестируемоеПриложение");
    ТекущаяВетка.Действие = "ПодключитьТестируемоеПриложение";
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);
	
КонецПроцедуры


Процедура мСцен_GenerateClientDisconnectionScript(РодительВетка)
	
	ТекущаяВетка = РодительВетка.ПолучитьЭлементы().Добавить();
	ТекущаяВетка.UID = строка(новый UUID());
	ТекущаяВетка.FUID = ТекущаяВетка.UID;
	ТекущаяВетка.Наименование = мСцен_ПолучитьНаименованиеПоТегу("ЗакрытьТестируемоеПриложение");
    ТекущаяВетка.Действие = "ЗакрытьТестируемоеПриложение";
	ТекущаяВетка.ДанныеКартинки = мСцен_ПолучитьДанныеКартинки_НаКлиенте(ТекущаяВетка);
	
КонецПроцедуры




#КонецОбласти


#КонецОбласти
