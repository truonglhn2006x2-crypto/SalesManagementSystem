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

-- 1.1. Tạo bảng Users (Lưu thông tin tài khoản người dùng).

-- 1.2. Tạo bảng Roles (Lưu danh sách vai trò người dùng).

-- 1.3. Tạo bảng Permissions (Lưu danh sách quyền hạn).

-- 1.4. Tạo bảng UserRoles (Liên kết tài khoản với vai trò).

-- 1.5. Tạo bảng RolePermissions (Liên kết vai trò với quyền hạn).


-- NHIỆM VỤ 2: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 2.1. Thiết lập khóa chính (PRIMARY KEY).

-- 2.2. Thiết lập khóa ngoại (FOREIGN KEY).

-- 2.3. Thiết lập UNIQUE cho tên đăng nhập.

-- 2.4. Thiết lập CHECK và DEFAULT phù hợp.


-- NHIỆM VỤ 3: TẠO CÁC STORED PROCEDURE.

-- 3.1. Tạo Stored Procedure quản lý tài khoản.

-- 3.2. Tạo Stored Procedure tìm kiếm người dùng.

-- 3.3. Tạo Stored Procedure cập nhật thông tin tài khoản.

-- 3.4. Tạo Stored Procedure khóa và mở khóa tài khoản.


-- NHIỆM VỤ 4: TẠO DỮ LIỆU MẪU.

-- 4.1. Thêm tài khoản Admin.

-- 4.2. Thêm tài khoản Manager.

-- 4.3. Thêm tài khoản Sales.

-- 4.4. Thêm tài khoản Customer.

-- 4.5. Thêm dữ liệu vai trò và quyền hạn.


-- NHIỆM VỤ 5: KIỂM TRA VÀ KIỂM THỬ.

-- 5.1. Kiểm tra chức năng đăng nhập.

-- 5.2. Kiểm tra chức năng phân quyền.

-- 5.3. Kiểm tra trường hợp tài khoản bị khóa.


-- =====================================================
-- THÀNH VIÊN 2: QUẢN LÝ SẢN PHẨM VÀ KHUYẾN MÃI
-- =====================================================

-- NHIỆM VỤ 1: TẠO CÁC BẢNG SẢN PHẨM VÀ DANH MỤC.

-- 1.1. Tạo bảng Categories (Lưu danh mục sản phẩm).
CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL
);

-- 1.2. Tạo bảng Products (Lưu thông tin sản phẩm).
CREATE TABLE Products
(
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    SKU NVARCHAR(50) NOT NULL CONSTRAINT UQ_Products_SKU UNIQUE,
    ProductName NVARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Unit NVARCHAR(50) NULL,
    PurchasePrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    SellingPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    StockQuantity INT NOT NULL DEFAULT 0,
    Description NVARCHAR(500) NULL,
    ImageURL NVARCHAR(500) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    CONSTRAINT FK_Products_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT CK_Products_PurchasePrice
        CHECK (PurchasePrice >= 0),

    CONSTRAINT CK_Products_SellingPrice
        CHECK (SellingPrice >= 0),

    CONSTRAINT CK_Products_StockQuantity
        CHECK (StockQuantity >= 0)
);

-- NHIỆM VỤ 2: TẠO CÁC BẢNG KHUYẾN MÃI--
-- 2.1. Tạo bảng Promotions (Lưu chương trình khuyến mãi)--
-- Khuyến mãi theo 2 hình thức giảm giá theo % hoặc giảm giá theo số tiền cố định--
CREATE TABLE Promotions
(
    PromotionID INT IDENTITY(1,1) PRIMARY KEY,
    PromotionName NVARCHAR(200) NOT NULL,
    Description NVARCHAR(500) NULL,
    DiscountType NVARCHAR(20) NOT NULL,
    DiscountValue DECIMAL(18,2) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,

    CONSTRAINT CK_Promotions_DiscountType
        CHECK (DiscountType IN (N'Percentage', N'FixedAmount')),

    CONSTRAINT CK_Promotions_DiscountValue
        CHECK (DiscountValue > 0),

    CONSTRAINT CK_Promotions_DiscountPercentage
        CHECK (
            DiscountType <> N'Percentage'
            OR DiscountValue <= 100
        ),

    CONSTRAINT CK_Promotions_Date
        CHECK (EndDate > StartDate)
);

-- 2.2. Tạo bảng PromotionProducts (Liên kết sản phẩm với khuyến mãi).
CREATE TABLE PromotionProducts
(
    PromotionID INT NOT NULL,
    ProductID INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_PromotionProducts
        PRIMARY KEY (PromotionID, ProductID),

    CONSTRAINT FK_PromotionProducts_Promotions
        FOREIGN KEY (PromotionID)
        REFERENCES Promotions(PromotionID),

    CONSTRAINT FK_PromotionProducts_Products
        FOREIGN KEY (ProductID)
        REFERENCES Products(ProductID)
);

-- NHIỆM VỤ 3: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU.

-- 3.1. Thiết lập khóa chính (PRIMARY KEY).

-- 3.2. Thiết lập khóa ngoại (FOREIGN KEY).

-- 3.3. Thiết lập UNIQUE cho mã SKU sản phẩm.

-- 3.4. Kiểm tra giá nhập và giá bán hợp lệ.

-- 3.5. Kiểm tra trạng thái và thời gian khuyến mãi.


-- NHIỆM VỤ 4: TẠO CÁC STORED PROCEDURE.

-- 4.1. Tạo Stored Procedure thêm sản phẩm.
CREATE OR ALTER PROCEDURE dbo.usp_Product_Add
    @SKU NVARCHAR(50),
    @ProductName NVARCHAR(200),
    @CategoryID INT,
    @Unit NVARCHAR(50) = NULL,
    @PurchasePrice DECIMAL(18,2) = 0,
    @SellingPrice DECIMAL(18,2) = 0,
    @StockQuantity INT = 0,
    @Description NVARCHAR(500) = NULL,
    @ImageURL NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @PurchasePrice < 0 OR @SellingPrice < 0 OR @StockQuantity < 0
        THROW 51001, N'Giá và số lượng tồn không được âm.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryID = @CategoryID)
        THROW 51002, N'Danh mục sản phẩm không tồn tại.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Products WHERE SKU = @SKU)
        THROW 51003, N'Mã SKU đã tồn tại.', 1;

    INSERT dbo.Products
        (SKU, ProductName, CategoryID, Unit, PurchasePrice, SellingPrice,
         StockQuantity, Description, ImageURL)
    VALUES
        (@SKU, @ProductName, @CategoryID, @Unit, @PurchasePrice, @SellingPrice,
         @StockQuantity, @Description, @ImageURL);

    SELECT CONVERT(INT, SCOPE_IDENTITY()) AS ProductID;
END;
GO


-- 4.2. Tạo Stored Procedure cập nhật sản phẩm.
-- NHIỆM VỤ 4.2: Cập nhật sản phẩm.
CREATE OR ALTER PROCEDURE dbo.usp_Product_Update
    @ProductID INT,
    @SKU NVARCHAR(50),
    @ProductName NVARCHAR(200),
    @CategoryID INT,
    @Unit NVARCHAR(50) = NULL,
    @PurchasePrice DECIMAL(18,2) = 0,
    @SellingPrice DECIMAL(18,2) = 0,
    @StockQuantity INT = 0,
    @Description NVARCHAR(500) = NULL,
    @ImageURL NVARCHAR(500) = NULL,
    @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @PurchasePrice < 0 OR @SellingPrice < 0 OR @StockQuantity < 0
        THROW 51004, N'Giá và số lượng tồn không được âm.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryID = @CategoryID)
        THROW 51005, N'Danh mục sản phẩm không tồn tại.', 1;
    IF EXISTS (SELECT 1 FROM dbo.Products WHERE SKU = @SKU AND ProductID <> @ProductID)
        THROW 51006, N'Mã SKU đã được sản phẩm khác sử dụng.', 1;

    UPDATE dbo.Products
    SET SKU = @SKU,
        ProductName = @ProductName,
        CategoryID = @CategoryID,
        Unit = @Unit,
        PurchasePrice = @PurchasePrice,
        SellingPrice = @SellingPrice,
        StockQuantity = @StockQuantity,
        Description = @Description,
        ImageURL = @ImageURL,
        IsActive = @IsActive,
        UpdatedAt = GETDATE()
    WHERE ProductID = @ProductID;

    IF @@ROWCOUNT = 0
        THROW 51007, N'Không tìm thấy sản phẩm cần cập nhật.', 1;
END;
GO


-- 4.3. Tạo Stored Procedure xóa hoặc ngừng kinh doanh sản phẩm.
-- NHIỆM VỤ 4.3: Ngừng kinh doanh sản phẩm (xóa mềm).
CREATE OR ALTER PROCEDURE dbo.usp_Product_Deactivate
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Products
    SET IsActive = 0,
        UpdatedAt = GETDATE()
    WHERE ProductID = @ProductID;

    IF @@ROWCOUNT = 0
        THROW 51008, N'Không tìm thấy sản phẩm cần ngừng kinh doanh.', 1;
END;
GO


-- 4.4. Tạo Stored Procedure tìm kiếm sản phẩm.
-- NHIỆM VỤ 4.4: Tìm kiếm sản phẩm theo tên, SKU và danh mục.
CREATE OR ALTER PROCEDURE dbo.usp_Product_Search
    @Keyword NVARCHAR(200) = NULL,
    @CategoryID INT = NULL,
    @IncludeInactive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT p.ProductID, p.SKU, p.ProductName, p.CategoryID, c.CategoryName,
           p.Unit, p.PurchasePrice, p.SellingPrice, p.StockQuantity,
           p.Description, p.ImageURL, p.IsActive, p.CreatedAt, p.UpdatedAt
    FROM dbo.Products AS p
    INNER JOIN dbo.Categories AS c ON c.CategoryID = p.CategoryID
    WHERE (@IncludeInactive = 1 OR p.IsActive = 1)
      AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID)
      AND (@Keyword IS NULL
           OR p.ProductName LIKE N'%' + @Keyword + N'%'
           OR p.SKU LIKE N'%' + @Keyword + N'%'
           OR c.CategoryName LIKE N'%' + @Keyword + N'%')
    ORDER BY p.ProductName;
END;
GO

-- 4.5. Tạo Stored Procedure quản lý khuyến mãi.
-- NHIỆM VỤ 4.5: Tạo/cập nhật khuyến mãi.
CREATE OR ALTER PROCEDURE dbo.usp_Promotion_Save
    @PromotionName NVARCHAR(200),
    @DiscountType NVARCHAR(20),
    @DiscountValue DECIMAL(18,2),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @Description NVARCHAR(500) = NULL,
    @IsActive BIT = 1,
    @PromotionID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @DiscountType NOT IN (N'Percentage', N'FixedAmount')
        THROW 51009, N'Loại giảm giá phải là Percentage hoặc FixedAmount.', 1;
    IF @DiscountValue <= 0 OR
       (@DiscountType = N'Percentage' AND @DiscountValue > 100)
        THROW 51010, N'Giá trị giảm giá không hợp lệ.', 1;
    IF @EndDate <= @StartDate
        THROW 51011, N'Thời điểm kết thúc phải sau thời điểm bắt đầu.', 1;

    IF @PromotionID IS NULL
    BEGIN
        INSERT dbo.Promotions
            (PromotionName, Description, DiscountType, DiscountValue,
             StartDate, EndDate, IsActive)
        VALUES
            (@PromotionName, @Description, @DiscountType, @DiscountValue,
             @StartDate, @EndDate, @IsActive);

        SET @PromotionID = CONVERT(INT, SCOPE_IDENTITY());
    END
    ELSE
    BEGIN
        UPDATE dbo.Promotions
        SET PromotionName = @PromotionName,
            Description = @Description,
            DiscountType = @DiscountType,
            DiscountValue = @DiscountValue,
            StartDate = @StartDate,
            EndDate = @EndDate,
            IsActive = @IsActive,
            UpdatedAt = GETDATE()
        WHERE PromotionID = @PromotionID;

        IF @@ROWCOUNT = 0
            THROW 51012, N'Không tìm thấy chương trình khuyến mãi.', 1;
    END;

    SELECT @PromotionID AS PromotionID;
END;
GO

-- Gán hoặc gỡ một sản phẩm khỏi chương trình khuyến mãi.
CREATE OR ALTER PROCEDURE dbo.usp_Promotion_AssignProduct
    @PromotionID INT,
    @ProductID INT,
    @Assign BIT = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM dbo.Promotions WHERE PromotionID = @PromotionID)
        THROW 51013, N'Chương trình khuyến mãi không tồn tại.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductID = @ProductID)
        THROW 51014, N'Sản phẩm không tồn tại.', 1;

    IF @Assign = 1 AND NOT EXISTS
       (SELECT 1 FROM dbo.PromotionProducts
        WHERE PromotionID = @PromotionID AND ProductID = @ProductID)
    BEGIN
        INSERT dbo.PromotionProducts (PromotionID, ProductID)
        VALUES (@PromotionID, @ProductID);
    END
    ELSE IF @Assign = 0
    BEGIN
        DELETE dbo.PromotionProducts
        WHERE PromotionID = @PromotionID AND ProductID = @ProductID;
    END;
END;
GO


-- NHIỆM VỤ 5: TẠO VIEW VÀ DỮ LIỆU MẪU.

-- 5.1. Tạo View danh sách sản phẩm.
CREATE OR ALTER VIEW dbo.vw_ProductList
AS
    SELECT p.ProductID, p.SKU, p.ProductName, p.CategoryID, c.CategoryName,
           p.Unit, p.PurchasePrice, p.SellingPrice, p.StockQuantity,
           p.IsActive, p.CreatedAt, p.UpdatedAt
    FROM dbo.Products AS p
    INNER JOIN dbo.Categories AS c ON c.CategoryID = p.CategoryID;
GO

-- 5.2. Tạo View danh mục sản phẩm.
CREATE OR ALTER VIEW dbo.vw_CategoryProductSummary
AS
    SELECT c.CategoryID, c.CategoryName, c.Description,
           COUNT(p.ProductID) AS ActiveProductCount
    FROM dbo.Categories AS c
    LEFT JOIN dbo.Products AS p
        ON p.CategoryID = c.CategoryID AND p.IsActive = 1
    GROUP BY c.CategoryID, c.CategoryName, c.Description;
GO

-- 5.3. Thêm dữ liệu mẫu danh mục sản phẩm.
INSERT dbo.Categories (CategoryName, Description)
SELECT v.CategoryName, v.Description
FROM (VALUES
    (N'Điện thoại', N'Điện thoại và phụ kiện di động'),
    (N'Máy tính', N'Máy tính, laptop và thiết bị ngoại vi'),
    (N'Gia dụng', N'Thiết bị gia dụng'),
    (N'Phụ kiện', N'Phụ kiện công nghệ'),
    (N'Văn phòng phẩm', N'Dụng cụ và vật tư văn phòng')
) AS v(CategoryName, Description)
WHERE NOT EXISTS
    (SELECT 1 FROM dbo.Categories AS c WHERE c.CategoryName = v.CategoryName);
GO

-- 5.4. Thêm tối thiểu 20 sản phẩm mẫu.
INSERT dbo.Products
    (SKU, ProductName, CategoryID, Unit, PurchasePrice, SellingPrice,
     StockQuantity, Description)
SELECT v.SKU, v.ProductName, c.CategoryID, v.Unit, v.PurchasePrice,
       v.SellingPrice, v.StockQuantity, v.Description
FROM (VALUES
    (N'PHONE-001', N'iPhone 15 128GB', N'Điện thoại', N'Cái', 16500000, 19990000, 12, N'Điện thoại thông minh'),
    (N'PHONE-002', N'Samsung Galaxy A55', N'Điện thoại', N'Cái', 8500000, 10490000, 18, N'Điện thoại Android'),
    (N'PHONE-003', N'Xiaomi Redmi Note 13', N'Điện thoại', N'Cái', 4200000, 5490000, 25, N'Điện thoại phổ thông'),
    (N'PHONE-004', N'OPPO Reno 11F', N'Điện thoại', N'Cái', 6500000, 7990000, 10, N'Điện thoại Android'),
    (N'PHONE-005', N'Google Pixel 8a', N'Điện thoại', N'Cái', 9500000, 11990000, 7, N'Điện thoại Google'),
    (N'PC-001', N'Dell Inspiron 15', N'Máy tính', N'Cái', 12500000, 14990000, 8, N'Laptop văn phòng'),
    (N'PC-002', N'HP Pavilion 14', N'Máy tính', N'Cái', 14500000, 16990000, 6, N'Laptop văn phòng'),
    (N'PC-003', N'Lenovo IdeaPad Slim 3', N'Máy tính', N'Cái', 10500000, 12990000, 9, N'Laptop học tập'),
    (N'PC-004', N'Logitech K380', N'Máy tính', N'Cái', 650000, 890000, 30, N'Bàn phím không dây'),
    (N'PC-005', N'Logitech M331', N'Máy tính', N'Cái', 350000, 490000, 35, N'Chuột không dây'),
    (N'HOME-001', N'Nồi chiên không dầu 5L', N'Gia dụng', N'Cái', 1500000, 1990000, 14, N'Nồi chiên dung tích 5 lít'),
    (N'HOME-002', N'Máy lọc không khí mini', N'Gia dụng', N'Cái', 1800000, 2390000, 11, N'Máy lọc không khí'),
    (N'HOME-003', N'Ấm siêu tốc inox 1.8L', N'Gia dụng', N'Cái', 300000, 450000, 22, N'Ấm đun nước'),
    (N'HOME-004', N'Máy xay sinh tố 600W', N'Gia dụng', N'Cái', 700000, 990000, 13, N'Máy xay gia đình'),
    (N'HOME-005', N'Quạt đứng 5 cánh', N'Gia dụng', N'Cái', 550000, 790000, 16, N'Quạt điện'),
    (N'ACC-001', N'Tai nghe Bluetooth', N'Phụ kiện', N'Cái', 420000, 650000, 28, N'Tai nghe không dây'),
    (N'ACC-002', N'Cáp USB-C 1m', N'Phụ kiện', N'Sợi', 70000, 120000, 50, N'Cáp sạc USB-C'),
    (N'ACC-003', N'Sạc nhanh 30W', N'Phụ kiện', N'Cái', 250000, 390000, 32, N'Củ sạc nhanh'),
    (N'OFF-001', N'Giấy in A4 80gsm', N'Văn phòng phẩm', N'Ream', 65000, 85000, 40, N'Giấy in 500 tờ'),
    (N'OFF-002', N'Bút bi xanh (hộp 20)', N'Văn phòng phẩm', N'Hộp', 50000, 75000, 45, N'Bút bi mực xanh')
) AS v(SKU, ProductName, CategoryName, Unit, PurchasePrice,
       SellingPrice, StockQuantity, Description)
INNER JOIN dbo.Categories AS c ON c.CategoryName = v.CategoryName
WHERE NOT EXISTS (SELECT 1 FROM dbo.Products AS p WHERE p.SKU = v.SKU);
GO

-- 5.5. Thêm dữ liệu chương trình khuyến mãi.
INSERT dbo.Promotions
    (PromotionName, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive)
SELECT v.PromotionName, v.Description, v.DiscountType, v.DiscountValue,
       v.StartDate, v.EndDate, 1
FROM (VALUES
    (N'Giảm giá mùa mua sắm', N'Giảm 10% một số sản phẩm', N'Percentage',
     CONVERT(DECIMAL(18,2), 10), DATEADD(DAY, -7, GETDATE()), DATEADD(DAY, 30, GETDATE())),
    (N'Ưu đãi phụ kiện', N'Giảm 50000 đồng', N'FixedAmount',
     CONVERT(DECIMAL(18,2), 50000), DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, 14, GETDATE()))
) AS v(PromotionName, Description, DiscountType, DiscountValue, StartDate, EndDate)
WHERE NOT EXISTS
    (SELECT 1 FROM dbo.Promotions AS p WHERE p.PromotionName = v.PromotionName);
GO

INSERT dbo.PromotionProducts (PromotionID, ProductID)
SELECT p.PromotionID, pr.ProductID
FROM dbo.Promotions AS p
INNER JOIN dbo.Products AS pr
    ON (p.PromotionName = N'Giảm giá mùa mua sắm' AND pr.SKU IN (N'PHONE-001', N'PC-001'))
    OR (p.PromotionName = N'Ưu đãi phụ kiện' AND pr.SKU IN (N'ACC-001', N'ACC-003'))
WHERE NOT EXISTS
    (SELECT 1 FROM dbo.PromotionProducts AS pp
     WHERE pp.PromotionID = p.PromotionID AND pp.ProductID = pr.ProductID);
GO

-- NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ.

-- 6.1. Kiểm tra thêm, sửa và tìm kiếm sản phẩm.
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @TestCategoryID INT =
        (SELECT TOP (1) CategoryID FROM dbo.Categories ORDER BY CategoryID);

    EXEC dbo.usp_Product_Add
        @SKU = N'TEST-M2-001', @ProductName = N'Sản phẩm kiểm thử',
        @CategoryID = @TestCategoryID,
        @Unit = N'Cái', @PurchasePrice = 100000, @SellingPrice = 150000,
        @StockQuantity = 1;

    DECLARE @TestProductID INT =
        (SELECT ProductID FROM dbo.Products WHERE SKU = N'TEST-M2-001');

    EXEC dbo.usp_Product_Update
        @ProductID = @TestProductID, @SKU = N'TEST-M2-001',
        @ProductName = N'Sản phẩm kiểm thử đã sửa',
        @CategoryID = @TestCategoryID,
        @Unit = N'Cái', @PurchasePrice = 100000, @SellingPrice = 160000,
        @StockQuantity = 2;

    EXEC dbo.usp_Product_Search @Keyword = N'TEST-M2-001';
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO

-- 6.2. Kiểm tra mã SKU bị trùng.
SELECT SKU, COUNT(*) AS DuplicateCount
FROM dbo.Products
GROUP BY SKU
HAVING COUNT(*) > 1;
GO

-- 6.3. Kiểm tra chương trình khuyến mãi hết hạn.
SELECT PromotionID, PromotionName, StartDate, EndDate, IsActive,
       CASE WHEN EndDate <= GETDATE() THEN N'Đã hết hạn'
            WHEN StartDate > GETDATE() THEN N'Chưa bắt đầu'
            ELSE N'Đang áp dụng' END AS PromotionStatus
FROM dbo.Promotions
WHERE EndDate <= GETDATE() OR StartDate > GETDATE();
GO

-- Xem nhanh dữ liệu và view của thành viên 2.
SELECT * FROM dbo.vw_ProductList ORDER BY CategoryName, ProductName;
SELECT * FROM dbo.vw_CategoryProductSummary ORDER BY CategoryName;

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



