use Склад_214TSQL
go

-- 1 процедура
create procedure pr_КолебанияСпросаТоваров
 @Интервал int,
 @ТипРезультата int,
 @Имя varchar(50) output,
 @Итог int output
 as
 if @ТипРезультата = 1 
 begin
	select @Имя = Т.Наименование, @Итог = SUM(Количество)
	from Заказ З
		inner join Товар Т on З.КодТовара = Т.КодТовара
	where ДатаЗаказа BETWEEN GetDate() - @Интервал AND GetDate()
	group by Т.Наименование
	order by SUM(Количество)
 end
 else
 if @ТипРезультата = 2
	begin
	select @Имя = Т.Наименование, @Итог = SUM(Количество)
	from Заказ З
		inner join Товар Т on З.КодТовара = Т.КодТовара
	where ДатаЗаказа BETWEEN GetDate() - @Интервал AND GetDate()
	group by Т.Наименование
	order by SUM(Количество) desc
 end
go

declare @Имя varchar(50), @Итог int
exec pr_КолебанияСпросаТоваров 20, 1, @Имя output, @Итог output
select @Имя as [Наименование товара], @Итог as [Спрос]
exec pr_КолебанияСпросаТоваров 40, 2, @Имя output, @Итог output
select @Имя as [Наименование товара], @Итог as [Спрос]
go

-- 2 процедура
create procedure pr_КлиентПоставщик_СтранаИнтервал
 @Страна varchar(20),
 @НачалоИнтервала datetime,
 @КонецИнтервала datetime,
 @ЧислоКлиентов int output,
 @ЧислоПоставщиков int output
as
 if @Страна is not null
  begin
   select @ЧислоКлиентов = count(distinct З.КодКлиента)
   from Заказ З
	inner join Клиент К on З.КодКлиента = К.КодКлиента
	inner join Регион Р on К.КодРегиона = Р.КодРегиона
   where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала and @Страна = Р.Страна 
   select @ЧислоПоставщиков = count(distinct З.КодПоставщика) 
   from Заказ З
    inner join Поставщик П on З.КодПоставщика = П.КодПоставщика
	inner join Регион Р on П.КодРегиона = Р.КодРегиона
   where ДатаЗаказа <= @КонецИнтервала and ДатаЗаказа >= @НачалоИнтервала and @Страна = Р.Страна
  end
 else
  begin
   select @ЧислоКлиентов = count(distinct З.КодКлиента)
   from Заказ З
    inner join Клиент К on З.КодКлиента = К.КодКлиента
	inner join Регион Р on К.КодРегиона = Р.КодРегиона
   where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала
   select @ЧислоПоставщиков = count(distinct З.КодПоставщика) 
   from Заказ З
    inner join Поставщик П on З.КодПоставщика = П.КодПоставщика
	inner join Регион Р on П.КодРегиона = Р.КодРегиона
   where ДатаЗаказа <= @КонецИнтервала and ДатаЗаказа >= @НачалоИнтервала
  end
go

declare @ЧислоКлиентов int, @ЧислоПоставщиков int
exec pr_КлиентПоставщик_СтранаИнтервал 'Беларусь', "2019-03-10", "2019-05-10", @ЧислоКлиентов output, @ЧислоПоставщиков output
select @ЧислоКлиентов as [Число клинетов], @ЧислоПоставщиков as [Число поставщиков]
exec pr_КлиентПоставщик_СтранаИнтервал NULL, "2019-03-10", "2019-05-10", @ЧислоКлиентов output, @ЧислоПоставщиков output
select @ЧислоКлиентов as [Число клинетов], @ЧислоПоставщиков as [Число поставщиков]
go

-- 3 процедура
create procedure pr_Товар_СтранаВалютаИнтервал
@Страна varchar(20),
@Валюта char(3),
@НачалоИнтервала datetime,
@КонецИнтервала datetime,
@ЧислоТоваров int output
as
 if @Страна is not null
  if @Валюта is not null
   begin
    select @ЧислоТоваров = count(distinct З.КодТовара)
    from Заказ З
	 inner join Клиент К on З.КодКлиента = К.КодКлиента
	 inner join Регион Р on К.КодРегиона = Р.КодРегиона
	 inner join Товар Т on З.КодТовара = Т.КодТовара
	 inner join Валюта В on Т.КодВалюты = В.КодВалюты
    where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала and @Страна = Р.Страна and @Валюта = В.КодВалюты
   end
  else
   begin
    select @ЧислоТоваров = count(distinct З.КодТовара)
    from Заказ З
	 inner join Клиент К on З.КодКлиента = К.КодКлиента
	 inner join Регион Р on К.КодРегиона = Р.КодРегиона
	 inner join Товар Т on З.КодТовара = Т.КодТовара
	 inner join Валюта В on Т.КодВалюты = В.КодВалюты
    where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала and @Страна = Р.Страна and 'BYR' = В.КодВалюты
   end
 else
   if @Валюта is not null
    begin
	 select @ЧислоТоваров = count(distinct З.КодТовара)
     from Заказ З
	  inner join Клиент К on З.КодКлиента = К.КодКлиента
	  inner join Регион Р on К.КодРегиона = Р.КодРегиона
	  inner join Товар Т on З.КодТовара = Т.КодТовара
	  inner join Валюта В on Т.КодВалюты = В.КодВалюты
     where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала and @Валюта = В.КодВалюты
    end
   else
    begin
	 select @ЧислоТоваров = count(distinct З.КодТовара)
     from Заказ З
	  inner join Клиент К on З.КодКлиента = К.КодКлиента
	  inner join Регион Р on К.КодРегиона = Р.КодРегиона
	  inner join Товар Т on З.КодТовара = Т.КодТовара
	  inner join Валюта В on Т.КодВалюты = В.КодВалюты
     where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала and 'BYR' = В.КодВалюты
    end
go

declare @ЧислоТоваров int
exec pr_Товар_СтранаВалютаИнтервал 'Россия', 'USD', "2019-03-10", "2019-05-10", @ЧислоТоваров output
select @ЧислоТоваров as [Число Товаров]
exec pr_Товар_СтранаВалютаИнтервал NULL, NULL, "2019-03-10", "2019-05-10", @ЧислоТоваров output
select @ЧислоТоваров as [Число Товаров]
go

-- 4 функция типа Scalar
create function fn_getЧислоДней_вМесяце 
 (@Дата datetime)
returns int
begin
 declare @ЧислоДней int
 select @ЧислоДней = day(EOMONTH(@Дата))
 return @ЧислоДней
end
go

SET DATEFORMAT DMY
select dbo.fn_getЧислоДней_вМесяце('05-06-2000') as [Число дней в месяце]
select dbo.fn_getЧислоДней_вМесяце('07-08-2000') as [Число дней в месяце]
select dbo.fn_getЧислоДней_вМесяце('04-09-2021') as [Число дней в месяце]
go

-- 5 функция
create function fn_getФИО_вФормате 
 (@ФИО varchar(100), @Формат int)
returns varchar(100)
begin
 declare @ФорматированноеФИО varchar(100)
 select @ФорматированноеФИО = 
  case @Формат
  when 1 then lower(@ФИО)
  when 2 then upper(@ФИО)
  when 3 then upper(substring(parsename(replace(@ФИО, ' ', '.'), 3), 1, 1)) + lower(substring(parsename(replace(@ФИО, ' ', '.'), 3), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@ФИО, ' ', '.'), 2), 1, 1)) + lower(substring(parsename(replace(@ФИО, ' ', '.'), 2), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@ФИО, ' ', '.'), 1), 1, 1)) + lower(substring(parsename(replace(@ФИО, ' ', '.'), 1), 2, 100))
   
  when 4 then upper(substring(parsename(replace(@ФИО, ' ', '.'), 3), 1, 1)) + lower(substring(parsename(replace(@ФИО, ' ', '.'), 3), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@ФИО, ' ', '.'), 2), 1, 1)) + '. '+
	 upper(substring(parsename(replace(@ФИО, ' ', '.'), 1), 1, 1)) + '.'
  end
 return @ФорматированноеФИО
end
go

select dbo.fn_getФИО_вФормате('иванов иван иванович', 1) as [Форматированное полное имя]
select dbo.fn_getФИО_вФормате('иванов иван иванович', 2) as [Форматированное полное имя]
select dbo.fn_getФИО_вФормате('иванов иван иванович', 3) as [Форматированное полное имя]
select dbo.fn_getФИО_вФормате('иванов иван иванович', 4) as [Форматированное полное имя]
go

-- 6 функция
create function fn_getGroup_НаименованиеВалюта 
 (@НачалоИнтервала datetime, @КонецИнтервала datetime)
returns table
as return
 select Т.Наименование as [Наименование товара], В.ИмяВалюты as [Имя валюты], sum(З.Количество) as [Заказанное кол-во], max(Т.Цена) * sum(З.Количество) as [Стоимость в валюте], max(Т.Цена) * max(В.КурсВалюты) * sum(З.Количество) as [Стоимость в национальной валюте] 
 from Заказ З
  inner join Товар Т on З.КодТовара = Т.КодТовара
  inner join Валюта В on Т.КодВалюты = В.КодВалюты
 where З.ДатаЗаказа <= @КонецИнтервала and З.ДатаЗаказа >= @НачалоИнтервала
 group by Т.Наименование, В.ИмяВалюты
go

select * from fn_getGroup_НаименованиеВалюта('2019-03-10', '2019-05-10')
go

-- 7 функция
create function fn_getTable_СтоимостьНВ 
 ()
returns @Таблица table(
 Номер int primary key identity(1,1),
 ДатаЗаказа datetime,
 ИмяКлиента varchar(40),
 Наименование varchar(50),
 Количество int,
 ЦенаНВ money,
 СтоиомостьНВ money)
begin
  insert @Таблица(ДатаЗаказа, ИмяКлиента, Наименование, Количество, ЦенаНВ, СтоиомостьНВ)
   select З.ДатаЗаказа, К.ИмяКлиента, Т.Наименование, З.Количество, В.КурсВалюты * Т.Цена, В.КурсВалюты * Т.Цена * З.Количество
   from Заказ З
    inner join Клиент К on З.КодКлиента = К.КодКлиента
    inner join Товар Т on З.КодТовара = Т.КодТовара
	inner join Валюта В on Т.КодВалюты = В.КодВалюты

  declare @AveragePrice int
  select @AveragePrice = AVG(СтоиомостьНВ)
   from @Таблица

  delete from @Таблица
   where СтоиомостьНВ < @AveragePrice
  return
end
go

select * from fn_getTable_СтоимостьНВ()
go

