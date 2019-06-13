CREATE DATABASE �����_214TSQL_INDIVIDUAL  -- database creation with files 
 ON PRIMARY                   
   ( NAME = �����_data,       
     FILENAME = 'D:\Artyom\�����\DB\4 ���� Transact-SQL\�����_214TSQL_INDIVIDUAL_data.mdf',
     SIZE = 5MB, 
     MAXSIZE = 75MB,
     FILEGROWTH = 3MB ),
 FILEGROUP Secondary
   ( NAME = �����2_data,
     FILENAME = 'D:\Artyom\�����\DB\4 ���� Transact-SQL\�����_214TSQL_INDIVIDUAL_data2.ndf',
     SIZE = 3MB, 
     MAXSIZE = 50MB,
     FILEGROWTH = 15% ),
   ( NAME = �����3_data,
     FILENAME = 'D:\Artyom\�����\DB\4 ���� Transact-SQL\�����_214TSQL_INDIVIDUAL_data3.ndf',
     SIZE = 4MB, 
     FILEGROWTH = 4MB )
 LOG ON
   ( NAME = �����_log,
     FILENAME = 'D:\Artyom\�����\DB\4 ���� Transact-SQL\�����_214TSQL_INDIVIDUAL_log.ldf',
     SIZE = 1MB,
     MAXSIZE = 10MB,
     FILEGROWTH = 20% ),
   ( NAME = �����2_log,
     FILENAME = 'D:\Artyom\�����\DB\4 ���� Transact-SQL\�����_214TSQL_INDIVIDUAL_log2.ldf',
     SIZE = 512KB,
     MAXSIZE = 15MB,
     FILEGROWTH = 10% )
 GO  

 USE �����_214TSQL_INDIVIDUAL										-- use this database
 GO

 CREATE RULE Logical_rule AS @value IN ('���', '��')	-- create logical rule
 GO

 CREATE DEFAULT Logical_default AS '���'				-- create default value
 GO

 EXEC sp_addtype Logical, 'char(3)', 'NOT NULL'			-- create new type(system type, default value, owner type)
 GO

 EXEC sp_bindrule 'Logical_rule', 'Logical'				-- tie rule with type of data
 GO

 EXEC sp_bindefault 'Logical_default', 'Logical'		-- bind default with type of data
 GO


 /* create tables */
 CREATE TABLE ������ (				/* ������ ������� ������ */
   ����������	INT  PRIMARY KEY,
   ������		VARCHAR(20)  DEFAULT '��������'  NOT NULL,
   �������		VARCHAR(20)  NOT NULL,
   �����		VARCHAR(20)  NOT NULL,
   �����		VARCHAR(50)  NOT NULL,
   �������		CHAR(15)  NULL,
   ����			CHAR(15)  NOT NULL  CONSTRAINT CIX_������2
   UNIQUE		ON Secondary,
   CONSTRAINT	CIX_������  UNIQUE (������, �������, �����, �����)
   ON Secondary
 )

  /* ��������� */
 CREATE TABLE ��������� (			/* ������ ������� ������ */
   �������������	INT  PRIMARY KEY,
   �������������	VARCHAR(40)  NOT NULL,
   �������������	VARCHAR(30)  DEFAULT '����������'  NULL,
   ����������		INT  NULL,
   �������			VARCHAR(MAX)  NULL,
   CONSTRAINT		FK_���������_������  FOREIGN KEY (����������)
   REFERENCES		������  ON UPDATE CASCADE
 )

  /* ������ */
 CREATE TABLE ������ (				/* ������ ������� ������ */
   ����������	 	INT  IDENTITY(1,1)  PRIMARY KEY,
   ����������		VARCHAR(40)  NOT NULL,
   ���������������	VARCHAR(60)  NULL,
   ���������� 		INT  NULL,
   CONSTRAINT		FK_������_������  FOREIGN KEY (����������)
   REFERENCES		������  ON UPDATE CASCADE
 )

  /* ������ */
 CREATE TABLE ������ (				/* ��������� ������� ������ */
   ���������		CHAR(3)  PRIMARY KEY,
   ���������		VARCHAR(30)  NOT NULL,
   ������������� 	NUMERIC(10, 4)  DEFAULT 0.01  NULL
   CHECK (������������� IN (50, 1, 0.01)),
   ����������  		SMALLMONEY  NOT NULL  CHECK (���������� > 0)
 )

  /* ����� */
 CREATE TABLE ����� (				/* ������ ������� ������ */
   ���������		INT  PRIMARY KEY,
   ����������	 	INT  NOT NULL,	
   ����������	 	DATETIME  DEFAULT getdate()  NULL,
   ������������		DATETIME  DEFAULT getdate() + 14  NULL,
   CONSTRAINT  FK_�����_������  FOREIGN KEY (����������)
   REFERENCES  ������  ON UPDATE CASCADE ON DELETE CASCADE
 )

  /* ����� */
 CREATE TABLE ����� (				/* ����� ������� ������ */
   ���������		INT  PRIMARY KEY,
   ������������		VARCHAR(50)  NOT NULL,
   ����������  		CHAR(10)  DEFAULT '�����'  NULL,
   ����				MONEY  NULL  CHECK (���� > 0),
   ���������		CHAR(3)  DEFAULT 'BYR'  NULL,
   ����������		LOGICAL  NOT NULL,
   CONSTRAINT		FK_�����_������  FOREIGN KEY (���������)
   REFERENCES		������  ON UPDATE CASCADE
 )

 CREATE TABLE ������������ (
	���������		INT	NOT NULL,
	���������		INT NOT NULL,
	�������������	INT NOT NULL,
	����������		NUMERIC(12, 3)  NULL  CHECK (���������� > 0),
	CONSTRAINT FK_������������_����� FOREIGN KEY (���������)
	REFERENCES		�����  ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_������������_����� FOREIGN KEY (���������)
	REFERENCES		�����  ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_������������_��������� FOREIGN KEY (�������������)
	REFERENCES		��������� ON UPDATE NO ACTION ON DELETE NO ACTION,
  )

 GO
 

 /* create unique indexes */
 CREATE UNIQUE INDEX  UIX_���������  ON ��������� (�������������)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_������  ON ������ (����������)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_������  ON ������ (���������)
   ON Secondary
 CREATE UNIQUE INDEX  UIX_�����  ON ����� (������������)
   ON Secondary
 CREATE INDEX  IX_������  ON ������ (������, �����)  
   ON Secondary
 CREATE INDEX  IX_�����  ON ����� (����������, ������������)
   ON Secondary
 CREATE INDEX  IX_�����  ON ����� (����������)  
   ON Secondary
 GO


 /* insert data into tables */

 /* inser Region data */
 INSERT INTO ������ 
 VALUES (101, '������', '����������', '�������', '��.����, 15',
   '387-23-04', '387-23-05')

 INSERT INTO ������ (����������, �������, �����, �����, ����)
 VALUES (201, '', '�����', '��.������, 9', '278-83-88')	

 INSERT INTO ������ (����������, �������, �����, �����, ����)
 VALUES (202, '�������', '�������', '��.������, 11', '48-37-92')

 INSERT INTO ������ (����������, �������, �����, �����, �������,
   ����)
 VALUES (203, '', '�����', '��.������, 24', '269-13-76',
   '269-13-77')	

 INSERT INTO ������ (����������, �������, �����, �����, ����)
 VALUES (204, '���������', '������', '��.������, 6', '48-24-12')

INSERT INTO ������ 
 VALUES (301, '�������', '��������', '������', '��.������, 24',
   NULL, '46-49-16')	
 GO

 -- insert �����������
INSERT INTO ��������� (�������������, �������������, ����������)
 VALUES (123, '��� ����������', 101)	
  
INSERT INTO ��������� (�������������, �������������, ����������)
 VALUES (124, 'Vasiliy & co', 201)
  
INSERT INTO ��������� (�������������, �������������, ����������)
 VALUES (125, '������', 202)  

INSERT INTO ��������� (�������������, �������������, ����������)
 VALUES (257, '�������', 301)  

INSERT INTO ���������
VALUES (567, '�� ��������', '�� ����� ��������', 203,
   '���������� ���������')	
GO

-- ��������� ��������
INSERT INTO ������
 VALUES ('�� ������', '�������� ��������� ��������', 202)
  
INSERT INTO ������
 VALUES ('��"����"', '������������ ����', 201)

INSERT INTO ������
 VALUES ('�� �������', '���������� ������ ��������', 203)

INSERT INTO ������
 VALUES ('�� ������', '������� ���� ����������', 204)

INSERT INTO ������ (����������, ���������������)
 VALUES ('�� �����', '������ �������� �����������')
 GO

 -- ��������� ������
INSERT INTO ������
 VALUES ('BYR', '����������� �����', 1, 1)

INSERT INTO ������ (���������, ���������, ����������)
 VALUES ('RUR', '���������� �����', 276)

INSERT INTO ������ (���������, ���������, ����������)
 VALUES ('USD', '������� ���', 9160)

INSERT INTO ������ (���������, ���������, ����������)
 VALUES ('EUR', '����', 12450)
GO

-- ��������� ������
INSERT INTO �����
 VALUES (111, '������� 21 ����', '�����', 320, 'USD', '���')
 
INSERT INTO �����
 VALUES (112, '����� 6 ����', '�����', 350, 'USD', '���')

INSERT INTO �����
 VALUES (113, '����������� "��������"', '�����', 300, 'EUR', '���')

INSERT INTO �����
 VALUES (114, '����� "� ���������"', '�����', 3, 'BYR', '���')

INSERT INTO ����� (���������, ������������, ����, ����������)
 VALUES (115, '��������� HDD 120GB', 285000, '��')
GO

-- ��������� ������
INSERT INTO �����		/* ��� ����� �������� ��� 2-��, ��� � 4-�� ������� */
 VALUES (1, 1, '05.04.2019', '06.07.2019')   

INSERT INTO �����		
 VALUES (2, 2, '04.04.2019', '06.07.2019') 
 
INSERT INTO �����		
 VALUES (3, 3, '03.04.2019', '06.07.2019') 

INSERT INTO �����		
 VALUES (4, 4, '02.04.2019', '06.07.2019') 

INSERT INTO �����		
 VALUES (5, 5, '01.04.2019', '06.07.2019') 

INSERT INTO �����		
 VALUES (6, 1, '06.03.2019', '06.07.2019')
 
INSERT INTO �����		
 VALUES (7, 2, '06.02.2019', '06.07.2019') 

INSERT INTO �����		
 VALUES (8, 3, '06.01.2019', '06.07.2019') 

INSERT INTO �����		
 VALUES (9, 4, '06.11.2019', '06.07.2019') 

INSERT INTO �����
 VALUES (10, 5, '06.09.2019', '06.07.2019')
 GO

SET DATEFORMAT dmy		/* ������ ��������� ������ ���� ����.�����.���, �.�. 
                           �� ��������� ���������� ������ ���.�����.���� */
INSERT INTO ������������
 VALUES (1, 111, 123, 2)

INSERT INTO ������������
 VALUES (2, 113, 123, 2)

INSERT INTO ������������
 VALUES (3, 112, 123, 2)

INSERT INTO ������������
 VALUES (4, 114, 123, 2)

INSERT INTO ������������
 VALUES (5, 115, 123, 2)

INSERT INTO ������������
 VALUES (6, 111, 123, 2)

INSERT INTO ������������
 VALUES (7, 112, 123, 2)

INSERT INTO ������������
 VALUES (8, 113, 123, 2)

INSERT INTO ������������
 VALUES (9, 114, 123, 2)

INSERT INTO ������������
 VALUES (10, 115, 123, 2)

INSERT INTO ������������
 VALUES (1, 111, 123, 2)

INSERT INTO ������������
 VALUES (2, 112, 123, 2)
 GO