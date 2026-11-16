-- =====================================================
-- THÀNH VIÊN 4: KHÁCH HÀNG, CẤU HÌNH VÀ BÁO CÁO
-- SQL Server (T-SQL) - chạy được nhiều lần (re-runnable)
-- =====================================================
-- GIẢ ĐỊNH về bảng của các thành viên khác (nếu chưa có, script sẽ tự tạo bản tối thiểu):
--   Products(ProductID, ProductName, Price, StockQuantity, MinStockLevel, IsActive)
--   Orders(OrderID, CustomerID, OrderDate, TotalAmount, Status)   -- Status = N'Completed' là đơn đã hoàn thành
--   OrderDetails(OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
-- Nếu tên cột/bảng của nhóm khác tên, chỉ cần Find & Replace trong file này.
-- =====================================================

IF DB_ID(N'StoreManagementDB') IS NULL
    CREATE DATABASE StoreManagementDB;
GO
USE StoreManagementDB;
GO

-- =====================================================
-- NHIỆM VỤ 1 + 2: TẠO BẢNG VÀ RÀNG BUỘC
-- =====================================================

-- 1.1. Bảng Customers
IF OBJECT_ID(N'dbo.Customers', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Customers
    (
        CustomerID    INT IDENTITY(1,1) NOT NULL,
        FullName      NVARCHAR(100)  NOT NULL,
        Phone         VARCHAR(15)    NOT NULL,
        Email         VARCHAR(100)   NULL,
        Address       NVARCHAR(255)  NULL,
        Gender        NVARCHAR(10)   NULL,
        DateOfBirth   DATE           NULL,
        CustomerType  NVARCHAR(20)   NOT NULL CONSTRAINT DF_Customers_Type DEFAULT N'Thường',
        LoyaltyPoints INT            NOT NULL CONSTRAINT DF_Customers_Points DEFAULT 0,
        IsActive      BIT            NOT NULL CONSTRAINT DF_Customers_Active DEFAULT 1,
        CreatedAt     DATETIME2      NOT NULL CONSTRAINT DF_Customers_Created DEFAULT SYSDATETIME(),
        UpdatedAt     DATETIME2      NULL,

        -- 2.1. Khóa chính
        CONSTRAINT PK_Customers PRIMARY KEY (CustomerID),

        -- 2.3. Duy nhất
        CONSTRAINT UQ_Customers_Phone UNIQUE (Phone),

        -- 2.4. Kiểm tra dữ liệu hợp lệ
        CONSTRAINT CK_Customers_FullName CHECK (LEN(LTRIM(RTRIM(FullName))) > 0),
        CONSTRAINT CK_Customers_Phone    CHECK (Phone NOT LIKE '%[^0-9]%' AND LEN(Phone) BETWEEN 9 AND 11),
        CONSTRAINT CK_Customers_Email    CHECK (Email IS NULL OR Email LIKE '%_@__%.__%'),
        CONSTRAINT CK_Customers_Gender   CHECK (Gender IS NULL OR Gender IN (N'Nam', N'Nữ', N'Khác')),
        CONSTRAINT CK_Customers_Type     CHECK (CustomerType IN (N'Thường', N'Thân thiết', N'VIP')),
        CONSTRAINT CK_Customers_Points   CHECK (LoyaltyPoints >= 0),
        CONSTRAINT CK_Customers_DOB      CHECK (DateOfBirth IS NULL OR DateOfBirth >= '1900-01-01')
    );
END
GO

-- Email duy nhất (cho phép nhiều khách không có email)
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_Customers_Email' AND object_id = OBJECT_ID(N'dbo.Customers'))
    CREATE UNIQUE INDEX UX_Customers_Email ON dbo.Customers(Email) WHERE Email IS NOT NULL;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_Customers_FullName' AND object_id = OBJECT_ID(N'dbo.Customers'))
    CREATE INDEX IX_Customers_FullName ON dbo.Customers(FullName);
GO

-- 1.2. Bảng AuditLogs
IF OBJECT_ID(N'dbo.AuditLogs', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AuditLogs
    (
        LogID       BIGINT IDENTITY(1,1) NOT NULL,
        UserID      INT            NULL,           -- người thực hiện (không ràng buộc FK để tránh phụ thuộc bảng Users)
        Action      NVARCHAR(50)   NOT NULL,       -- INSERT / UPDATE / DELETE / LOGIN ...
        TableName   NVARCHAR(100)  NULL,
        RecordID    NVARCHAR(50)   NULL,
        OldValue    NVARCHAR(MAX)  NULL,
        NewValue    NVARCHAR(MAX)  NULL,
        Description NVARCHAR(500)  NULL,
        IPAddress   VARCHAR(45)    NULL,
        CreatedAt   DATETIME2      NOT NULL CONSTRAINT DF_AuditLogs_Created DEFAULT SYSDATETIME(),
        CONSTRAINT PK_AuditLogs PRIMARY KEY (LogID),
        CONSTRAINT CK_AuditLogs_Action CHECK (LEN(LTRIM(RTRIM(Action))) > 0)
    );
    CREATE INDEX IX_AuditLogs_CreatedAt ON dbo.AuditLogs(CreatedAt DESC);
    CREATE INDEX IX_AuditLogs_Table ON dbo.AuditLogs(TableName, RecordID);
END
GO

-- 1.3. Bảng AppSettings
IF OBJECT_ID(N'dbo.AppSettings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AppSettings
    (
        SettingKey   NVARCHAR(100) NOT NULL,
        SettingValue NVARCHAR(500) NULL,
        Description  NVARCHAR(255) NULL,
        UpdatedAt    DATETIME2     NOT NULL CONSTRAINT DF_AppSettings_Updated DEFAULT SYSDATETIME(),
        CONSTRAINT PK_AppSettings PRIMARY KEY (SettingKey),
        CONSTRAINT CK_AppSettings_Key CHECK (LEN(LTRIM(RTRIM(SettingKey))) > 0)
    );
END
GO

-- Bảng của thành viên khác: chỉ tạo bản tối thiểu nếu CHƯA tồn tại (để script chạy độc lập)
IF OBJECT_ID(N'dbo.Products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Products
    (
        ProductID     INT IDENTITY(1,1) PRIMARY KEY,
        ProductName   NVARCHAR(150) NOT NULL,
        Price         DECIMAL(18,2) NOT NULL CHECK (Price >= 0),
        StockQuantity INT NOT NULL DEFAULT 0 CHECK (StockQuantity >= 0),
        MinStockLevel INT NOT NULL DEFAULT 10,
        IsActive      BIT NOT NULL DEFAULT 1
    );
END
GO
IF OBJECT_ID(N'dbo.Orders', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Orders
    (
        OrderID     INT IDENTITY(1,1) PRIMARY KEY,
        CustomerID  INT NULL,
        OrderDate   DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
        TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        Status      NVARCHAR(20) NOT NULL DEFAULT N'Completed'
    );
END
GO
IF OBJECT_ID(N'dbo.OrderDetails', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.OrderDetails
    (
        OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
        OrderID       INT NOT NULL REFERENCES dbo.Orders(OrderID),
        ProductID     INT NOT NULL REFERENCES dbo.Products(ProductID),
        Quantity      INT NOT NULL CHECK (Quantity > 0),
        UnitPrice     DECIMAL(18,2) NOT NULL CHECK (UnitPrice >= 0)
    );
END
GO

-- 2.2. Khóa ngoại: Orders.CustomerID -> Customers.CustomerID
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_Orders_Customers')
    ALTER TABLE dbo.Orders
        ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID);
GO

-- =====================================================
-- NHIỆM VỤ 3: STORED PROCEDURE
-- =====================================================

-- 3.1. Thêm khách hàng
CREATE OR ALTER PROCEDURE dbo.sp_AddCustomer
    @FullName      NVARCHAR(100),
    @Phone         VARCHAR(15),
    @Email         VARCHAR(100)  = NULL,
    @Address       NVARCHAR(255) = NULL,
    @Gender        NVARCHAR(10)  = NULL,
    @DateOfBirth   DATE          = NULL,
    @UserID        INT           = NULL,
    @NewCustomerID INT           = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @FullName = LTRIM(RTRIM(@FullName));
        SET @Phone    = LTRIM(RTRIM(@Phone));
        SET @Email    = NULLIF(LTRIM(RTRIM(@Email)), '');

        IF @FullName IS NULL OR @FullName = N''
            THROW 50001, N'Họ tên khách hàng không được để trống.', 1;
        IF @Phone IS NULL OR @Phone LIKE '%[^0-9]%' OR LEN(@Phone) NOT BETWEEN 9 AND 11
            THROW 50002, N'Số điện thoại không hợp lệ (chỉ gồm 9-11 chữ số).', 1;
        IF @Email IS NOT NULL AND @Email NOT LIKE '%_@__%.__%'
            THROW 50003, N'Email không hợp lệ.', 1;
        IF EXISTS (SELECT 1 FROM dbo.Customers WHERE Phone = @Phone)
            THROW 50004, N'Số điện thoại đã tồn tại.', 1;
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Customers WHERE Email = @Email)
            THROW 50005, N'Email đã tồn tại.', 1;

        INSERT INTO dbo.Customers (FullName, Phone, Email, Address, Gender, DateOfBirth)
        VALUES (@FullName, @Phone, @Email, @Address, @Gender, @DateOfBirth);

        SET @NewCustomerID = SCOPE_IDENTITY();

        INSERT INTO dbo.AuditLogs (UserID, Action, TableName, RecordID, NewValue, Description)
        VALUES (@UserID, N'INSERT', N'Customers', CAST(@NewCustomerID AS NVARCHAR(50)),
                CONCAT(N'FullName=', @FullName, N'; Phone=', @Phone, N'; Email=', ISNULL(@Email, N'')),
                N'Thêm khách hàng mới');

        SELECT @NewCustomerID AS CustomerID, N'Thêm khách hàng thành công' AS Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- 3.2. Cập nhật khách hàng
CREATE OR ALTER PROCEDURE dbo.sp_UpdateCustomer
    @CustomerID   INT,
    @FullName     NVARCHAR(100),
    @Phone        VARCHAR(15),
    @Email        VARCHAR(100)  = NULL,
    @Address      NVARCHAR(255) = NULL,
    @Gender       NVARCHAR(10)  = NULL,
    @DateOfBirth  DATE          = NULL,
    @CustomerType NVARCHAR(20)  = NULL,   -- NULL = giữ nguyên
    @IsActive     BIT           = NULL,   -- NULL = giữ nguyên
    @UserID       INT           = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        SET @FullName = LTRIM(RTRIM(@FullName));
        SET @Phone    = LTRIM(RTRIM(@Phone));
        SET @Email    = NULLIF(LTRIM(RTRIM(@Email)), '');

        IF NOT EXISTS (SELECT 1 FROM dbo.Customers WHERE CustomerID = @CustomerID)
            THROW 50010, N'Không tìm thấy khách hàng.', 1;
        IF @FullName IS NULL OR @FullName = N''
            THROW 50001, N'Họ tên khách hàng không được để trống.', 1;
        IF @Phone IS NULL OR @Phone LIKE '%[^0-9]%' OR LEN(@Phone) NOT BETWEEN 9 AND 11
            THROW 50002, N'Số điện thoại không hợp lệ (chỉ gồm 9-11 chữ số).', 1;
        IF @Email IS NOT NULL AND @Email NOT LIKE '%_@__%.__%'
            THROW 50003, N'Email không hợp lệ.', 1;
        IF EXISTS (SELECT 1 FROM dbo.Customers WHERE Phone = @Phone AND CustomerID <> @CustomerID)
            THROW 50004, N'Số điện thoại đã được khách hàng khác sử dụng.', 1;
        IF @Email IS NOT NULL AND EXISTS (SELECT 1 FROM dbo.Customers WHERE Email = @Email AND CustomerID <> @CustomerID)
            THROW 50005, N'Email đã được khách hàng khác sử dụng.', 1;

        DECLARE @Old NVARCHAR(MAX);
        SELECT @Old = CONCAT(N'FullName=', FullName, N'; Phone=', Phone, N'; Email=', ISNULL(Email, N''),
                             N'; Type=', CustomerType, N'; Active=', IsActive)
        FROM dbo.Customers WHERE CustomerID = @CustomerID;

        UPDATE dbo.Customers
        SET FullName     = @FullName,
            Phone        = @Phone,
            Email        = @Email,
            Address      = @Address,
            Gender       = @Gender,
            DateOfBirth  = @DateOfBirth,
            CustomerType = ISNULL(@CustomerType, CustomerType),
            IsActive     = ISNULL(@IsActive, IsActive),
            UpdatedAt    = SYSDATETIME()
        WHERE CustomerID = @CustomerID;

        INSERT INTO dbo.AuditLogs (UserID, Action, TableName, RecordID, OldValue, NewValue, Description)
        SELECT @UserID, N'UPDATE', N'Customers', CAST(@CustomerID AS NVARCHAR(50)), @Old,
               CONCAT(N'FullName=', FullName, N'; Phone=', Phone, N'; Email=', ISNULL(Email, N''),
                      N'; Type=', CustomerType, N'; Active=', IsActive),
               N'Cập nhật khách hàng'
        FROM dbo.Customers WHERE CustomerID = @CustomerID;

        SELECT N'Cập nhật khách hàng thành công' AS Message;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- 3.3. Tìm kiếm khách hàng (theo tên / SĐT / email, có phân trang)
CREATE OR ALTER PROCEDURE dbo.sp_SearchCustomers
    @Keyword      NVARCHAR(100) = NULL,
    @CustomerType NVARCHAR(20)  = NULL,
    @OnlyActive   BIT           = 1,
    @PageNumber   INT           = 1,
    @PageSize     INT           = 20
AS
BEGIN
    SET NOCOUNT ON;
    SET @Keyword = NULLIF(LTRIM(RTRIM(@Keyword)), N'');
    IF @PageNumber < 1 SET @PageNumber = 1;
    IF @PageSize   < 1 SET @PageSize   = 20;

    SELECT c.CustomerID, c.FullName, c.Phone, c.Email, c.Address, c.Gender, c.DateOfBirth,
           c.CustomerType, c.LoyaltyPoints, c.IsActive, c.CreatedAt,
           COUNT(*) OVER() AS TotalRows
    FROM dbo.Customers c
    WHERE (@Keyword IS NULL
           OR c.FullName LIKE N'%' + @Keyword + N'%'
           OR c.Phone    LIKE '%' + @Keyword + '%'
           OR c.Email    LIKE '%' + @Keyword + '%')
      AND (@CustomerType IS NULL OR c.CustomerType = @CustomerType)
      AND (@OnlyActive = 0 OR c.IsActive = 1)
    ORDER BY c.FullName, c.CustomerID
    OFFSET (@PageNumber - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

-- 3.4. Lịch sử mua hàng của khách hàng
CREATE OR ALTER PROCEDURE dbo.sp_GetCustomerPurchaseHistory
    @CustomerID INT,
    @FromDate   DATE = NULL,
    @ToDate     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Customers WHERE CustomerID = @CustomerID)
        THROW 50010, N'Không tìm thấy khách hàng.', 1;

    -- Kết quả 1: chi tiết từng đơn hàng
    SELECT o.OrderID, o.OrderDate, o.Status,
           p.ProductName, od.Quantity, od.UnitPrice,
           od.Quantity * od.UnitPrice AS LineTotal,
           o.TotalAmount AS OrderTotal
    FROM dbo.Orders o
    JOIN dbo.OrderDetails od ON od.OrderID = o.OrderID
    JOIN dbo.Products p      ON p.ProductID = od.ProductID
    WHERE o.CustomerID = @CustomerID
      AND (@FromDate IS NULL OR CAST(o.OrderDate AS DATE) >= @FromDate)
      AND (@ToDate   IS NULL OR CAST(o.OrderDate AS DATE) <= @ToDate)
    ORDER BY o.OrderDate DESC, o.OrderID DESC;

    -- Kết quả 2: tổng hợp
    SELECT c.CustomerID, c.FullName, c.Phone,
           COUNT(o.OrderID)                 AS TotalOrders,
           ISNULL(SUM(o.TotalAmount), 0)    AS TotalSpent,
           MAX(o.OrderDate)                 AS LastOrderDate
    FROM dbo.Customers c
    LEFT JOIN dbo.Orders o
           ON o.CustomerID = c.CustomerID
          AND o.Status = N'Completed'
          AND (@FromDate IS NULL OR CAST(o.OrderDate AS DATE) >= @FromDate)
          AND (@ToDate   IS NULL OR CAST(o.OrderDate AS DATE) <= @ToDate)
    WHERE c.CustomerID = @CustomerID
    GROUP BY c.CustomerID, c.FullName, c.Phone;
END
GO

-- 3.5. Thống kê khách hàng
CREATE OR ALTER PROCEDURE dbo.sp_GetCustomerStatistics
AS
BEGIN
    SET NOCOUNT ON;

    -- Kết quả 1: số liệu tổng quan
    SELECT
        COUNT(*)                                                                       AS TotalCustomers,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END)                                  AS ActiveCustomers,
        SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END)                                  AS InactiveCustomers,
        SUM(CASE WHEN YEAR(CreatedAt) = YEAR(GETDATE())
                  AND MONTH(CreatedAt) = MONTH(GETDATE()) THEN 1 ELSE 0 END)           AS NewCustomersThisMonth,
        (SELECT COUNT(DISTINCT CustomerID) FROM dbo.Orders
          WHERE Status = N'Completed' AND CustomerID IS NOT NULL)                      AS CustomersWithPurchase,
        (SELECT ISNULL(SUM(TotalAmount), 0) FROM dbo.Orders
          WHERE Status = N'Completed' AND CustomerID IS NOT NULL)                      AS RevenueFromCustomers
    FROM dbo.Customers;

    -- Kết quả 2: theo loại khách hàng
    SELECT CustomerType, COUNT(*) AS Total
    FROM dbo.Customers
    GROUP BY CustomerType
    ORDER BY Total DESC;

    -- Kết quả 3: theo giới tính
    SELECT ISNULL(Gender, N'Chưa rõ') AS Gender, COUNT(*) AS Total
    FROM dbo.Customers
    GROUP BY ISNULL(Gender, N'Chưa rõ');
END
GO

-- =====================================================
-- NHIỆM VỤ 4: VIEW BÁO CÁO
-- (Chỉ tính các đơn có Status = N'Completed')
-- =====================================================

-- 4.1. Doanh thu theo ngày
CREATE OR ALTER VIEW dbo.vw_RevenueByDay
AS
SELECT CAST(o.OrderDate AS DATE)         AS OrderDay,
       COUNT(o.OrderID)                  AS TotalOrders,
       SUM(o.TotalAmount)                AS Revenue,
       AVG(o.TotalAmount)                AS AvgOrderValue
FROM dbo.Orders o
WHERE o.Status = N'Completed'
GROUP BY CAST(o.OrderDate AS DATE);
GO

-- 4.2. Doanh thu theo tháng
CREATE OR ALTER VIEW dbo.vw_RevenueByMonth
AS
SELECT YEAR(o.OrderDate)                 AS [Year],
       MONTH(o.OrderDate)                AS [Month],
       COUNT(o.OrderID)                  AS TotalOrders,
       SUM(o.TotalAmount)                AS Revenue,
       AVG(o.TotalAmount)                AS AvgOrderValue
FROM dbo.Orders o
WHERE o.Status = N'Completed'
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate);
GO

-- 4.3. Sản phẩm bán chạy
CREATE OR ALTER VIEW dbo.vw_TopSellingProducts
AS
SELECT p.ProductID, p.ProductName,
       SUM(od.Quantity)                  AS TotalQuantitySold,
       SUM(od.Quantity * od.UnitPrice)   AS TotalRevenue,
       COUNT(DISTINCT o.OrderID)         AS TotalOrders,
       RANK() OVER (ORDER BY SUM(od.Quantity) DESC) AS SalesRank
FROM dbo.OrderDetails od
JOIN dbo.Orders o   ON o.OrderID = od.OrderID AND o.Status = N'Completed'
JOIN dbo.Products p ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName;
GO

-- 4.4. Khách hàng mua nhiều nhất
CREATE OR ALTER VIEW dbo.vw_TopCustomers
AS
SELECT c.CustomerID, c.FullName, c.Phone, c.CustomerType,
       COUNT(o.OrderID)                  AS TotalOrders,
       SUM(o.TotalAmount)                AS TotalSpent,
       MAX(o.OrderDate)                  AS LastOrderDate,
       RANK() OVER (ORDER BY SUM(o.TotalAmount) DESC) AS SpendingRank
FROM dbo.Customers c
JOIN dbo.Orders o ON o.CustomerID = c.CustomerID AND o.Status = N'Completed'
GROUP BY c.CustomerID, c.FullName, c.Phone, c.CustomerType;
GO

-- 4.5. Tình trạng tồn kho
CREATE OR ALTER VIEW dbo.vw_InventoryStatus
AS
SELECT p.ProductID, p.ProductName, p.Price,
       p.StockQuantity, p.MinStockLevel,
       p.StockQuantity * p.Price AS StockValue,
       CASE WHEN p.StockQuantity = 0                THEN N'Hết hàng'
            WHEN p.StockQuantity <= p.MinStockLevel THEN N'Sắp hết'
            ELSE N'Còn hàng' END AS StockStatus
FROM dbo.Products p
WHERE p.IsActive = 1;
GO

-- 4.6. Dữ liệu Dashboard
-- (a) Số liệu tổng quan (1 dòng)
CREATE OR ALTER VIEW dbo.vw_DashboardSummary
AS
SELECT
    (SELECT ISNULL(SUM(TotalAmount), 0) FROM dbo.Orders
      WHERE Status = N'Completed' AND CAST(OrderDate AS DATE) = CAST(GETDATE() AS DATE))   AS RevenueToday,
    (SELECT COUNT(*) FROM dbo.Orders
      WHERE Status = N'Completed' AND CAST(OrderDate AS DATE) = CAST(GETDATE() AS DATE))   AS OrdersToday,
    (SELECT ISNULL(SUM(TotalAmount), 0) FROM dbo.Orders
      WHERE Status = N'Completed' AND YEAR(OrderDate) = YEAR(GETDATE())
        AND MONTH(OrderDate) = MONTH(GETDATE()))                                           AS RevenueThisMonth,
    (SELECT COUNT(*) FROM dbo.Orders
      WHERE Status = N'Completed' AND YEAR(OrderDate) = YEAR(GETDATE())
        AND MONTH(OrderDate) = MONTH(GETDATE()))                                           AS OrdersThisMonth,
    (SELECT COUNT(*) FROM dbo.Customers WHERE IsActive = 1)                                AS TotalCustomers,
    (SELECT COUNT(*) FROM dbo.Customers
      WHERE YEAR(CreatedAt) = YEAR(GETDATE()) AND MONTH(CreatedAt) = MONTH(GETDATE()))     AS NewCustomersThisMonth,
    (SELECT COUNT(*) FROM dbo.Products WHERE IsActive = 1)                                 AS TotalProducts,
    (SELECT COUNT(*) FROM dbo.vw_InventoryStatus WHERE StockStatus = N'Sắp hết')           AS LowStockProducts,
    (SELECT COUNT(*) FROM dbo.vw_InventoryStatus WHERE StockStatus = N'Hết hàng')          AS OutOfStockProducts,
    (SELECT ISNULL(SUM(StockValue), 0) FROM dbo.vw_InventoryStatus)                        AS TotalStockValue;
GO

-- (b) Top 5 sản phẩm bán chạy cho Dashboard
CREATE OR ALTER VIEW dbo.vw_DashboardTopProducts
AS
SELECT TOP (5) ProductID, ProductName, TotalQuantitySold, TotalRevenue
FROM dbo.vw_TopSellingProducts
ORDER BY TotalQuantitySold DESC;
GO

-- (c) Doanh thu 7 ngày gần nhất (đủ 7 ngày, ngày không bán = 0) cho biểu đồ
CREATE OR ALTER VIEW dbo.vw_DashboardRevenue7Days
AS
SELECT d.Day AS OrderDay,
       ISNULL(r.TotalOrders, 0) AS TotalOrders,
       ISNULL(r.Revenue, 0)     AS Revenue
FROM (VALUES (CAST(GETDATE() AS DATE)),
             (CAST(DATEADD(DAY, -1, GETDATE()) AS DATE)),
             (CAST(DATEADD(DAY, -2, GETDATE()) AS DATE)),
             (CAST(DATEADD(DAY, -3, GETDATE()) AS DATE)),
             (CAST(DATEADD(DAY, -4, GETDATE()) AS DATE)),
             (CAST(DATEADD(DAY, -5, GETDATE()) AS DATE)),
             (CAST(DATEADD(DAY, -6, GETDATE()) AS DATE))) AS d(Day)
LEFT JOIN dbo.vw_RevenueByDay r ON r.OrderDay = d.Day;
GO

-- (d) Stored procedure gom toàn bộ dữ liệu Dashboard
CREATE OR ALTER PROCEDURE dbo.sp_GetDashboardData
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.vw_DashboardSummary;                                  -- 1: tổng quan
    SELECT * FROM dbo.vw_DashboardRevenue7Days ORDER BY OrderDay;           -- 2: doanh thu 7 ngày
    SELECT * FROM dbo.vw_DashboardTopProducts ORDER BY TotalQuantitySold DESC; -- 3: top sản phẩm
    SELECT TOP (5) * FROM dbo.vw_TopCustomers ORDER BY TotalSpent DESC;     -- 4: top khách hàng
    SELECT TOP (10) ProductID, ProductName, StockQuantity, MinStockLevel, StockStatus
    FROM dbo.vw_InventoryStatus
    WHERE StockStatus <> N'Còn hàng'
    ORDER BY StockQuantity;                                                  -- 5: cảnh báo tồn kho
END
GO

-- =====================================================
-- NHIỆM VỤ 5: DỮ LIỆU MẪU
-- =====================================================

-- 5.1. Dữ liệu mẫu khách hàng (bỏ qua nếu SĐT đã tồn tại)
INSERT INTO dbo.Customers (FullName, Phone, Email, Address, Gender, DateOfBirth, CustomerType, LoyaltyPoints)
SELECT v.FullName, v.Phone, v.Email, v.Address, v.Gender, v.DateOfBirth, v.CustomerType, v.LoyaltyPoints
FROM (VALUES
    (N'Nguyễn Văn An',   '0901234561', 'an.nguyen@example.com',   N'12 Lê Lợi, Quận 1, TP.HCM',        N'Nam', CAST('1990-03-15' AS DATE), N'VIP',        500),
    (N'Trần Thị Bình',   '0901234562', 'binh.tran@example.com',   N'45 Nguyễn Huệ, Quận 1, TP.HCM',    N'Nữ',  CAST('1992-07-20' AS DATE), N'Thân thiết', 220),
    (N'Lê Hoàng Cường',  '0901234563', 'cuong.le@example.com',    N'78 Hai Bà Trưng, Hà Nội',          N'Nam', CAST('1985-11-02' AS DATE), N'Thường',      40),
    (N'Phạm Thu Dung',   '0901234564', 'dung.pham@example.com',   N'9 Trần Phú, Đà Nẵng',              N'Nữ',  CAST('1995-01-30' AS DATE), N'Thường',      60),
    (N'Hoàng Minh Đức',  '0901234565', 'duc.hoang@example.com',   N'23 Pasteur, Quận 3, TP.HCM',       N'Nam', CAST('1988-09-09' AS DATE), N'Thân thiết', 180),
    (N'Vũ Ngọc Hà',      '0901234566', 'ha.vu@example.com',       N'101 Láng Hạ, Hà Nội',              N'Nữ',  CAST('1993-05-12' AS DATE), N'Thường',      25),
    (N'Đặng Quốc Huy',   '0901234567', NULL,                      N'5 Lý Thường Kiệt, Huế',            N'Nam', CAST('1991-12-25' AS DATE), N'Thường',       0),
    (N'Bùi Khánh Linh',  '0901234568', 'linh.bui@example.com',    N'66 Võ Văn Tần, Quận 3, TP.HCM',    N'Nữ',  CAST('1997-04-18' AS DATE), N'VIP',        410),
    (N'Ngô Thanh Sơn',   '0901234569', 'son.ngo@example.com',     N'88 Điện Biên Phủ, Hải Phòng',      N'Nam', CAST('1987-08-08' AS DATE), N'Thường',      15),
    (N'Đỗ Mai Phương',   '0901234570', 'phuong.do@example.com',   N'34 Bạch Đằng, Cần Thơ',            N'Nữ',  CAST('1994-02-14' AS DATE), N'Thân thiết', 150)
) AS v(FullName, Phone, Email, Address, Gender, DateOfBirth, CustomerType, LoyaltyPoints)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Customers c WHERE c.Phone = v.Phone);
GO

-- 5.2. Dữ liệu cấu hình cửa hàng
MERGE dbo.AppSettings AS t
USING (VALUES
    (N'StoreName',          N'Cửa hàng Tạp hóa ABC',            N'Tên cửa hàng'),
    (N'StoreAddress',       N'123 Nguyễn Trãi, Hà Nội',         N'Địa chỉ cửa hàng'),
    (N'StorePhone',         N'0241234567',                      N'Số điện thoại cửa hàng'),
    (N'StoreEmail',         N'contact@cuahangabc.vn',           N'Email liên hệ'),
    (N'Currency',           N'VND',                             N'Đơn vị tiền tệ'),
    (N'TaxRate',            N'8',                               N'Thuế VAT (%)'),
    (N'LowStockThreshold',  N'10',                              N'Ngưỡng cảnh báo sắp hết hàng mặc định'),
    (N'PointsPerAmount',    N'10000',                           N'Số tiền (VND) để tích 1 điểm'),
    (N'ReceiptFooter',      N'Cảm ơn quý khách, hẹn gặp lại!',  N'Lời cảm ơn cuối hóa đơn'),
    (N'DateFormat',         N'dd/MM/yyyy',                      N'Định dạng ngày hiển thị')
) AS s(SettingKey, SettingValue, Description)
ON t.SettingKey = s.SettingKey
WHEN NOT MATCHED THEN
    INSERT (SettingKey, SettingValue, Description) VALUES (s.SettingKey, s.SettingValue, s.Description);
GO

-- Dữ liệu mẫu sản phẩm/đơn hàng CHỈ để test báo cáo (chỉ chèn khi các bảng đang trống)
IF NOT EXISTS (SELECT 1 FROM dbo.Orders) AND NOT EXISTS (SELECT 1 FROM dbo.Products)
BEGIN
    INSERT INTO dbo.Products (ProductName, Price, StockQuantity, MinStockLevel) VALUES
        (N'Nước suối 500ml',   5000, 200, 50),
        (N'Mì gói Hảo Hảo',    4500,   8, 30),
        (N'Sữa tươi 1L',      32000,   0, 20),
        (N'Bánh quy bơ',      25000,  60, 15),
        (N'Dầu ăn 1L',        55000,   5, 10);

    DECLARE @c1 INT = (SELECT CustomerID FROM dbo.Customers WHERE Phone = '0901234561');
    DECLARE @c2 INT = (SELECT CustomerID FROM dbo.Customers WHERE Phone = '0901234562');
    DECLARE @c3 INT = (SELECT CustomerID FROM dbo.Customers WHERE Phone = '0901234568');

    INSERT INTO dbo.Orders (CustomerID, OrderDate, Status) VALUES
        (@c1, DATEADD(DAY,  0, SYSDATETIME()), N'Completed'),
        (@c1, DATEADD(DAY, -1, SYSDATETIME()), N'Completed'),
        (@c2, DATEADD(DAY, -2, SYSDATETIME()), N'Completed'),
        (@c3, DATEADD(DAY, -3, SYSDATETIME()), N'Completed'),
        (@c3, DATEADD(DAY, -5, SYSDATETIME()), N'Completed'),
        (@c2, DATEADD(DAY, -6, SYSDATETIME()), N'Cancelled');

    -- Mỗi đơn có 2 sản phẩm
    INSERT INTO dbo.OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    SELECT o.OrderID, p.ProductID, 1 + (o.OrderID + p.ProductID) % 4, p.Price
    FROM dbo.Orders o
    JOIN dbo.Products p ON p.ProductID IN (((o.OrderID - 1) % 5) + 1, (o.OrderID % 5) + 1);

    UPDATE o
    SET TotalAmount = x.Total
    FROM dbo.Orders o
    JOIN (SELECT OrderID, SUM(Quantity * UnitPrice) AS Total FROM dbo.OrderDetails GROUP BY OrderID) x
      ON x.OrderID = o.OrderID;
END
GO

-- 5.3. Kiểm tra nhật ký hoạt động (thêm log mẫu nếu bảng còn trống)
IF NOT EXISTS (SELECT 1 FROM dbo.AuditLogs)
    INSERT INTO dbo.AuditLogs (UserID, Action, TableName, RecordID, Description)
    VALUES (NULL, N'SYSTEM', N'AppSettings', NULL, N'Khởi tạo dữ liệu cấu hình hệ thống');
GO

SELECT TOP (20) LogID, UserID, Action, TableName, RecordID, Description, CreatedAt
FROM dbo.AuditLogs
ORDER BY LogID DESC;
GO

-- =====================================================
-- NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ
-- =====================================================

-- 6.1. Kiểm tra tìm kiếm khách hàng
PRINT N'--- 6.1 Tìm theo tên ---';
EXEC dbo.sp_SearchCustomers @Keyword = N'Nguyễn';
PRINT N'--- 6.1 Tìm theo SĐT ---';
EXEC dbo.sp_SearchCustomers @Keyword = '090123456';
PRINT N'--- 6.1 Lọc khách VIP ---';
EXEC dbo.sp_SearchCustomers @CustomerType = N'VIP';
GO

-- Kiểm tra thêm / cập nhật / bắt lỗi trùng SĐT
DECLARE @NewID INT;
EXEC dbo.sp_AddCustomer @FullName = N'Khách Test', @Phone = '0988000111',
                        @Email = 'test.kh@example.com', @NewCustomerID = @NewID OUTPUT;
EXEC dbo.sp_UpdateCustomer @CustomerID = @NewID, @FullName = N'Khách Test (đã sửa)',
                           @Phone = '0988000111', @Email = 'test.kh@example.com',
                           @Address = N'Địa chỉ mới', @CustomerType = N'Thân thiết';
BEGIN TRY
    EXEC dbo.sp_AddCustomer @FullName = N'Trùng SĐT', @Phone = '0988000111';  -- phải báo lỗi
END TRY
BEGIN CATCH
    PRINT N'Lỗi mong đợi: ' + ERROR_MESSAGE();
END CATCH
GO

-- 6.2. Kiểm tra lịch sử mua hàng
PRINT N'--- 6.2 Lịch sử mua hàng ---';
DECLARE @TestCustomer INT = (SELECT CustomerID FROM dbo.Customers WHERE Phone = '0901234561');
EXEC dbo.sp_GetCustomerPurchaseHistory @CustomerID = @TestCustomer;
EXEC dbo.sp_GetCustomerStatistics;
GO

-- 6.3. Kiểm tra báo cáo doanh thu
PRINT N'--- 6.3 Doanh thu theo ngày ---';
SELECT * FROM dbo.vw_RevenueByDay ORDER BY OrderDay DESC;
PRINT N'--- 6.3 Doanh thu theo tháng ---';
SELECT * FROM dbo.vw_RevenueByMonth ORDER BY [Year] DESC, [Month] DESC;
PRINT N'--- 6.3 Sản phẩm bán chạy ---';
SELECT * FROM dbo.vw_TopSellingProducts ORDER BY SalesRank;
PRINT N'--- 6.3 Khách hàng mua nhiều nhất ---';
SELECT * FROM dbo.vw_TopCustomers ORDER BY SpendingRank;
PRINT N'--- 6.3 Tình trạng tồn kho ---';
SELECT * FROM dbo.vw_InventoryStatus ORDER BY StockQuantity;
GO

-- Đối chiếu: tổng doanh thu theo view phải bằng tổng đơn hoàn thành
SELECT (SELECT ISNULL(SUM(Revenue), 0) FROM dbo.vw_RevenueByDay)                              AS RevenueFromView,
       (SELECT ISNULL(SUM(TotalAmount), 0) FROM dbo.Orders WHERE Status = N'Completed')       AS RevenueFromOrders;
GO

-- 6.4. Kiểm tra dữ liệu Dashboard
PRINT N'--- 6.4 Dashboard ---';
EXEC dbo.sp_GetDashboardData;
GO

-- Kiểm tra cấu hình
SELECT * FROM dbo.AppSettings ORDER BY SettingKey;
GO