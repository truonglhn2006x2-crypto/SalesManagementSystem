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
/* =====================================================================
   HỆ THỐNG QUẢN LÝ KHO HÀNG & NHẬP HÀNG   (SQL Server / T-SQL)
   Yêu cầu: SQL Server 2016 trở lên.

   CÁCH CHẠY: mở file bằng SSMS (UTF-8) -> Execute toàn bộ (F5).
   Phần 6 (kiểm thử) nên chạy sau khi phần 1-5 đã chạy xong.

   GIẢ ĐỊNH:
   - Dùng database mới tên InventoryDB (tự tạo bên dưới, đổi tên nếu muốn).
   - Bảng Products (sản phẩm) được xem là đã có sẵn. Nếu chưa có, script
     sẽ tạo bản tối giản + 5 sản phẩm mẫu ở phần 0.
     Nếu bảng Products của bạn có sẵn, cần có cột ProductID (khóa chính)
     và ProductName; các view đang dùng 2 cột này.
   - Số lượng tồn kho theo từng (kho, sản phẩm).
   ===================================================================== */

IF DB_ID(N'InventoryDB') IS NULL
    CREATE DATABASE InventoryDB;
GO
USE InventoryDB;
GO

/* =====================================================================
   PHẦN 0. DỌN DẸP ĐỂ CÓ THỂ CHẠY LẠI SCRIPT
   CẢNH BÁO: khối này XÓA các đối tượng của hệ thống kho/nhập hàng
   (không đụng tới bảng Products). Nếu chạy trong DB đã có bảng
   Suppliers/Warehouses/... của bạn thì dữ liệu đó cũng bị xóa.
   ===================================================================== */
DROP VIEW IF EXISTS dbo.vw_LowStockProducts;
DROP VIEW IF EXISTS dbo.vw_StockTransactionHistory;
DROP VIEW IF EXISTS dbo.vw_InventoryStock;

DROP PROCEDURE IF EXISTS dbo.usp_CheckLowStock;
DROP PROCEDURE IF EXISTS dbo.usp_AdjustStock;
DROP PROCEDURE IF EXISTS dbo.usp_ReceivePurchaseOrder;
DROP PROCEDURE IF EXISTS dbo.usp_UpdateStock;
DROP PROCEDURE IF EXISTS dbo.usp_CreatePurchaseOrder;
DROP PROCEDURE IF EXISTS dbo.usp_ManageSupplier;

DROP TYPE IF EXISTS dbo.PurchaseOrderItemType;
DROP SEQUENCE IF EXISTS dbo.seq_PurchaseOrderNumber;

DROP TABLE IF EXISTS dbo.PurchaseOrderItems;
DROP TABLE IF EXISTS dbo.PurchaseOrders;
DROP TABLE IF EXISTS dbo.StockTransactions;
DROP TABLE IF EXISTS dbo.InventoryStocks;
DROP TABLE IF EXISTS dbo.Suppliers;
DROP TABLE IF EXISTS dbo.Warehouses;
GO

/* ---------------------------------------------------------------------
   Bảng Products (giả định). Bỏ qua nếu bạn đã có bảng này.
   --------------------------------------------------------------------- */
IF OBJECT_ID(N'dbo.Products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.Products (
        ProductID   INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Products PRIMARY KEY,
        ProductName NVARCHAR(200)     NOT NULL,
        Unit        NVARCHAR(30)      NULL,
        Price       DECIMAL(18,2)     NOT NULL CONSTRAINT DF_Products_Price DEFAULT (0)
    );

    INSERT INTO dbo.Products (ProductName, Unit, Price) VALUES
        (N'Laptop Dell Inspiron 15',        N'Chiếc', 16500000),
        (N'Chuột không dây Logitech M331',  N'Chiếc',   320000),
        (N'Bàn phím cơ Keychron K2',        N'Chiếc',  2100000),
        (N'Màn hình LG 24 inch',            N'Chiếc',  3200000),
        (N'Tai nghe Sony WH-1000XM5',       N'Chiếc',  7500000);
END
GO


/* =====================================================================
   NHIỆM VỤ 1: TẠO CÁC BẢNG KHO HÀNG
   (Ở bước này chỉ khai báo cột, NOT NULL và DEFAULT. Khóa chính, khóa
   ngoại và CHECK được thêm riêng ở Nhiệm vụ 3 bằng ALTER TABLE.)
   ===================================================================== */

-- 1.1. Bảng Warehouses: thông tin kho hàng
CREATE TABLE dbo.Warehouses (
    WarehouseID   INT IDENTITY(1,1) NOT NULL,
    WarehouseCode VARCHAR(20)       NOT NULL,
    WarehouseName NVARCHAR(150)     NOT NULL,
    Address       NVARCHAR(255)     NULL,
    Phone         VARCHAR(20)       NULL,
    ManagerName   NVARCHAR(100)     NULL,
    IsActive      BIT               NOT NULL CONSTRAINT DF_Warehouses_IsActive  DEFAULT (1),
    CreatedAt     DATETIME2(0)      NOT NULL CONSTRAINT DF_Warehouses_CreatedAt DEFAULT (SYSDATETIME())
);
GO

-- 1.2. Bảng InventoryStocks: số lượng tồn kho theo (kho, sản phẩm)
CREATE TABLE dbo.InventoryStocks (
    StockID        INT IDENTITY(1,1) NOT NULL,
    WarehouseID    INT               NOT NULL,
    ProductID      INT               NOT NULL,
    QuantityOnHand INT               NOT NULL CONSTRAINT DF_InventoryStocks_Qty  DEFAULT (0),
    MinStockLevel  INT               NOT NULL CONSTRAINT DF_InventoryStocks_Min  DEFAULT (10),  -- ngưỡng cảnh báo sắp hết
    LastUpdated    DATETIME2(0)      NOT NULL CONSTRAINT DF_InventoryStocks_Last DEFAULT (SYSDATETIME())
);
GO

-- 1.3. Bảng StockTransactions: lịch sử nhập / xuất / điều chỉnh kho
--      QuantityChange mang dấu: dương = tăng, âm = giảm.
CREATE TABLE dbo.StockTransactions (
    TransactionID   BIGINT IDENTITY(1,1) NOT NULL,
    WarehouseID     INT           NOT NULL,
    ProductID       INT           NOT NULL,
    TransactionType VARCHAR(20)   NOT NULL,          -- IMPORT | EXPORT | ADJUST
    QuantityChange  INT           NOT NULL,
    QuantityBefore  INT           NOT NULL,
    QuantityAfter   INT           NOT NULL,
    ReferenceType   VARCHAR(30)   NULL,              -- PURCHASE_ORDER | MANUAL ...
    ReferenceID     INT           NULL,              -- ví dụ PurchaseOrderID
    Note            NVARCHAR(255) NULL,
    CreatedBy       NVARCHAR(100) NOT NULL CONSTRAINT DF_StockTransactions_By DEFAULT (SUSER_SNAME()),
    CreatedAt       DATETIME2(0)  NOT NULL CONSTRAINT DF_StockTransactions_At DEFAULT (SYSDATETIME())
);
GO


/* =====================================================================
   NHIỆM VỤ 2: TẠO CÁC BẢNG NHÀ CUNG CẤP VÀ NHẬP HÀNG
   ===================================================================== */

-- 2.1. Bảng Suppliers: thông tin nhà cung cấp
CREATE TABLE dbo.Suppliers (
    SupplierID    INT IDENTITY(1,1) NOT NULL,
    SupplierCode  VARCHAR(20)       NOT NULL,
    SupplierName  NVARCHAR(200)     NOT NULL,
    ContactPerson NVARCHAR(100)     NULL,
    Phone         VARCHAR(20)       NULL,
    Email         VARCHAR(100)      NULL,
    Address       NVARCHAR(255)     NULL,
    TaxCode       VARCHAR(20)       NULL,
    IsActive      BIT               NOT NULL CONSTRAINT DF_Suppliers_IsActive  DEFAULT (1),
    CreatedAt     DATETIME2(0)      NOT NULL CONSTRAINT DF_Suppliers_CreatedAt DEFAULT (SYSDATETIME())
);
GO

-- 2.2. Bảng PurchaseOrders: phiếu đặt hàng nhập
CREATE TABLE dbo.PurchaseOrders (
    PurchaseOrderID INT IDENTITY(1,1) NOT NULL,
    PONumber        VARCHAR(30)       NOT NULL,                 -- số phiếu, ví dụ PO20261114-0001
    SupplierID      INT               NOT NULL,
    WarehouseID     INT               NOT NULL,                 -- kho nhận hàng
    OrderDate       DATE              NOT NULL CONSTRAINT DF_PO_OrderDate DEFAULT (CAST(SYSDATETIME() AS DATE)),
    ExpectedDate    DATE              NULL,
    Status          VARCHAR(20)       NOT NULL CONSTRAINT DF_PO_Status    DEFAULT ('Pending'),
    TotalAmount     DECIMAL(18,2)     NOT NULL CONSTRAINT DF_PO_Total     DEFAULT (0),
    Note            NVARCHAR(500)     NULL,
    CreatedAt       DATETIME2(0)      NOT NULL CONSTRAINT DF_PO_CreatedAt DEFAULT (SYSDATETIME()),
    ReceivedAt      DATETIME2(0)      NULL
);
GO

-- 2.3. Bảng PurchaseOrderItems: chi tiết sản phẩm trong phiếu nhập
CREATE TABLE dbo.PurchaseOrderItems (
    POItemID        INT IDENTITY(1,1) NOT NULL,
    PurchaseOrderID INT               NOT NULL,
    ProductID       INT               NOT NULL,
    Quantity        INT               NOT NULL,
    UnitPrice       DECIMAL(18,2)     NOT NULL,
    LineTotal       AS (Quantity * UnitPrice) PERSISTED         -- thành tiền, tự tính
);
GO


/* =====================================================================
   NHIỆM VỤ 3: THIẾT LẬP CÁC RÀNG BUỘC DỮ LIỆU
   ===================================================================== */

-- 3.1. Khóa chính (PRIMARY KEY) + các ràng buộc duy nhất (UNIQUE)
ALTER TABLE dbo.Warehouses         ADD CONSTRAINT PK_Warehouses         PRIMARY KEY (WarehouseID);
ALTER TABLE dbo.InventoryStocks    ADD CONSTRAINT PK_InventoryStocks    PRIMARY KEY (StockID);
ALTER TABLE dbo.StockTransactions  ADD CONSTRAINT PK_StockTransactions  PRIMARY KEY (TransactionID);
ALTER TABLE dbo.Suppliers          ADD CONSTRAINT PK_Suppliers          PRIMARY KEY (SupplierID);
ALTER TABLE dbo.PurchaseOrders     ADD CONSTRAINT PK_PurchaseOrders     PRIMARY KEY (PurchaseOrderID);
ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT PK_PurchaseOrderItems PRIMARY KEY (POItemID);

ALTER TABLE dbo.Warehouses         ADD CONSTRAINT UQ_Warehouses_Code         UNIQUE (WarehouseCode);
ALTER TABLE dbo.Suppliers          ADD CONSTRAINT UQ_Suppliers_Code          UNIQUE (SupplierCode);
ALTER TABLE dbo.PurchaseOrders     ADD CONSTRAINT UQ_PurchaseOrders_PONumber UNIQUE (PONumber);
ALTER TABLE dbo.InventoryStocks    ADD CONSTRAINT UQ_InventoryStocks_WH_Prod UNIQUE (WarehouseID, ProductID);
ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT UQ_POItems_PO_Prod         UNIQUE (PurchaseOrderID, ProductID);
GO

-- 3.2. Khóa ngoại (FOREIGN KEY)
ALTER TABLE dbo.InventoryStocks    ADD CONSTRAINT FK_InventoryStocks_Warehouses
    FOREIGN KEY (WarehouseID) REFERENCES dbo.Warehouses (WarehouseID);
ALTER TABLE dbo.InventoryStocks    ADD CONSTRAINT FK_InventoryStocks_Products
    FOREIGN KEY (ProductID)   REFERENCES dbo.Products (ProductID);

ALTER TABLE dbo.StockTransactions  ADD CONSTRAINT FK_StockTransactions_Warehouses
    FOREIGN KEY (WarehouseID) REFERENCES dbo.Warehouses (WarehouseID);
ALTER TABLE dbo.StockTransactions  ADD CONSTRAINT FK_StockTransactions_Products
    FOREIGN KEY (ProductID)   REFERENCES dbo.Products (ProductID);

ALTER TABLE dbo.PurchaseOrders     ADD CONSTRAINT FK_PurchaseOrders_Suppliers
    FOREIGN KEY (SupplierID)  REFERENCES dbo.Suppliers (SupplierID);
ALTER TABLE dbo.PurchaseOrders     ADD CONSTRAINT FK_PurchaseOrders_Warehouses
    FOREIGN KEY (WarehouseID) REFERENCES dbo.Warehouses (WarehouseID);

ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT FK_POItems_PurchaseOrders
    FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders (PurchaseOrderID) ON DELETE CASCADE;
ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT FK_POItems_Products
    FOREIGN KEY (ProductID)       REFERENCES dbo.Products (ProductID);
GO

-- 3.3. Số lượng tồn kho không được âm
ALTER TABLE dbo.InventoryStocks ADD CONSTRAINT CK_InventoryStocks_Qty_NonNegative
    CHECK (QuantityOnHand >= 0);
ALTER TABLE dbo.InventoryStocks ADD CONSTRAINT CK_InventoryStocks_Min_NonNegative
    CHECK (MinStockLevel >= 0);
GO

-- 3.4. Số lượng sản phẩm nhập hợp lệ
ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT CK_POItems_Quantity_Positive
    CHECK (Quantity > 0);
ALTER TABLE dbo.PurchaseOrderItems ADD CONSTRAINT CK_POItems_UnitPrice_NonNegative
    CHECK (UnitPrice >= 0);

-- Lịch sử kho: loại giao dịch hợp lệ, dấu của số lượng khớp với loại, trước/sau nhất quán
ALTER TABLE dbo.StockTransactions ADD CONSTRAINT CK_StockTransactions_Type
    CHECK (TransactionType IN ('IMPORT', 'EXPORT', 'ADJUST'));
ALTER TABLE dbo.StockTransactions ADD CONSTRAINT CK_StockTransactions_Quantity
    CHECK (
        QuantityChange <> 0
        AND QuantityBefore >= 0
        AND QuantityAfter  >= 0
        AND QuantityAfter = QuantityBefore + QuantityChange
        AND (   (TransactionType = 'IMPORT' AND QuantityChange > 0)
             OR (TransactionType = 'EXPORT' AND QuantityChange < 0)
             OR  TransactionType = 'ADJUST')
    );
GO

-- 3.5. Trạng thái phiếu nhập hàng
--      Pending = chờ nhận hàng | Received = đã nhận hàng | Cancelled = đã hủy
ALTER TABLE dbo.PurchaseOrders ADD CONSTRAINT CK_PurchaseOrders_Status
    CHECK (Status IN ('Pending', 'Received', 'Cancelled'));
ALTER TABLE dbo.PurchaseOrders ADD CONSTRAINT CK_PurchaseOrders_ExpectedDate
    CHECK (ExpectedDate IS NULL OR ExpectedDate >= OrderDate);
ALTER TABLE dbo.PurchaseOrders ADD CONSTRAINT CK_PurchaseOrders_Total
    CHECK (TotalAmount >= 0);
GO


/* =====================================================================
   NHIỆM VỤ 4: TẠO CÁC STORED PROCEDURE
   Mã lỗi tự định nghĩa: 50001-50009 nhà cung cấp, 50010-50019 tạo phiếu,
   50020-50029 nhận hàng, 50030-50039 cập nhật tồn kho, 50040-50049 điều chỉnh.
   ===================================================================== */

-- 4.1. Quản lý nhà cung cấp (thêm / sửa / xóa / xem) trong một procedure
--      @Action: INSERT | UPDATE | DELETE | GET
--      UPDATE chỉ đổi các cột có truyền giá trị (khác NULL).
--      DELETE: nếu NCC đã có phiếu nhập thì chỉ ngừng hoạt động (IsActive = 0).
CREATE PROCEDURE dbo.usp_ManageSupplier
    @Action         VARCHAR(10),
    @SupplierID     INT           = NULL,
    @SupplierCode   VARCHAR(20)   = NULL,
    @SupplierName   NVARCHAR(200) = NULL,
    @ContactPerson  NVARCHAR(100) = NULL,
    @Phone          VARCHAR(20)   = NULL,
    @Email          VARCHAR(100)  = NULL,
    @Address        NVARCHAR(255) = NULL,
    @TaxCode        VARCHAR(20)   = NULL,
    @IsActive       BIT           = NULL,
    @NewSupplierID  INT           = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @Action = UPPER(LTRIM(RTRIM(@Action)));

    BEGIN TRY
        IF @Action = 'INSERT'
        BEGIN
            IF NULLIF(LTRIM(RTRIM(@SupplierCode)), '') IS NULL
               OR NULLIF(LTRIM(RTRIM(@SupplierName)), '') IS NULL
                THROW 50001, N'Mã và tên nhà cung cấp là bắt buộc.', 1;

            IF EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierCode = @SupplierCode)
                THROW 50002, N'Mã nhà cung cấp đã tồn tại.', 1;

            INSERT INTO dbo.Suppliers (SupplierCode, SupplierName, ContactPerson, Phone, Email, Address, TaxCode, IsActive)
            VALUES (@SupplierCode, @SupplierName, @ContactPerson, @Phone, @Email, @Address, @TaxCode, ISNULL(@IsActive, 1));

            SET @NewSupplierID = SCOPE_IDENTITY();
        END
        ELSE IF @Action = 'UPDATE'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierID = @SupplierID)
                THROW 50003, N'Nhà cung cấp không tồn tại.', 1;

            IF @SupplierCode IS NOT NULL
               AND EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierCode = @SupplierCode AND SupplierID <> @SupplierID)
                THROW 50002, N'Mã nhà cung cấp đã tồn tại.', 1;

            UPDATE dbo.Suppliers
            SET SupplierCode  = ISNULL(@SupplierCode,  SupplierCode),
                SupplierName  = ISNULL(@SupplierName,  SupplierName),
                ContactPerson = ISNULL(@ContactPerson, ContactPerson),
                Phone         = ISNULL(@Phone,         Phone),
                Email         = ISNULL(@Email,         Email),
                Address       = ISNULL(@Address,       Address),
                TaxCode       = ISNULL(@TaxCode,       TaxCode),
                IsActive      = ISNULL(@IsActive,      IsActive)
            WHERE SupplierID = @SupplierID;
        END
        ELSE IF @Action = 'DELETE'
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierID = @SupplierID)
                THROW 50003, N'Nhà cung cấp không tồn tại.', 1;

            IF EXISTS (SELECT 1 FROM dbo.PurchaseOrders WHERE SupplierID = @SupplierID)
            BEGIN
                UPDATE dbo.Suppliers SET IsActive = 0 WHERE SupplierID = @SupplierID;
                PRINT N'Nhà cung cấp đã có phiếu nhập nên chỉ được chuyển sang ngừng hoạt động (IsActive = 0).';
            END
            ELSE
                DELETE FROM dbo.Suppliers WHERE SupplierID = @SupplierID;
        END
        ELSE IF @Action = 'GET'
        BEGIN
            SELECT SupplierID, SupplierCode, SupplierName, ContactPerson, Phone, Email, Address, TaxCode, IsActive, CreatedAt
            FROM dbo.Suppliers
            WHERE @SupplierID IS NULL OR SupplierID = @SupplierID
            ORDER BY SupplierID;
        END
        ELSE
            THROW 50005, N'Action không hợp lệ. Chỉ nhận INSERT, UPDATE, DELETE hoặc GET.', 1;
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END
GO

-- Kiểu bảng để truyền danh sách sản phẩm vào procedure tạo phiếu nhập
CREATE TYPE dbo.PurchaseOrderItemType AS TABLE (
    ProductID INT           NOT NULL,
    Quantity  INT           NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL
);
GO

-- Sequence sinh số phiếu nhập
CREATE SEQUENCE dbo.seq_PurchaseOrderNumber AS INT START WITH 1 INCREMENT BY 1;
GO

-- 4.2. Tạo phiếu nhập hàng (phiếu + chi tiết trong 1 transaction, trạng thái ban đầu Pending)
CREATE PROCEDURE dbo.usp_CreatePurchaseOrder
    @SupplierID      INT,
    @WarehouseID     INT,
    @Items           dbo.PurchaseOrderItemType READONLY,
    @ExpectedDate    DATE          = NULL,
    @Note            NVARCHAR(500) = NULL,
    @PurchaseOrderID INT           = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StartedTran BIT = 0, @Seq INT, @PONumber VARCHAR(30);

    BEGIN TRY
        -- Kiểm tra dữ liệu đầu vào
        IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierID = @SupplierID AND IsActive = 1)
            THROW 50010, N'Nhà cung cấp không tồn tại hoặc đã ngừng hoạt động.', 1;

        IF NOT EXISTS (SELECT 1 FROM dbo.Warehouses WHERE WarehouseID = @WarehouseID AND IsActive = 1)
            THROW 50011, N'Kho không tồn tại hoặc đã ngừng hoạt động.', 1;

        IF NOT EXISTS (SELECT 1 FROM @Items)
            THROW 50012, N'Phiếu nhập phải có ít nhất một sản phẩm.', 1;

        IF EXISTS (SELECT 1 FROM @Items WHERE Quantity <= 0)
            THROW 50013, N'Số lượng nhập của mỗi sản phẩm phải lớn hơn 0.', 1;

        IF EXISTS (SELECT 1 FROM @Items WHERE UnitPrice < 0)
            THROW 50014, N'Đơn giá nhập không được âm.', 1;

        IF EXISTS (SELECT ProductID FROM @Items GROUP BY ProductID HAVING COUNT(*) > 1)
            THROW 50015, N'Danh sách sản phẩm bị trùng. Mỗi sản phẩm chỉ xuất hiện một lần trong phiếu.', 1;

        IF EXISTS (SELECT 1 FROM @Items i WHERE NOT EXISTS (SELECT 1 FROM dbo.Products p WHERE p.ProductID = i.ProductID))
            THROW 50016, N'Có sản phẩm trong phiếu không tồn tại.', 1;

        IF @ExpectedDate IS NOT NULL AND @ExpectedDate < CAST(SYSDATETIME() AS DATE)
            THROW 50017, N'Ngày dự kiến nhận hàng không được nhỏ hơn ngày hôm nay.', 1;

        IF @@TRANCOUNT = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @StartedTran = 1;
        END

        SET @Seq = NEXT VALUE FOR dbo.seq_PurchaseOrderNumber;
        SET @PONumber = 'PO' + CONVERT(VARCHAR(8), SYSDATETIME(), 112) + '-' + FORMAT(@Seq, '0000');

        INSERT INTO dbo.PurchaseOrders (PONumber, SupplierID, WarehouseID, ExpectedDate, Status, Note)
        VALUES (@PONumber, @SupplierID, @WarehouseID, @ExpectedDate, 'Pending', @Note);

        SET @PurchaseOrderID = SCOPE_IDENTITY();

        INSERT INTO dbo.PurchaseOrderItems (PurchaseOrderID, ProductID, Quantity, UnitPrice)
        SELECT @PurchaseOrderID, ProductID, Quantity, UnitPrice
        FROM @Items;

        UPDATE dbo.PurchaseOrders
        SET TotalAmount = (SELECT SUM(LineTotal) FROM dbo.PurchaseOrderItems WHERE PurchaseOrderID = @PurchaseOrderID)
        WHERE PurchaseOrderID = @PurchaseOrderID;

        IF @StartedTran = 1 COMMIT TRANSACTION;

        SELECT PurchaseOrderID, PONumber, Status, TotalAmount
        FROM dbo.PurchaseOrders
        WHERE PurchaseOrderID = @PurchaseOrderID;
    END TRY
    BEGIN CATCH
        IF @StartedTran = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 4.4. Cập nhật số lượng tồn kho (procedure lõi, dùng chung cho nhập / xuất / điều chỉnh)
--      @QuantityChange mang dấu: IMPORT phải > 0, EXPORT phải < 0, ADJUST khác 0.
--      Khóa dòng tồn kho (UPDLOCK, HOLDLOCK) để 2 phiên không ghi đè nhau.
--      Mỗi lần cập nhật đều ghi 1 dòng vào StockTransactions.
--      (Khai báo trước 4.3 vì 4.3 gọi procedure này.)
CREATE PROCEDURE dbo.usp_UpdateStock
    @WarehouseID     INT,
    @ProductID       INT,
    @QuantityChange  INT,
    @TransactionType VARCHAR(20),
    @ReferenceType   VARCHAR(30)   = NULL,
    @ReferenceID     INT           = NULL,
    @Note            NVARCHAR(255) = NULL,
    @CreatedBy       NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StartedTran BIT = 0, @OldQty INT, @NewQty BIGINT, @Msg NVARCHAR(400);

    BEGIN TRY
        SET @TransactionType = UPPER(LTRIM(RTRIM(@TransactionType)));

        IF @TransactionType NOT IN ('IMPORT', 'EXPORT', 'ADJUST')
            THROW 50030, N'Loại giao dịch không hợp lệ. Chỉ nhận IMPORT, EXPORT hoặc ADJUST.', 1;

        IF @QuantityChange = 0
            THROW 50031, N'Số lượng thay đổi phải khác 0.', 1;

        IF @TransactionType = 'IMPORT' AND @QuantityChange < 0
            THROW 50032, N'Nhập kho phải có số lượng dương.', 1;

        IF @TransactionType = 'EXPORT' AND @QuantityChange > 0
            THROW 50033, N'Xuất kho phải có số lượng âm (ví dụ -5).', 1;

        IF NOT EXISTS (SELECT 1 FROM dbo.Warehouses WHERE WarehouseID = @WarehouseID AND IsActive = 1)
            THROW 50034, N'Kho không tồn tại hoặc đã ngừng hoạt động.', 1;

        IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductID = @ProductID)
            THROW 50035, N'Sản phẩm không tồn tại.', 1;

        IF @@TRANCOUNT = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @StartedTran = 1;
        END

        SELECT @OldQty = QuantityOnHand
        FROM dbo.InventoryStocks WITH (UPDLOCK, HOLDLOCK)
        WHERE WarehouseID = @WarehouseID AND ProductID = @ProductID;

        IF @OldQty IS NULL
        BEGIN
            -- Sản phẩm chưa từng có trong kho này
            IF @QuantityChange < 0
                THROW 50036, N'Sản phẩm chưa có tồn kho tại kho này (hết hàng), không thể xuất hoặc giảm.', 1;

            SET @OldQty = 0;
            INSERT INTO dbo.InventoryStocks (WarehouseID, ProductID, QuantityOnHand)
            VALUES (@WarehouseID, @ProductID, 0);
        END

        SET @NewQty = CAST(@OldQty AS BIGINT) + @QuantityChange;

        IF @NewQty < 0
        BEGIN
            SET @Msg = N'Không đủ hàng tồn kho. Hiện có: ' + CAST(@OldQty AS NVARCHAR(20))
                     + N', yêu cầu giảm: ' + CAST(ABS(CAST(@QuantityChange AS BIGINT)) AS NVARCHAR(20)) + N'.';
            THROW 50037, @Msg, 1;
        END

        IF @NewQty > 2147483647
            THROW 50038, N'Số lượng tồn kho vượt quá giới hạn cho phép.', 1;

        UPDATE dbo.InventoryStocks
        SET QuantityOnHand = CAST(@NewQty AS INT),
            LastUpdated    = SYSDATETIME()
        WHERE WarehouseID = @WarehouseID AND ProductID = @ProductID;

        INSERT INTO dbo.StockTransactions
            (WarehouseID, ProductID, TransactionType, QuantityChange, QuantityBefore, QuantityAfter,
             ReferenceType, ReferenceID, Note, CreatedBy)
        VALUES
            (@WarehouseID, @ProductID, @TransactionType, @QuantityChange, @OldQty, CAST(@NewQty AS INT),
             @ReferenceType, @ReferenceID, @Note, ISNULL(@CreatedBy, SUSER_SNAME()));

        IF @StartedTran = 1 COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @StartedTran = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 4.3. Xác nhận nhận hàng: cộng tồn kho cho toàn bộ sản phẩm của phiếu rồi chuyển Pending -> Received.
--      Tất cả nằm trong 1 transaction: lỗi ở bất kỳ sản phẩm nào thì rollback toàn bộ.
CREATE PROCEDURE dbo.usp_ReceivePurchaseOrder
    @PurchaseOrderID INT,
    @ReceivedBy      NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StartedTran BIT = 0,
            @Status VARCHAR(20), @WarehouseID INT, @PONumber VARCHAR(30),
            @ProductID INT, @Qty INT, @Note NVARCHAR(255),
            @i INT = 1, @n INT;

    DECLARE @Lines TABLE (RowNo INT IDENTITY(1,1) PRIMARY KEY, ProductID INT NOT NULL, Quantity INT NOT NULL);

    BEGIN TRY
        IF @@TRANCOUNT = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @StartedTran = 1;
        END

        -- Khóa phiếu để tránh 2 người cùng xác nhận một phiếu
        SELECT @Status = Status, @WarehouseID = WarehouseID, @PONumber = PONumber
        FROM dbo.PurchaseOrders WITH (UPDLOCK, HOLDLOCK)
        WHERE PurchaseOrderID = @PurchaseOrderID;

        IF @Status IS NULL
            THROW 50020, N'Phiếu nhập không tồn tại.', 1;

        IF @Status <> 'Pending'
            THROW 50021, N'Chỉ xác nhận nhận hàng cho phiếu đang ở trạng thái Pending (phiếu đã nhận hoặc đã hủy thì không nhận lại được).', 1;

        -- Xử lý theo thứ tự ProductID để các phiên khóa dòng cùng một thứ tự (tránh deadlock)
        INSERT INTO @Lines (ProductID, Quantity)
        SELECT ProductID, Quantity
        FROM dbo.PurchaseOrderItems
        WHERE PurchaseOrderID = @PurchaseOrderID
        ORDER BY ProductID;

        SET @n = (SELECT COUNT(*) FROM @Lines);
        IF @n = 0
            THROW 50022, N'Phiếu nhập không có sản phẩm nào.', 1;

        SET @Note = N'Nhập hàng theo phiếu ' + @PONumber;

        WHILE @i <= @n
        BEGIN
            SELECT @ProductID = ProductID, @Qty = Quantity FROM @Lines WHERE RowNo = @i;

            EXEC dbo.usp_UpdateStock
                 @WarehouseID     = @WarehouseID,
                 @ProductID       = @ProductID,
                 @QuantityChange  = @Qty,
                 @TransactionType = 'IMPORT',
                 @ReferenceType   = 'PURCHASE_ORDER',
                 @ReferenceID     = @PurchaseOrderID,
                 @Note            = @Note,
                 @CreatedBy       = @ReceivedBy;

            SET @i += 1;
        END

        UPDATE dbo.PurchaseOrders
        SET Status = 'Received', ReceivedAt = SYSDATETIME()
        WHERE PurchaseOrderID = @PurchaseOrderID;

        IF @StartedTran = 1 COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @StartedTran = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 4.5. Điều chỉnh tồn kho (kiểm kê): đặt số lượng tồn về giá trị mới, ghi lịch sử loại ADJUST
CREATE PROCEDURE dbo.usp_AdjustStock
    @WarehouseID INT,
    @ProductID   INT,
    @NewQuantity INT,
    @Reason      NVARCHAR(255),
    @AdjustedBy  NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @StartedTran BIT = 0, @CurrentQty INT, @Diff INT, @Note NVARCHAR(255);

    BEGIN TRY
        IF @NewQuantity < 0
            THROW 50040, N'Số lượng tồn mới không được âm.', 1;

        IF NULLIF(LTRIM(RTRIM(@Reason)), '') IS NULL
            THROW 50041, N'Phải nhập lý do điều chỉnh tồn kho.', 1;

        IF @@TRANCOUNT = 0
        BEGIN
            BEGIN TRANSACTION;
            SET @StartedTran = 1;
        END

        SELECT @CurrentQty = QuantityOnHand
        FROM dbo.InventoryStocks WITH (UPDLOCK, HOLDLOCK)
        WHERE WarehouseID = @WarehouseID AND ProductID = @ProductID;

        SET @CurrentQty = ISNULL(@CurrentQty, 0);
        SET @Diff = @NewQuantity - @CurrentQty;

        IF @Diff = 0
            THROW 50042, N'Số lượng mới bằng tồn kho hiện tại, không cần điều chỉnh.', 1;

        SET @Note = N'Điều chỉnh tồn kho: ' + LTRIM(RTRIM(@Reason));

        EXEC dbo.usp_UpdateStock
             @WarehouseID     = @WarehouseID,
             @ProductID       = @ProductID,
             @QuantityChange  = @Diff,
             @TransactionType = 'ADJUST',
             @ReferenceType   = 'MANUAL',
             @ReferenceID     = NULL,
             @Note            = @Note,
             @CreatedBy       = @AdjustedBy;

        IF @StartedTran = 1 COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @StartedTran = 1 AND @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 4.6. Kiểm tra hàng sắp hết
--      @Threshold = NULL: so với MinStockLevel của từng dòng; có giá trị: dùng ngưỡng chung đó.
--      @WarehouseID = NULL: xét tất cả các kho.
CREATE PROCEDURE dbo.usp_CheckLowStock
    @WarehouseID INT = NULL,
    @Threshold   INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT  w.WarehouseID,
            w.WarehouseName,
            p.ProductID,
            p.ProductName,
            s.QuantityOnHand,
            ISNULL(@Threshold, s.MinStockLevel)                      AS ThresholdUsed,
            CASE WHEN s.QuantityOnHand = 0 THEN N'Hết hàng' ELSE N'Sắp hết hàng' END AS StockStatus,
            ISNULL(@Threshold, s.MinStockLevel) - s.QuantityOnHand   AS ShortageQty
    FROM dbo.InventoryStocks s
    JOIN dbo.Warehouses w ON w.WarehouseID = s.WarehouseID
    JOIN dbo.Products   p ON p.ProductID   = s.ProductID
    WHERE (@WarehouseID IS NULL OR s.WarehouseID = @WarehouseID)
      AND s.QuantityOnHand <= ISNULL(@Threshold, s.MinStockLevel)
    ORDER BY s.QuantityOnHand, w.WarehouseName, p.ProductName;
END
GO


/* =====================================================================
   NHIỆM VỤ 5: TẠO VIEW VÀ DỮ LIỆU MẪU
   ===================================================================== */

-- 5.1. View danh sách hàng tồn kho
CREATE VIEW dbo.vw_InventoryStock
AS
SELECT  s.StockID,
        w.WarehouseID,
        w.WarehouseCode,
        w.WarehouseName,
        p.ProductID,
        p.ProductName,
        s.QuantityOnHand,
        s.MinStockLevel,
        CASE WHEN s.QuantityOnHand = 0                THEN N'Hết hàng'
             WHEN s.QuantityOnHand <= s.MinStockLevel THEN N'Sắp hết hàng'
             ELSE N'Còn hàng' END AS StockStatus,
        s.LastUpdated
FROM dbo.InventoryStocks s
JOIN dbo.Warehouses w ON w.WarehouseID = s.WarehouseID
JOIN dbo.Products   p ON p.ProductID   = s.ProductID;
GO

-- 5.2. View lịch sử nhập xuất kho
CREATE VIEW dbo.vw_StockTransactionHistory
AS
SELECT  t.TransactionID,
        t.CreatedAt,
        w.WarehouseID,
        w.WarehouseName,
        p.ProductID,
        p.ProductName,
        t.TransactionType,
        CASE t.TransactionType WHEN 'IMPORT' THEN N'Nhập kho'
                               WHEN 'EXPORT' THEN N'Xuất kho'
                               ELSE N'Điều chỉnh' END AS TransactionTypeName,
        t.QuantityChange,
        t.QuantityBefore,
        t.QuantityAfter,
        t.ReferenceType,
        t.ReferenceID,
        po.PONumber,
        t.Note,
        t.CreatedBy
FROM dbo.StockTransactions t
JOIN dbo.Warehouses w ON w.WarehouseID = t.WarehouseID
JOIN dbo.Products   p ON p.ProductID   = t.ProductID
LEFT JOIN dbo.PurchaseOrders po
       ON t.ReferenceType = 'PURCHASE_ORDER' AND po.PurchaseOrderID = t.ReferenceID;
GO

-- 5.3. View danh sách sản phẩm sắp hết hàng (gồm cả đã hết hàng)
CREATE VIEW dbo.vw_LowStockProducts
AS
SELECT  WarehouseID,
        WarehouseCode,
        WarehouseName,
        ProductID,
        ProductName,
        QuantityOnHand,
        MinStockLevel,
        StockStatus,
        MinStockLevel - QuantityOnHand AS ShortageQty
FROM dbo.vw_InventoryStock
WHERE QuantityOnHand <= MinStockLevel;
GO

-- 5.4. Dữ liệu mẫu nhà cung cấp
INSERT INTO dbo.Suppliers (SupplierCode, SupplierName, ContactPerson, Phone, Email, Address, TaxCode) VALUES
    ('NCC001', N'Công ty TNHH Thiết bị Tin học An Phát',  N'Nguyễn Văn An',  '0901234567', 'sales@anphat.example.com',   N'12 Láng Hạ, Đống Đa, Hà Nội',            '0101234567'),
    ('NCC002', N'Công ty CP Phân phối Công nghệ Hoàng Long', N'Trần Thị Bình', '0912345678', 'contact@hoanglong.example.com', N'45 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh', '0301234567'),
    ('NCC003', N'Công ty TNHH Điện tử Minh Quân',         N'Lê Quốc Cường',  '0923456789', 'info@minhquan.example.com',  N'88 Nguyễn Văn Linh, Hải Châu, Đà Nẵng',  '0401234567'),
    ('NCC004', N'Công ty TNHH Phụ kiện Số Thành Đạt',     N'Phạm Thu Dung',  '0934567890', 'order@thanhdat.example.com', N'27 Trần Phú, Ninh Kiều, Cần Thơ',        '1801234567'),
    ('NCC005', N'Công ty CP Thương mại Việt Tiến',        N'Hoàng Minh Em',  '0945678901', 'sales@viettien.example.com', N'9 Lê Lợi, Hồng Bàng, Hải Phòng',          '0201234567');
GO

-- 5.5. Dữ liệu mẫu kho hàng
INSERT INTO dbo.Warehouses (WarehouseCode, WarehouseName, Address, Phone, ManagerName) VALUES
    ('KHO-HN',  N'Kho Hà Nội',        N'Khu công nghiệp Thăng Long, Đông Anh, Hà Nội',      '0241234567', N'Vũ Đức Hạnh'),
    ('KHO-HCM', N'Kho TP. Hồ Chí Minh', N'Khu chế xuất Tân Thuận, Quận 7, TP. Hồ Chí Minh', '0281234567', N'Đặng Thị Lan'),
    ('KHO-DN',  N'Kho Đà Nẵng',       N'Khu công nghiệp Hòa Khánh, Liên Chiểu, Đà Nẵng',    '0236123456', N'Bùi Văn Khoa');
GO

SELECT * FROM dbo.Suppliers;
SELECT * FROM dbo.Warehouses;
GO


/* =====================================================================
   NHIỆM VỤ 6: KIỂM TRA VÀ KIỂM THỬ
   Mỗi khối là một batch độc lập. Xem tab "Messages" để thấy PASS/FAIL,
   tab "Results" để xem dữ liệu. Các test lấy 3 sản phẩm đầu tiên trong
   bảng Products (theo ProductID) nên chạy được với dữ liệu Products của bạn.
   Kết quả mong đợi tính theo chênh lệch trước/sau nên có thể chạy lại.
   ===================================================================== */

-- 6.0 (bổ sung). Kiểm tra procedure quản lý nhà cung cấp
PRINT N'===== 6.0 Quản lý nhà cung cấp =====';
DECLARE @NewID INT;
EXEC dbo.usp_ManageSupplier @Action = 'INSERT', @SupplierCode = 'NCC-TEST', @SupplierName = N'NCC thử nghiệm',
                            @Phone = '0900000000', @NewSupplierID = @NewID OUTPUT;
EXEC dbo.usp_ManageSupplier @Action = 'UPDATE', @SupplierID = @NewID, @ContactPerson = N'Người liên hệ test';
EXEC dbo.usp_ManageSupplier @Action = 'GET',    @SupplierID = @NewID;

BEGIN TRY
    EXEC dbo.usp_ManageSupplier @Action = 'INSERT', @SupplierCode = 'NCC-TEST', @SupplierName = N'Trùng mã';
    PRINT N'FAIL: thêm trùng mã mà không báo lỗi.';
END TRY
BEGIN CATCH
    PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE();
END CATCH;

EXEC dbo.usp_ManageSupplier @Action = 'DELETE', @SupplierID = @NewID;   -- chưa có phiếu nhập -> xóa hẳn
IF NOT EXISTS (SELECT 1 FROM dbo.Suppliers WHERE SupplierID = @NewID) PRINT N'PASS: đã xóa NCC thử nghiệm.';
ELSE PRINT N'FAIL: NCC thử nghiệm vẫn còn.';
GO


-- 6.1. Kiểm tra nghiệp vụ nhập hàng
PRINT N'===== 6.1 Nghiệp vụ nhập hàng =====';
DECLARE @WH INT, @NCC INT, @P1 INT, @P2 INT;
SELECT @WH  = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-HN';
SELECT @NCC = SupplierID  FROM dbo.Suppliers  WHERE SupplierCode  = 'NCC001';
SELECT @P1 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
SELECT @P2 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

DECLARE @Items dbo.PurchaseOrderItemType, @Bad dbo.PurchaseOrderItemType, @POID INT,
        @B1 INT, @B2 INT, @A1 INT, @A2 INT;

SET @B1 = ISNULL((SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1), 0);
SET @B2 = ISNULL((SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P2), 0);

-- a) Tạo phiếu hợp lệ
INSERT INTO @Items (ProductID, Quantity, UnitPrice) VALUES (@P1, 20, 15000000), (@P2, 50, 250000);
EXEC dbo.usp_CreatePurchaseOrder @SupplierID = @NCC, @WarehouseID = @WH, @Items = @Items,
                                 @Note = N'Phiếu test 6.1', @PurchaseOrderID = @POID OUTPUT;

SELECT * FROM dbo.PurchaseOrders     WHERE PurchaseOrderID = @POID;
SELECT * FROM dbo.PurchaseOrderItems WHERE PurchaseOrderID = @POID;

IF (SELECT Status FROM dbo.PurchaseOrders WHERE PurchaseOrderID = @POID) = 'Pending'
    PRINT N'PASS: phiếu mới tạo có trạng thái Pending.';
ELSE PRINT N'FAIL: trạng thái phiếu mới không phải Pending.';

IF (SELECT TotalAmount FROM dbo.PurchaseOrders WHERE PurchaseOrderID = @POID) = 312500000
    PRINT N'PASS: tổng tiền = 20*15.000.000 + 50*250.000 = 312.500.000.';
ELSE PRINT N'FAIL: tổng tiền sai.';

SET @A1 = ISNULL((SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1), 0);
IF @A1 = @B1 PRINT N'PASS: tạo phiếu chưa làm thay đổi tồn kho.';
ELSE PRINT N'FAIL: tồn kho bị đổi khi mới tạo phiếu.';

-- b) Nhận hàng
EXEC dbo.usp_ReceivePurchaseOrder @PurchaseOrderID = @POID, @ReceivedBy = N'tester';

SET @A1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
SET @A2 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P2);

IF @A1 = @B1 + 20 AND @A2 = @B2 + 50 PRINT N'PASS: tồn kho tăng đúng (+20 và +50) sau khi nhận hàng.';
ELSE PRINT N'FAIL: tồn kho sau nhận hàng không đúng.';

IF (SELECT Status FROM dbo.PurchaseOrders WHERE PurchaseOrderID = @POID) = 'Received'
    PRINT N'PASS: phiếu chuyển sang Received.';
ELSE PRINT N'FAIL: phiếu chưa chuyển sang Received.';

-- c) Nhận hàng lần 2 -> phải lỗi
BEGIN TRY
    EXEC dbo.usp_ReceivePurchaseOrder @PurchaseOrderID = @POID;
    PRINT N'FAIL: nhận hàng 2 lần mà không báo lỗi.';
END TRY
BEGIN CATCH
    PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE();
END CATCH;

-- d) Số lượng không hợp lệ (0)
INSERT INTO @Bad (ProductID, Quantity, UnitPrice) VALUES (@P1, 0, 1000);
BEGIN TRY
    EXEC dbo.usp_CreatePurchaseOrder @SupplierID = @NCC, @WarehouseID = @WH, @Items = @Bad;
    PRINT N'FAIL: tạo phiếu số lượng 0 mà không báo lỗi.';
END TRY
BEGIN CATCH
    PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE();
END CATCH;

-- e) Nhà cung cấp không tồn tại
BEGIN TRY
    EXEC dbo.usp_CreatePurchaseOrder @SupplierID = -1, @WarehouseID = @WH, @Items = @Items;
    PRINT N'FAIL: NCC không tồn tại mà không báo lỗi.';
END TRY
BEGIN CATCH
    PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE();
END CATCH;

-- f) Ràng buộc CHECK ở mức bảng (3.4 và 3.5): ghi trực tiếp dữ liệu sai
BEGIN TRY
    UPDATE dbo.PurchaseOrderItems SET Quantity = 0 WHERE PurchaseOrderID = @POID AND ProductID = @P1;
    PRINT N'FAIL: CHECK số lượng > 0 không hoạt động.';
END TRY
BEGIN CATCH
    PRINT N'PASS (CHECK số lượng): ' + ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    UPDATE dbo.PurchaseOrders SET Status = 'Foo' WHERE PurchaseOrderID = @POID;
    PRINT N'FAIL: CHECK trạng thái không hoạt động.';
END TRY
BEGIN CATCH
    PRINT N'PASS (CHECK trạng thái): ' + ERROR_MESSAGE();
END CATCH;
GO


-- 6.2. Kiểm tra cập nhật số lượng tồn kho
PRINT N'===== 6.2 Cập nhật tồn kho =====';
DECLARE @WH INT, @P3 INT, @Before INT, @After INT, @LastAfter INT;
SELECT @WH = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-HN';
SELECT @P3 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;

SET @Before = ISNULL((SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3), 0);

EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = 30,  @TransactionType = 'IMPORT',
                         @ReferenceType = 'MANUAL', @Note = N'Nhập thêm test 6.2', @CreatedBy = N'tester';
EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = -12, @TransactionType = 'EXPORT',
                         @ReferenceType = 'MANUAL', @Note = N'Xuất bán test 6.2',  @CreatedBy = N'tester';

SET @After = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3);
IF @After = @Before + 18 PRINT N'PASS: tồn kho = trước + 30 - 12.';
ELSE PRINT N'FAIL: tồn kho sau cập nhật không đúng.';

SELECT TOP (1) @LastAfter = QuantityAfter
FROM dbo.StockTransactions WHERE WarehouseID = @WH AND ProductID = @P3 ORDER BY TransactionID DESC;
IF @LastAfter = @After PRINT N'PASS: lịch sử ghi đúng số lượng sau cùng.';
ELSE PRINT N'FAIL: lịch sử không khớp tồn kho.';

SELECT TOP (2) * FROM dbo.vw_StockTransactionHistory
WHERE WarehouseID = @WH AND ProductID = @P3 ORDER BY TransactionID DESC;

-- Các trường hợp sai: phải báo lỗi
BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = -5, @TransactionType = 'IMPORT';
    PRINT N'FAIL: IMPORT với số âm mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = 5, @TransactionType = 'EXPORT';
    PRINT N'FAIL: EXPORT với số dương mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = 0, @TransactionType = 'ADJUST';
    PRINT N'FAIL: số lượng 0 mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = -1, @ProductID = @P3, @QuantityChange = 5, @TransactionType = 'IMPORT';
    PRINT N'FAIL: kho không tồn tại mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;
GO


-- 6.3. Kiểm tra điều chỉnh tồn kho
PRINT N'===== 6.3 Điều chỉnh tồn kho =====';
DECLARE @WH INT, @P3 INT, @Before INT, @Target INT, @After INT, @LastChange INT, @LastType VARCHAR(20);
SELECT @WH = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-HN';
SELECT @P3 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;

SET @Before = ISNULL((SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3), 0);

-- a) Điều chỉnh tăng (kiểm kê thấy thừa 50)
SET @Target = @Before + 50;
EXEC dbo.usp_AdjustStock @WarehouseID = @WH, @ProductID = @P3, @NewQuantity = @Target,
                         @Reason = N'Kiểm kê định kỳ - thừa hàng', @AdjustedBy = N'tester';

SET @After = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3);
SELECT TOP (1) @LastType = TransactionType, @LastChange = QuantityChange
FROM dbo.StockTransactions WHERE WarehouseID = @WH AND ProductID = @P3 ORDER BY TransactionID DESC;

IF @After = @Target AND @LastType = 'ADJUST' AND @LastChange = 50
    PRINT N'PASS: điều chỉnh tăng đúng và ghi lịch sử loại ADJUST (+50).';
ELSE PRINT N'FAIL: điều chỉnh tăng không đúng.';

-- b) Điều chỉnh giảm về 40
EXEC dbo.usp_AdjustStock @WarehouseID = @WH, @ProductID = @P3, @NewQuantity = 40,
                         @Reason = N'Kiểm kê - hàng hư hỏng', @AdjustedBy = N'tester';
IF (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3) = 40
    PRINT N'PASS: điều chỉnh giảm về 40.';
ELSE PRINT N'FAIL: điều chỉnh giảm không đúng.';

-- c) Các trường hợp sai
BEGIN TRY
    EXEC dbo.usp_AdjustStock @WarehouseID = @WH, @ProductID = @P3, @NewQuantity = -1, @Reason = N'Test số âm';
    PRINT N'FAIL: điều chỉnh về số âm mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

BEGIN TRY
    EXEC dbo.usp_AdjustStock @WarehouseID = @WH, @ProductID = @P3, @NewQuantity = 40, @Reason = N'Test không đổi';
    PRINT N'FAIL: điều chỉnh về đúng số hiện tại mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

BEGIN TRY
    EXEC dbo.usp_AdjustStock @WarehouseID = @WH, @ProductID = @P3, @NewQuantity = 60, @Reason = N'   ';
    PRINT N'FAIL: thiếu lý do mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

SELECT TOP (3) * FROM dbo.vw_StockTransactionHistory
WHERE WarehouseID = @WH AND ProductID = @P3 ORDER BY TransactionID DESC;
GO


-- 6.4. Kiểm tra trường hợp sản phẩm hết hàng
PRINT N'===== 6.4 Sản phẩm hết hàng =====';
DECLARE @WH INT, @WH2 INT, @P2 INT, @P3 INT, @Qty INT, @Neg INT;
SELECT @WH  = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-HN';
SELECT @WH2 = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-DN';   -- kho chưa có hàng
SELECT @P2 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;
SELECT @P3 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;

-- a) Xuất hết toàn bộ tồn kho của sản phẩm P3
SET @Qty = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3);
SET @Neg = -@Qty;
EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = @Neg, @TransactionType = 'EXPORT',
                         @ReferenceType = 'MANUAL', @Note = N'Xuất hết hàng test 6.4', @CreatedBy = N'tester';

IF (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3) = 0
    PRINT N'PASS: tồn kho về 0.';
ELSE PRINT N'FAIL: tồn kho chưa về 0.';

IF EXISTS (SELECT 1 FROM dbo.vw_InventoryStock WHERE WarehouseID = @WH AND ProductID = @P3 AND StockStatus = N'Hết hàng')
    PRINT N'PASS: vw_InventoryStock báo "Hết hàng".';
ELSE PRINT N'FAIL: view không báo hết hàng.';

IF EXISTS (SELECT 1 FROM dbo.vw_LowStockProducts WHERE WarehouseID = @WH AND ProductID = @P3)
    PRINT N'PASS: sản phẩm xuất hiện trong vw_LowStockProducts.';
ELSE PRINT N'FAIL: sản phẩm không có trong vw_LowStockProducts.';

EXEC dbo.usp_CheckLowStock @WarehouseID = @WH;            -- theo MinStockLevel của từng dòng
EXEC dbo.usp_CheckLowStock @WarehouseID = NULL, @Threshold = 100;  -- ngưỡng chung 100, mọi kho

-- b) Xuất thêm khi đã hết hàng -> phải lỗi, tồn kho vẫn 0
BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P3, @QuantityChange = -1, @TransactionType = 'EXPORT';
    PRINT N'FAIL: xuất khi hết hàng mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

IF (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P3) = 0
    PRINT N'PASS: tồn kho vẫn là 0 sau lần xuất bị từ chối.';
ELSE PRINT N'FAIL: tồn kho bị đổi.';

-- c) Xuất sản phẩm chưa từng có trong kho
BEGIN TRY
    EXEC dbo.usp_UpdateStock @WarehouseID = @WH2, @ProductID = @P2, @QuantityChange = -1, @TransactionType = 'EXPORT';
    PRINT N'FAIL: xuất sản phẩm chưa có trong kho mà không báo lỗi.';
END TRY
BEGIN CATCH PRINT N'PASS (lỗi như mong đợi): ' + ERROR_MESSAGE(); END CATCH;

-- d) Ràng buộc CHECK tồn kho không âm (3.3): ghi thẳng giá trị âm vào bảng
BEGIN TRY
    UPDATE dbo.InventoryStocks SET QuantityOnHand = -1 WHERE WarehouseID = @WH AND ProductID = @P3;
    PRINT N'FAIL: CHECK tồn kho không âm không hoạt động.';
END TRY
BEGIN CATCH PRINT N'PASS (CHECK tồn kho không âm): ' + ERROR_MESSAGE(); END CATCH;
GO


-- 6.5. Kiểm tra Transaction khi nhập hàng
PRINT N'===== 6.5 Transaction khi nhập hàng =====';
DECLARE @WH INT, @NCC INT, @P1 INT, @P2 INT;
SELECT @WH  = WarehouseID FROM dbo.Warehouses WHERE WarehouseCode = 'KHO-HN';
SELECT @NCC = SupplierID  FROM dbo.Suppliers  WHERE SupplierCode  = 'NCC001';
SELECT @P1 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
SELECT @P2 = ProductID FROM dbo.Products ORDER BY ProductID OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY;

DECLARE @Items dbo.PurchaseOrderItemType, @POID INT, @POID2 INT,
        @B1 INT, @A1 INT, @A2 INT, @Orig2 INT, @TxCount INT;

-- Đảm bảo cả 2 sản phẩm đã có dòng tồn kho tại kho này
EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P1, @QuantityChange = 1, @TransactionType = 'IMPORT', @Note = N'Khởi tạo test 6.5';
EXEC dbo.usp_UpdateStock @WarehouseID = @WH, @ProductID = @P2, @QuantityChange = 1, @TransactionType = 'IMPORT', @Note = N'Khởi tạo test 6.5';

SET @B1    = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
SET @Orig2 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P2);

-- ---- Trường hợp A: sản phẩm thứ 2 gây lỗi -> toàn bộ phiếu phải rollback ----
INSERT INTO @Items (ProductID, Quantity, UnitPrice) VALUES (@P1, 10, 1000000), (@P2, 10, 200000);
EXEC dbo.usp_CreatePurchaseOrder @SupplierID = @NCC, @WarehouseID = @WH, @Items = @Items,
                                 @Note = N'Phiếu test 6.5-A', @PurchaseOrderID = @POID OUTPUT;

-- Giả lập: tồn của P2 sát giới hạn INT nên cộng thêm 10 sẽ vượt giới hạn (lỗi 50038).
-- P1 được xử lý trước (theo ProductID) và đã cộng, nhưng phải bị hoàn tác.
UPDATE dbo.InventoryStocks SET QuantityOnHand = 2147483647 WHERE WarehouseID = @WH AND ProductID = @P2;

BEGIN TRY
    EXEC dbo.usp_ReceivePurchaseOrder @PurchaseOrderID = @POID, @ReceivedBy = N'tester';
    PRINT N'FAIL: lẽ ra nhận hàng phải lỗi.';
END TRY
BEGIN CATCH
    PRINT N'Lỗi như mong đợi: ' + ERROR_MESSAGE();
END CATCH;

SET @A1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
IF @A1 = @B1 PRINT N'PASS: tồn kho sản phẩm 1 không bị cộng (đã rollback).';
ELSE PRINT N'FAIL: sản phẩm 1 vẫn bị cộng dù phiếu lỗi.';

IF (SELECT Status FROM dbo.PurchaseOrders WHERE PurchaseOrderID = @POID) = 'Pending'
    PRINT N'PASS: phiếu vẫn ở trạng thái Pending.';
ELSE PRINT N'FAIL: trạng thái phiếu đã bị đổi.';

SET @TxCount = (SELECT COUNT(*) FROM dbo.StockTransactions WHERE ReferenceType = 'PURCHASE_ORDER' AND ReferenceID = @POID);
IF @TxCount = 0 PRINT N'PASS: không còn dòng lịch sử nào của phiếu lỗi.';
ELSE PRINT N'FAIL: vẫn còn dòng lịch sử của phiếu lỗi.';

IF @@TRANCOUNT = 0 PRINT N'PASS: không còn transaction treo.';
ELSE PRINT N'FAIL: còn transaction chưa đóng.';

-- Khôi phục tồn của P2 rồi nhận lại phiếu: lần này phải thành công
UPDATE dbo.InventoryStocks SET QuantityOnHand = @Orig2 WHERE WarehouseID = @WH AND ProductID = @P2;
EXEC dbo.usp_ReceivePurchaseOrder @PurchaseOrderID = @POID, @ReceivedBy = N'tester';

SET @A1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
SET @A2 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P2);
IF @A1 = @B1 + 10 AND @A2 = @Orig2 + 10
    PRINT N'PASS: sau khi khắc phục lỗi, nhận lại phiếu thành công (+10 và +10).';
ELSE PRINT N'FAIL: nhận lại phiếu không đúng.';

-- ---- Trường hợp B: procedure chạy trong transaction của người gọi, người gọi ROLLBACK ----
SET @B1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
DELETE FROM @Items;
INSERT INTO @Items (ProductID, Quantity, UnitPrice) VALUES (@P1, 5, 1000000);
EXEC dbo.usp_CreatePurchaseOrder @SupplierID = @NCC, @WarehouseID = @WH, @Items = @Items,
                                 @Note = N'Phiếu test 6.5-B', @PurchaseOrderID = @POID2 OUTPUT;

BEGIN TRANSACTION;
    EXEC dbo.usp_ReceivePurchaseOrder @PurchaseOrderID = @POID2, @ReceivedBy = N'tester';
    SET @A1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
    IF @A1 = @B1 + 5 PRINT N'PASS: bên trong transaction, tồn kho đã tăng +5.';
    ELSE PRINT N'FAIL: tồn kho trong transaction không đúng.';
ROLLBACK TRANSACTION;

SET @A1 = (SELECT QuantityOnHand FROM dbo.InventoryStocks WHERE WarehouseID = @WH AND ProductID = @P1);
IF @A1 = @B1 AND (SELECT Status FROM dbo.PurchaseOrders WHERE PurchaseOrderID = @POID2) = 'Pending'
    PRINT N'PASS: sau ROLLBACK của người gọi, tồn kho và trạng thái phiếu được hoàn tác.';
ELSE PRINT N'FAIL: ROLLBACK ngoài không hoàn tác hết.';
GO

-- Tổng kết sau khi kiểm thử
SELECT * FROM dbo.vw_InventoryStock ORDER BY WarehouseName, ProductName;
SELECT * FROM dbo.vw_StockTransactionHistory ORDER BY TransactionID;
SELECT * FROM dbo.PurchaseOrders ORDER BY PurchaseOrderID;
GO


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



