--------------------------------------------------------------------------------------------------------------------------

-- 7. JOIN

--- 7.1. INNER JOIN/JOIN: JOIN (hay đầy đủ là INNER JOIN) được dùng để kết hợp dữ liệu từ 2 bảng dựa trên điều kiện liên kết (thường là khóa ngoại - khóa chính).
SELECT 
    nv.Id,
    nv.Ma AS MaNhanVien,
    nv.Ho,
    nv.TenDem,
    nv.Ten,
    nv.GioiTinh,
    nv.NgaySinh,
    nv.Sdt,
    ch.Ten AS TenCuaHang,
    cv.Ten AS TenChucVu
FROM 
    NhanVien nv
INNER JOIN 
    CuaHang ch ON nv.IdCH = ch.Id
JOIN 
    ChucVu cv ON nv.IdCV = cv.Id;

--- 7.2. FULL OUTER JOIN (OUTER JOIN):Lấy tất cả dòng từ cả 2 bảng, dù có khớp hay không
---- FULL OUTER JOIN (⚠️ Không hỗ trợ trực tiếp trong MySQL) có thể thay thế bằng cách bên dưới

----- MySQL: Dùng UNION hợp nhất 2 phần A và B
SELECT *FROM NhanVien nv
LEFT JOIN CuaHang ch ON nv.IdCH = ch.Id
UNION
SELECT * FROM NhanVien nv
RIGHT JOIN CuaHang ch ON nv.IdCH = ch.Id;

----- SQL: Dùng OUTER JOIN bth
SELECT * FROM NhanVien nv 
FULL OUTER JOIN CuaHang ch 
ON nv.IdCH = ch.Id
-- Thêm WHERE chỉ lấy bản ghi có CH còn lại bỏ qua
WHERE nv.Id is null

--- 7.3. RIGHT OUTER JOIN (RIGHT JOIN): Lấy tất cả bên phải, kể cả không khớp bên trái
SELECT *
FROM NhanVien nv
RIGHT JOIN CuaHang ch ON nv.IdCH = ch.Id;

--- 7.4. LEFT OUTER JOIN (LEFT JOIN): Lấy tất cả bên trái, kể cả không khớp bên phải
SELECT *
FROM NhanVien nv
LEFT JOIN CuaHang ch ON nv.IdCH = ch.Id;

--- 7.5. CROSS JOIN: Kết hợp tất cả dòng từ 2 bảng (tổ hợp)
---- Kết quả của CROSS JOIN = Số dòng bảng A × Số dòng bảng B
SELECT *
FROM NhanVien nv
CROSS JOIN CuaHang ch;

--- 7.6. SELF JOIN (tự nối chính mình) là kỹ thuật dùng JOIN một bảng với chính nó, để tìm mối quan hệ giữa các dòng trong cùng một bảng.
SELECT 
	a.*,
	CASE
	  WHEN a.Id = b.Id THEN 'Gửi cho chính mình'
	  ELSE 'Gửi cho nhân viên khác'
	END AS LoaiGui
FROM NhanVien a
JOIN NhanVien b ON a.Id = b.IdGuiBC;

--- 7.7. NATURAL JOIN trong SQL là câu lệnh dùng để kết nối hai bảng lại với nhau dựa trên các cột có cùng tên và kiểu dữ liệu ở cả hai bảng.
SELECT *
FROM PhongBan
NATURAL JOIN NhanVien;


--------------------------------------------------------------------------------------------------------------------------

-- 8. CRUD DB/TABLE

--- 8.1. CREATE/DROP DATABASE
CREATE DATABASE Demo_01
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

drop database Demo_01

--- 8.2. COLUMN CONSTRAINTS
| Tên constraint     | Mô tả ngắn                               | Hệ quả                           |
| ------------------ | ---------------------------------------- | -------------------------------- |
| `NOT NULL`         | Không cho phép giá trị `NULL`            | Cột bắt buộc có dữ liệu          |
| `UNIQUE`           | Không cho phép giá trị trùng lặp         | Không trùng nhau                 |
| `PRIMARY KEY`      | Khóa chính, vừa `NOT NULL` + `UNIQUE`    | Duy nhất, định danh từng bản ghi |
| `FOREIGN KEY`      | Khóa ngoại, tham chiếu sang bảng khác    | Tạo liên kết giữa các bảng       |
| `DEFAULT`          | Gán giá trị mặc định nếu không nhập vào  | Cung cấp giá trị ngầm định       |
| `CHECK`            | Ràng buộc theo điều kiện biểu thức logic | Kiểm tra điều kiện cụ thể        |
| `AUTO_INCREMENT`   | Tự tăng số (chỉ trong MySQL/MariaDB)     | Thường dùng cho ID               |
| `GENERATED` / `AS` | Cột ảo tính toán từ các cột khác         | Không nhập tay được              |

--- 8.3. CREATE TABLE
CREATE TABLE staff(
	staff_id	 	char 		 primary key,
	name 			nvarchar 	 not null,
	email			varchar(50)  default 'hoant@gmail.com'
	address_id		char         references address(address_id)
)

--- 8.4. INSERT DATA 
INSERT INTO NhanVien (
    Id, Ma, Ten, TenDem, Ho, GioiTinh, NgaySinh, DiaChi, Sdt, MatKhau, IdCH, IdCV, IdGuiBC, TrangThai
) VALUES (
    UUID(), 'NV003', 'Lan', 'Thị', 'Trần', 'Nữ', '1992-03-10',
    '456 Lê Lợi, Đà Nẵng', '0911122333', 'matkhau123',
    'b75d8ebe-6932-11f0-bc80-60189545588f', -- IdCH
    'b4787c90-6932-11f0-bc80-60189545588f', -- IdCV
    NULL, 1
);

--- 8.5. ALTER TABLE
| STT | Mục đích                          | Câu lệnh SQL                                                                                     | Ghi chú thêm             |
| --- | --------------------------------- | ------------------------------------------------------------------------------------------------ | ------------------------ |
| 1   | Thêm cột mới                      | `ALTER TABLE NhanVien ADD COLUMN SoDT VARCHAR(15);`                                              | Có thể thêm nhiều cột    |
| 2   | Xoá cột                           | `ALTER TABLE NhanVien DROP COLUMN SoDT;`                                                         | Xoá hoàn toàn cột        |
| 3   | Đổi tên cột                       | `ALTER TABLE NhanVien RENAME COLUMN SoDT TO DienThoai;`                                          | Chỉ MySQL 8+             |
| 4   | Đổi kiểu dữ liệu cột              | `ALTER TABLE NhanVien MODIFY COLUMN DienThoai CHAR(10);`                                         | `MODIFY` giữ tên         |
| 5   | Đổi tên cột và kiểu cùng lúc      | `ALTER TABLE NhanVien CHANGE COLUMN DienThoai SDT VARCHAR(20);`                                  | Dùng trong MySQL/MariaDB |
| 6   | Thêm `NOT NULL`                   | `ALTER TABLE NhanVien MODIFY COLUMN HoTen VARCHAR(100) NOT NULL;`                                |                          |
| 7   | Thêm giá trị mặc định (`DEFAULT`) | `ALTER TABLE NhanVien ALTER COLUMN GioiTinh SET DEFAULT 'Nam';`                                  |                          |
| 8   | Xoá `DEFAULT`                     | `ALTER TABLE NhanVien ALTER COLUMN GioiTinh DROP DEFAULT;`                                       |                          |
| 9   | Thêm `UNIQUE`                     | `ALTER TABLE NhanVien ADD CONSTRAINT uniq_email UNIQUE (Email);`                                 |                          |
| 10  | Xoá `UNIQUE`                      | `ALTER TABLE NhanVien DROP INDEX uniq_email;`                                                    |                          |
| 11  | Thêm `FOREIGN KEY`                | `ALTER TABLE NhanVien ADD CONSTRAINT fk_phong FOREIGN KEY (MaPhong) REFERENCES PhongBan(Id);`    |                          |
| 12  | Xoá `FOREIGN KEY`                 | `ALTER TABLE NhanVien DROP FOREIGN KEY fk_phong;`                                                |                          |
| 13  | Thêm `CHECK`                      | `ALTER TABLE NhanVien ADD CONSTRAINT check_tuoi CHECK (YEAR(CURDATE()) - YEAR(NgaySinh) >= 18);` | Chỉ MySQL 8+             |
| 14  | Đổi tên bảng                      | `RENAME TABLE NhanVien TO NhanSu;`                                                               | Ngoài `ALTER TABLE`      |

--> Chưa xong
--- 8.6. TRUNCATE & DROP
| Thuộc tính                            | `TRUNCATE`                                | `DROP`                                  |
| ------------------------------------- | ----------------------------------------- | --------------------------------------- |
| **Tác động đến bảng**                 | Xóa tất cả dữ liệu, giữ lại cấu trúc bảng | Xóa toàn bộ bảng (cấu trúc + dữ liệu)   |
| **Có thể rollback không?**            | Không (nếu không dùng trong transaction)  | Không                                   |
| **Tốc độ thực thi**                   | Nhanh hơn `DELETE`                        | Nhanh nhất, vì xóa hoàn toàn bảng       |
| **Còn dùng bảng sau lệnh?**           | Có — bảng vẫn còn, có thể insert tiếp     | Không — bảng không tồn tại sau khi drop |
| **Reset IDENTITY (tự tăng)?**         | Có (trả về 1)                             | Có (do bảng bị xóa hoàn toàn)           |
| **Gọi trigger?**                      | Không                                     | Không                                   |
| **Khả năng dùng trong FK ràng buộc?** | Không nếu bảng bị ràng buộc bởi FK        | Không nếu bảng bị ràng buộc bởi FK      |


--- 8.7. CHECK and update constrain
select * from phongban
CREATE TABLE PhongBan (
    MaPhong INT PRIMARY KEY,         -- Khóa chính
    TenPhong VARCHAR(100) NOT NULL,  -- Tên phòng không được để trống
    DiaChi VARCHAR(255),             -- Địa chỉ có thể null
    MaTruongPhong INT,               -- Mã trưởng phòng (có thể là nhân viên)
    NgayThanhLap DATE                -- Ngày thành lập
);
--- 8.8. ADD FOREIGN KEY
ALTER TABLE PhongBan
ADD CONSTRAINT fk_TruongPhong FOREIGN KEY (Id_NV) REFERENCES NhanVien(Id);

--- 8.9. INSERT DATA
INSERT INTO PhongBan (MaPhong, TenPhong, Id_NV)
VALUES 
  (104, 'Phòng Kế Toán', '457f6378-693d-11f0-bc80-60189545588f'),
  (105, 'Phòng Nhân Sự', '457f6378-693d-11f0-bc80-60189545588f'),
  (107, 'Phòng Nhân Sự', '457f6378-693d-11f0-bc80-60189545588f'),
  (108, 'Phòng Nhân Sự', '457f6378-693d-11f0-bc80-60189545588f'),
  (109, 'Phòng Nhân Sự', '457f6378-693d-11f0-bc80-60189545588f'),
  (110, 'Phòng Nhân Sự', '457f6378-693d-11f0-bc80-60189545588f'),
  (106, 'Phòng Kỹ Thuật', '457f6378-693d-11f0-bc80-60189545588f');

--- 8.10. Update kiểu dữ liệu
MODIFY COLUMN NgayThanhLap DATE;

--- 8.11. Kiểm tra hiện trigger của bảng
SHOW TRIGGERS LIKE 'PhongBan';
