use �����_004
go

create trigger tr_Set_������������
on �����
after insert, update
as 
 begin
  declare @���� int, @���� char(3)
  select @���� = �����.��������� 
  from inserted
   inner join ����� on inserted.��������� = �����.���������
  select @���� =
  case 
  when @���� = 'BYR' then 3
  when @���� ='RUB' then 7
  when @���� = 'USD' then 10
  when @���� ='EUR' then 10
  else 14
  end
  update �����
  set ������������ = �����.���������� + @����
  from �����
	inner join inserted on �����.��������� = inserted.���������
 end
go

insert into �����(����������, ���������, ����������, �������������)
values (2, 222, 80, 123)
go

CREATE TABLE ������ (
   ���������		INT  PRIMARY KEY,
   ������������	VARCHAR(50)  NOT NULL,
   �������������	NUMERIC(12, 3)  NULL,
   CONSTRAINT  FK_������_�����  FOREIGN KEY (���������)
     REFERENCES  �����  ON UPDATE CASCADE
 )
go

alter trigger tr_���_�����������������
on �����
after update, insert, delete
as
 if UPDATE(����������)
  begin
    declare @���� int, @������ int
    select @���� = ���������
    from inserted
    select @������ = sum(����������)
    from �����
    where ��������� = @����
    group by ���������
    update ������
    set ������������� = @������
    where ��������� = @����
  end
 if (exists(select * from inserted) and not exists(select * from deleted))
  begin
   declare @���� int, @������ int
   select @���� = ���������
   from inserted
   if not exists(select ��������� from ������ where ��������� = @����)
    begin
	 insert into ������
	 select ���������, ������������, 0
	 from �����
     where ��������� = @����
	end
   select @������ = sum(����������)
   from ����� 
   where ��������� = @����
   group by ���������
   update ������
   set ������������� = @������
   where ��������� = @����
  end
 if (not exists(select * from inserted) and exists(select * from deleted))
  begin
   declare @���� int, @������ int
   select @���� = ���������
   from deleted
   if not exists(select ��������� from ����� where ��������� = @����)
    begin
	 delete from ������
	 where ��������� = @����
	end
   else
    begin
	 select @���� = ���������
     from deleted
	 select @������ = sum(����������)
     from �����
     where ��������� = @����
     group by ���������
     update ������
     set ������������� = @������
     where ��������� = @����
	end
  end
go

insert into �����(����������, ���������, ����������, �������������)
values (2, 222, 80, 123)
go

--�������������� �������
alter trigger tr_���_�����������������
on �����
after update, insert, delete
as
 begin
  truncate table ������
  insert into ������
  select max(�.���������), max(�.������������), sum(�.����������)
  from ����� �
   inner join ����� � on �.��������� = �.���������
  group by �.���������
 end 
go

insert into �����(����������, ���������, ����������, �������������)
values (2, 222, 80, 123)
go

alter procedure pr_���������_�������������� 
@��������� char(3), 
@��������������� datetime, 
@�������������� datetime,
@��������� money output
as
 IF @��������������� IS NULL
  SET @��������������� = getdate() - 365
 IF @�������������� IS NULL 
  SET @�������������� = getdate()
 SET @��������� = 0
 DECLARE @��������������� MONEY, @������ MONEY
 select @������ = ����������
 from ������
 where @��������� = ���������
 DECLARE Curs CURSOR LOCAL STATIC
   FOR SELECT �.���������� * �.���� * �.���������� / @������
     FROM ����� �
       INNER JOIN ����� � ON �.��������� = �.���������
       INNER JOIN ������ � ON �.��������� = �.���������
     WHERE �.���������� BETWEEN @��������������� AND
       @��������������      
 OPEN Curs
 FETCH FIRST FROM Curs INTO @���������������
 WHILE @@FETCH_STATUS = 0
  BEGIN
   SET @��������� = @��������� + @���������������
   FETCH NEXT FROM Curs INTO @���������������
  END
 CLOSE Curs
 DEALLOCATE Curs
go

DECLARE @Cost MONEY
EXEC pr_���������_�������������� 'USD', NULL, NULL, @Cost OUTPUT
SELECT @Cost AS [��������� ������� � USD]
EXEC pr_���������_�������������� 'BYR', NULL, NULL, @Cost OUTPUT
SELECT @Cost AS [��������� ������� � ��]
go

INSERT INTO ������ 
 VALUES (102, '������', '', '������', '��.��������, 50', 
   '339-62- 10', '(095) 339-62-11')
 INSERT INTO ������ 
 VALUES (401, '�����', '', '�������', '��.��������, 19', NULL,
   '(055) 33-27-75')	
 GO

declare @������� table(
 ������ varchar(20) primary key,
 ������������� int,
 ���������������� int
 )
 insert into @�������(������)
  select max(������)
  from ������
  group by ������
  declare @������ int, @������ int, @��� varchar(20), @��������������� datetime, @�������������� datetime
  select @��������������� = '2019-03-10', @�������������� = '2019-05-31'
  declare Curs cursor local static
   for select ������
     FROM @�������
  open Curs
  fetch first from Curs into @���
  while @@FETCH_STATUS = 0
   begin
    exec pr_���������������_�������������� @���, @���������������, @��������������, @������ output, @������ output
    update @�������
    set ������������� = @������, ���������������� = @������
    where ������ = @���
    fetch next from Curs into @���
   end
 close Curs
 deallocate Curs
 select * from @�������
 go

 create table �������� (
  ����� int primary key identity(1, 1),
  ��������� datetime,
  ������������ nvarchar(128),
  �������� varchar(10),
  ���������� int
 )
 go

 create trigger tr_���_���
 on �����
 after insert, delete, update
 as
 begin
 declare @date datetime, @user nvarchar(128), @act varchar(10), @num int
 select @date = getdate(), @user = CURRENT_USER
  if (exists(select * from inserted) and exists(select * from deleted))
   begin
    select @num = count(*) from inserted
	set @act = '����������'
   end
  if (exists(select * from inserted) and not exists(select * from deleted))
   begin
    select @num = count(*) from inserted
	set @act = '����������'
   end
  if (not exists(select * from inserted) and exists(select * from deleted))
   begin
    select @num = count(*) from deleted
	set @act = '��������'
   end
 insert into ��������
 select @date, @user, @act, @num
 end
 go

 INSERT INTO �����
 VALUES (777, '���', '��', 250, 'USD', '��')
 go

 update �����
 set ���� = 90000
 where ��������� = 333
 update �����
 set ���� = 100000
 where ��������� = 333
 update �����
 set ���� = 250
 where ��������� = 444 or ��������� = 777 
 go

 delete from �����
 where ��������� = 777
 go
 
 ALTER TABLE ����� ADD ��������� MONEY NULL
 ALTER TABLE ����� ADD ����������� MONEY NULL
 GO

create TRIGGER tr_�����_���� 
 ON ����� 
 FOR insert, UPDATE 
 AS
   IF UPDATE(����)
     BEGIN
       DECLARE @��������� INT, @���� MONEY, @������ MONEY
	   DECLARE myCursor CURSOR LOCAL STATIC
       FOR 
         SELECT inserted.���������, inserted.����, 
           inserted.���� * ������.����������
         FROM inserted INNER JOIN ������
           ON inserted.��������� = ������.���������	
		OPEN myCursor
		FETCH FIRST FROM myCursor INTO @���������, @����, @������ 
		WHILE @@FETCH_STATUS = 0
         BEGIN
           UPDATE �����
           SET ��������� = ���������� * @����, 
             ����������� = ���������� * @������
           WHERE ��������� = @���������
           FETCH NEXT FROM myCursor INTO @���������, @����,
             @������
         END
       CLOSE myCursor
       DEALLOCATE myCursor
     END
 GO

 create trigger tr_���_������_���
 on ����� 
 after insert, update
 as
  if update(����������) or (exists(select * from inserted) and not exists(select * from deleted))
   begin
    DECLARE @��������� INT, @���� MONEY, @������ MONEY
	   DECLARE myCursor CURSOR LOCAL STATIC
       FOR 
         SELECT inserted.���������, inserted.���������� * �����.����, 
           inserted.���������� * �����.���� * ������.����������
         FROM inserted 
		  INNER JOIN ����� ON inserted.��������� = �����.���������	
          INNER JOIN ������ ON �����.��������� = ������.���������
		OPEN myCursor
		FETCH FIRST FROM myCursor INTO @���������, @����, @������ 
		WHILE @@FETCH_STATUS = 0
         BEGIN
           UPDATE �����
           SET ��������� = @����, 
             ����������� = @������
           WHERE ��������� = @���������
           FETCH NEXT FROM myCursor INTO @���������, @����, @������
         END
       CLOSE myCursor
       DEALLOCATE myCursor
   end
 go

 create trigger tr_���_������_����
 on ������
 after update
 as
 if update(����������)
 begin
 DECLARE @��������� INT, @���� MONEY, @������ MONEY
 DECLARE myCursor CURSOR LOCAL STATIC
 FOR 
 SELECT �����.���������, �����.����, 
 �����.���� * inserted.����������
 FROM inserted 
 INNER JOIN ����� ON inserted.��������� = �����.���������	
 OPEN myCursor
 FETCH FIRST FROM myCursor INTO @���������, @����, @������
 WHILE @@FETCH_STATUS = 0
 BEGIN
 UPDATE �����
 SET ��������� = ���������� * @����, 
 ����������� = ���������� * @������
 WHERE ��������� = @���������
 FETCH NEXT FROM myCursor INTO @���������, @����, @������
 END
 CLOSE myCursor
 DEALLOCATE myCursor
 end
 go


 update ������
 set ���������� = 12450
 where ��������� = 'USD'
 update ������
 set ���������� = 1
 where ��������� = 'BYR'
 update ������
 set ���������� = 276
 where ��������� = 'RUR'
 update ������
 set ���������� = 9160
 where ��������� = 'EUR'
 


 begin transaction

 insert into �����(����������, ���������, ����������, �������������)
 values(2, 222, 160, 123)
select * from �����

 update �����
 set ���������� = 120
 where ��������� = 62
 
 update ������
 set ���������� = 2.1
 where ��������� = 'USD'
select * from �����
 
 rollback
select * from �����
 go