// INFORMATION
// обработки взятые из примеров в дальнейшем будут заменены на библиотеку NativeApi

#Область РаботаСПроцессами

// Функция - Запускает локально приложение по командной строке и получает PID процесса
//
// Параметры:
//  СтрокаЗапуска	 - строка	 -  командная строка запуска приложения, может содержать параметры
// 
// Возвращаемое значение:
//  Число - в случае успеха возвращает идентификатор процесса pid, если ошибка, то -1. 
//
Функция ЗапуститьПриложениеЛокально(Знач СтрокаЗапуска,Сообщение="")  Экспорт
	Попытка
		Шелл=Новый COMОбъект("WScript.Shell"); 
		Процесс=Шелл.Exec(СтрокаЗапуска); 
		PID=Процесс.ProcessID;
		Возврат PID;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Сообщение = ТекстОшибки;
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации("ПланировщикЗаданийКлиентСервер.ЗапуситьПриложениеЛокально",УровеньЖурналаРегистрации.Ошибка,,ТекстОшибки,,);
		#КонецЕсли
		Возврат -1;
	КонецПопытки;
КонецФункции

// Функция - Запускает удаленно приложение по командной строке и получает PID процесса
//
// Параметры:
//  СтрокаЗапуска	 - строка	 -  командная строка запуска приложения, может содержать параметры
// 
//  Computer	 - строка	 -  адрес компьютера, по умолчнию "." текущий компьютер
// 
// Возвращаемое значение:
//  Число - в случае успеха возвращает идентификатор процесса pid, если ошибка, то -1. 
//
Функция ЗапуститьПриложениеУдаленно(Знач СтрокаЗапуска,Computer = ".",Сообщение="") Экспорт
	
	Возврат Computer_StartProccess(СтрокаЗапуска,Computer,Сообщение);
	
КонецФункции

// Функция - Убить процесс локально
//
// Параметры:
//  PID	 - число - Идентификатор процесса
// 
// Возвращаемое значение:
//  Истина, если успешно, Ложь - если ошибка, Неопределено - если исключание
//
Функция ЗавершитьПроцессЛокально(Знач PID,Сообщение="") Экспорт
	Если Computer_KillProccessByPID(".",PID)<>0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли; 	
КонецФункции

Функция ЗавершитьПроцессУдаленно(Знач PID,Computer = ".",Сообщение="") Экспорт
	Попытка
		Если Computer_KillProccessByPID(Computer,PID)<>0 Тогда
			Возврат Истина;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	Исключение
		Сообщение = ОписаниеОшибки();
		Возврат Неопределено;
	КонецПопытки;	
КонецФункции
	
// Функция - Возвращает информацию о работе процесса
//
// Параметры:
//  PID	 - число - Идентификатор процесса 
// 
// Возвращаемое значение:
//   Истина, если успешно, Ложь - если ошибка, Неопределено - если исключание
//
Функция ЕщеРаботаетПроцессЛокальный(Знач PID) Экспорт 
	Попытка
		ПроцессИнфо = Computer_SystemProcessByPID(".",PID);
		Если ПроцессИнфо.ProcessId=Неопределено ИЛИ ПроцессИнфо.ProcessId<>-1 Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	Исключение
		Возврат Неопределено;
	КонецПопытки;
КонецФункции

// Функция, позволяющая завершить некий процесс на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
//    ProccessName - Имя процесса, который необходимо завершить.
// Возвращаемое значение:
//    Количество завершенных процессов.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_StartProccess(Знач Command,Computer = ".",Сообщение = "") Экспорт
    
    Попытка
        PID = 0 ;
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2:Win32_Process");
        WinMGMT.Create(Command,,,PID);
 
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Сообщение = ТекстОшибки;
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации("ПланировщикЗаданийКлиентСервер.Computer_StartProccess",УровеньЖурналаРегистрации.Ошибка,,ТекстОшибки,,);
		#КонецЕсли
		Сообщить(ТекстОшибки);
		PID = -1;
    КонецПопытки;

    Возврат PID;

КонецФункции

// Функция, позволяющая завершить некий процесс на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
//    ProccessName - Имя процесса, который необходимо завершить.
// Возвращаемое значение:
//    Количество завершенных процессов.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_KillProccessByPID(Computer = ".", PID = "") Экспорт
	
	Count=0;
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process Where ProcessID = '" + СтрЗаменить(Строка(PID),Символы.НПП,"") + "'");
        
        Для Каждого Process ИЗ Win32_Process Цикл
            Process.Terminate();
		КонецЦикла;
		
		Count= Win32_Process.Count;
        
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		#Если Сервер Тогда
			ЗаписьЖурналаРегистрации("ПланировщикЗаданийКлиентСервер.Computer_KillProccessByPID",УровеньЖурналаРегистрации.Ошибка,,ТекстОшибки,,);
		#КонецЕсли
		Сообщить(ТекстОшибки);
    КонецПопытки;

    Возврат Count;

КонецФункции

// Функция, позволяющая получить информацию о процессах на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_SystemProcessByPID(Computer = ".",PID) Экспорт
    
    ProccessInfo = новый Структура("Caption,CommandLine,CreationDate,CSName,ExecutablePath,OSName,ParentProcessId,ProcessId,WindowsVersion,Owner");	
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process Where ProcessID = '" + СтрЗаменить(Строка(PID),Символы.НПП,"") + "'");
        
		Для Каждого Proccess ИЗ Win32_Process Цикл
            
            ProccessInfo.Caption = Proccess.Caption;
            ProccessInfo.CommandLine = Proccess.CommandLine;
            Попытка
                ProccessInfo.CreationDate = Дата(Лев(Proccess.CreationDate,14));
            Исключение
            КонецПопытки;
            ProccessInfo.CSName = Proccess.CSName;
            ProccessInfo.ExecutablePath = Proccess.ExecutablePath;
            ProccessInfo.OSName = Proccess.OSName;
            ProccessInfo.ParentProcessID = Proccess.ParentProcessID;
            ProccessInfo.ProcessID = Proccess.ProcessID;
            ProccessInfo.WindowsVersion = Proccess.WindowsVersion;
            User = "";
            Domain = "";
            Owner = Proccess.GetOwner(User, Domain);
            Если User = NULL И Domain = NULL Тогда
                ProccessInfo.Owner = "System";
            Иначе
                ProccessInfo.Owner = Domain + "\" + User;
			КонецЕсли;
			
			Прервать;
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат ProccessInfo;

КонецФункции


#Область ПримерыС_infostart_ru_public_165702

// Функция, позволяющая завершить некий процесс на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
//    ProccessName - Имя процесса, который необходимо завершить.
// Возвращаемое значение:
//    Количество завершенных процессов.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_KillProccessByName(Computer = ".", ProccessName = "")Экспорт
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process Where Name = '" + ProccessName + "'");
        
        Для Каждого Process ИЗ Win32_Process Цикл
            Process.Terminate();
        КонецЦикла;
        
    Исключение
    КонецПопытки;

    Возврат Win32_Process.Count;

КонецФункции

// Функция, позволяющая невизуально "пропинговать" удаленный компьютер.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Ложь/Истина.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_PING(Computer = "localhost")Экспорт
    
    WinMGMT = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\");
    Win32_PingStatus = WinMGMT.ExecQuery("SELECT StatusCode FROM Win32_PingStatus WHERE Address = '" + Computer + "'");
    
    Успешно = Ложь;
    Для Каждого PingStatus ИЗ Win32_PingStatus Цикл
        Если PingStatus.StatusCode = NULL Тогда
            Успешно = Ложь;
        Иначе
            Успешно = PingStatus.StatusCode = 0;
        КонецЕсли;
    КонецЦикла;
    
    Возврат Успешно;
    
КонецФункции

// Функция, позволяющая получить информацию о службах на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_SystemService(Computer = ".")Экспорт
    
    Win32_ServiceInfo = Новый Массив;
   
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Service = WinMGMT.ExecQuery("SELECT * FROM Win32_Service");
        
		Для Каждого Service ИЗ Win32_Service Цикл
			Win32_ServiceInfoСтруктура = новый Структура("Name,Caption,Description,PathName,StartMode,StartName,State,ProcessID,SystemName");	
            Win32_ServiceInfoСтруктура.Name = Service.Name;
            Win32_ServiceInfoСтруктура.Caption = Service.Caption;
            Win32_ServiceInfoСтруктура.Description = Service.Description;
            Win32_ServiceInfoСтруктура.PathName = Service.PathName;
            Win32_ServiceInfoСтруктура.StartMode = Service.StartMode;
            Win32_ServiceInfoСтруктура.StartName = Service.StartName;
            Win32_ServiceInfoСтруктура.State = Service.State;
            Win32_ServiceInfoСтруктура.ProcessID = Service.ProcessID;
            Win32_ServiceInfoСтруктура.SystemName = Service.SystemName;
			
			Win32_ServiceInfo.Добавить(Win32_ServiceInfoСтруктура);
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат Win32_ServiceInfo;

КонецФункции

// Функция, позволяющая получить информацию о процессах на локальном/удаленном компьютере.
// Параметры:
//    Computer - Имя компьютера.
// Возвращаемое значение:
//    Таблица значений.
//
// Рекомендация:
// Перед применением проверить на компьютерах
// Windows Management Instrumentation (WMI):
// 1. Состояние служб.
// 2. Разрешение в брандмауэре.
//
Функция Computer_SystemProcess(Computer = ".") Экспорт
    
    Win32_ProcessInfo = Новый Массив;
    
    Попытка
        
        WinMGMT = ПолучитьCOMОбъект("winmgmts:\\" + Computer + "\root\cimv2");
        Win32_Process = WinMGMT.ExecQuery("SELECT * FROM Win32_Process");
        
		Для Каждого Proccess ИЗ Win32_Process Цикл
			
			ProccessInfo = новый Структура("Caption,CommandLine,CreationDate,CSName,ExecutablePath,OSName,ParentProcessId,ProcessId,WindowsVersion,Owner");			
            
            ProccessInfo.Caption = Proccess.Caption;
            ProccessInfo.CommandLine = Proccess.CommandLine;
            Попытка
                ProccessInfo.CreationDate = Дата(Лев(Proccess.CreationDate,14));
            Исключение
            КонецПопытки;
            ProccessInfo.CSName = Proccess.CSName;
            ProccessInfo.ExecutablePath = Proccess.ExecutablePath;
            ProccessInfo.OSName = Proccess.OSName;
            ProccessInfo.ParentProcessID = Proccess.ParentProcessID;
            ProccessInfo.ProcessID = Proccess.ProcessID;
            ProccessInfo.WindowsVersion = Proccess.WindowsVersion;
            User = "";
            Domain = "";
            Owner = Proccess.GetOwner(User, Domain);
            Если User = NULL И Domain = NULL Тогда
                ProccessInfo.Owner = "System";
            Иначе
                ProccessInfo.Owner = Domain + "\" + User;
			КонецЕсли;
			
			Win32_ProcessInfo.Добавить(ProccessInfo);
			
        КонецЦикла;
        
    Исключение
    КонецПопытки;
    
    Возврат Win32_ProcessInfo;

КонецФункции


#КонецОбласти

#Область За_Основу_Взята_Функция_Из_xUnit_Тест

&НаКлиенте
Процедура ЗавершитьВсеТестовыеПриложенияПринудительно() Экспорт
	Scr = Новый COMОбъект("MSScriptControl.ScriptControl");
	Scr.Language = "vbscript";
	Scr.AddCode("
	|Option Explicit
	|
	|Dim objWMIService, objProcess, colProcess
	|
	|Set objWMIService = GetObject(""winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2"")
	|
	|Set colProcess = objWMIService.ExecQuery(""Select * from Win32_Process Where (CommandLine Like '%/TESTCLIENT%' And ExecutablePath Like '%1cv8c%')"")
	|
	|For Each objProcess in colProcess
	| objProcess.Terminate()
	|Next
	|");
КонецПроцедуры

#КонецОбласти


#Область РазноеПроцеркаИдей

Функция ПолучитьPID() Экспорт
	Перем oLocator, oService, oShell, oApp, oChildProcess;
	Перем чPID;
	
	чPID = -1;
	Попытка
		oLocator = новый COMОбъект("WbemScripting.SWbemLocator");
		oService = oLocator.ConnectServer(".", "root\CIMV2");
		
		// Запускаем дочерний rundll32.exe
		oShell = новый COMОбъект("WScript.Shell");
		oApp = oShell.Exec("rundll32.exe kernel32,Sleep");
		// Получаем rundll32 по PID'у
		oChildProcess = oService.Get("Win32_Process.Handle=" + oApp.ProcessID);
		// Получаем PID родительского процесса - 1с
		чPID = oChildProcess.ParentProcessID;
		// Завершаем rundll32, чтобы не мусорить
		oChildProcess.Terminate();
	Исключение
		// нуу, может не быть прав на эти вещи, например.
	КонецПопытки;
	Возврат чPID;
КонецФункции // ПолучитьPID()

Процедура Сформировать() Экспорт
	Сообщить("PID: " + ПолучитьPID());
КонецПроцедуры // Сформировать()


#КонецОбласти


Функция ПреобразоватьДатуВМилСек(Знач ДатаВремяВх) Экспорт
	Возврат (ДатаВремяВх - Дата('00010101000000'))*1000
КонецФункции

Функция ПреобразоватьДатуВСек(Знач ДатаВремяВх) Экспорт
	Возврат (ДатаВремяВх - Дата('00010101000000'))
КонецФункции

Функция ПреобразоватьСекВДату(Знач ВремяСек) Экспорт
	Возврат Дата('00010101000000')+ВремяСек;
КонецФункции

#КонецОбласти
