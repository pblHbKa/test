﻿//////////////////////////////////////////////////////////////////////////////////////////
// Обработчики событий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОтборЖурналаРегистрации = Новый Структура;
	СтруктураПараметровОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации("Событие");
	ЗначенияОтбораПоСобытию = СтруктураПараметровОтбора.Событие;
	СписокСобытий = Новый СписокЗначений;
	Для каждого ЗначениеОтбораПоСобытию Из ЗначенияОтбораПоСобытию Цикл
		Если Найти(ЗначениеОтбораПоСобытию.Значение, "Транзакция.") = 1 Тогда
			Продолжить;
		КонецЕсли;
		Если Найти(ЗначениеОтбораПоСобытию.Значение, "Transaction.") = 1 Тогда
			Продолжить;
		КонецЕсли;
		СписокСобытий.Добавить(ЗначениеОтбораПоСобытию.Ключ, СтрЗаменить(ЗначениеОтбораПоСобытию.Значение, ". ", "."));
	КонецЦикла;
	Если СписокСобытий.Количество() <> 0 Тогда
		ОтборЖурналаРегистрации.Вставить("Событие", СписокСобытий);
	КонецЕсли;
	
	Если Параметры.Пользователь <> Неопределено Тогда
		ИмяПользователя = Параметры.Пользователь;
		ОтборПоПользователю = Новый СписокЗначений;
		ПоПользователю = ОтборПоПользователю.Добавить(ИмяПользователя);
		Если ПустаяСтрока(ИмяПользователя) Тогда
			ПоПользователю.Представление = НСтр("ru = '<Пользователь по умолчанию>'", "ru");
		Иначе
			ПоПользователю.Представление = ИмяПользователя;
		КонецЕсли;
		
		ОтборЖурналаРегистрации.Вставить("Пользователь", ОтборПоПользователю);
	КонецЕсли;
	
	КоличествоПоказываемыхСобытий = 200;
	
	ПрочитатьЖурнал(ОтборЖурналаРегистрации);
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	Данные = Элементы.Журнал.ТекущиеДанные;
	Если Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ФормаСобытия = ПолучитьФорму("Обработка.ЖурналРегистрации.Форма.ФормаСобытия");
	ФормаСобытия.ДатаВремя    = Данные.Дата;
	ФормаСобытия.Пользователь = Данные.ИмяПользователя;
	ФормаСобытия.Приложение   = Данные.ПредставлениеПриложения;
	ФормаСобытия.Компьютер    = Данные.Компьютер;
	ФормаСобытия.Событие      = Данные.ПредставлениеСобытия;
	ФормаСобытия.Комментарий  = Данные.Комментарий;
	ФормаСобытия.Метаданные   = Данные.ПредставлениеМетаданных;
	ФормаСобытия.Данные       = Данные.Данные;
	ФормаСобытия.ПредставлениеДанных        = Данные.ПредставлениеДанных;
	ФормаСобытия.ИдентификаторТранзакции    = Данные.Транзакция;
	ФормаСобытия.СтатусЗавершенияТранзакции = Данные.СтатусТранзакции;
	ФормаСобытия.Сеанс         = Данные.Сеанс;
	ФормаСобытия.РабочийСервер = Данные.РабочийСервер;
	ФормаСобытия.ОсновнойIPПорт        = Данные.ОсновнойIPПорт;
	ФормаСобытия.ВспомогательныйIPПорт = Данные.ВспомогательныйIPПорт;
	ФормаСобытия.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеДляПросмотра()
	ТекущиеДанные = Элементы.Журнал.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.Данные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ПоказатьЗначение( ,ТекущиеДанные.Данные);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	Диалог = Новый ДиалогРедактированияСтандартногоПериода;
	ДатаНачала    = Неопределено;
	ДатаОкончания = Неопределено;
	ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачала);
	ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончания);
	ДатаНачала    = ?(ТипЗнч(ДатаНачала)    = Тип("Дата"), ДатаНачала, '00010101000000');
	ДатаОкончания = ?(ТипЗнч(ДатаОкончания) = Тип("Дата"), ДатаОкончания, '00010101000000');
	Если ИнтервалДат.ДатаНачала <> ДатаНачала Тогда
		ИнтервалДат.ДатаНачала = ДатаНачала;
	КонецЕсли;
	Если ИнтервалДат.ДатаОкончания <> ДатаОкончания Тогда
		ИнтервалДат.ДатаОкончания = ДатаОкончания;
	КонецЕсли;
	Диалог.Период = ИнтервалДат;
	Диалог.Показать(
		Новый ОписаниеОповещения(
			"УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(Результат, Параметры) Экспорт
	НовыйИнтервалДат = Результат;
	Если НЕ НовыйИнтервалДат = Неопределено Тогда
		Если НовыйИнтервалДат.ДатаНачала = '00010101000000' Тогда
			ОтборЖурналаРегистрации.Удалить("ДатаНачала");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаНачала", НовыйИнтервалДат.ДатаНачала);
		КонецЕсли;
		Если НовыйИнтервалДат.ДатаОкончания = '00010101000000' Тогда
			ОтборЖурналаРегистрации.Удалить("ДатаОкончания");
		Иначе
			ОтборЖурналаРегистрации.Вставить("ДатаОкончания", НовыйИнтервалДат.ДатаОкончания);
		КонецЕсли;
		ОбновитьТекущийСписок();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУстановитьОтбор()
	
	ПараметрФормы = Новый Структура("Отбор", ОтборЖурналаРегистрации);
	Оповещение = Новый ОписаниеОповещения(
			"ВыполнитьУстановитьОтборЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ОтборЖурналаРегистрации",
		ПараметрФормы,,,,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьУстановитьОтборЗавершение(Результат, Параметры) Экспорт
	
	Если Не Результат = Неопределено Тогда
		ОтборЖурналаРегистрации = Результат;
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	ОтборЖурналаРегистрации.Очистить();
	ОбновитьТекущийСписок();
КонецПроцедуры

&НаКлиенте
Процедура СписокАктивныхПользователей()
	ОткрытьФорму("Обработка.СписокАктивныхПользователей.Форма");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТекущийСписок() Экспорт
	ПрочитатьЖурнал(ОтборЖурналаРегистрации);
	// Позиционирование в конец списка
	Если Журнал.Количество() Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	ОбновитьТекущийСписок();
КонецПроцедуры

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Журнал.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Поле.Имя = "Данные" ИЛИ Поле.Имя = "ПредставлениеДанных" Тогда
		Если ТекущиеДанные.Данные <> Неопределено И (НЕ ТекущиеДанные.Данные.Пустая()) Тогда
			ОткрытьДанныеДляПросмотра();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ПросмотрТекущегоСобытияВОтдельномОкне();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ПрочитатьЖурнал(Знач ОтборЖурналаНаКлиенте)
	// Выгрузка ототборованных событий в таблицу
	Отбор = Новый Структура;
	Для каждого ЭлементОтбора Из ОтборЖурналаНаКлиенте Цикл
		Отбор.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
	КонецЦикла;
	ТаблицаЗначенийСобытия = Новый ТаблицаЗначений;
	ПреобразованиеОтбора(Отбор);
	ВыгрузитьЖурналРегистрации(ТаблицаЗначенийСобытия, Отбор, , , КоличествоПоказываемыхСобытий);
	ТаблицаЗначенийСобытия.Колонки.Добавить("НомерРисунка", Новый ОписаниеТипов("Число"));
	Для каждого СтрокаТаблицыЗначенийСобытия Из ТаблицаЗначенийСобытия Цикл
		СтрокаТаблицыЗначенийСобытия.НомерРисунка = -1;
		Если СтрокаТаблицыЗначенийСобытия.Уровень = УровеньЖурналаРегистрации.Информация Тогда
			СтрокаТаблицыЗначенийСобытия.НомерРисунка = 0;
		ИначеЕсли СтрокаТаблицыЗначенийСобытия.Уровень = УровеньЖурналаРегистрации.Предупреждение Тогда
			СтрокаТаблицыЗначенийСобытия.НомерРисунка = 1;
		ИначеЕсли СтрокаТаблицыЗначенийСобытия.Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
			СтрокаТаблицыЗначенийСобытия.НомерРисунка = 2;
		КонецЕсли;
		СтрокаТаблицыЗначенийСобытия.Пользователь = СтрокаТаблицыЗначенийСобытия.ИмяПользователя;
		Если СтрокаТаблицыЗначенийСобытия.ИмяПользователя = "" Тогда
			СтрокаТаблицыЗначенийСобытия.ИмяПользователя = НСтр("ru = '<Пользователь по умолчанию>'", "ru");
		КонецЕсли;
	КонецЦикла;
	
	// Преобразование в универсальный объект
	ЗначениеВРеквизитФормы(ТаблицаЗначенийСобытия, "Журнал");
	// Показать параметры отбора
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаСервере
Процедура ПреобразованиеОтбора(Отбор)
	Для каждого ЭлементОтбора Из Отбор Цикл
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
			ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора)
	// Эта процедура вызывается, если элемент отбора является списком значений,
	// в отборе же должен быть массив значений. Преобразуем список в массив
	НовоеЗначение = Новый Массив;
	
	Для каждого ЗначениеИзСписка Из ЭлементОтбора.Значение Цикл
		Если ЭлементОтбора.Ключ = "Уровень" Тогда
			// Уровни сообщений представлены строкой, требуется преобразование в значение перечисления
			Обработка = РеквизитФормыВЗначение("Объект");
			НовоеЗначение.Добавить(Обработка.УровеньЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		ИначеЕсли ЭлементОтбора.Ключ = "СтатусТранзакции" Тогда
			// Статусы транзакций представлены строкой, требуется преобразование в значение перечисления
			Обработка = РеквизитФормыВЗначение("Объект");
			НовоеЗначение.Добавить(Обработка.СтатусТранзакцииЗаписиЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		Иначе
			НовоеЗначение.Добавить(ЗначениеИзСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Отбор.Вставить(ЭлементОтбора.Ключ, НовоеЗначение);
КонецПроцедуры
	
&НаСервере
Процедура СформироватьПредставлениеОтбора()
	ПредставлениеОтбора = "";
	// Интервал
	ДатаНачалаИнтервала    = Неопределено;
	ДатаОкончанияИнтервала = Неопределено;
	Если НЕ ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачалаИнтервала) ИЛИ
		 ДатаНачалаИнтервала = Неопределено Тогда 
		ДатаНачалаИнтервала    = '00010101000000';
	КонецЕсли;
	Если НЕ ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончанияИнтервала) ИЛИ
		 ДатаОкончанияИнтервала = Неопределено Тогда 
		ДатаОкончанияИнтервала = '00010101000000';
	КонецЕсли;
	Если НЕ (ДатаНачалаИнтервала = '00010101000000' И ДатаОкончанияИнтервала = '00010101000000') Тогда
		ПредставлениеОтбора = НСтр("ru = 'Интервал ('", "ru");
		СтрБезОграничений = НСтр("ru = 'без ограничений'", "ru");
		ПредставлениеОтбора = ПредставлениеОтбора + Формат(ДатаНачалаИнтервала,    "ДЛФ=DT; ДП='" + СтрБезОграничений + "'") + " - ";
		ПредставлениеОтбора = ПредставлениеОтбора + Формат(ДатаОкончанияИнтервала, "ДЛФ=DT; ДП='" + СтрБезОграничений + "'") + ")";
	КонецЕсли;
	
	// Остальные ограничения указываем просто по представлением, без указания значений ограничения
	Для каждого ЭлементОтбора Из ОтборЖурналаРегистрации Цикл
		ИмяОграничения = ЭлементОтбора.Ключ;
		Если ИмяОграничения = "ДатаНачала" ИЛИ ИмяОграничения = "ДатаОкончания" Тогда
			Продолжить; // Интервал уже выводили
		КонецЕсли;
		
		// Для некоторых ограничений меняем представление
		Если ИмяОграничения = "ИмяПриложения" Тогда
			ИмяОграничения = НСтр("ru = 'Приложение'", "ru");
		ИначеЕсли ИмяОграничения = "СтатусТранзакции" Тогда
			ИмяОграничения = ИмяОграничения = НСтр("ru = 'Статус транзакции'", "ru");
		ИначеЕсли ИмяОграничения = "ПредставлениеДанных" Тогда
			ИмяОграничения = ИмяОграничения = НСтр("ru = 'Представление данных'", "ru");
		ИначеЕсли ИмяОграничения = "РабочийСервер" Тогда
			ИмяОграничения = ИмяОграничения = НСтр("ru = 'Рабочий сервер'", "ru");
		ИначеЕсли ИмяОграничения = "ОсновнойIPПорт" Тогда
			ИмяОграничения = ИмяОграничения = НСтр("ru = 'Основной IP порт'", "ru");
		ИначеЕсли ИмяОграничения = "ВспомогательныйIPПорт" Тогда
			ИмяОграничения = ИмяОграничения = НСтр("ru = 'Вспомогательный IP порт'", "ru");
		КонецЕсли;
		
		Если НЕ ПустаяСтрока(ПредставлениеОтбора) Тогда 
			ПредставлениеОтбора = ПредставлениеОтбора + "; ";
		КонецЕсли;
		ПредставлениеОтбора = ПредставлениеОтбора + ИмяОграничения;
	КонецЦикла;
КонецПроцедуры
