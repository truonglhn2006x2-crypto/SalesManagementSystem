-- =====================================================
-- Khởi tạo cơ sở dữ liệu quản lý bán hàng.
CREATE DATABASE QuanLyBanHang;
GO

-- Sử dụng cơ sở dữ liệu quản lý bán hàng.
USE QuanLyBanHang;
GO

-- =====================================================
-- THÀNH VIÊN 1: QUẢN LÝ TÀI KHOẢN VÀ PHÂN QUYỀN
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG TÀI KHOẢN VÀ PHÂN QUYỀN.
-- Ghi chú: ở bước này chỉ tạo bảng và cột. Các ràng buộc được thêm ở NHIỆM VỤ 2.

-- 1.1. Tạo bảng Users (Lưu thông tin tài khoản người dùng).
-- Mật khẩu KHÔNG lưu dạng chữ thường: lưu PasswordHash = SHA2_256(Salt + Password), mỗi tài khoản một Salt riêng.
CREATE TABLE dbo.Users (
    UserID           INT IDENTITY(1,1) NOT NULL,   -- Khóa chính, các bảng khác (đơn hàng, nhật ký...) tham chiếu cột này
    Username         NVARCHAR(50)      NOT NULL,   -- Tên đăng nhập
    PasswordHash     VARBINARY(32)     NOT NULL,   -- Mật khẩu đã băm
    PasswordSalt     UNIQUEIDENTIFIER  NOT NULL,   -- Salt dùng để băm mật khẩu
    FullName         NVARCHAR(100)     NOT NULL,   -- Họ tên
    Email            NVARCHAR(100)     NULL,
    Phone            NVARCHAR(15)      NULL,
    IsActive         BIT               NOT NULL,   -- 1 = đang hoạt động, 0 = bị khóa
    FailedLoginCount INT               NOT NULL,   -- Số lần đăng nhập sai liên tiếp
    LockReason       NVARCHAR(200)     NULL,       -- Lý do khóa tài khoản
    LastLoginAt      DATETIME2(0)      NULL,       -- Lần đăng nhập gần nhất
    CreatedAt        DATETIME2(0)      NOT NULL,
    UpdatedAt        DATETIME2(0)      NULL
);
GO

-- 1.2. Tạo bảng Roles (Lưu danh sách vai trò người dùng).
CREATE TABLE dbo.Roles (
    RoleID      INT IDENTITY(1,1) NOT NULL,
    RoleName    NVARCHAR(50)      NOT NULL,        -- Admin, Manager, Sales, Customer
    Description NVARCHAR(200)     NULL
);
GO

-- 1.3. Tạo bảng Permissions (Lưu danh sách quyền hạn).
CREATE TABLE dbo.Permissions (
    PermissionID   INT IDENTITY(1,1) NOT NULL,
    PermissionCode VARCHAR(50)       NOT NULL,     -- Mã quyền dùng trong code C#, ví dụ: ORDER_CREATE
    PermissionName NVARCHAR(100)     NOT NULL,     -- Tên hiển thị
    Description    NVARCHAR(200)     NULL
);
GO

-- 1.4. Tạo bảng UserRoles (Liên kết tài khoản với vai trò).
CREATE TABLE dbo.UserRoles (
    UserID     INT          NOT NULL,
    RoleID     INT          NOT NULL,
    AssignedAt DATETIME2(0) NOT NULL
);
GO

-- 1.5. Tạo bảng RolePermissions (Liên kết vai trò với quyền hạn).
CREATE TABLE dbo.RolePermissions (
    RoleID       INT NOT NULL,
    PermissionID INT NOT NULL
);
GO


-- NHIỆM VỤ 2: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 2.1. Thiết lập khóa chính (PRIMARY KEY).
ALTER TABLE dbo.Users           ADD CONSTRAINT PK_Users           PRIMARY KEY (UserID);
ALTER TABLE dbo.Roles           ADD CONSTRAINT PK_Roles           PRIMARY KEY (RoleID);
ALTER TABLE dbo.Permissions     ADD CONSTRAINT PK_Permissions     PRIMARY KEY (PermissionID);
ALTER TABLE dbo.UserRoles       ADD CONSTRAINT PK_UserRoles       PRIMARY KEY (UserID, RoleID);
ALTER TABLE dbo.RolePermissions ADD CONSTRAINT PK_RolePermissions PRIMARY KEY (RoleID, PermissionID);
GO

-- 2.2. Thiết lập khóa ngoại (FOREIGN KEY).
-- Xóa user  -> tự xóa các dòng gán vai trò của user đó.
-- Xóa role  -> bị chặn nếu vẫn còn user đang giữ vai trò đó.
-- Xóa role/permission -> tự xóa các dòng trong RolePermissions.
ALTER TABLE dbo.UserRoles ADD CONSTRAINT FK_UserRoles_Users
    FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID) ON DELETE CASCADE;
ALTER TABLE dbo.UserRoles ADD CONSTRAINT FK_UserRoles_Roles
    FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID);
ALTER TABLE dbo.RolePermissions ADD CONSTRAINT FK_RolePermissions_Roles
    FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID) ON DELETE CASCADE;
ALTER TABLE dbo.RolePermissions ADD CONSTRAINT FK_RolePermissions_Permissions
    FOREIGN KEY (PermissionID) REFERENCES dbo.Permissions(PermissionID) ON DELETE CASCADE;
GO

-- 2.3. Thiết lập UNIQUE cho tên đăng nhập.
ALTER TABLE dbo.Users       ADD CONSTRAINT UQ_Users_Username          UNIQUE (Username);
ALTER TABLE dbo.Roles       ADD CONSTRAINT UQ_Roles_RoleName          UNIQUE (RoleName);
ALTER TABLE dbo.Permissions ADD CONSTRAINT UQ_Permissions_Code        UNIQUE (PermissionCode);
GO
-- Email có thể để trống (NULL) nhưng nếu có thì không được trùng.
CREATE UNIQUE NONCLUSTERED INDEX UX_Users_Email ON dbo.Users(Email) WHERE Email IS NOT NULL;
GO

-- 2.4. Thiết lập CHECK và DEFAULT phù hợp.
-- DEFAULT
ALTER TABLE dbo.Users     ADD CONSTRAINT DF_Users_IsActive         DEFAULT 1             FOR IsActive;
ALTER TABLE dbo.Users     ADD CONSTRAINT DF_Users_FailedLoginCount DEFAULT 0             FOR FailedLoginCount;
ALTER TABLE dbo.Users     ADD CONSTRAINT DF_Users_CreatedAt        DEFAULT SYSDATETIME() FOR CreatedAt;
ALTER TABLE dbo.UserRoles ADD CONSTRAINT DF_UserRoles_AssignedAt   DEFAULT SYSDATETIME() FOR AssignedAt;
GO
-- CHECK
-- Username: tối thiểu 3 ký tự, chỉ gồm chữ không dấu, số, dấu chấm, dấu gạch dưới.
ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Username
    CHECK (LEN(Username) >= 3 AND Username COLLATE Latin1_General_BIN2 NOT LIKE N'%[^a-zA-Z0-9._]%');
ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_FullName
    CHECK (LEN(LTRIM(RTRIM(FullName))) > 0);
ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Email
    CHECK (Email IS NULL OR (Email LIKE N'_%@_%._%' AND Email NOT LIKE N'% %'));
ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_Phone
    CHECK (Phone IS NULL OR (LEN(Phone) BETWEEN 9 AND 15 AND Phone NOT LIKE N'%[^0-9+]%'));
ALTER TABLE dbo.Users ADD CONSTRAINT CK_Users_FailedLoginCount
    CHECK (FailedLoginCount >= 0);
ALTER TABLE dbo.Roles ADD CONSTRAINT CK_Roles_RoleName
    CHECK (LEN(LTRIM(RTRIM(RoleName))) > 0);
-- PermissionCode: chỉ gồm chữ HOA, số, dấu gạch dưới.
ALTER TABLE dbo.Permissions ADD CONSTRAINT CK_Permissions_Code
    CHECK (PermissionCode COLLATE Latin1_General_BIN2 NOT LIKE '%[^A-Z0-9_]%');
GO


-- NHIỆM VỤ 3: TẠO CÁC STORED PROCEDURE.
-- Quy ước lỗi: các SP quản lý dùng THROW với mã lỗi tự định nghĩa để C# bắt bằng SqlException (ex.Number, ex.Message).
--   50001 Tên đăng nhập không hợp lệ        50006 Vai trò không tồn tại
--   50002 Mật khẩu quá ngắn (< 6 ký tự)     50007 Tài khoản không tồn tại
--   50003 Họ tên trống                      50008 Mật khẩu cũ không đúng
--   50004 Tên đăng nhập đã tồn tại          50009 Không được khóa/xóa/gỡ quyền Admin hoạt động cuối cùng
--   50005 Email đã tồn tại                  50010 Tài khoản đã phát sinh dữ liệu, không thể xóa (hãy khóa)
-- sp_User_Login KHÔNG throw mà trả về 1 dòng có ResultCode: 1 = thành công, 0 = sai thông tin, -1 = tài khoản bị khóa.

-- Hàm băm mật khẩu (dùng chung cho tạo tài khoản, đăng nhập, đổi mật khẩu).
CREATE FUNCTION dbo.fn_HashPassword (@Password NVARCHAR(100), @Salt UNIQUEIDENTIFIER)
RETURNS VARBINARY(32)
AS
BEGIN
    RETURN HASHBYTES('SHA2_256', CONCAT(CONVERT(NVARCHAR(36), @Salt), @Password));
END;
GO

-- Hàm kiểm tra tài khoản có phải là Admin đang hoạt động DUY NHẤT hay không (1 = đúng).
-- Dùng để chặn khóa/xóa/gỡ quyền của Admin cuối cùng, tránh hệ thống không còn ai quản trị.
CREATE FUNCTION dbo.fn_IsLastActiveAdmin (@UserID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (SELECT 1
               FROM dbo.Users u
               JOIN dbo.UserRoles ur ON ur.UserID = u.UserID
               JOIN dbo.Roles r      ON r.RoleID = ur.RoleID
               WHERE u.UserID = @UserID AND u.IsActive = 1 AND r.RoleName = N'Admin')
       AND NOT EXISTS (SELECT 1
               FROM dbo.Users u
               JOIN dbo.UserRoles ur ON ur.UserID = u.UserID
               JOIN dbo.Roles r      ON r.RoleID = ur.RoleID
               WHERE u.UserID <> @UserID AND u.IsActive = 1 AND r.RoleName = N'Admin')
        SET @Result = 1;

    RETURN @Result;
END;
GO

-- Hàm kiểm tra tài khoản có quyền hay không (1 = có). Tài khoản bị khóa thì luôn trả 0.
CREATE FUNCTION dbo.fn_HasPermission (@UserID INT, @PermissionCode VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (SELECT 1
               FROM dbo.Users u
               JOIN dbo.UserRoles ur       ON ur.UserID = u.UserID
               JOIN dbo.RolePermissions rp ON rp.RoleID = ur.RoleID
               JOIN dbo.Permissions p      ON p.PermissionID = rp.PermissionID
               WHERE u.UserID = @UserID AND u.IsActive = 1 AND p.PermissionCode = @PermissionCode)
        SET @Result = 1;

    RETURN @Result;
END;
GO

-- 3.1. Tạo Stored Procedure quản lý tài khoản.

-- Tạo tài khoản mới (kèm gán 1 vai trò). Trả về UserID mới qua tham số OUTPUT @NewUserID.
CREATE PROCEDURE dbo.sp_User_Create
    @Username  NVARCHAR(50),
    @Password  NVARCHAR(100),
    @FullName  NVARCHAR(100),
    @Email     NVARCHAR(100) = NULL,
    @Phone     NVARCHAR(15)  = NULL,
    @RoleName  NVARCHAR(50)  = N'Customer',
    @NewUserID INT           = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    SET @Username = LTRIM(RTRIM(@Username));
    SET @FullName = LTRIM(RTRIM(@FullName));
    SET @Email    = NULLIF(LTRIM(RTRIM(@Email)), N'');
    SET @Phone    = NULLIF(LTRIM(RTRIM(@Phone)), N'');

    IF @Username IS NULL OR LEN(@Username) < 3
       OR @Username COLLATE Latin1_General_BIN2 LIKE N'%[^a-zA-Z0-9._]%'
    BEGIN
        THROW 50001, N'Tên đăng nhập phải từ 3 ký tự, chỉ gồm chữ không dấu, số, dấu chấm hoặc gạch dưới.', 1;
    END;

    IF @Password IS NULL OR LEN(@Password) < 6
    BEGIN
        THROW 50002, N'Mật khẩu phải có ít nhất 6 ký tự.', 1;
    END;

    IF @FullName IS NULL OR @FullName = N''
    BEGIN
        THROW 50003, N'Họ tên không được để trống.', 1;
    END;

    IF EXISTS (SELECT 1 FROM dbo.Users WHERE Username = @Username)
    BEGIN
        THROW 50004, N'Tên đăng nhập đã tồn tại.', 1;
    END;

    IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Users WHERE Email = @Email)
    BEGIN
        THROW 50005, N'Email đã được sử dụng bởi tài khoản khác.', 1;
    END;

    DECLARE @RoleID INT = (SELECT RoleID FROM dbo.Roles WHERE RoleName = @RoleName);
    IF @RoleID IS NULL
    BEGIN
        THROW 50006, N'Vai trò không tồn tại.', 1;
    END;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Salt UNIQUEIDENTIFIER = NEWID();

        INSERT INTO dbo.Users (Username, PasswordHash, PasswordSalt, FullName, Email, Phone)
        VALUES (@Username, dbo.fn_HashPassword(@Password, @Salt), @Salt, @FullName, @Email, @Phone);

        SET @NewUserID = SCOPE_IDENTITY();

        INSERT INTO dbo.UserRoles (UserID, RoleID) VALUES (@NewUserID, @RoleID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- Lấy thông tin 1 tài khoản (không trả mật khẩu).
CREATE PROCEDURE dbo.sp_User_GetById
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    SELECT u.UserID, u.Username, u.FullName, u.Email, u.Phone, u.IsActive, u.LockReason,
           u.FailedLoginCount, u.LastLoginAt, u.CreatedAt, u.UpdatedAt,
           (SELECT STRING_AGG(r.RoleName, N', ')
            FROM dbo.UserRoles ur JOIN dbo.Roles r ON r.RoleID = ur.RoleID
            WHERE ur.UserID = u.UserID) AS RoleNames
    FROM dbo.Users u
    WHERE u.UserID = @UserID;
END;
GO

-- Đổi mật khẩu (người dùng tự đổi, phải nhập đúng mật khẩu cũ).
CREATE PROCEDURE dbo.sp_User_ChangePassword
    @UserID      INT,
    @OldPassword NVARCHAR(100),
    @NewPassword NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Salt UNIQUEIDENTIFIER, @Hash VARBINARY(32);
    SELECT @Salt = PasswordSalt, @Hash = PasswordHash FROM dbo.Users WHERE UserID = @UserID;

    IF @Salt IS NULL
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    IF @OldPassword IS NULL OR dbo.fn_HashPassword(@OldPassword, @Salt) <> @Hash
    BEGIN
        THROW 50008, N'Mật khẩu cũ không đúng.', 1;
    END;

    IF @NewPassword IS NULL OR LEN(@NewPassword) < 6
    BEGIN
        THROW 50002, N'Mật khẩu mới phải có ít nhất 6 ký tự.', 1;
    END;

    SET @Salt = NEWID();
    UPDATE dbo.Users
    SET PasswordSalt = @Salt,
        PasswordHash = dbo.fn_HashPassword(@NewPassword, @Salt),
        UpdatedAt    = SYSDATETIME()
    WHERE UserID = @UserID;
END;
GO

-- Đặt lại mật khẩu (dành cho Admin, không cần mật khẩu cũ). Đồng thời xóa bộ đếm đăng nhập sai.
CREATE PROCEDURE dbo.sp_User_ResetPassword
    @UserID      INT,
    @NewPassword NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    IF @NewPassword IS NULL OR LEN(@NewPassword) < 6
    BEGIN
        THROW 50002, N'Mật khẩu mới phải có ít nhất 6 ký tự.', 1;
    END;

    DECLARE @Salt UNIQUEIDENTIFIER = NEWID();
    UPDATE dbo.Users
    SET PasswordSalt     = @Salt,
        PasswordHash     = dbo.fn_HashPassword(@NewPassword, @Salt),
        FailedLoginCount = 0,
        UpdatedAt        = SYSDATETIME()
    WHERE UserID = @UserID;
END;
GO

-- Gán thêm vai trò cho tài khoản (đã có rồi thì bỏ qua).
CREATE PROCEDURE dbo.sp_User_AssignRole
    @UserID   INT,
    @RoleName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    DECLARE @RoleID INT = (SELECT RoleID FROM dbo.Roles WHERE RoleName = @RoleName);
    IF @RoleID IS NULL
    BEGIN
        THROW 50006, N'Vai trò không tồn tại.', 1;
    END;

    IF NOT EXISTS (SELECT 1 FROM dbo.UserRoles WHERE UserID = @UserID AND RoleID = @RoleID)
        INSERT INTO dbo.UserRoles (UserID, RoleID) VALUES (@UserID, @RoleID);
END;
GO

-- Gỡ vai trò khỏi tài khoản.
CREATE PROCEDURE dbo.sp_User_RemoveRole
    @UserID   INT,
    @RoleName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    DECLARE @RoleID INT = (SELECT RoleID FROM dbo.Roles WHERE RoleName = @RoleName);
    IF @RoleID IS NULL
    BEGIN
        THROW 50006, N'Vai trò không tồn tại.', 1;
    END;

    IF @RoleName = N'Admin' AND dbo.fn_IsLastActiveAdmin(@UserID) = 1
    BEGIN
        THROW 50009, N'Không thể gỡ quyền Admin của quản trị viên hoạt động cuối cùng.', 1;
    END;

    DELETE FROM dbo.UserRoles WHERE UserID = @UserID AND RoleID = @RoleID;
END;
GO

-- Xóa tài khoản. Nếu tài khoản đã phát sinh dữ liệu ở bảng khác (đơn hàng, nhật ký...) thì không xóa được -> nên khóa.
CREATE PROCEDURE dbo.sp_User_Delete
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    IF dbo.fn_IsLastActiveAdmin(@UserID) = 1
    BEGIN
        THROW 50009, N'Không thể xóa quản trị viên hoạt động cuối cùng.', 1;
    END;

    BEGIN TRY
        DELETE FROM dbo.Users WHERE UserID = @UserID;   -- UserRoles tự xóa theo (ON DELETE CASCADE)
    END TRY
    BEGIN CATCH
        IF ERROR_NUMBER() = 547   -- vi phạm khóa ngoại từ bảng khác
        BEGIN
            THROW 50010, N'Tài khoản đã phát sinh dữ liệu nên không thể xóa. Hãy khóa tài khoản thay vì xóa.', 1;
        END;
        THROW;
    END CATCH;
END;
GO

-- 3.2. Tạo Stored Procedure tìm kiếm người dùng.
-- Tìm theo từ khóa (username/họ tên/email/số điện thoại), lọc theo vai trò và trạng thái, có phân trang.
-- Cột TotalRows = tổng số dòng khớp điều kiện (dùng để tính số trang trên giao diện).
CREATE PROCEDURE dbo.sp_User_Search
    @Keyword    NVARCHAR(100) = NULL,
    @RoleName   NVARCHAR(50)  = NULL,
    @IsActive   BIT           = NULL,
    @PageNumber INT           = 1,
    @PageSize   INT           = 20
AS
BEGIN
    SET NOCOUNT ON;

    SET @Keyword = NULLIF(LTRIM(RTRIM(@Keyword)), N'');
    IF @PageNumber IS NULL OR @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize   IS NULL OR @PageSize   < 1 SET @PageSize   = 20;

    SELECT u.UserID, u.Username, u.FullName, u.Email, u.Phone, u.IsActive, u.LockReason,
           u.LastLoginAt, u.CreatedAt,
           (SELECT STRING_AGG(r.RoleName, N', ')
            FROM dbo.UserRoles ur JOIN dbo.Roles r ON r.RoleID = ur.RoleID
            WHERE ur.UserID = u.UserID) AS RoleNames,
           COUNT(*) OVER () AS TotalRows
    FROM dbo.Users u
    WHERE (@Keyword IS NULL
           OR u.Username LIKE N'%' + @Keyword + N'%'
           OR u.FullName LIKE N'%' + @Keyword + N'%'
           OR u.Email    LIKE N'%' + @Keyword + N'%'
           OR u.Phone    LIKE N'%' + @Keyword + N'%')
      AND (@IsActive IS NULL OR u.IsActive = @IsActive)
      AND (@RoleName IS NULL OR EXISTS (SELECT 1
                                        FROM dbo.UserRoles ur JOIN dbo.Roles r ON r.RoleID = ur.RoleID
                                        WHERE ur.UserID = u.UserID AND r.RoleName = @RoleName))
    ORDER BY u.UserID
    OFFSET (@PageNumber - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- 3.3. Tạo Stored Procedure cập nhật thông tin tài khoản.
-- Cập nhật họ tên, email, số điện thoại (không đổi username/mật khẩu/vai trò - đã có SP riêng).
CREATE PROCEDURE dbo.sp_User_Update
    @UserID   INT,
    @FullName NVARCHAR(100),
    @Email    NVARCHAR(100) = NULL,
    @Phone    NVARCHAR(15)  = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @FullName = LTRIM(RTRIM(@FullName));
    SET @Email    = NULLIF(LTRIM(RTRIM(@Email)), N'');
    SET @Phone    = NULLIF(LTRIM(RTRIM(@Phone)), N'');

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    IF @FullName IS NULL OR @FullName = N''
    BEGIN
        THROW 50003, N'Họ tên không được để trống.', 1;
    END;

    IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Users WHERE Email = @Email AND UserID <> @UserID)
    BEGIN
        THROW 50005, N'Email đã được sử dụng bởi tài khoản khác.', 1;
    END;

    UPDATE dbo.Users
    SET FullName  = @FullName,
        Email     = @Email,
        Phone     = @Phone,
        UpdatedAt = SYSDATETIME()
    WHERE UserID = @UserID;
END;
GO

-- 3.4. Tạo Stored Procedure khóa và mở khóa tài khoản.
CREATE PROCEDURE dbo.sp_User_Lock
    @UserID INT,
    @Reason NVARCHAR(200) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    IF dbo.fn_IsLastActiveAdmin(@UserID) = 1
    BEGIN
        THROW 50009, N'Không thể khóa quản trị viên hoạt động cuối cùng.', 1;
    END;

    UPDATE dbo.Users
    SET IsActive   = 0,
        LockReason = ISNULL(NULLIF(LTRIM(RTRIM(@Reason)), N''), N'Khóa bởi quản trị viên'),
        UpdatedAt  = SYSDATETIME()
    WHERE UserID = @UserID;
END;
GO

CREATE PROCEDURE dbo.sp_User_Unlock
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Users WHERE UserID = @UserID)
    BEGIN
        THROW 50007, N'Tài khoản không tồn tại.', 1;
    END;

    UPDATE dbo.Users
    SET IsActive         = 1,
        FailedLoginCount = 0,
        LockReason       = NULL,
        UpdatedAt        = SYSDATETIME()
    WHERE UserID = @UserID;
END;
GO

-- 3.5. (Bổ sung) Stored Procedure đăng nhập và lấy danh sách quyền - cần cho phần kiểm thử 5.1, 5.2 và cho Windows Forms.
-- sp_User_Login luôn trả về đúng 1 dòng: ResultCode, Message, UserID, Username, FullName, RoleNames.
--   ResultCode =  1 : đăng nhập thành công (UserID, Username... có giá trị)
--   ResultCode =  0 : sai tên đăng nhập hoặc mật khẩu (không tiết lộ là sai cái nào)
--   ResultCode = -1 : tài khoản bị khóa (hoặc vừa bị khóa do nhập sai 5 lần liên tiếp)
CREATE PROCEDURE dbo.sp_User_Login
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaxFailed INT = 5;
    DECLARE @UserID INT, @StoredUsername NVARCHAR(50), @FullName NVARCHAR(100),
            @Salt UNIQUEIDENTIFIER, @Hash VARBINARY(32), @IsActive BIT, @Failed INT;
    DECLARE @Code INT, @Message NVARCHAR(200), @RoleNames NVARCHAR(500);

    SELECT @UserID = UserID, @StoredUsername = Username, @FullName = FullName,
           @Salt = PasswordSalt, @Hash = PasswordHash, @IsActive = IsActive, @Failed = FailedLoginCount
    FROM dbo.Users
    WHERE Username = LTRIM(RTRIM(@Username));

    IF @UserID IS NULL OR @Password IS NULL OR dbo.fn_HashPassword(@Password, @Salt) <> @Hash
    BEGIN
        -- Sai thông tin đăng nhập
        SET @Code = 0;
        SET @Message = N'Tên đăng nhập hoặc mật khẩu không đúng.';

        IF @UserID IS NOT NULL AND @IsActive = 1
        BEGIN
            SET @Failed = @Failed + 1;

            IF @Failed >= @MaxFailed
            BEGIN
                UPDATE dbo.Users
                SET FailedLoginCount = @Failed, IsActive = 0,
                    LockReason = N'Nhập sai mật khẩu quá ' + CAST(@MaxFailed AS NVARCHAR(10)) + N' lần liên tiếp',
                    UpdatedAt = SYSDATETIME()
                WHERE UserID = @UserID;

                SET @Code = -1;
                SET @Message = N'Bạn đã nhập sai mật khẩu quá ' + CAST(@MaxFailed AS NVARCHAR(10))
                             + N' lần, tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.';
            END
            ELSE
            BEGIN
                UPDATE dbo.Users SET FailedLoginCount = @Failed WHERE UserID = @UserID;
            END;
        END;

        SET @UserID = NULL;
        SET @StoredUsername = NULL;
        SET @FullName = NULL;
    END
    ELSE IF @IsActive = 0
    BEGIN
        -- Đúng mật khẩu nhưng tài khoản đang bị khóa
        SET @Code = -1;
        SET @Message = N'Tài khoản đã bị khóa. Vui lòng liên hệ quản trị viên.';
        SET @UserID = NULL;
        SET @StoredUsername = NULL;
        SET @FullName = NULL;
    END
    ELSE
    BEGIN
        -- Đăng nhập thành công
        SET @Code = 1;
        SET @Message = N'Đăng nhập thành công.';

        UPDATE dbo.Users
        SET FailedLoginCount = 0, LastLoginAt = SYSDATETIME()
        WHERE UserID = @UserID;

        SELECT @RoleNames = STRING_AGG(r.RoleName, N', ')
        FROM dbo.UserRoles ur JOIN dbo.Roles r ON r.RoleID = ur.RoleID
        WHERE ur.UserID = @UserID;
    END;

    SELECT @Code AS ResultCode, @Message AS Message, @UserID AS UserID,
           @StoredUsername AS Username, @FullName AS FullName, @RoleNames AS RoleNames;
END;
GO

-- Lấy danh sách mã quyền của tài khoản (để Windows Forms ẩn/hiện chức năng sau khi đăng nhập).
CREATE PROCEDURE dbo.sp_User_GetPermissions
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT p.PermissionCode, p.PermissionName
    FROM dbo.Users u
    JOIN dbo.UserRoles ur       ON ur.UserID = u.UserID
    JOIN dbo.RolePermissions rp ON rp.RoleID = ur.RoleID
    JOIN dbo.Permissions p      ON p.PermissionID = rp.PermissionID
    WHERE u.UserID = @UserID AND u.IsActive = 1
    ORDER BY p.PermissionCode;
END;
GO


-- NHIỆM VỤ 4: TẠO DỮ LIỆU MẪU.
-- Mật khẩu mẫu chỉ dùng để test: Admin@123, Manager@123, Sales@123, Customer@123 -> PHẢI đổi khi dùng thật.

-- 4.5. Thêm dữ liệu vai trò và quyền hạn.
-- (Chạy TRƯỚC 4.1-4.4 vì tài khoản cần có vai trò để gán.)
INSERT INTO dbo.Roles (RoleName, Description) VALUES
    (N'Admin',    N'Quản trị hệ thống: toàn quyền, quản lý tài khoản và cấu hình'),
    (N'Manager',  N'Quản lý cửa hàng: sản phẩm, kho, nhập hàng, khách hàng, đơn hàng, báo cáo'),
    (N'Sales',    N'Nhân viên bán hàng: tạo đơn, thanh toán, hóa đơn, đổi trả, quản lý khách hàng'),
    (N'Customer', N'Khách hàng: xem sản phẩm và đặt hàng');
GO

INSERT INTO dbo.Permissions (PermissionCode, PermissionName) VALUES
    ('USER_VIEW',         N'Xem danh sách tài khoản'),
    ('USER_MANAGE',       N'Quản lý tài khoản (thêm, sửa, khóa, xóa)'),
    ('ROLE_MANAGE',       N'Quản lý vai trò và phân quyền'),
    ('PRODUCT_VIEW',      N'Xem sản phẩm'),
    ('PRODUCT_MANAGE',    N'Quản lý sản phẩm và danh mục'),
    ('PROMOTION_MANAGE',  N'Quản lý khuyến mãi'),
    ('INVENTORY_VIEW',    N'Xem tồn kho'),
    ('INVENTORY_MANAGE',  N'Quản lý kho, điều chỉnh tồn kho'),
    ('SUPPLIER_MANAGE',   N'Quản lý nhà cung cấp'),
    ('PURCHASE_MANAGE',   N'Quản lý phiếu nhập hàng'),
    ('CUSTOMER_VIEW',     N'Xem khách hàng'),
    ('CUSTOMER_MANAGE',   N'Quản lý khách hàng'),
    ('ORDER_VIEW',        N'Xem đơn hàng'),
    ('ORDER_CREATE',      N'Tạo đơn hàng'),
    ('PAYMENT_PROCESS',   N'Xử lý thanh toán'),
    ('INVOICE_CREATE',    N'Tạo hóa đơn'),
    ('RETURN_PROCESS',    N'Xử lý đổi trả và hoàn tiền'),
    ('REPORT_VIEW',       N'Xem báo cáo và Dashboard'),
    ('AUDIT_VIEW',        N'Xem nhật ký hoạt động'),
    ('SETTING_MANAGE',    N'Quản lý cấu hình hệ thống');
GO

-- Admin: toàn bộ quyền.
INSERT INTO dbo.RolePermissions (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM dbo.Roles r CROSS JOIN dbo.Permissions p
WHERE r.RoleName = N'Admin';

-- Manager: tất cả trừ quản lý tài khoản, phân quyền và cấu hình hệ thống.
INSERT INTO dbo.RolePermissions (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM dbo.Roles r CROSS JOIN dbo.Permissions p
WHERE r.RoleName = N'Manager'
  AND p.PermissionCode NOT IN ('USER_MANAGE', 'ROLE_MANAGE', 'SETTING_MANAGE');

-- Sales: nghiệp vụ bán hàng.
INSERT INTO dbo.RolePermissions (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM dbo.Roles r JOIN dbo.Permissions p
  ON p.PermissionCode IN ('PRODUCT_VIEW', 'INVENTORY_VIEW', 'CUSTOMER_VIEW', 'CUSTOMER_MANAGE',
                          'ORDER_VIEW', 'ORDER_CREATE', 'PAYMENT_PROCESS', 'INVOICE_CREATE', 'RETURN_PROCESS')
WHERE r.RoleName = N'Sales';

-- Customer: xem sản phẩm và đặt hàng.
INSERT INTO dbo.RolePermissions (RoleID, PermissionID)
SELECT r.RoleID, p.PermissionID
FROM dbo.Roles r JOIN dbo.Permissions p
  ON p.PermissionCode IN ('PRODUCT_VIEW', 'ORDER_CREATE')
WHERE r.RoleName = N'Customer';
GO

-- 4.1. Thêm tài khoản Admin.
EXEC dbo.sp_User_Create @Username = N'admin', @Password = N'Admin@123',
     @FullName = N'Quản Trị Viên', @Email = N'admin@shop.vn', @Phone = N'0901000001', @RoleName = N'Admin';

-- 4.2. Thêm tài khoản Manager.
EXEC dbo.sp_User_Create @Username = N'manager01', @Password = N'Manager@123',
     @FullName = N'Nguyễn Văn Quản', @Email = N'manager01@shop.vn', @Phone = N'0901000002', @RoleName = N'Manager';

-- 4.3. Thêm tài khoản Sales.
EXEC dbo.sp_User_Create @Username = N'sales01', @Password = N'Sales@123',
     @FullName = N'Trần Thị Bán', @Email = N'sales01@shop.vn', @Phone = N'0901000003', @RoleName = N'Sales';
EXEC dbo.sp_User_Create @Username = N'sales02', @Password = N'Sales@123',
     @FullName = N'Lê Văn Hàng', @Email = N'sales02@shop.vn', @Phone = N'0901000004', @RoleName = N'Sales';

-- 4.4. Thêm tài khoản Customer.
EXEC dbo.sp_User_Create @Username = N'customer01', @Password = N'Customer@123',
     @FullName = N'Phạm Minh Khách', @Email = N'customer01@gmail.com', @Phone = N'0912000001', @RoleName = N'Customer';
EXEC dbo.sp_User_Create @Username = N'customer02', @Password = N'Customer@123',
     @FullName = N'Hoàng Thị Mua', @Email = N'customer02@gmail.com', @Phone = N'0912000002', @RoleName = N'Customer';
GO


-- NHIỆM VỤ 5: KIỂM TRA VÀ KIỂM THỬ.
-- Chạy từng phần 5.1 -> 5.3 theo thứ tự. Kết quả hiển thị ở bảng #TestResult (cột Result = PASS/FAIL).
-- Các test có thay đổi dữ liệu (khóa/mở khóa, gán vai trò) đều được trả về trạng thái ban đầu ở cuối mỗi test.

IF OBJECT_ID('tempdb..#TestResult') IS NOT NULL DROP TABLE #TestResult;
IF OBJECT_ID('tempdb..#Login')      IS NOT NULL DROP TABLE #Login;

CREATE TABLE #TestResult (
    TestNo      VARCHAR(10)   NOT NULL,
    Description NVARCHAR(200) NOT NULL,
    Expected    NVARCHAR(50)  NOT NULL,
    Actual      NVARCHAR(50)  NULL,
    Result      AS (CASE WHEN Expected = Actual THEN 'PASS' ELSE 'FAIL' END)
);

CREATE TABLE #Login (
    ResultCode INT, Message NVARCHAR(200), UserID INT,
    Username NVARCHAR(50), FullName NVARCHAR(100), RoleNames NVARCHAR(500)
);
GO

-- 5.1. Kiểm tra chức năng đăng nhập.
DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'admin', @Password = N'Admin@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.1', N'Đăng nhập đúng tên và mật khẩu -> ResultCode = 1', N'1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.2', N'Đăng nhập thành công trả về vai trò Admin', N'Admin', RoleNames FROM #Login;

DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'admin', @Password = N'SaiMatKhau';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.3', N'Sai mật khẩu -> ResultCode = 0', N'0', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.4', N'Sai mật khẩu 1 lần -> FailedLoginCount = 1', N'1', CAST(FailedLoginCount AS NVARCHAR(10))
FROM dbo.Users WHERE Username = N'admin';

DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'khong_ton_tai', @Password = N'Admin@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.5', N'Tên đăng nhập không tồn tại -> ResultCode = 0', N'0', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'admin', @Password = N'Admin@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.1.6', N'Đăng nhập đúng sau khi sai -> FailedLoginCount về 0', N'0', CAST(FailedLoginCount AS NVARCHAR(10))
FROM dbo.Users WHERE Username = N'admin';

-- Test tạo tài khoản trùng username (phải báo lỗi 50004).
BEGIN TRY
    EXEC dbo.sp_User_Create @Username = N'admin', @Password = N'Abc12345', @FullName = N'Trùng tên', @RoleName = N'Sales';
    INSERT INTO #TestResult (TestNo, Description, Expected, Actual) VALUES ('5.1.7', N'Tạo tài khoản trùng username phải bị chặn', N'50004', N'NO ERROR');
END TRY
BEGIN CATCH
    INSERT INTO #TestResult (TestNo, Description, Expected, Actual) VALUES ('5.1.7', N'Tạo tài khoản trùng username phải bị chặn', N'50004', CAST(ERROR_NUMBER() AS NVARCHAR(10)));
END CATCH;

SELECT * FROM #TestResult WHERE TestNo LIKE '5.1.%' ORDER BY TestNo;
GO

-- 5.2. Kiểm tra chức năng phân quyền.
DECLARE @Admin INT    = (SELECT UserID FROM dbo.Users WHERE Username = N'admin');
DECLARE @Manager INT  = (SELECT UserID FROM dbo.Users WHERE Username = N'manager01');
DECLARE @Sales INT    = (SELECT UserID FROM dbo.Users WHERE Username = N'sales01');
DECLARE @Customer INT = (SELECT UserID FROM dbo.Users WHERE Username = N'customer01');

INSERT INTO #TestResult (TestNo, Description, Expected, Actual) VALUES
    ('5.2.1', N'Admin có quyền USER_MANAGE',            N'1', CAST(dbo.fn_HasPermission(@Admin,    'USER_MANAGE')    AS NVARCHAR(1))),
    ('5.2.2', N'Admin có quyền SETTING_MANAGE',         N'1', CAST(dbo.fn_HasPermission(@Admin,    'SETTING_MANAGE') AS NVARCHAR(1))),
    ('5.2.3', N'Manager có quyền REPORT_VIEW',          N'1', CAST(dbo.fn_HasPermission(@Manager,  'REPORT_VIEW')    AS NVARCHAR(1))),
    ('5.2.4', N'Manager KHÔNG có quyền USER_MANAGE',    N'0', CAST(dbo.fn_HasPermission(@Manager,  'USER_MANAGE')    AS NVARCHAR(1))),
    ('5.2.5', N'Sales có quyền ORDER_CREATE',           N'1', CAST(dbo.fn_HasPermission(@Sales,    'ORDER_CREATE')   AS NVARCHAR(1))),
    ('5.2.6', N'Sales KHÔNG có quyền REPORT_VIEW',      N'0', CAST(dbo.fn_HasPermission(@Sales,    'REPORT_VIEW')    AS NVARCHAR(1))),
    ('5.2.7', N'Customer có quyền PRODUCT_VIEW',        N'1', CAST(dbo.fn_HasPermission(@Customer, 'PRODUCT_VIEW')   AS NVARCHAR(1))),
    ('5.2.8', N'Customer KHÔNG có quyền PAYMENT_PROCESS', N'0', CAST(dbo.fn_HasPermission(@Customer, 'PAYMENT_PROCESS') AS NVARCHAR(1)));

-- Gán thêm vai trò Manager cho sales01 -> có quyền REPORT_VIEW; gỡ ra -> mất quyền.
EXEC dbo.sp_User_AssignRole @UserID = @Sales, @RoleName = N'Manager';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
VALUES ('5.2.9', N'Sales được gán thêm Manager -> có REPORT_VIEW', N'1', CAST(dbo.fn_HasPermission(@Sales, 'REPORT_VIEW') AS NVARCHAR(1)));

EXEC dbo.sp_User_RemoveRole @UserID = @Sales, @RoleName = N'Manager';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
VALUES ('5.2.10', N'Gỡ vai trò Manager -> mất REPORT_VIEW', N'0', CAST(dbo.fn_HasPermission(@Sales, 'REPORT_VIEW') AS NVARCHAR(1)));

-- Số quyền của từng vai trò (xem bằng mắt): Admin = 20, Manager = 17, Sales = 9, Customer = 2.
SELECT r.RoleName, COUNT(rp.PermissionID) AS SoQuyen
FROM dbo.Roles r LEFT JOIN dbo.RolePermissions rp ON rp.RoleID = r.RoleID
GROUP BY r.RoleName ORDER BY SoQuyen DESC;

EXEC dbo.sp_User_GetPermissions @UserID = @Sales;

SELECT * FROM #TestResult WHERE TestNo LIKE '5.2.%' ORDER BY LEN(TestNo), TestNo;
GO

-- 5.3. Kiểm tra trường hợp tài khoản bị khóa.
DECLARE @Admin INT = (SELECT UserID FROM dbo.Users WHERE Username = N'admin');
DECLARE @Sales2 INT = (SELECT UserID FROM dbo.Users WHERE Username = N'sales02');
DECLARE @Cust2 INT = (SELECT UserID FROM dbo.Users WHERE Username = N'customer02');
DECLARE @i INT = 1;

-- (a) Admin khóa sales02 -> đăng nhập đúng mật khẩu vẫn bị từ chối (-1), không có quyền.
EXEC dbo.sp_User_Lock @UserID = @Sales2, @Reason = N'Test khóa tài khoản';

DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'sales02', @Password = N'Sales@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.1', N'Tài khoản bị khóa đăng nhập đúng mật khẩu -> ResultCode = -1', N'-1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
VALUES ('5.3.2', N'Tài khoản bị khóa không có quyền nào', N'0', CAST(dbo.fn_HasPermission(@Sales2, 'ORDER_CREATE') AS NVARCHAR(1)));

-- (b) Mở khóa -> đăng nhập lại được.
EXEC dbo.sp_User_Unlock @UserID = @Sales2;
DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'sales02', @Password = N'Sales@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.3', N'Sau khi mở khóa đăng nhập lại -> ResultCode = 1', N'1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

-- (c) Nhập sai mật khẩu 5 lần liên tiếp -> tự động khóa.
DELETE FROM #Login;
WHILE @i <= 5
BEGIN
    DELETE FROM #Login;
    INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'customer02', @Password = N'SaiMatKhau';
    SET @i = @i + 1;
END;
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.4', N'Sai mật khẩu lần thứ 5 -> ResultCode = -1 (vừa bị khóa)', N'-1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.5', N'Sai 5 lần -> IsActive = 0', N'0', CAST(IsActive AS NVARCHAR(1)) FROM dbo.Users WHERE UserID = @Cust2;

DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'customer02', @Password = N'Customer@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.6', N'Tài khoản đã bị tự khóa, đúng mật khẩu vẫn không vào được', N'-1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

EXEC dbo.sp_User_Unlock @UserID = @Cust2;
DELETE FROM #Login;
INSERT INTO #Login EXEC dbo.sp_User_Login @Username = N'customer02', @Password = N'Customer@123';
INSERT INTO #TestResult (TestNo, Description, Expected, Actual)
SELECT '5.3.7', N'Mở khóa tài khoản bị tự khóa -> đăng nhập được', N'1', CAST(ResultCode AS NVARCHAR(10)) FROM #Login;

-- (d) Không cho khóa Admin hoạt động duy nhất.
BEGIN TRY
    EXEC dbo.sp_User_Lock @UserID = @Admin;
    INSERT INTO #TestResult (TestNo, Description, Expected, Actual) VALUES ('5.3.8', N'Khóa Admin duy nhất phải bị chặn', N'50009', N'NO ERROR');
END TRY
BEGIN CATCH
    INSERT INTO #TestResult (TestNo, Description, Expected, Actual) VALUES ('5.3.8', N'Khóa Admin duy nhất phải bị chặn', N'50009', CAST(ERROR_NUMBER() AS NVARCHAR(10)));
END CATCH;

SELECT * FROM #TestResult WHERE TestNo LIKE '5.3.%' ORDER BY TestNo;

-- Tổng hợp toàn bộ kết quả kiểm thử của Thành viên 1.
SELECT Result, COUNT(*) AS SoTest FROM #TestResult GROUP BY Result;
GO

DROP TABLE #Login;
DROP TABLE #TestResult;
GO


-- =====================================================
-- THÀNH VIÊN 2: QUẢN LÝ SẢN PHẨM VÀ KHUYẾN MÃI
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG SẢN PHẨM VÀ DANH MỤC.

-- 1.1. Tạo bảng Categories (Lưu danh mục sản phẩm).

-- 1.2. Tạo bảng Products (Lưu thông tin sản phẩm).


-- NHIỆM VỤ 2: TẠO CÁC BẢNG KHUYẾN MÃI.

-- 2.1. Tạo bảng Promotions (Lưu chương trình khuyến mãi).

-- 2.2. Tạo bảng PromotionProducts (Liên kết sản phẩm với khuyến mãi).


-- NHIỆM VỤ 3: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 3.1. Thiết lập khóa chính (PRIMARY KEY).

-- 3.2. Thiết lập khóa ngoại (FOREIGN KEY).

-- 3.3. Thiết lập UNIQUE cho mã SKU sản phẩm.

-- 3.4. Kiểm tra giá nhập và giá bán hợp lệ.

-- 3.5. Kiểm tra trạng thái và thời gian khuyến mãi.


-- NHIỆM VỤ 4: TẠO CÁC STORED PROCEDURE.

-- 4.1. Tạo Stored Procedure thêm sản phẩm.

-- 4.2. Tạo Stored Procedure cập nhật sản phẩm.

-- 4.3. Tạo Stored Procedure xóa hoặc ngừng kinh doanh sản phẩm.

-- 4.4. Tạo Stored Procedure tìm kiếm sản phẩm.

-- 4.5. Tạo Stored Procedure quản lý khuyến mãi.


-- NHIỆM VỤ 5: TẠO VIEW VÀ DỮ LIỆU MẪU.

-- 5.1. Tạo View danh sách sản phẩm.

-- 5.2. Tạo View danh mục sản phẩm.

-- 5.3. Thêm dữ liệu mẫu danh mục sản phẩm.

-- 5.4. Thêm tối thiểu 20 sản phẩm mẫu.

-- 5.5. Thêm dữ liệu chương trình khuyến mãi.


-- NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ.

-- 6.1. Kiểm tra thêm, sửa và tìm kiếm sản phẩm.

-- 6.2. Kiểm tra mã SKU bị trùng.

-- 6.3. Kiểm tra chương trình khuyến mãi hết hạn.


-- =====================================================
-- THÀNH VIÊN 3: QUẢN LÝ KHO VÀ NHẬP HÀNG
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG KHO HÀNG.

-- 1.1. Tạo bảng Warehouses (Lưu thông tin kho hàng).

-- 1.2. Tạo bảng InventoryStocks (Lưu số lượng tồn kho).

-- 1.3. Tạo bảng StockTransactions (Lưu lịch sử nhập, xuất và điều chỉnh kho).


-- NHIỆM VỤ 2: TẠO CÁC BẢNG NHÀ CUNG CẤP VÀ NHẬP HÀNG.

-- 2.1. Tạo bảng Suppliers (Lưu thông tin nhà cung cấp).

-- 2.2. Tạo bảng PurchaseOrders (Lưu thông tin phiếu đặt hàng nhập).

-- 2.3. Tạo bảng PurchaseOrderItems (Lưu chi tiết từng sản phẩm trong phiếu nhập).


-- NHIỆM VỤ 3: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 3.1. Thiết lập khóa chính (PRIMARY KEY).

-- 3.2. Thiết lập khóa ngoại (FOREIGN KEY).

-- 3.3. Kiểm tra số lượng tồn kho không được âm.

-- 3.4. Kiểm tra số lượng sản phẩm nhập hợp lệ.

-- 3.5. Thiết lập trạng thái phiếu nhập hàng.


-- NHIỆM VỤ 4: TẠO CÁC STORED PROCEDURE.

-- 4.1. Tạo Stored Procedure quản lý nhà cung cấp.

-- 4.2. Tạo Stored Procedure tạo phiếu nhập hàng.

-- 4.3. Tạo Stored Procedure xác nhận nhận hàng.

-- 4.4. Tạo Stored Procedure cập nhật số lượng tồn kho.

-- 4.5. Tạo Stored Procedure điều chỉnh tồn kho.

-- 4.6. Tạo Stored Procedure kiểm tra hàng sắp hết.


-- NHIỆM VỤ 5: TẠO VIEW VÀ DỮ LIỆU MẪU.

-- 5.1. Tạo View danh sách hàng tồn kho.

-- 5.2. Tạo View lịch sử nhập xuất kho.

-- 5.3. Tạo View danh sách sản phẩm sắp hết hàng.

-- 5.4. Thêm dữ liệu mẫu nhà cung cấp.

-- 5.5. Thêm dữ liệu mẫu kho hàng.


-- NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ.

-- 6.1. Kiểm tra nghiệp vụ nhập hàng.

-- 6.2. Kiểm tra cập nhật số lượng tồn kho.

-- 6.3. Kiểm tra điều chỉnh tồn kho.

-- 6.4. Kiểm tra trường hợp sản phẩm hết hàng.

-- 6.5. Kiểm tra Transaction khi nhập hàng.



-- =====================================================
-- THÀNH VIÊN 4: KHÁCH HÀNG, CẤU HÌNH VÀ BÁO CÁO
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG KHÁCH HÀNG VÀ QUẢN TRỊ.

-- 1.1. Tạo bảng Customers (Lưu thông tin khách hàng).

-- 1.2. Tạo bảng AuditLogs (Lưu nhật ký hoạt động hệ thống).

-- 1.3. Tạo bảng AppSettings (Lưu cấu hình hệ thống).


-- NHIỆM VỤ 2: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 2.1. Thiết lập khóa chính (PRIMARY KEY).

-- 2.2. Thiết lập khóa ngoại (FOREIGN KEY) nếu cần.

-- 2.3. Thiết lập UNIQUE cho các trường cần duy nhất.

-- 2.4. Kiểm tra dữ liệu khách hàng hợp lệ.


-- NHIỆM VỤ 3: TẠO CÁC STORED PROCEDURE.

-- 3.1. Tạo Stored Procedure thêm khách hàng.

-- 3.2. Tạo Stored Procedure cập nhật khách hàng.

-- 3.3. Tạo Stored Procedure tìm kiếm khách hàng.

-- 3.4. Tạo Stored Procedure xem lịch sử mua hàng của khách hàng.

-- 3.5. Tạo Stored Procedure thống kê khách hàng.


-- NHIỆM VỤ 4: TẠO CÁC VIEW BÁO CÁO.

-- 4.1. Tạo View tổng hợp doanh thu theo ngày.

-- 4.2. Tạo View tổng hợp doanh thu theo tháng.

-- 4.3. Tạo View thống kê sản phẩm bán chạy.

-- 4.4. Tạo View thống kê khách hàng mua nhiều nhất.

-- 4.5. Tạo View tổng hợp tình trạng tồn kho.

-- 4.6. Tạo dữ liệu phục vụ Dashboard.


-- NHIỆM VỤ 5: TẠO DỮ LIỆU MẪU.

-- 5.1. Thêm dữ liệu mẫu khách hàng.

-- 5.2. Thêm dữ liệu cấu hình cửa hàng.

-- 5.3. Kiểm tra dữ liệu nhật ký hoạt động.


-- NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ.

-- 6.1. Kiểm tra chức năng tìm kiếm khách hàng.

-- 6.2. Kiểm tra lịch sử mua hàng.

-- 6.3. Kiểm tra báo cáo doanh thu.

-- 6.4. Kiểm tra dữ liệu Dashboard.

-- LƯU Ý: Các báo cáo lấy dữ liệu từ bảng của cả nhóm.
-- Cần phối hợp với thành viên 2, 3 và 5 để thống nhất truy vấn.



-- =====================================================
-- THÀNH VIÊN 5: QUẢN LÝ ĐƠN HÀNG VÀ THANH TOÁN
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG ĐƠN HÀNG.

-- 1.1. Tạo bảng SalesOrders (Lưu thông tin đơn hàng bán).

-- 1.2. Tạo bảng SalesOrderItems (Lưu chi tiết sản phẩm trong đơn hàng).


-- NHIỆM VỤ 2: TẠO CÁC BẢNG THANH TOÁN VÀ HÓA ĐƠN.

-- 2.1. Tạo bảng Payments (Lưu thông tin thanh toán).

-- 2.2. Tạo bảng Invoices (Lưu thông tin hóa đơn).


-- NHIỆM VỤ 3: TẠO CÁC BẢNG ĐỔI TRẢ VÀ HOÀN TIỀN.

-- 3.1. Tạo bảng Returns (Lưu thông tin phiếu đổi trả).

-- 3.2. Tạo bảng ReturnItems (Lưu chi tiết sản phẩm đổi trả).


-- NHIỆM VỤ 4: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 4.1. Thiết lập khóa chính (PRIMARY KEY).

-- 4.2. Thiết lập khóa ngoại (FOREIGN KEY).

-- 4.3. Kiểm tra số lượng sản phẩm trong đơn hàng.

-- 4.4. Kiểm tra tổng tiền đơn hàng hợp lệ.

-- 4.5. Thiết lập trạng thái đơn hàng và thanh toán.


-- NHIỆM VỤ 5: TẠO CÁC STORED PROCEDURE.

-- 5.1. Tạo Stored Procedure tạo đơn hàng.

-- 5.2. Tạo Stored Procedure thêm sản phẩm vào đơn hàng.

-- 5.3. Tạo Stored Procedure tính tổng tiền đơn hàng.

-- 5.4. Tạo Stored Procedure xử lý thanh toán.

-- 5.5. Tạo Stored Procedure tạo hóa đơn.

-- 5.6. Tạo Stored Procedure xử lý đổi trả và hoàn tiền.


-- NHIỆM VỤ 6: TẠO VIEW VÀ DỮ LIỆU MẪU.

-- 6.1. Tạo View danh sách đơn hàng.

-- 6.2. Tạo View chi tiết đơn hàng.

-- 6.3. Tạo View lịch sử thanh toán.

-- 6.4. Thêm dữ liệu mẫu đơn hàng.

-- 6.5. Thêm dữ liệu mẫu thanh toán.


-- NHIỆM VỤ 7: KIỂM TRA VÀ KIỂM THỬ.

-- 7.1. Kiểm tra tạo đơn hàng.

-- 7.2. Kiểm tra tính tổng tiền.

-- 7.3. Kiểm tra thanh toán thành công và thất bại.

-- 7.4. Kiểm tra tạo hóa đơn.

-- 7.5. Kiểm tra đổi trả và hoàn tiền.

-- 7.6. Kiểm tra Transaction khi bán hàng.



-- =====================================================
-- PHẦN CUỐI: TÍCH HỢP VÀ KIỂM THỬ DATABASE
-- THÀNH VIÊN: CẢ NHÓM 5 NGƯỜI
-- =====================================================

-- NHIỆM VỤ 1: KIỂM TRA CẤU TRÚC DATABASE.

-- 1.1. Kiểm tra danh sách các bảng.

-- 1.2. Kiểm tra khóa chính và khóa ngoại.

-- 1.3. Kiểm tra các mối quan hệ giữa các bảng.

-- 1.4. Kiểm tra kiểu dữ liệu và các ràng buộc.


-- NHIỆM VỤ 2: KIỂM TRA NGHIỆP VỤ TOÀN HỆ THỐNG.

-- 2.1. Kiểm tra đăng nhập và phân quyền.

-- 2.2. Kiểm tra quản lý sản phẩm.

-- 2.3. Kiểm tra nhập hàng và tồn kho.

-- 2.4. Kiểm tra quản lý khách hàng.

-- 2.5. Kiểm tra tạo đơn hàng và thanh toán.

-- 2.6. Kiểm tra báo cáo doanh thu.


-- NHIỆM VỤ 3: KIỂM TRA KẾT NỐI VỚI WINDOWS FORMS.

-- 3.1. Kiểm tra kết nối SQL Server bằng C#.

-- 3.2. Kiểm tra chức năng hiển thị dữ liệu.

-- 3.3. Kiểm tra chức năng thêm dữ liệu.

-- 3.4. Kiểm tra chức năng cập nhật dữ liệu.

-- 3.5. Kiểm tra chức năng tìm kiếm dữ liệu.

-- 3.6. Kiểm tra xử lý lỗi khi kết nối Database.


-- NHIỆM VỤ 4: SAO LƯU VÀ PHỤC HỒI DATABASE.

-- 4.1. Tạo bản Backup Database.

-- 4.2. Kiểm tra khả năng Restore Database.

-- 4.3. Tổng hợp và bàn giao toàn bộ SQL Script.


-- =====================================================
-- KẾT THÚC PHẦN XÂY DỰNG DATABASE QUẢN LÝ BÁN HÀNG
-- =====================================================