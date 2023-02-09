﻿
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = ТекущаяДата();
	КонецЕсли;
	
	ЗаписатьЕслиНадоИСформироватьДиаграмму();	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	ЗаполнитьДиаграмму();	
КонецПроцедуры

&НаСервере
Процедура НастроитьДиаграмму()
	
	Диаграмма.ОбластьЛегенды.Расположение = РасположениеЛегендыДиаграммы.Нет;
	Диаграмма.РежимРедактированияЗначений = РежимРедактированияЗначенийДиаграммы.Использовать;
	
	СтрокаЦена = НСтр("ru = 'Цена'", "ru");
	СтрокаФормат = НСтр("ru = 'ЧН=0; ЧФ=''Ч руб.'''", "ru");
	
	Серия = Диаграмма.Серии.Добавить(СтрокаЦена);
	Серия.ФорматЗначенийВПодписях = СтрокаФормат;
	
	ШкалаЗначений = Диаграмма.ОбластьПостроения.ШкалаЗначений;
	ШкалаЗначений.ТекстЗаголовка = СтрокаЦена;
	ШкалаЗначений.ФорматПодписей = СтрокаФормат;
	
КонецПроцедуры

&НаСервере
Процедура ПроставитьЦветаТочекВДиаграмму()
	
	Оформление = ХранилищеСистемныхНастроек.Загрузить("Общее/ЦветаДиаграммы");
	Если Оформление = Неопределено Тогда 
		Оформление = Новый ОформлениеЗначений();
	КонецЕсли;
	
	Палитра = Диаграмма.ОписаниеПалитрыЦветов.ПолучитьПалитру();
	
	Для Каждого Точка Из Диаграмма.Точки Цикл 
		Точка.ПриоритетЦвета = Истина;
		ЗначениеЦвета = Оформление.Установить(Точка.Расшифровка);
		Если ТипЗнч(ЗначениеЦвета) = Тип("Число") Тогда
			Точка.Цвет = Палитра[ЗначениеЦвета % Палитра.Количество()];
		ИначеЕсли ТипЗнч(ЗначениеЦвета) = Тип("Цвет") Тогда
			Точка.Цвет = ЗначениеЦвета;
		КонецЕсли;
	КонецЦикла;
	
	ХранилищеСистемныхНастроек.Сохранить("Общее/ЦветаДиаграммы", ,Оформление);
	
КонецПроцедуры
	
&НаСервере
Процедура ЗаполнитьДиаграмму()
		
	Диаграмма.Обновление = Ложь;
	Диаграмма.Точки.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЦеныТоваров.Товар КАК Товар,
		|	ЦеныТоваров.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныТоваров.СрезПоследних(
		|			&Период,
		|			ВидЦен = &ВидЦен
		|				И Товар В ИЕРАРХИИ (&ГруппаТоваров)) КАК ЦеныТоваров
		|
		|УПОРЯДОЧИТЬ ПО
		|	ЦеныТоваров.Товар.Наименование";
	
	Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
	Запрос.УстановитьПараметр("ГруппаТоваров", ГруппаТоваров);
	Запрос.УстановитьПараметр("Период", Период);
	
	РезультатЗапроса = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Точка = Диаграмма.Точки.Добавить(ВыборкаДетальныеЗаписи.Товар.Наименование);
		Точка.Расшифровка = ВыборкаДетальныеЗаписи.Товар;
		Диаграмма.УстановитьЗначение(Точка, 0, ВыборкаДетальныеЗаписи.Цена);
	КонецЦикла;
	
	ПроставитьЦветаТочекВДиаграмму();
	
	Диаграмма.Обновление = Истина;
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИСформироватьНаСервере()
	ЗаписатьДанныеИзДиаграммы();
	ЗаполнитьДиаграмму();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеИзДиаграммы()
	
	НачатьТранзакцию();
	
	Для Каждого Точка из Диаграмма.Точки Цикл
		
		ЦенаТовара = РегистрыСведений.ЦеныТоваров.СоздатьМенеджерЗаписи();
		ЦенаТовара.Период = Период;
		ЦенаТовара.ВидЦен = ВидЦен;
		ЦенаТовара.Товар = Точка.Расшифровка;
		ЦенаТовара.Цена = Диаграмма.ПолучитьЗначение(Точка, 0).Значение;
		ЦенаТовара.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ЭтаФорма.Модифицированность = Ложь;
КонецПроцедуры
	
&НаКлиенте
Процедура Записать(Команда)
	ЗаписатьЕслиНадоИСформироватьДиаграмму(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЕслиНадоИСформироватьДиаграмму(ЗадатьВопрос = Истина)
	Если ЭтаФорма.Модифицированность Тогда
		Если ЗадатьВопрос Тогда 
			Режим = РежимДиалогаВопрос.ДаНет;
			Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
			СтрокаВопрос = НСтр("ru = 'Данные были изменены. Записать изменения?'", "ru");
			ПоказатьВопрос(Оповещение, СтрокаВопрос, Режим, 0);
		Иначе 
			ЗаписатьИСформироватьНаСервере();
		КонецЕсли;
	Иначе 
		ЗаполнитьДиаграмму();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        ЗаписатьИСформироватьНаСервере();
	КонецЕсли;
	ЗаполнитьДиаграмму();
КонецПроцедуры

&НаКлиенте
Процедура ГруппаТоваровПриИзменении(Элемент)
	ЗаписатьЕслиНадоИСформироватьДиаграмму();
КонецПроцедуры

&НаКлиенте
Процедура ВидЦенПриИзменении(Элемент)
	ЗаписатьЕслиНадоИСформироватьДиаграмму();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЭтаФорма.Модифицированность Тогда 
		Отказ = Истина;
		Режим = РежимДиалогаВопрос.ДаНетОтмена;
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемПослеЗакрытияВопроса", ЭтотОбъект);
		СтрокаВопрос = НСтр("ru = 'Данные были изменены. Записать изменения?'", "ru");
		ПоказатьВопрос(Оповещение, СтрокаВопрос, Режим, 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПослеЗакрытияВопроса(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Да Тогда
        ЗаписатьДанныеИзДиаграммы();
		Закрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ЭтаФорма.Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДиаграммаПриРедактированииЗначения(Элемент, ЗначениеДиаграммы, СостояниеРедактирования)
	//Цена должна быть больше нуля
	Если ЗначениеДиаграммы.Значение <= 0 Тогда
		ЗначениеДиаграммы.Значение = 0.01;
	КонецЕсли;
	
	//Округляем, оставляя на мантиссу 3 разряда
	Разрядность = 2 - Цел(Log10(ЗначениеДиаграммы.Значение));
	ЗначениеДиаграммы.Значение = Окр(ЗначениеДиаграммы.Значение, Разрядность);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Период = ТекущаяДата();
	НастроитьДиаграмму();
КонецПроцедуры
