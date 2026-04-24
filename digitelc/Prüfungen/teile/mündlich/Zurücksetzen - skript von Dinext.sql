-- Mündliche Prüfungsteil vollständig zurücksetzen. Auch die Paare werden gelöscht.

DECLARE @ExaminationId UNIQUEIDENTIFIER = (Select ExaminationId FROM Examinations WHERE ExaminationNumber = '9209735')

BEGIN TRANSACTION;

BEGIN TRY

    -- 1. ExaminationGroupTimeManagements löschen
    --    (über ExaminationGroupParticipants → ExaminationGroups → ExaminationParts mit Type=1)
    DELETE egtm
    FROM [dbo].[ExaminationGroupTimeManagements] AS egtm
    INNER JOIN [dbo].[ExaminationGroupParticipants] AS egp
        ON egtm.[ExaminationGroupParticipantId] = egp.[ExaminationGroupParticipantId]
    INNER JOIN [dbo].[ExaminationGroups] AS eg
        ON egp.[ExaminationGroupId] = eg.[ExaminationGroupId]
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 2. OralPairExercises löschen (über OralPairParticipants → OralPairs → ExaminationGroups → ExaminationParts mit Type=1)
    DELETE ope
    FROM [dbo].[OralPairExercises] AS ope
    INNER JOIN [dbo].[OralPairParticipants] AS opp
        ON ope.[OralPairParticipantId] = opp.[OralPairParticipantId]
    INNER JOIN [dbo].[OralPairs] AS op
        ON opp.[OralPairId] = op.[OralPairId]
    INNER JOIN [dbo].[ExaminationGroups] AS eg
        ON op.[ExaminationGroupId] = eg.[ExaminationGroupId]
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 3. OralPairParticipants löschen (über OralPairs → ExaminationGroups → ExaminationParts mit Type=1)
    DELETE opp
    FROM [dbo].[OralPairParticipants] AS opp
    INNER JOIN [dbo].[OralPairs] AS op
        ON opp.[OralPairId] = op.[OralPairId]
    INNER JOIN [dbo].[ExaminationGroups] AS eg
        ON op.[ExaminationGroupId] = eg.[ExaminationGroupId]
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 4. OralPairs löschen (über ExaminationGroups → ExaminationParts mit Type=1)
    DELETE op
    FROM [dbo].[OralPairs] AS op
    INNER JOIN [dbo].[ExaminationGroups] AS eg
        ON op.[ExaminationGroupId] = eg.[ExaminationGroupId]
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 5. ExaminationGroupParticipants: ParticipantStatus auf 1 setzen
    UPDATE egp
    SET egp.[ParticipantStatus] = 1
    FROM [dbo].[ExaminationGroupParticipants] AS egp
    INNER JOIN [dbo].[ExaminationGroups] AS eg
        ON egp.[ExaminationGroupId] = eg.[ExaminationGroupId]
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 6. ExaminationGroups: ExaminationOralGroupStatus auf 1 setzen
    UPDATE eg
    SET eg.[ExaminationOralGroupStatus] = 1
    FROM [dbo].[ExaminationGroups] AS eg
    INNER JOIN [dbo].[ExaminationParts] AS ep
        ON eg.[ExaminationPartId] = ep.[ExaminationPartId]
    WHERE ep.[ExaminationId] = @ExaminationId
      AND ep.[ExaminationPartType] = 1;

    -- 7. ExaminationParts: ExaminationPartStatus auf 1 setzen (nur Type=1)
    UPDATE [dbo].[ExaminationParts]
    SET [ExaminationPartStatus] = 1
    WHERE [ExaminationId] = @ExaminationId
      AND [ExaminationPartType] = 1;

    -- 8. Examination
    UPDATE [dbo].[Examinations]
    SET [ExaminationStatus] = 2
    WHERE [ExaminationId] = @ExaminationId;

    COMMIT TRANSACTION;

END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH;