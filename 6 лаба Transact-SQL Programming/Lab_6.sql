use �����_214TSQL
go

-- 1 ���������
create procedure pr_����������������������
 @�������� int,
 @������������� int,
 @��� varchar(50) output,
 @���� int output
 as
 if @������������� = 1 
 begin
	select @��� = �.������������, @���� = SUM(����������)
	from ����� �
		inner join ����� � on �.��������� = �.���������
	where ���������� BETWEEN GetDate() - @�������� AND GetDate()
	group by �.������������
	order by SUM(����������)
 end
 else
 if @������������� = 2
	begin
	select @��� = �.������������, @���� = SUM(����������)
	from ����� �
		inner join ����� � on �.��������� = �.���������
	where ���������� BETWEEN GetDate() - @�������� AND GetDate()
	group by �.������������
	order by SUM(����������) desc
 end
go

declare @��� varchar(50), @���� int
exec pr_���������������������� 20, 1, @��� output, @���� output
select @��� as [������������ ������], @���� as [�����]
exec pr_���������������������� 40, 2, @��� output, @���� output
select @��� as [������������ ������], @���� as [�����]
go

-- 2 ���������
create procedure pr_���������������_��������������
 @������ varchar(20),
 @��������������� datetime,
 @�������������� datetime,
 @������������� int output,
 @���������������� int output
as
 if @������ is not null
  begin
   select @������������� = count(distinct �.����������)
   from ����� �
	inner join ������ � on �.���������� = �.����������
	inner join ������ � on �.���������� = �.����������
   where �.���������� <= @�������������� and �.���������� >= @��������������� and @������ = �.������ 
   select @���������������� = count(distinct �.�������������) 
   from ����� �
    inner join ��������� � on �.������������� = �.�������������
	inner join ������ � on �.���������� = �.����������
   where ���������� <= @�������������� and ���������� >= @��������������� and @������ = �.������
  end
 else
  begin
   select @������������� = count(distinct �.����������)
   from ����� �
    inner join ������ � on �.���������� = �.����������
	inner join ������ � on �.���������� = �.����������
   where �.���������� <= @�������������� and �.���������� >= @���������������
   select @���������������� = count(distinct �.�������������) 
   from ����� �
    inner join ��������� � on �.������������� = �.�������������
	inner join ������ � on �.���������� = �.����������
   where ���������� <= @�������������� and ���������� >= @���������������
  end
go

declare @������������� int, @���������������� int
exec pr_���������������_�������������� '��������', "2019-03-10", "2019-05-10", @������������� output, @���������������� output
select @������������� as [����� ��������], @���������������� as [����� �����������]
exec pr_���������������_�������������� NULL, "2019-03-10", "2019-05-10", @������������� output, @���������������� output
select @������������� as [����� ��������], @���������������� as [����� �����������]
go

-- 3 ���������
create procedure pr_�����_��������������������
@������ varchar(20),
@������ char(3),
@��������������� datetime,
@�������������� datetime,
@������������ int output
as
 if @������ is not null
  if @������ is not null
   begin
    select @������������ = count(distinct �.���������)
    from ����� �
	 inner join ������ � on �.���������� = �.����������
	 inner join ������ � on �.���������� = �.����������
	 inner join ����� � on �.��������� = �.���������
	 inner join ������ � on �.��������� = �.���������
    where �.���������� <= @�������������� and �.���������� >= @��������������� and @������ = �.������ and @������ = �.���������
   end
  else
   begin
    select @������������ = count(distinct �.���������)
    from ����� �
	 inner join ������ � on �.���������� = �.����������
	 inner join ������ � on �.���������� = �.����������
	 inner join ����� � on �.��������� = �.���������
	 inner join ������ � on �.��������� = �.���������
    where �.���������� <= @�������������� and �.���������� >= @��������������� and @������ = �.������ and 'BYR' = �.���������
   end
 else
   if @������ is not null
    begin
	 select @������������ = count(distinct �.���������)
     from ����� �
	  inner join ������ � on �.���������� = �.����������
	  inner join ������ � on �.���������� = �.����������
	  inner join ����� � on �.��������� = �.���������
	  inner join ������ � on �.��������� = �.���������
     where �.���������� <= @�������������� and �.���������� >= @��������������� and @������ = �.���������
    end
   else
    begin
	 select @������������ = count(distinct �.���������)
     from ����� �
	  inner join ������ � on �.���������� = �.����������
	  inner join ������ � on �.���������� = �.����������
	  inner join ����� � on �.��������� = �.���������
	  inner join ������ � on �.��������� = �.���������
     where �.���������� <= @�������������� and �.���������� >= @��������������� and 'BYR' = �.���������
    end
go

declare @������������ int
exec pr_�����_�������������������� '������', 'USD', "2019-03-10", "2019-05-10", @������������ output
select @������������ as [����� �������]
exec pr_�����_�������������������� NULL, NULL, "2019-03-10", "2019-05-10", @������������ output
select @������������ as [����� �������]
go

-- 4 ������� ���� Scalar
create function fn_get���������_������� 
 (@���� datetime)
returns int
begin
 declare @��������� int
 select @��������� = day(EOMONTH(@����))
 return @���������
end
go

SET DATEFORMAT DMY
select dbo.fn_get���������_�������('05-06-2000') as [����� ���� � ������]
select dbo.fn_get���������_�������('07-08-2000') as [����� ���� � ������]
select dbo.fn_get���������_�������('04-09-2021') as [����� ���� � ������]
go

-- 5 �������
create function fn_get���_�������� 
 (@��� varchar(100), @������ int)
returns varchar(100)
begin
 declare @������������������ varchar(100)
 select @������������������ = 
  case @������
  when 1 then lower(@���)
  when 2 then upper(@���)
  when 3 then upper(substring(parsename(replace(@���, ' ', '.'), 3), 1, 1)) + lower(substring(parsename(replace(@���, ' ', '.'), 3), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@���, ' ', '.'), 2), 1, 1)) + lower(substring(parsename(replace(@���, ' ', '.'), 2), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@���, ' ', '.'), 1), 1, 1)) + lower(substring(parsename(replace(@���, ' ', '.'), 1), 2, 100))
   
  when 4 then upper(substring(parsename(replace(@���, ' ', '.'), 3), 1, 1)) + lower(substring(parsename(replace(@���, ' ', '.'), 3), 2, 100)) + ' '+
	 upper(substring(parsename(replace(@���, ' ', '.'), 2), 1, 1)) + '. '+
	 upper(substring(parsename(replace(@���, ' ', '.'), 1), 1, 1)) + '.'
  end
 return @������������������
end
go

select dbo.fn_get���_��������('������ ���� ��������', 1) as [��������������� ������ ���]
select dbo.fn_get���_��������('������ ���� ��������', 2) as [��������������� ������ ���]
select dbo.fn_get���_��������('������ ���� ��������', 3) as [��������������� ������ ���]
select dbo.fn_get���_��������('������ ���� ��������', 4) as [��������������� ������ ���]
go

-- 6 �������
create function fn_getGroup_������������������ 
 (@��������������� datetime, @�������������� datetime)
returns table
as return
 select �.������������ as [������������ ������], �.��������� as [��� ������], sum(�.����������) as [���������� ���-��], max(�.����) * sum(�.����������) as [��������� � ������], max(�.����) * max(�.����������) * sum(�.����������) as [��������� � ������������ ������] 
 from ����� �
  inner join ����� � on �.��������� = �.���������
  inner join ������ � on �.��������� = �.���������
 where �.���������� <= @�������������� and �.���������� >= @���������������
 group by �.������������, �.���������
go

select * from fn_getGroup_������������������('2019-03-10', '2019-05-10')
go

-- 7 �������
create function fn_getTable_����������� 
 ()
returns @������� table(
 ����� int primary key identity(1,1),
 ���������� datetime,
 ���������� varchar(40),
 ������������ varchar(50),
 ���������� int,
 ������ money,
 ������������ money)
begin
  insert @�������(����������, ����������, ������������, ����������, ������, ������������)
   select �.����������, �.����������, �.������������, �.����������, �.���������� * �.����, �.���������� * �.���� * �.����������
   from ����� �
    inner join ������ � on �.���������� = �.����������
    inner join ����� � on �.��������� = �.���������
	inner join ������ � on �.��������� = �.���������

  declare @AveragePrice int
  select @AveragePrice = AVG(������������)
   from @�������

  delete from @�������
   where ������������ < @AveragePrice
  return
end
go

select * from fn_getTable_�����������()
go

