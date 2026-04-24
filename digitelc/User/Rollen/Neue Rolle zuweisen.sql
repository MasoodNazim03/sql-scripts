-- User eine neue Rolle zuweisen
-- 1 'Admin'
-- 2 'TelcUser'
-- 3 'Examiner (Prüfer)'
-- 4 'Assessor (Bewerter)'
-- 5 'ExaminationCenterEmployee'
-- 6 'ExaminationCenterAdmin'

DECLARE @UserIdMN NVARCHAR(255) = '13F71771-F302-F111-832E-6045BD1694D6'; -- UserID von MN
DECLARE @targetUserId NVARCHAR(255) = (SELECT UserId FROM Users WHERE UserName = 'm.nazim@telc.net'); -- ID von dem User der die Rolle bekommen soll

INSERT INTO UserRoles
(
    UserId,
    RoleCode,
    CreatedAt,
    CreatedByUserId,
	LastModifiedByUserId
)
VALUES
(
	@targetUserId,
    2, -- Rolle den der User bekommen soll
    GETDATE(),
    @UserIdMN,
	@UserIdMN
)