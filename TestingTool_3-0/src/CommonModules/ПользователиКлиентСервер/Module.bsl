
// Возвращает текущего авторизованного пользователя.
Функция АвторизованныйПользователь() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ТекущийПользователь;
#Иначе
	Возврат ПользователиВызовСервера.АвторизованныйПользователь();
#КонецЕсли
	
КонецФункции

// Возвращает текущего пользователя.
Функция ТекущийПользователь() Экспорт
	
	АвторизованныйПользователь = АвторизованныйПользователь();

	Возврат АвторизованныйПользователь;
	
КонецФункции


// Возвращает Истина, если вход в сеанс выполнил внешний пользователь.
//
// Возвращаемое значение:
//  Булево - Истина, если вход в сеанс выполнил внешний пользователь.
//
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
	Возврат НЕ ТипЗнч(АвторизованныйПользователь())
	      = Тип("СправочникСсылка.Пользователи");
	
КонецФункции


Функция ТекущееРабочееМесто() Экспорт
	
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ТекущееРабочееМесто;
#Иначе
	Возврат ПользователиВызовСервера.ТекущееРабочееМесто();
#КонецЕсли
	
КонецФункции