-- Prüfungsstatus
    CASE e.ExaminationStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Completed'
        WHEN 5 THEN 'Terminated (abgebrochen)'
        ELSE 'Unknown'
    END AS 'Prüfungsstatus',

-- Prüfungsteile
    CASE ep.ExaminationPartType
        WHEN 1 THEN 'Oral'
        WHEN 2 THEN 'Written'
        ELSE 'Unknown'
    END AS 'Prüfungsteil',

-- Prüfungsteiltstatus
    CASE ep.ExaminationPartStatus
        WHEN 1 THEN 'Upcoming '
        WHEN 2 THEN 'InPreparation'
        WHEN 3 THEN 'InProgress'
        WHEN 4 THEN 'Paused'
        WHEN 5 THEN 'Completed'
        ELSE 'Unknown'
    END AS 'Prüfungsteil Status',

-- Gruppenstatus
    CASE eg.ExaminationOralGroupStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'PairsCreated' -- Paare wurden generiert
        WHEN 3 THEN 'InProgress' -- Wurde gestartet
        WHEN 4 THEN 'Evaluated' -- Ist vollständig
        ELSE 'Unknown'
    END AS 'Mündliche Gruppen Status',

-- Teilnehmerstatus
    CASE egp.ParticipantStatus
        WHEN 1 THEN 'Initial'
        WHEN 2 THEN 'CodeGenerated'
        WHEN 3 THEN 'InLobby (wartet)'
        WHEN 4 THEN 'InProgress (macht gerade die Prüfung)'
        WHEN 5 THEN 'Paused'
        WHEN 6 THEN 'Completed (Abgeschlossen)'
        ELSE 'Unknown'
    END AS StatusName,

-- Ausschlusskreterien
    CASE egp.ExclusionCriterionType
        WHEN 1 THEN 'Kein Ausschluss'
        WHEN 2 THEN 'Täuschungsversuch'
        WHEN 3 THEN 'Auschluss'
        WHEN 4 THEN 'Abgebrochen'
        WHEN 5 THEN 'Abwesend'
        ELSE 'Unknown'
    END AS 'Ausschlussgrund',

-- Teilnehmeraktionen
    CASE tm.ActionCode
        WHEN 1 THEN 'PreparationStarted (Startzeit Warteraum)'
        WHEN 2 THEN 'ExamStarted (Prüfung wurde gestartet)'
        WHEN 3 THEN 'ExamEnded (Prüfung wurde beendet)'
        WHEN 4 THEN 'Paused (Prüfung wurde Pausiert)'
        WHEN 5 THEN 'Resumed (Pause oder Prüfung beendet)'
        ELSE 'Unknown'
    END AS ActionCodeName,