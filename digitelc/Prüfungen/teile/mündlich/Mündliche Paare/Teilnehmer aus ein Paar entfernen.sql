-- Teilnehmer aus eine Mündliche Paar löschen
-- Achtung: Danach ist der Teilnehmer weg und kann über
-- die Oberfläche nicht zu einer anderen Gruppe hinzugefügt werden.
-- Man muss über die Datenbank ihm neue Aufgaben geben und ihn zu einer Gruppe hinzufügen.

DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = '1234503';


-- Testen wenn ich löschen werde
SELECT DISTINCT op.PairName, p.ParticipantNumber, p.FirstName, p.LastName

-- Erst die zugewiesenen Aufgaben löschen - Abhängige Datensätze
-- DELETE ope

-- Dann den Teilnehmer aus einer Gruppe entfernen
-- DELETE opp

FROM
	Examinations e -- Prüfungen

INNER JOIN
	ExaminationParts ep --  Prüfungsteile
	ON ep.ExaminationId = e.ExaminationId

INNER JOIN
	ExaminationGroups eg -- Gruppen innerhalb Prüfungsparts
	ON eg.ExaminationPartId = ep.ExaminationPartId

INNER JOIN
	ExaminationGroupParticipants egp -- Zuordnungstabelle Gruppe und Prüfungsteilnehmer die zu dieser Gruppe gehören
	ON egp.ExaminationGroupId = eg.ExaminationGroupId

INNER JOIN
	OralPairs op -- Mündliche Paare
    ON op.ExaminationGroupId = egp.ExaminationGroupId

INNER JOIN
	OralPairParticipants opp -- Zuordnungstabelle - Welche Teilnehmer gehört zu eine Paar.
    ON opp.OralPairId = op.OralPairId

INNER JOIN
	Participants p -- Teilnehmer die zu ein Paar gehört
	ON p.ParticipantId = opp.ParticipantId

LEFT JOIN
	OralPairExercises ope -- Zuordnung von Aufgaben an Teilnehmer
    ON ope.OralPairParticipantId = opp.OralPairParticipantId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündlich