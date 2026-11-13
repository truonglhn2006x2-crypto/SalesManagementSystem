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



