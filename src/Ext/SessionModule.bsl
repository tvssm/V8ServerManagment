﻿
Процедура УстановкаПараметровСеанса(ТребуемыеПараметры)          
    
    Для каждого ПараметрСеанса Из Метаданные.ПараметрыСеанса Цикл
        ИмяПараметра = ПараметрСеанса.Имя;
        ПараметрыСеанса[ИмяПараметра] = Константы[ИмяПараметра].Получить();
    КонецЦикла;
    
КонецПроцедуры