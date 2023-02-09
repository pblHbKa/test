﻿
#Если МобильныйКлиент Тогда 
		
// Процедура обработчик push-уведомлений и локальных уведомлений
Процедура ОбработкаУведомлений(Уведомление, Локальное, Показано, Параметры) Экспорт
	
	Если НЕ Показано Тогда
		// Иначе пользователь оповещен об уведомлении системными средствами.
		СредстваМультимедиа.ВоспроизвестиЗвуковоеОповещение();
	КонецЕсли;
	
	Если УведомленияСервер.ВоспроизводитьТекстУведомления() Тогда
		СредстваМультимедиа.ВоспроизвестиТекст(Уведомление.Текст);
	КонецЕсли;
	
	Если Локальное Тогда
		Если СтрНачинаетсяС(Уведомление.Данные, "TN:") Тогда
			// По префиксу "TN:" определили, что уведомление установлено в форме контрагента, это "Перезвоните..."
			ПараметрыФормы = Новый Структура("Текст, Данные", Уведомление.Текст, Сред(Уведомление.Данные, 4));
	        ОткрытьФорму("ОбщаяФорма.Звонок", ПараметрыФормы);
        КонецЕсли;
	Иначе
		Если НЕ Показано Тогда
			ПоказатьПредупреждение(, Уведомление.Текст);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры
	
#КонецЕсли

// Процедура получает идентификатор подписчика уведомлений
// - получает новый идентификатор
// - отправляет идентификатор источнику push-уведомлений
// - информирует пользователя о возникших ошибках
Процедура ОбновитьИдентификаторПодписчикаУведомлений() Экспорт
	
#Если МобильныйКлиент Тогда 
	
	Если ОсновнойСерверДоступен() = Истина Тогда
		Попытка
			ИдентификаторПодписчикаУведомлений = ДоставляемыеУведомления.ПолучитьИдентификаторПодписчикаУведомлений();
			ТекстОшибки = "";
			УведомленияСервер.ПередатьИдентификаторПодписчикаУведомлений(ИдентификаторПодписчикаУведомлений, ТекстОшибки);
			Если ТекстОшибки <> "" Тогда
				Сообщить(ТекстОшибки);
			КонецЕсли
		Исключение
	        Инфо = ИнформацияОбОшибке();
	        ПоказатьИнформациюОбОшибке(Инфо);
		КонецПопытки
	КонецЕсли
	
#КонецЕсли

КонецПроцедуры
