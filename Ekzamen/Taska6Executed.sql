use lexus

SELECT S.NZach, S.LastName, E.Mark

FROM [Group] AS G
	inner join Student AS S ON G.NGroup = S.NGroup
	inner join Exams AS E ON S.NZach = E.NZach

WHERE G.Faculty = 'IEF' AND E.Semestr = 1 AND E.[Subject] = 'OOP' AND E.Mark > (SELECT AVG(E.Mark)
										FROM [Group] AS G
										inner join Student AS S ON G.NGroup = S.NGroup
										inner join Exams AS E ON S.NZach = E.NZach
										WHERE (G.Faculty = 'FCAD' OR G.Faculty = 'FITY') AND (E.Semestr = 1 AND E.[Subject] = 'OOP'))

ORDER BY E.Mark DESC, S.LastName ASC


SELECT AVG(E.Mark) AS AVGOnFCADAndFITY
FROM [Group] AS G
	inner join Student AS S ON G.NGroup = S.NGroup
	inner join Exams AS E ON S.NZach = E.NZach
WHERE (G.Faculty = 'FCAD' OR G.Faculty = 'FITY') AND (E.Semestr = 1 AND E.[Subject] = 'OOP')

