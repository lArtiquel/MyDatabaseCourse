/*
CREATE DATABASE lexus -- database creation with files 
 ON PRIMARY 
	( NAME = Склад_data, 
	FILENAME = 'D:\Artyom\Учеба\DB\Ekzamen\lex.mdf', 
	SIZE = 5MB, 
	MAXSIZE = 75MB, 
	FILEGROWTH = 3MB ), 
FILEGROUP Secondary 
	( NAME = Склад2_data, 
	FILENAME = 'D:\Artyom\Учеба\DB\Ekzamen\lex1.ndf', 
	SIZE = 3MB, 
	MAXSIZE = 50MB, 
	FILEGROWTH = 15% ), 
	( NAME = Склад3_data, 
	FILENAME = 'D:\Artyom\Учеба\DB\Ekzamen\lex2.ndf', 
	SIZE = 4MB, 
	FILEGROWTH = 4MB ) 
LOG ON 
	( NAME = Склад_log, 
	FILENAME = 'D:\Artyom\Учеба\DB\Ekzamen\lex3.ldf', 
	SIZE = 1MB, 
	MAXSIZE = 10MB, 
	FILEGROWTH = 20% ), 
	( NAME = Склад2_log, 
	FILENAME = 'D:\Artyom\Учеба\DB\Ekzamen\lex4.ldf', 
	SIZE = 512KB, 
	MAXSIZE = 15MB, 
	FILEGROWTH = 10% ) 
GO 

USE lexus
GO

Create Table [Group] ( 
	NGroup INT PRIMARY KEY, 
	Faculty VARCHAR(20) NOT NULL,
) 

Create Table Student ( 
	NZach INT PRIMARY KEY, 
	LastName VARCHAR(20) NOT NULL, 
	Birth DATETIME NULL,
	DateOfEntering DATETIME NULL,
	NGroup INT NOT NULL, 

	CONSTRAINT FK_Group_Student FOREIGN KEY (NGroup) 
	REFERENCES [Group] ON UPDATE NO ACTION ON DELETE NO ACTION
) 

Create Table Exams ( 
	Semestr INT NOT NULL,
	[Subject] Varchar(20) NOT NULL, 
	NZach INT NOT NULL, 
	Mark Int NOT NULL, 
	PRIMARY KEY(Semestr, [Subject], NZach), 

	CONSTRAINT FK_Exams_Student FOREIGN KEY (NZach) 
	REFERENCES Student ON UPDATE CASCADE ON DELETE CASCADE 
) 
GO


INSERT INTO [Group] VALUES (710102, 'FCAD')
INSERT INTO [Group] VALUES (703305, 'IEF')
INSERT INTO [Group] VALUES (703306, 'IEF')
INSERT INTO [Group] VALUES (730102, 'FRE')
INSERT INTO [Group] VALUES (720204, 'KSIS')


set dateformat dmy
INSERT INTO Student VALUES (1, 'Tsvirko', NULL, NULL, 710102)
INSERT INTO Student VALUES (2, 'Grib', NULL, NULL, 710102)
INSERT INTO Student VALUES (3, 'ZHIBA', NULL, NULL, 710102)

INSERT INTO Student VALUES (4, 'Zhendos', NULL, NULL, 703305)
INSERT INTO Student VALUES (5, 'Katya', NULL, NULL, 703305)
INSERT INTO Student VALUES (6, 'Nastya', NULL, NULL, 703305)

INSERT INTO Student VALUES (7, 'Dido', NULL, NULL, 730102)
INSERT INTO Student VALUES (8, 'Vido', NULL, NULL, 730102)
INSERT INTO Student VALUES (9, 'Mido', NULL, NULL, 730102)

INSERT INTO Student VALUES (10, 'Zadrot', NULL, NULL, 720204)
INSERT INTO Student VALUES (11, 'Poseur', NULL, NULL, 720204)
INSERT INTO Student VALUES (12, 'BlowjobExpert', NULL, NULL, 720204)
INSERT INTO Student VALUES (13, 'Drochila', NULL, NULL, 720204)

INSERT INTO Student VALUES (14, 'Mashka', NULL, NULL, 703306)
INSERT INTO Student VALUES (15, 'Lizzy', NULL, NULL, 703306)
INSERT INTO Student VALUES (16, 'Anne', NULL, NULL, 703306)
INSERT INTO Student VALUES (17, 'Bonnie', NULL, NULL, 703306)



INSERT INTO Exams VALUES (1, 'OOP', 1, 10)
INSERT INTO Exams VALUES (2, 'OOP', 1, 9)
INSERT INTO Exams VALUES (1, 'OOP', 2, 8)
INSERT INTO Exams VALUES (2, 'OOP', 2, 4)
INSERT INTO Exams VALUES (1, 'OOP', 3, 5)
INSERT INTO Exams VALUES (2, 'OOP', 3, 5)
INSERT INTO Exams VALUES (1, 'Matan', 1, 9)
INSERT INTO Exams VALUES (2, 'Matan', 1, 9)
INSERT INTO Exams VALUES (1, 'Matan', 2, 7)
INSERT INTO Exams VALUES (2, 'Matan', 2, 6)
INSERT INTO Exams VALUES (1, 'Matan', 3, 4)
INSERT INTO Exams VALUES (2, 'Matan', 3, 4)

INSERT INTO Exams VALUES (1, 'OOP', 4, 10)
INSERT INTO Exams VALUES (2, 'OOP', 4, 9)
INSERT INTO Exams VALUES (1, 'OOP', 5, 8)
INSERT INTO Exams VALUES (2, 'OOP', 5, 4)
INSERT INTO Exams VALUES (1, 'OOP', 6, 5)
INSERT INTO Exams VALUES (2, 'OOP', 6, 5)
INSERT INTO Exams VALUES (1, 'Matan', 5, 9)
INSERT INTO Exams VALUES (2, 'Matan', 5, 9)
INSERT INTO Exams VALUES (1, 'Matan', 4, 7)
INSERT INTO Exams VALUES (2, 'Matan', 4, 6)
INSERT INTO Exams VALUES (1, 'Matan', 6, 4)
INSERT INTO Exams VALUES (2, 'Matan', 6, 4)

INSERT INTO Exams VALUES (1, 'OOP', 7, 10)
INSERT INTO Exams VALUES (2, 'OOP', 7, 9)
INSERT INTO Exams VALUES (1, 'OOP', 8, 8)
INSERT INTO Exams VALUES (2, 'OOP', 8, 4)
INSERT INTO Exams VALUES (1, 'OOP', 9, 5)
INSERT INTO Exams VALUES (2, 'OOP', 9, 5)
INSERT INTO Exams VALUES (1, 'Matan', 8, 9)
INSERT INTO Exams VALUES (2, 'Matan', 8, 9)
INSERT INTO Exams VALUES (1, 'Matan', 7, 7)
INSERT INTO Exams VALUES (2, 'Matan', 7, 6)
INSERT INTO Exams VALUES (1, 'Matan', 9, 4)
INSERT INTO Exams VALUES (2, 'Matan', 9, 4)

INSERT INTO Exams VALUES (1, 'OOP', 10, 10)
INSERT INTO Exams VALUES (2, 'OOP', 10, 9)
INSERT INTO Exams VALUES (1, 'OOP', 11, 8)
INSERT INTO Exams VALUES (2, 'OOP', 11, 4)
INSERT INTO Exams VALUES (1, 'OOP', 12, 5)
INSERT INTO Exams VALUES (2, 'OOP', 12, 5)
INSERT INTO Exams VALUES (1, 'Matan', 10, 9)
INSERT INTO Exams VALUES (2, 'Matan', 10, 9)
INSERT INTO Exams VALUES (1, 'Matan', 11, 7)
INSERT INTO Exams VALUES (2, 'Matan', 11, 6)
INSERT INTO Exams VALUES (1, 'Matan', 12, 4)
INSERT INTO Exams VALUES (2, 'Matan', 12, 4)
INSERT INTO Exams VALUES (1, 'OOP', 13, 5)
INSERT INTO Exams VALUES (2, 'OOP', 13, 5)
INSERT INTO Exams VALUES (1, 'Matan', 13, 6)
INSERT INTO Exams VALUES (2, 'Matan', 13, 6)

INSERT INTO Exams VALUES (1, 'OOP', 14, 9)
INSERT INTO Exams VALUES (2, 'OOP', 14, 9)
INSERT INTO Exams VALUES (1, 'OOP', 15, 8)
INSERT INTO Exams VALUES (2, 'OOP', 15, 8)
INSERT INTO Exams VALUES (1, 'OOP', 16, 4)
INSERT INTO Exams VALUES (2, 'OOP', 16, 4)
INSERT INTO Exams VALUES (1, 'Matan', 14, 9)
INSERT INTO Exams VALUES (2, 'Matan', 14, 9)
INSERT INTO Exams VALUES (1, 'Matan', 15, 8)
INSERT INTO Exams VALUES (2, 'Matan', 15, 8)
INSERT INTO Exams VALUES (1, 'Matan', 16, 4)
INSERT INTO Exams VALUES (2, 'Matan', 16, 4)
INSERT INTO Exams VALUES (1, 'OOP', 17, 6)
INSERT INTO Exams VALUES (2, 'OOP', 17, 6)
INSERT INTO Exams VALUES (1, 'Matan', 17, 5)
INSERT INTO Exams VALUES (2, 'Matan', 17, 5)
GO
*/


USE lexus
-- working query of Taska1.png
-- num of students, MIN, AVG, MAX
/*
SELECT S.NGroup, COUNT(DISTINCT S.NZach) AS NumberOfStudentsOnIEF,
		MIN(E.Mark) AS MinMarkOnOOP1Sem,
		AVG(E.Mark) AS AVGMarkOnOOP1Sem,
		MAX(E.Mark) AS MAXMarkOnOOP1Sem
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE G.Faculty = 'IEF' AND E.[Subject] = 'OOP' AND E.Semestr = 1 AND E.Mark >= 4
GROUP BY S.NGroup
HAVING AVG(E.Mark) > (SELECT AVG(E.Mark) FROM Exams AS E)
ORDER BY AVG(E.Mark) DESC
*/
/*
-- to all groups Applicable
SELECT S.NGroup,
		MIN(E.Mark) AS MinMarkOnOOP1Sem,
		AVG(E.Mark) AS AVGMarkOnOOP1Sem,
		MAX(E.Mark) AS MAXMarkOnOOP1Sem
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE E.[Subject] = 'OOP' AND E.Semestr = 1 AND E.Mark >= 4
GROUP BY S.NGroup
HAVING AVG(E.Mark) > (SELECT AVG(E.Mark) FROM Exams AS E)
*/

-- working query of Taska2.png
/*
SELECT S.NGroup, COUNT(DISTINCT S.NZach) AS NumberOFStudsInGroups
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE (E.[Subject] = 'OOP' AND E.Semestr = 1) AND (G.Faculty = 'IEF' OR G.Faculty = 'FRE' OR G.Faculty = 'FCAD') AND (E.Mark BETWEEN 8 AND 10)
GROUP BY S.NGroup
HAVING COUNT(S.NGroup) > 2
ORDER BY S.NZach DESC
*/

-- working query of Taska3.png
/*
SELECT S.NGroup,
		AVG(E.Mark) AS AVGMarkOnGroupNotCountingDebiksWithMarksLessThen
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE (E.[Subject] = 'OOP' AND E.Semestr = 1 AND E.Mark > 5) AND (G.Faculty = 'IEF' OR G.Faculty = 'FCAD')
GROUP BY S.NGroup
HAVING COUNT(S.NGroup) > 1 AND AVG(E.Mark) > 5
-- or
SELECT S.NGroup, AVG(E.Mark) AS AVGMarkOnGroup
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE (E.[Subject] = 'OOP' AND E.Semestr = 1) AND (G.Faculty = 'IEF' OR G.Faculty = 'FCAD')
GROUP BY S.NGroup
HAVING AVG(E.Mark) > 7
*/

/*
-- working Taska4.png
SELECT S.LastName, S.NZach, E.Mark
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
--WHERE G.NGroup = '710102'
GROUP BY S.LastName, S.NZach, E.Mark
HAVING E.Mark = 5
*/

/*
-- working Taska5.png
-- need to add to test query
/*
INSERT INTO [Group] VALUES (710801, 'FCAD')

INSERT INTO Student VALUES (18, 'MichalapLOH', NULL, NULL, 710801)
INSERT INTO Student VALUES (19, 'PopovLOH', NULL, NULL, 710801)

INSERT INTO Exams VALUES (1, 'Matan', 18, 3)
INSERT INTO Exams VALUES (1, 'Matan', 19, 3)
INSERT INTO Exams VALUES (2, 'Matan', 18, 2)
INSERT INTO Exams VALUES (2, 'Matan', 19, 1)
*/

SELECT S.LastName, S.NZach, E.Mark, E.[Subject]
FROM Student AS S
	INNER JOIN [Group] AS G ON S.NGroup = G.NGroup
	INNER JOIN [Exams] AS E ON S.NZach = E.NZach
WHERE G.NGroup = '710102' OR G.NGroup = '703305' OR G.NGroup = '703306' OR G.NGroup = '710801'
GROUP BY S.LastName, S.NZach, E.Mark, E.[Subject]
HAVING (E.Mark >= 4 AND E.[Subject] = 'OOP') OR (E.Mark <= 3 AND E.[Subject] = 'Matan')
*/

