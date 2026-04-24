-- Für welche Prüfungsformate hat ein Prüfer ein Lizenz?
SELECT
	d.FirstName,
	d.LastName,
	d.TuqReference,

	b.Code,
	b.Name,
	FORMAT(b.LicenseStartDate, 'dd.MM.yyyy') AS Start,
	FORMAT(b.LicenseEndDate, 'dd.MM.yyyy') AS Ende,

	c.Number AS 'Prüfungsformat',
	c.LevelText,
	c.Title,
	c.Language

FROM
	AssessmentPersonLicenseExamSubject AS a -- Zuordnungstabelle - Hier steht welche Prüfungsformat zu welche Liznez gehört

LEFT JOIN
	AssessmentPersonLicenses AS b -- Hier steht welche Prüfer welche Lizenzen hat.
	ON a.AssessmentPersonLicensesId = b.AssessmentPersonLicenseId

LEFT JOIN
	ExamSubjects AS c -- Prüfungsformat Infos
	ON a.ExamSubjectId = c.ExamSubjectId

LEFT JOIN
	AssessmentPersons AS d -- Prüferdaten - Name, Tuqref
	ON d.AssessmentPersonId = b.AssessmentPersonId

WHERE
	d.TuqReference IN (8002120, 8002121, 8002122)
	AND c.Number >= 7000
	AND c.Number <= 8000

ORDER BY c.Number