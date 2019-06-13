use Склад_004
go

create trigger tr_Set_СрокПоставки
on Заказ
after insert, update
as 
 begin
  declare @Срок int, @КодВ char(3)
  select @КодВ = Товар.КодВалюты 
  from inserted
   inner join Товар on inserted.КодТовара = Товар.КодТовара
  select @Срок =
  case 
  when @КодВ = 'BYR' then 3
  when @КодВ ='RUB' then 7
  when @КодВ = 'USD' then 10
  when @КодВ ='EUR' then 10
  else 14
  end
  update Заказ
  set СрокПоставки = Заказ.ДатаЗаказа + @Срок
  from Заказ
	inner join inserted on Заказ.КодЗаказа = inserted.КодЗаказа
 end
go

insert into Заказ(КодКлиента, КодТовара, Количество, КодПоставщика)
values (2, 222, 80, 123)
go

CREATE TABLE Отпуск (
   КодТовара		INT  PRIMARY KEY,
   Наименование	VARCHAR(50)  NOT NULL,
   ВсегоЗаказано	NUMERIC(12, 3)  NULL,
   CONSTRAINT  FK_Отпуск_Товар  FOREIGN KEY (КодТовара)
     REFERENCES  Товар  ON UPDATE CASCADE
 )
go

alter trigger tr_Кол_ЗаказанногоТовара
on Заказ
after update, insert, delete
as
 if UPDATE(Количество)
  begin
    declare @КодИ int, @СуммаИ int
    select @КодИ = КодТовара
    from inserted
    select @СуммаИ = sum(Количество)
    from Заказ
    where КодТовара = @КодИ
    group by КодТовара
    update Отпуск
    set ВсегоЗаказано = @СуммаИ
    where КодТовара = @КодИ
  end
 if (exists(select * from inserted) and not exists(select * from deleted))
  begin
   declare @КодВ int, @СуммаВ int
   select @КодВ = КодТовара
   from inserted
   if not exists(select КодТовара from Отпуск where КодТовара = @КодВ)
    begin
	 insert into Отпуск
	 select КодТовара, Наименование, 0
	 from Товар
     where КодТовара = @КодВ
	end
   select @СуммаВ = sum(Количество)
   from Заказ 
   where КодТовара = @КодВ
   group by КодТовара
   update Отпуск
   set ВсегоЗаказано = @СуммаВ
   where КодТовара = @КодВ
  end
 if (not exists(select * from inserted) and exists(select * from deleted))
  begin
   declare @КодУ int, @СуммаУ int
   select @КодУ = КодТовара
   from deleted
   if not exists(select КодТовара from Заказ where КодТовара = @КодВ)
    begin
	 delete from Отпуск
	 where КодТовара = @КодУ
	end
   else
    begin
	 select @КодУ = КодТовара
     from deleted
	 select @СуммаУ = sum(Количество)
     from Заказ
     where КодТовара = @КодУ
     group by КодТовара
     update Отпуск
     set ВсегоЗаказано = @СуммаУ
     where КодТовара = @КодУ
	end
  end
go

insert into Заказ(КодКлиента, КодТовара, Количество, КодПоставщика)
values (2, 222, 80, 123)
go

--Альтернативный вариант
alter trigger tr_Кол_ЗаказанногоТовара
on Заказ
after update, insert, delete
as
 begin
  truncate table Отпуск
  insert into Отпуск
  select max(З.КодТовара), max(Т.Наименование), sum(З.Количество)
  from Заказ З
   inner join Товар Т on З.КодТовара = Т.КодТовара
  group by З.КодТовара
 end 
go

insert into Заказ(КодКлиента, КодТовара, Количество, КодПоставщика)
values (2, 222, 80, 123)
go

alter procedure pr_Стоимость_ВалютаИнтервал 
@КодВалюты char(3), 
@НачалоИнтервала datetime, 
@КонецИнтервала datetime,
@Стоимость money output
as
 IF @НачалоИнтервала IS NULL
  SET @НачалоИнтервала = getdate() - 365
 IF @КонецИнтервала IS NULL 
  SET @КонецИнтервала = getdate()
 SET @Стоимость = 0
 DECLARE @СтоимостьЗаказа MONEY, @КурсПр MONEY
 select @КурсПр = КурсВалюты
 from Валюта
 where @КодВалюты = КодВалюты
 DECLARE Curs CURSOR LOCAL STATIC
   FOR SELECT З.Количество * Т.Цена * В.КурсВалюты / @КурсПр
     FROM Заказ З
       INNER JOIN Товар Т ON З.КодТовара = Т.КодТовара
       INNER JOIN Валюта В ON Т.КодВалюты = В.КодВалюты
     WHERE З.ДатаЗаказа BETWEEN @НачалоИнтервала AND
       @КонецИнтервала      
 OPEN Curs
 FETCH FIRST FROM Curs INTO @СтоимостьЗаказа
 WHILE @@FETCH_STATUS = 0
  BEGIN
   SET @Стоимость = @Стоимость + @СтоимостьЗаказа
   FETCH NEXT FROM Curs INTO @СтоимостьЗаказа
  END
 CLOSE Curs
 DEALLOCATE Curs
go

DECLARE @Cost MONEY
EXEC pr_Стоимость_ВалютаИнтервал 'USD', NULL, NULL, @Cost OUTPUT
SELECT @Cost AS [Стоимость заказов в USD]
EXEC pr_Стоимость_ВалютаИнтервал 'BYR', NULL, NULL, @Cost OUTPUT
SELECT @Cost AS [Стоимость заказов в НВ]
go

INSERT INTO Регион 
 VALUES (102, 'Россия', '', 'Москва', 'пр.Калинина, 50', 
   '339-62- 10', '(095) 339-62-11')
 INSERT INTO Регион 
 VALUES (401, 'Литва', '', 'Вильнюс', 'ул.Чурлёниса, 19', NULL,
   '(055) 33-27-75')	
 GO

declare @Таблица table(
 Страна varchar(20) primary key,
 ЧислоКлиентов int,
 ЧислоПоставщиков int
 )
 insert into @Таблица(Страна)
  select max(Страна)
  from Регион
  group by Страна
  declare @КолКли int, @КолПос int, @Стр varchar(20), @НачалоИнтервала datetime, @КонецИнтервала datetime
  select @НачалоИнтервала = '2019-03-10', @КонецИнтервала = '2019-05-31'
  declare Curs cursor local static
   for select Страна
     FROM @Таблица
  open Curs
  fetch first from Curs into @Стр
  while @@FETCH_STATUS = 0
   begin
    exec pr_КлиентПоставщик_СтранаИнтервал @Стр, @НачалоИнтервала, @КонецИнтервала, @КолКли output, @КолПос output
    update @Таблица
    set ЧислоКлиентов = @КолКли, ЧислоПоставщиков = @КолПос
    where Страна = @Стр
    fetch next from Curs into @Стр
   end
 close Curs
 deallocate Curs
 select * from @Таблица
 go

 create table Протокол (
  Номер int primary key identity(1, 1),
  ДатаВремя datetime,
  Пользователь nvarchar(128),
  Дейсвтие varchar(10),
  ЧислоСтрок int
 )
 go

 create trigger tr_Твр_Изм
 on Товар
 after insert, delete, update
 as
 begin
 declare @date datetime, @user nvarchar(128), @act varchar(10), @num int
 select @date = getdate(), @user = CURRENT_USER
  if (exists(select * from inserted) and exists(select * from deleted))
   begin
    select @num = count(*) from inserted
	set @act = 'Обновление'
   end
  if (exists(select * from inserted) and not exists(select * from deleted))
   begin
    select @num = count(*) from inserted
	set @act = 'Добавление'
   end
  if (not exists(select * from inserted) and exists(select * from deleted))
   begin
    select @num = count(*) from deleted
	set @act = 'Удаление'
   end
 insert into Протокол
 select @date, @user, @act, @num
 end
 go

 INSERT INTO Товар
 VALUES (777, 'Лук', 'кг', 250, 'USD', 'Да')
 go

 update Товар
 set Цена = 90000
 where КодТовара = 333
 update Товар
 set Цена = 100000
 where КодТовара = 333
 update Товар
 set Цена = 250
 where КодТовара = 444 or КодТовара = 777 
 go

 delete from Товар
 where КодТовара = 777
 go
 
 ALTER TABLE Заказ ADD Стоимость MONEY NULL
 ALTER TABLE Заказ ADD СтоимостьНВ MONEY NULL
 GO

create TRIGGER tr_Товар_Цена 
 ON Товар 
 FOR insert, UPDATE 
 AS
   IF UPDATE(Цена)
     BEGIN
       DECLARE @КодТовара INT, @Цена MONEY, @ЦенаНВ MONEY
	   DECLARE myCursor CURSOR LOCAL STATIC
       FOR 
         SELECT inserted.КодТовара, inserted.Цена, 
           inserted.Цена * Валюта.КурсВалюты
         FROM inserted INNER JOIN Валюта
           ON inserted.КодВалюты = Валюта.КодВалюты	
		OPEN myCursor
		FETCH FIRST FROM myCursor INTO @КодТовара, @Цена, @ЦенаНВ 
		WHILE @@FETCH_STATUS = 0
         BEGIN
           UPDATE Заказ
           SET Стоимость = Количество * @Цена, 
             СтоимостьНВ = Количество * @ЦенаНВ
           WHERE КодТовара = @КодТовара
           FETCH NEXT FROM myCursor INTO @КодТовара, @Цена,
             @ЦенаНВ
         END
       CLOSE myCursor
       DEALLOCATE myCursor
     END
 GO

 create trigger tr_Зак_Обновл_Кол
 on Заказ 
 after insert, update
 as
  if update(Количество) or (exists(select * from inserted) and not exists(select * from deleted))
   begin
    DECLARE @КодЗаказа INT, @Цена MONEY, @ЦенаНВ MONEY
	   DECLARE myCursor CURSOR LOCAL STATIC
       FOR 
         SELECT inserted.КодЗаказа, inserted.Количество * Товар.Цена, 
           inserted.Количество * Товар.Цена * Валюта.КурсВалюты
         FROM inserted 
		  INNER JOIN Товар ON inserted.КодТовара = Товар.КодТовара	
          INNER JOIN Валюта ON Товар.КодВалюты = Валюта.КодВалюты
		OPEN myCursor
		FETCH FIRST FROM myCursor INTO @КодЗаказа, @Цена, @ЦенаНВ 
		WHILE @@FETCH_STATUS = 0
         BEGIN
           UPDATE Заказ
           SET Стоимость = @Цена, 
             СтоимостьНВ = @ЦенаНВ
           WHERE КодЗаказа = @КодЗаказа
           FETCH NEXT FROM myCursor INTO @КодЗаказа, @Цена, @ЦенаНВ
         END
       CLOSE myCursor
       DEALLOCATE myCursor
   end
 go

 create trigger tr_Вал_Обновл_Курс
 on Валюта
 after update
 as
 if update(КурсВалюты)
 begin
 DECLARE @КодТовара INT, @Цена MONEY, @ЦенаНВ MONEY
 DECLARE myCursor CURSOR LOCAL STATIC
 FOR 
 SELECT Товар.КодТовара, Товар.Цена, 
 Товар.Цена * inserted.КурсВалюты
 FROM inserted 
 INNER JOIN Товар ON inserted.КодВалюты = Товар.КодВалюты	
 OPEN myCursor
 FETCH FIRST FROM myCursor INTO @КодТовара, @Цена, @ЦенаНВ
 WHILE @@FETCH_STATUS = 0
 BEGIN
 UPDATE Заказ
 SET Стоимость = Количество * @Цена, 
 СтоимостьНВ = Количество * @ЦенаНВ
 WHERE КодТовара = @КодТовара
 FETCH NEXT FROM myCursor INTO @КодТовара, @Цена, @ЦенаНВ
 END
 CLOSE myCursor
 DEALLOCATE myCursor
 end
 go


 update Валюта
 set КурсВалюты = 12450
 where КодВалюты = 'USD'
 update Валюта
 set КурсВалюты = 1
 where КодВалюты = 'BYR'
 update Валюта
 set КурсВалюты = 276
 where КодВалюты = 'RUR'
 update Валюта
 set КурсВалюты = 9160
 where КодВалюты = 'EUR'
 


 begin transaction

 insert into Заказ(КодКлиента, КодТовара, Количество, КодПоставщика)
 values(2, 222, 160, 123)
select * from Заказ

 update Заказ
 set Количество = 120
 where КодЗаказа = 62
 
 update Валюта
 set КурсВалюты = 2.1
 where КодВалюты = 'USD'
select * from Заказ
 
 rollback
select * from Заказ
 go