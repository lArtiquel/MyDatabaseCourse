CREATE DATABASE Склад_214TSQL  -- database creation with files 
 ON PRIMARY                   
   ( NAME = Склад_data,       
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_data.mdf',
     SIZE = 5MB, 
     MAXSIZE = 75MB,
     FILEGROWTH = 3MB ),
 FILEGROUP Secondary
   ( NAME = Склад2_data,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_data2.ndf',
     SIZE = 3MB, 
     MAXSIZE = 50MB,
     FILEGROWTH = 15% ),
   ( NAME = Склад3_data,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_data3.ndf',
     SIZE = 4MB, 
     FILEGROWTH = 4MB )
 LOG ON
   ( NAME = Склад_log,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_log.ldf',
     SIZE = 1MB,
     MAXSIZE = 10MB,
     FILEGROWTH = 20% ),
   ( NAME = Склад2_log,
     FILENAME = 'D:\Artyom\Учеба\DB\4 лаба Transact-SQL\Склад_214TSQL_log2.ldf',
     SIZE = 512KB,
     MAXSIZE = 15MB,
     FILEGROWTH = 10% )
 GO  

 USE Склад_214TSQL										-- use this database
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

  /* Заказ */
 CREATE TABLE Заказ (				/* шестая команда пакета */
   КодЗаказа		INT  IDENTITY(1,1)  NOT NULL,
   КодКлиента	 	INT  NOT NULL,
   КодТовара   		INT  NOT NULL,
   Количество		NUMERIC(12, 3)  NULL  CHECK (Количество > 0),
   ДатаЗаказа	 	DATETIME  DEFAULT getdate()  NULL,
   СрокПоставки		DATETIME  DEFAULT getdate() + 14  NULL,
   КодПоставщика	INT  NULL,  					
   PRIMARY KEY (КодЗаказа, КодКлиента, КодТовара),
   CONSTRAINT  FK_Заказ_Товар  FOREIGN KEY (КодТовара)  
   REFERENCES  Товар  ON UPDATE CASCADE ON DELETE CASCADE,
   CONSTRAINT  FK_Заказ_Клиент  FOREIGN KEY (КодКлиента)
   REFERENCES  Клиент  ON UPDATE CASCADE ON DELETE CASCADE,
   CONSTRAINT  FK_Заказ_Поставщик  FOREIGN KEY (КодПоставщика)
   REFERENCES  Поставщик
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
 CREATE INDEX  IX_Регион  ON Регион (Страна, Город)  ON Secondary
 CREATE INDEX  IX_Товар  ON Товар (ЕдиницаИзм, Наименование)
   ON Secondary
 CREATE INDEX  IX_Заказ  ON Заказ (ДатаЗаказа)  ON Secondary
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
SET DATEFORMAT dmy		/* задаем привычный формат даты день.месяц.год, т.к. 
                           по умолчанию установлен формат год.месяц.день */
INSERT INTO Заказ		/* год можно задавать как 2-мя, так и 4-мя цифрами */
 VALUES (1, 111, 8, '04.09.2019', '14.09.2019', 567)   

INSERT INTO Заказ		
 VALUES (2, 112, 80, '05.09.19', '14.09.19', 257) 
 
INSERT INTO Заказ		
 VALUES (3, 113, 30, '07.09.12', '14.09.12', 257) 

INSERT INTO Заказ		
 VALUES (4, 114, 18, '08.09.12', '14.09.12', 123) 

INSERT INTO Заказ		
 VALUES (5, 115, 60, '18.09.19', '20.09.19', 124) 

INSERT INTO Заказ		
 VALUES (1, 111, 70, '05.09.12', '14.09.12', 567)
 
INSERT INTO Заказ		
 VALUES (2, 112, 40, '05.09.12', '14.09.12', 123) 

INSERT INTO Заказ		
 VALUES (3, 113, 100, '05.09.12', '14.09.12', 124) 

INSERT INTO Заказ		
 VALUES (4, 115, 70, '05.09.19', '14.09.19', 125) 

INSERT INTO Заказ (КодКлиента, КодТовара, Количество)
 VALUES (5, 115, 25)
 GO

-- Cоздаем представление
CREATE VIEW Запрос_Товар_Заказ_Поставщик AS
   SELECT TOP 100 PERCENT Товар.Наименование, Заказ.Количество, 
     Товар.ЕдиницаИзм, Поставщик.ИмяПоставщика
   FROM Заказ 
     INNER JOIN Поставщик 
       ON Заказ.КодПоставщика = Поставщик.КодПоставщика 
     INNER JOIN Товар 
       ON Заказ.КодТовара = Товар.КодТовара
   ORDER BY Товар.Наименование, Заказ.Количество DESC 
 GO

-- Предоставление доступа к серверу учетной записи Windows 
EXEC sp_grantlogin 'DESKTOP-0D9IMT3\sql1'
EXEC sp_grantlogin 'DESKTOP-0D9IMT3\sql2'
EXEC sp_grantlogin 'DESKTOP-0D9IMT3\sql3'
EXEC sp_grantlogin 'DESKTOP-0D9IMT3\sql4'
/* отмена доступа -- sp_droplogin [ @loginame = ] 'login' */
 GO

-- Добавление учетной записи в фиксированную роль сервера
EXEC sp_addsrvrolemember 'DESKTOP-0D9IMT3\sql1', 'dbcreator'  
-- sp_dropsrvrolemember [ @loginame = ] 'login' , [ @rolename = ] 'role'
 GO

-- Создание нового пользователя и связывание его с учетной записью. 
EXEC sp_grantdbaccess 'DESKTOP-0D9IMT3\sql1', 'sql1'  
EXEC sp_grantdbaccess 'DESKTOP-0D9IMT3\sql2', 'sql2'  
EXEC sp_grantdbaccess 'DESKTOP-0D9IMT3\sql3', 'sql3'  	
EXEC sp_grantdbaccess 'DESKTOP-0D9IMT3\sql4', 'sql4'  
 GO

-- Создание пользовательской роли(sql1 owner)
EXEC sp_addrole 'Гл.бухгалтер', 'sql1'  
EXEC sp_addrole 'Бухгалтера',   'sql1'  
EXEC sp_addrole 'Экономисты',   'sql1'  
-- Delete Role: sp_droprole [ @rolename = ] 'role'
 GO

-- Добавление нового члена в роль (как фиксированную, так и пользовательскую) базы данных.
EXEC sp_addrolemember 'db_accessadmin', 'sql1'  
EXEC sp_addrolemember 'Гл.бухгалтер',   'sql1'  
EXEC sp_addrolemember 'Бухгалтера',     'sql2'  
EXEC sp_addrolemember 'Бухгалтера',     'sql3'  
EXEC sp_addrolemember 'Бухгалтера',     'Гл.бухгалтер'  
EXEC sp_addrolemember 'Экономисты',     'sql4'  
EXEC sp_addrolemember 'Экономисты',     'Гл.бухгалтер'  
-- To drop: sp_droprolemember [ @rolename = ] 'role' , [ @membername = ] 'security_account'
 GO

-- Предоставление привилегий доступа к объектам базы данных.
GRANT SELECT, INSERT, UPDATE, DELETE
 ON Валюта TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT UPDATE
 ON Заказ TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT SELECT
 ON Запрос_Товар_Заказ_Поставщик TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT UPDATE, DELETE
 ON Клиент TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT UPDATE, DELETE
 ON Поставщик TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT UPDATE, DELETE
 ON Товар TO [Гл.бухгалтер] WITH GRANT OPTION

GRANT SELECT, INSERT
 ON Заказ TO Бухгалтера

GRANT SELECT, INSERT
 ON Клиент TO Бухгалтера

GRANT SELECT, INSERT
 ON Поставщик TO Экономисты

GRANT SELECT, INSERT
 ON Товар TO Экономисты

GRANT SELECT, INSERT, UPDATE, DELETE
 ON Регион TO public
 GO

-- Запрещение доступа к объектам базы данных. 
DENY UPDATE
 ON Заказ (ДатаЗаказа, СрокПоставки) TO [Гл.бухгалтер] CASCADE 
 GO






