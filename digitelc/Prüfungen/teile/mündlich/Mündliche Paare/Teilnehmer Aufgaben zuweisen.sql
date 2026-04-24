-- Einen Prüfungsteilnehmer zu eine Paar hinzufügen und ihn Aufgaben zuweisen.

-- Vorname2 zu Vorname1 hinzufügen

-- Wie funktioniert es mit den aufgaben?
-- Jeden Teilnehmer werden 3 Aufgaben zugewisen
-- 1061-M1, 1061-M2 und 1061-M3

-- 1061-M1 ist für alle gleich
-- 1061-M2 eine bekommt A der andere bekommt B.
-- 1061-M3 Beide Paar-Mitglieder bekommen die Gleiche Aufgabe


-- Wir gehen davon aus das ein Teilnehmer von ein Paar entfernt wurde und liegt jetzt frei rum und gehört zu keine Paar.

-- OralPairExercises
-- ExerciseId - steht oben welches er bekommen soll
-- ExaminationDefinitionPartId ist für alle Teilnehmer dieser Prüfung gleich
-- CreatedAt Jetzt
-- CreatedByUserId Masood Nazim
-- LastModifiedByUserId Masood Nazim
-- OralPairParticipantId - ID von der Tabelle OralPairParticipants, als wir diesen Person zu eine Gruppe hinzugefügt haben

-- 01 - Die Person muss erst zu eine Paar hinzugefügt werden.
-- 02 - Dieser Person müssen wir Aufgaben zuweisen

/**
-- 01 von 02
-- Teilnehmer zu OralPairParticipants opp hinzufügen
-- OralPairId - zu welche Gruppe möchte ich ihn hinzufügen
-- ParticipantId - Welche Teilnehmer möchte ich hinzufügen
-- CreatedAt Jetzt
-- CreatedByUserId Masood Nazim
-- LastModifiedByUserId Masood Nazim
DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = '1234502';
DECLARE @PairName NVARCHAR(50) = 'Paar 1';

-- Testen
-- Welchen Teilnehmer fügen wir zu welche Gruppe hinzu
SELECT e.ExaminationNumber, p.ParticipantNumber, p.FirstName, p.LastName, op.PairName

-- INSERT INTO OralPairParticipants (OralPairId, ParticipantId, CreatedAt, CreatedByUserId, LastModifiedByUserId)
/**
SELECT
    op.OralPairId,
    p.ParticipantId,
    GETDATE(),
    '13F71771-F302-F111-832E-6045BD1694D6', -- ID von dem User der die Rolle zugewiesen hat - Hier von Masood
	'13F71771-F302-F111-832E-6045BD1694D6' -- ID von dem User der die Rolle zugewiesen hat - Hier von Masood
**/
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
	Participants p -- Teilnehmer
	ON p.ParticipantId = egp.ParticipantId

INNER JOIN
	OralPairs op -- Mündliche Paare
    ON op.ExaminationGroupId = egp.ExaminationGroupId

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ',')) -- Welche Teilnehmer soll hinzugefügt werden
	AND ep.ExaminationPartType = 1 -- Für Mündlich
	AND op.PairName = @PairName -- Zu welche Paar soll die Person hinzugefügt werden
**/

-- 02 von 02
-- Aufgaben zuweisen
DECLARE @ExaminationNumber NVARCHAR(50) = '9213324';
DECLARE @ParticipantNumbers NVARCHAR(MAX) = '1234501'; -- Wer ist sein Partner?
-- DECLARE @PairName NVARCHAR(50) = 'Paar 1';

--
-- INSERT INTO OralPairExercises(ExerciseId, ExaminationDefinitionPartId, CreatedAt, CreatedByUserId, LastModifiedByUserId, OralPairParticipantId)
-- testen
SELECT
	e.ExaminationNumber e,

    -- Mündliche Paare
    op.PairName,

	-- Prüfungsteilnehmer
    p.ParticipantNumber,
    p.FirstName,
    p.LastName,

    -- Exercises
    ex.ExerciseNumber,
    ex.Instructions,
    ex.Text,
    ex.PoolId,
    ex.Version
    , egp.*

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

WHERE
	e.ExaminationNumber = @ExaminationNumber
	AND p.ParticipantNumber IN (SELECT value FROM STRING_SPLIT(@ParticipantNumbers, ','))
	AND ep.ExaminationPartType = 1 -- Für Mündlich