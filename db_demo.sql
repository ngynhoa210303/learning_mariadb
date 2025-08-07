-- CREATE TABLE customers (
--   id INT AUTO_INCREMENT PRIMARY KEY,
--   name VARCHAR(100),
--   email VARCHAR(100),
--   segment VARCHAR(50),
--   subscribed BOOLEAN
-- );
-- INSERT INTO customers (name, email, segment, subscribed)
-- VALUES
-- ('Alice', 'alice@example.com', 'marketer', 1),
-- ('Bob', 'bob@example.com', 'blogger', 1);
-- select * from customers;
-- select * from test_n8n;
-- SHOW GRANTS FOR 'root'@'127.0.0.1';
-- SHOW VARIABLES WHERE Variable_name = 'port';
-- SHOW VARIABLES WHERE Variable_name = 'hostname';
-- SHOW VARIABLES LIKE 'pid_file';

-- 
-- USE FINALASS_FPOLYSHOP_FA22_SOF205__SOF2041
-- GO
CREATE TABLE ChucVu (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(50) DEFAULT NULL
);
-- CuaHang
CREATE TABLE CuaHang (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(50) DEFAULT NULL,
  DiaChi VARCHAR(100) DEFAULT NULL,
  ThanhPho VARCHAR(50) DEFAULT NULL,
  QuocGia VARCHAR(50) DEFAULT NULL
);
-- NhanVien
CREATE TABLE NhanVien (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30) DEFAULT NULL,
  TenDem VARCHAR(30) DEFAULT NULL,
  Ho VARCHAR(30) DEFAULT NULL,
  GioiTinh VARCHAR(10) DEFAULT NULL,
  NgaySinh DATE DEFAULT NULL,
  DiaChi VARCHAR(100) DEFAULT NULL,
  Sdt VARCHAR(30) DEFAULT NULL,
  MatKhau TEXT DEFAULT NULL,
  IdCH CHAR(36),
  IdCV CHAR(36),
  IdGuiBC CHAR(36),
  TrangThai INT DEFAULT 0,
  FOREIGN KEY (IdCH) REFERENCES CuaHang(Id),
  FOREIGN KEY (IdCV) REFERENCES ChucVu(Id),
  FOREIGN KEY (IdGuiBC) REFERENCES NhanVien(Id)
);
-- KhachHang
CREATE TABLE KhachHang (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30),
  TenDem VARCHAR(30) DEFAULT NULL,
  Ho VARCHAR(30) DEFAULT NULL,
  NgaySinh DATE DEFAULT NULL,
  Sdt VARCHAR(30) DEFAULT NULL,
  DiaChi VARCHAR(100) DEFAULT NULL,
  ThanhPho VARCHAR(50) DEFAULT NULL,
  QuocGia VARCHAR(50) DEFAULT NULL,
  MatKhau TEXT DEFAULT NULL
);

-- HoaDon
CREATE TABLE HoaDon (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  IdKH CHAR(36),
  IdNV CHAR(36),
  Ma VARCHAR(20) UNIQUE,
  NgayTao DATE DEFAULT NULL,
  NgayThanhToan DATE DEFAULT NULL,
  NgayShip DATE DEFAULT NULL,
  NgayNhan DATE DEFAULT NULL,
  TinhTrang INT DEFAULT 0,
  TenNguoiNhan VARCHAR(50) DEFAULT NULL,
  DiaChi VARCHAR(100) DEFAULT NULL,
  Sdt VARCHAR(30) DEFAULT NULL,
  FOREIGN KEY (IdKH) REFERENCES KhachHang(Id),
  FOREIGN KEY (IdNV) REFERENCES NhanVien(Id)
);

-- GioHang
CREATE TABLE GioHang (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  IdKH CHAR(36),
  IdNV CHAR(36),
  Ma VARCHAR(20) UNIQUE,
  NgayTao DATE DEFAULT NULL,
  NgayThanhToan DATE DEFAULT NULL,
  TenNguoiNhan VARCHAR(50) DEFAULT NULL,
  DiaChi VARCHAR(100) DEFAULT NULL,
  Sdt VARCHAR(30) DEFAULT NULL,
  TinhTrang INT DEFAULT 0,
  FOREIGN KEY (IdKH) REFERENCES KhachHang(Id),
  FOREIGN KEY (IdNV) REFERENCES NhanVien(Id)
);

-- SanPham
CREATE TABLE SanPham (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30)
);

-- NSX
CREATE TABLE NSX (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30)
);

-- MauSac
CREATE TABLE MauSac (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30)
);

-- DongSP
CREATE TABLE DongSP (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  Ma VARCHAR(20) UNIQUE,
  Ten VARCHAR(30)
);

-- ChiTietSP
CREATE TABLE ChiTietSP (
  Id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
  IdSP CHAR(36),
  IdNsx CHAR(36),
  IdMauSac CHAR(36),
  IdDongSP CHAR(36),
  NamBH INT DEFAULT NULL,
  MoTa VARCHAR(50) DEFAULT NULL,
  SoLuongTon INT,
  GiaNhap DECIMAL(20,0) DEFAULT 0,
  GiaBan DECIMAL(20,0) DEFAULT 0,
  FOREIGN KEY (IdSP) REFERENCES SanPham(Id),
  FOREIGN KEY (IdNsx) REFERENCES NSX(Id),
  FOREIGN KEY (IdMauSac) REFERENCES MauSac(Id),
  FOREIGN KEY (IdDongSP) REFERENCES DongSP(Id)
);

-- HoaDonChiTiet
CREATE TABLE HoaDonChiTiet (
  IdHoaDon CHAR(36),
  IdChiTietSP CHAR(36),
  SoLuong INT,
  DonGia DECIMAL(20,0) DEFAULT 0,
  PRIMARY KEY (IdHoaDon, IdChiTietSP),
  FOREIGN KEY (IdHoaDon) REFERENCES HoaDon(Id),
  FOREIGN KEY (IdChiTietSP) REFERENCES ChiTietSP(Id)
);

-- GioHangChiTiet
CREATE TABLE GioHangChiTiet (
  IdGioHang CHAR(36),
  IdChiTietSP CHAR(36),
  SoLuong INT,
  DonGia DECIMAL(20,0) DEFAULT 0,
  DonGiaKhiGiam DECIMAL(20,0) DEFAULT 0,
  PRIMARY KEY (IdGioHang, IdChiTietSP),
  FOREIGN KEY (IdGioHang) REFERENCES GioHang(Id),
  FOREIGN KEY (IdChiTietSP) REFERENCES ChiTietSP(Id)
);

-- Dữ liệu mẫu cho ChucVu
INSERT INTO ChucVu (Id, Ma, Ten) VALUES
(UUID(), 'CV01', 'Quản lý'),
(UUID(), 'CV02', 'Nhân viên'),
(UUID(), 'CV03', 'Thu ngân'),
(UUID(), 'CV04', 'Bán hàng'),
(UUID(), 'CV05', 'Kho');

-- Dữ liệu mẫu cho CuaHang
INSERT INTO CuaHang (Id, Ma, Ten, DiaChi, ThanhPho, QuocGia) VALUES
(UUID(), 'CH01', 'Cửa hàng A', '123 Lê Lợi', 'Hà Nội', 'Việt Nam'),
(UUID(), 'CH02', 'Cửa hàng B', '456 Nguyễn Huệ', 'Đà Nẵng', 'Việt Nam'),
(UUID(), 'CH03', 'Cửa hàng C', '789 Trần Hưng Đạo', 'Hồ Chí Minh', 'Việt Nam'),
(UUID(), 'CH04', 'Cửa hàng D', '12 Lý Thường Kiệt', 'Huế', 'Việt Nam'),
(UUID(), 'CH05', 'Cửa hàng E', '34 Cách Mạng', 'Cần Thơ', 'Việt Nam');

-- Dữ liệu mẫu cho KhachHang
INSERT INTO KhachHang (Id, Ma, Ten, TenDem, Ho, NgaySinh, Sdt, DiaChi, ThanhPho, QuocGia, MatKhau) VALUES
(UUID(), 'KH01', 'An', 'Văn', 'Nguyễn', '1990-01-01', '0909123456', '12 Nguyễn Trãi', 'Hà Nội', 'Việt Nam', '123'),
(UUID(), 'KH02', 'Bình', 'Thế', 'Trần', '1992-05-10', '0909765432', '45 Hai Bà Trưng', 'Đà Nẵng', 'Việt Nam', '123'),
(UUID(), 'KH03', 'Chi', 'Thị', 'Lê', '1995-08-20', '0912123123', '89 Lê Duẩn', 'Hồ Chí Minh', 'Việt Nam', '123'),
(UUID(), 'KH04', 'Dũng', 'Văn', 'Phạm', '1989-12-30', '0988888888', '11 Hùng Vương', 'Huế', 'Việt Nam', '123'),
(UUID(), 'KH05', 'Em', 'Ngọc', 'Bùi', '1993-03-15', '0933555777', '76 Điện Biên', 'Cần Thơ', 'Việt Nam', '123');

-- Dữ liệu mẫu cho SanPham
INSERT INTO SanPham (Id, Ma, Ten) VALUES
(UUID(), 'SP01', 'Áo thun'),
(UUID(), 'SP02', 'Quần jean'),
(UUID(), 'SP03', 'Giày sneaker'),
(UUID(), 'SP04', 'Túi xách'),
(UUID(), 'SP05', 'Nón lưỡi trai');

-- Dữ liệu mẫu cho NSX
INSERT INTO NSX (Id, Ma, Ten) VALUES
(UUID(), 'NSX01', 'Nhà sản xuất A'),
(UUID(), 'NSX02', 'Nhà sản xuất B'),
(UUID(), 'NSX03', 'Nhà sản xuất C'),
(UUID(), 'NSX04', 'Nhà sản xuất D'),
(UUID(), 'NSX05', 'Nhà sản xuất E');

-- Dữ liệu mẫu cho MauSac
INSERT INTO MauSac (Id, Ma, Ten) VALUES
(UUID(), 'MS01', 'Đỏ'),
(UUID(), 'MS02', 'Xanh'),
(UUID(), 'MS03', 'Vàng'),
(UUID(), 'MS04', 'Đen'),
(UUID(), 'MS05', 'Trắng');

-- Dữ liệu mẫu cho DongSP
INSERT INTO DongSP (Id, Ma, Ten) VALUES
(UUID(), 'DSP01', 'Dòng cao cấp'),
(UUID(), 'DSP02', 'Dòng phổ thông'),
(UUID(), 'DSP03', 'Dòng thể thao'),
(UUID(), 'DSP04', 'Dòng học sinh'),
(UUID(), 'DSP05', 'Dòng văn phòng');
select * from dongsp d  

SELECT distinct nv.Id, nv.Ho, nv.TenDem,nv.Ten, nv.GioiTinh, nv.NgaySinh, nv.Sdt FROM NhanVien nv
