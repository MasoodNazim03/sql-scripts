-- Welche Aufgaben haben Prüfungsteilnehmer, die zu eine Paar gehören, bekommen?

DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = '1234501,1234502,1234503';


SELECT
	e.ExaminationNumber e,

    -- Mündliche Paare
    op.PairName,

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName,

    -- Hierarchie
    -- OralPairs -> OralPairParticipants -> OralPairExercises
    -- OralPairs - Name, Status usw.
    -- OralPairParticipants - Welche Personen gehören zu einer Paar
    -- OralPairExercises - Welche Aufgabe bekommt welche Participant.
    -- Benutzt OralPairParticipantId-Feld von OralPairParticipants-Tabelle als Fremdschlüssel
    -- um eine Aufgabe einen bestimmten Participant zuzuweisen, weil für jede Participant gibt es eine gesonderte Zeile.

    ed.Description,
    CASE ed.ExaminationDefinitionStatus
        WHEN 1 THEN 'Nicht Aktive - In Bearbeitung'
        WHEN 2 THEN 'Nicht Aktive - Wartet auf Genehmigung'
        WHEN 3 THEN 'Aktive - darf in Prod eingesetzt werden'
        WHEN 4 THEN 'Nicht Aktiv - inactive'
        ELSE 'Unknown'
    END AS 'Prüfungsformat Status',
    edp.MaxDuration AS 'Dauer Mündliche Prüfung', -- Dauer von Schriftliche Prüfung

    -- Exercises
    -- Für jede Prüfungsteil gibt es separate dieser Infos stehen in ExerciseNumber.
    -- ExerciseNumber besteht aus Prüfungsformat, Mündlich oder Schriftlich eins, zwei oder drei.
    -- Und bei Mündliche Prüfung gibt es dann auch nochmal A und B.
    -- Sobald ein Prüfungsteilnehmer A hat sollte der Andere B bekommen.
    -- Sobald eine neue Teilnehmer zu eine Paar hinzugefügt wird, bekommt die Gesamte Paar neue Aufgaben,
    -- nicht nur der neue Teilnehmer.
    -- M1 ist für alle Teilnehmer aus allen Prüfungen gleich.
    -- M2 ist für jede Paar Mitglied unterschiedlich
    -- M3 ist für beide Paar Mitglied gleich
    ex.ExerciseNumber,
    ex.Instructions,
    ex.Text,
    ex.PoolId,
    ex.Version
    , opp.*

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
	Participants p -- Teilnehmer die zu ein Gruppe gehören
	ON p.ParticipantId = egp.ParticipantId

INNER JOIN OralPairParticipants opp -- Zuordnungstabelle - Welche Teilnehmer gehört zu eine Paar.
    ON opp.ParticipantId = p.ParticipantId

INNER JOIN
	OralPairs op -- Mündliche Paare
    ON op.OralPairId  = opp.OralPairId
    AND op.ExaminationGroupId = eg.ExaminationGroupId

INNER JOIN
	OralPairExercises ope -- Zuordnung von Aufgaben an Teilnehmer
    ON ope.OralPairParticipantId = opp.OralPairParticipantId

INNER JOIN
	Exercises ex -- Die Aufgaben selbst
    ON ex.ExerciseId = ope.ExerciseId

INNER JOIN
    ExaminationDefinitionParts edp -- Teile von einer Prüfungsformat
    ON edp.ExaminationDefinitionPartId = ope.ExaminationDefinitionPartId

INNER JOIN
	ExaminationDefinitions ed -- Prüfungsformat (B1, B2 usw.)
    ON ed.ExaminationDefinitionId = edp.ExaminationDefinitionId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündlich
    -- testen
    AND ex.ExerciseNumber != '1061-M1-000'

ORDER BY ex.ExerciseNumber