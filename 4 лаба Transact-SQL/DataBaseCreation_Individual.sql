CREATE DATABASE Склад_214TSQL_INDIVIDUAL  -- database creation with files 
 ON PRIMARY                   
   ( NAME = Склад_data,       
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_INDIVIDUAL_data.mdf',
     SIZE = 5MB, 
     MAXSIZE = 75MB,
     FILEGROWTH = 3MB ),
 FILEGROUP Secondary
   ( NAME = Склад2_data,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_INDIVIDUAL_data2.ndf',
     SIZE = 3MB, 
     MAXSIZE = 50MB,
     FILEGROWTH = 15% ),
   ( NAME = Склад3_data,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_INDIVIDUAL_data3.ndf',
     SIZE = 4MB, 
     FILEGROWTH = 4MB )
 LOG ON
   ( NAME = Склад_log,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_INDIVIDUAL_log.ldf',
     SIZE = 1MB,
     MAXSIZE = 10MB,
     FILEGROWTH = 20% ),
   ( NAME = Склад2_log,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_INDIVIDUAL_log2.ldf',
     SIZE = 512KB,
     MAXSIZE = 15MB,
     FILEGROWTH = 10% )
 GO  

 USE Склад_214TSQL_INDIVIDUAL										-- use this database
 GO

 CREATE RULE Logical_rule AS @value IN ('Нет', 'Да')	-- create logical rule
 GO

 CREATE DEFAULT Logical_default AS 'Нет'				-- create default value
 GO

 EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'			-- create new type(system type, default value, owner type)
 GO

 EXEC sp_bindrule 'Logical_rule', 'Logical'				-- tie rule with type of data
 GO

 EXEC sp_bindefault 'Logical_default', 'Logical'		-- bind default with type of data
 GO


 /* create tables */
 CREATE TABLE Регион (				/* первая команда пакета */
   КодРегиона	INT  PRIMARY KEY,
   Страна		VARCHAR(20)  DEFAULT 'Беларусь'  NOT NULL,
   Область		VARCHAR(20)  NOT NULL,
   Город		VARCHAR(20)  NOT NULL,
   Адрес		VARCHAR(50)  NOT NULL,
   Телефон		CHAR(15)  NULL,
   Факс			CHAR(15)  NOT NULL  CONSTRAINT CIX_Регион2
   UNIQUE		ON Secondary,
   CONSTRAINT	CIX_Регион  UNIQUE (Страна, Область, Город, Адрес)
   ON Secondary
 )

  /* Поставщик */
 CREATE TABLE Поставщик (			/* вторая команда пакета */
   КодПоставщика	INT  PRIMARY KEY,
   ИмяПоставщика	VARCHAR(40)  NOT NULL,
   УсловияОплаты	VARCHAR(30)  DEFAULT 'Предоплата'  NULL,
   КодРегиона		INT  NULL,
   Заметки			VARCHAR(MAX)  NULL,
   CONSTRAINT		FK_Поставщик_Регион  FOREIGN KEY (КодРегиона)
   REFERENCES		Регион  ON UPDATE CASCADE
 )

  /* Клиент */
 CREATE TABLE Клиент (				/* третья команда пакета */
   КодКлиента	 	INT  IDENTITY(1,1)  PRIMARY KEY,
   ИмяКлиента		VARCHAR(40)  NOT NULL,
   ФИОРуководителя	VARCHAR(60)  NULL,
   КодРегиона 		INT  NULL,
   CONSTRAINT		FK_Клиент_Регион  FOREIGN KEY (КодРегиона)
   REFERENCES		Регион  ON UPDATE CASCADE
 )

  /* Валюта */
 CREATE TABLE Валюта (				/* четвертая команда пакета */
   КодВалюты		CHAR(3)  PRIMARY KEY,
   ИмяВалюты		VARCHAR(30)  NOT NULL,
   ШагОкругления 	NUMERIC(10, 4)  DEFAULT 0.01  NULL
   CHECK (ШагОкругления IN (50, 1, 0.01)),
   КурсВалюты  		SMALLMONEY  NOT NULL  CHECK (КурсВалюты > 0)
 )

  /* Заказ */
 CREATE TABLE Заказ (				/* шестая команда пакета */
   КодЗаказа		INT  PRIMARY KEY,
   КодКлиента	 	INT  NOT NULL,	
   ДатаЗаказа	 	DATETIME  DEFAULT getdate()  NULL,
   СрокПоставки		DATETIME  DEFAULT getdate() + 14  NULL,
   CONSTRAINT  FK_Заказ_Клиент  FOREIGN KEY (КодКлиента)
   REFERENCES  Клиент  ON UPDATE CASCADE ON DELETE CASCADE
 )

  /* Товар */
 CREATE TABLE Товар (				/* пятая команда пакета */
   КодТовара		INT  PRIMARY KEY,
   Наименование		VARCHAR(50)  NOT NULL,
   ЕдиницаИзм  		CHAR(10)  DEFAULT 'штука'  NULL,
   Цена				MONEY  NULL  CHECK (Цена > 0),
   КодВалюты		CHAR(3)  DEFAULT 'BYR'  NULL,
   Расфасован		LOGICAL  NOT NULL,
   CONSTRAINT		FK_Товар_Валюта  FOREIGN KEY (КодВалюты)
   REFERENCES		Валюта  ON UPDATE CASCADE
 )

 CREATE TABLE Спецификация (
	КодЗаказа		INT	NOT NULL,
	КодТовара		INT NOT NULL,
	КодПоставщика	INT NOT NULL,
	Количество		NUMERIC(12, 3)  NULL  CHECK (Количество > 0),
	CONSTRAINT FK_Спецификация_Заказ FOREIGN KEY (КодЗаказа)
	REFERENCES		Заказ  ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_Спецификация_Товар FOREIGN KEY (КодТовара)
	REFERENCES		Товар  ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_Спецификация_Поставщик FOREIGN KEY (КодПоставщика)
	REFERENCES		Поставщик ON UPDATE NO ACTION ON DELETE NO ACTION,
  )

 GO
 

 /* create unique indexes */
 CREATE UNIQUE INDEX  UIX_Поставщик  ON Поставщик (ИмяПоставщика)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_Клиент  ON Клиент (ИмяКлиента)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_Валюта  ON Валюта (ИмяВалюты)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_Товар  ON Товар (Наименование)
   ON Secondary
 CREATE INDEX  IX_Регион  ON Регион (Страна, Город)  
   ON Secondary
 CREATE INDEX  IX_Товар  ON Товар (ЕдиницаИзм, Наименование)
   ON Secondary
 CREATE INDEX  IX_Заказ  ON Заказ (ДатаЗаказа)  
   ON Secondary
 GO


 /* insert data into tables */

 /* inser Region data */
 INSERT INTO Регион 
 VALUES (101, 'Россия', 'Московская', 'Королев', 'ул.Мира, 15',
   '387-23-04', '387-23-05')

 INSERT INTO Регион (КодРегиона, Область, Город, Адрес, Факс)
 VALUES (201, '', 'Минск', 'ул.Гикало, 9', '278-83-88')	

 INSERT INTO Регион (КодРегиона, Область, Город, Адрес, Факс)
 VALUES (202, 'Минская', 'Воложин', 'ул.Серова, 11', '48-37-92')

 INSERT INTO Регион (КодРегиона, Область, Город, Адрес, Телефон,
   Факс)
 VALUES (203, '', 'Минск', 'ул.Кирова, 24', '269-13-76',
   '269-13-77')	

 INSERT INTO Регион (КодРегиона, Область, Город, Адрес, Факс)
 VALUES (204, 'Витебская', 'Полоцк', 'ул.Лесная, 6', '48-24-12')

INSERT INTO Регион 
 VALUES (301, 'Украина', 'Крымская', 'Алушта', 'ул.Франко, 24',
   NULL, '46-49-16')	
 GO

 -- insert Поставщиков
INSERT INTO Поставщик (КодПоставщика, ИмяПоставщика, КодРегиона)
 VALUES (123, 'ЗАО Магистраль', 101)	
  
INSERT INTO Поставщик (КодПоставщика, ИмяПоставщика, КодРегиона)
 VALUES (124, 'Vasiliy & co', 201)
  
INSERT INTO Поставщик (КодПоставщика, ИмяПоставщика, КодРегиона)
 VALUES (125, 'ИванКо', 202)  

INSERT INTO Поставщик (КодПоставщика, ИмяПоставщика, КодРегиона)
 VALUES (257, 'Никитос', 301)  

INSERT INTO Поставщик
VALUES (567, 'СП ”Полихим”', 'По факту отгрузки', 203,
   'Постоянный поставщик')	
GO

-- вставляем клиентов
INSERT INTO Клиент
 VALUES ('ГП ”Верас”', 'Прокушев Станислав Игоревич', 202)
  
INSERT INTO Клиент
 VALUES ('ТЦ"Ашан"', 'Мурхабадилли Ашот', 201)

INSERT INTO Клиент
 VALUES ('ТЦ ”Космос”', 'Никитьевич Никита Артёмович', 203)

INSERT INTO Клиент
 VALUES ('ТЦ ”Рига”', 'Ковалак Иван Викторович', 204)

INSERT INTO Клиент (ИмяКлиента, ФИОРуководителя)
 VALUES ('ИП ”Темп”', 'Васько Григорий Терентьевич')
 GO

 -- вставляем валюту
INSERT INTO Валюта
 VALUES ('BYR', 'Белорусские рубли', 1, 1)

INSERT INTO Валюта (КодВалюты, ИмяВалюты, КурсВалюты)
 VALUES ('RUR', 'Российские рубли', 276)

INSERT INTO Валюта (КодВалюты, ИмяВалюты, КурсВалюты)
 VALUES ('USD', 'Доллары США', 9160)

INSERT INTO Валюта (КодВалюты, ИмяВалюты, КурсВалюты)
 VALUES ('EUR', 'Евро', 12450)
GO

-- вставляем товары
INSERT INTO Товар
 VALUES (111, 'Монитор 21 дюйм', 'штука', 320, 'USD', 'Нет')
 
INSERT INTO Товар
 VALUES (112, 'Айфон 6 Плюс', 'штука', 350, 'USD', 'Нет')

INSERT INTO Товар
 VALUES (113, 'Холодильник "Горизонт"', 'штука', 300, 'EUR', 'Нет')

INSERT INTO Товар
 VALUES (114, 'блины "У Валентины"', 'штука', 3, 'BYR', 'Нет')

INSERT INTO Товар (КодТовара, Наименование, Цена, Расфасован)
 VALUES (115, 'Винчестер HDD 120GB', 285000, 'Да')
GO

-- заполняем Заказы
INSERT INTO Заказ		/* год можно задавать как 2-мя, так и 4-мя цифрами */
 VALUES (1, 1, '05.04.2019', '06.07.2019')   

INSERT INTO Заказ		
 VALUES (2, 2, '04.04.2019', '06.07.2019') 
 
INSERT INTO Заказ		
 VALUES (3, 3, '03.04.2019', '06.07.2019') 

INSERT INTO Заказ		
 VALUES (4, 4, '02.04.2019', '06.07.2019') 

INSERT INTO Заказ		
 VALUES (5, 5, '01.04.2019', '06.07.2019') 

INSERT INTO Заказ		
 VALUES (6, 1, '06.03.2019', '06.07.2019')
 
INSERT INTO Заказ		
 VALUES (7, 2, '06.02.2019', '06.07.2019') 

INSERT INTO Заказ		
 VALUES (8, 3, '06.01.2019', '06.07.2019') 

INSERT INTO Заказ		
 VALUES (9, 4, '06.11.2019', '06.07.2019') 

INSERT INTO Заказ
 VALUES (10, 5, '06.09.2019', '06.07.2019')
 GO

SET DATEFORMAT dmy		/* задаем привычный формат даты день.месяц.год, т.к. 
                           по умолчанию установлен формат год.месяц.день */
INSERT INTO Спецификация
 VALUES (1, 111, 123, 2)

INSERT INTO Спецификация
 VALUES (2, 113, 123, 2)

INSERT INTO Спецификация
 VALUES (3, 112, 123, 2)

INSERT INTO Спецификация
 VALUES (4, 114, 123, 2)

INSERT INTO Спецификация
 VALUES (5, 115, 123, 2)

INSERT INTO Спецификация
 VALUES (6, 111, 123, 2)

INSERT INTO Спецификация
 VALUES (7, 112, 123, 2)

INSERT INTO Спецификация
 VALUES (8, 113, 123, 2)

INSERT INTO Спецификация
 VALUES (9, 114, 123, 2)

INSERT INTO Спецификация
 VALUES (10, 115, 123, 2)

INSERT INTO Спецификация
 VALUES (1, 111, 123, 2)

INSERT INTO Спецификация
 VALUES (2, 112, 123, 2)
 GO