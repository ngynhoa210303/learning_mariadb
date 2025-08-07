--------------------------------------------------------------------------------------------------------------------------
-- Slide: https://pdfhost.io/v/JKH62p43pD_Day_14_-_Course_slides
--------------------------------------------------------------------------------------------------------------------------

-- 11. STORE PROCEDURES/ TRANSACTION/ User-defined functions

--- 11.1. User-defined functions
-- Check version DB
SELECT VERSION();
-- Check user sử dụng db
SELECT CURRENT_USER();
-- Check function có trong db (Hoặc vào thư mục db>Procedures>function )
SHOW FUNCTION STATUS WHERE Db = 'finalass_fpolyshop_fa22_sof205__sof2041';

-- Hàm tính tuổi
CREATE FUNCTION TinhTuoi(ngay_sinh DATE)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE tuoi INT;
  SET tuoi = TIMESTAMPDIFF(YEAR, ngay_sinh, CURDATE());
  RETURN tuoi;
END

SELECT TinhTuoi('2000-01-01');
/* Tạo một hàm người dùng định nghĩa (user-defined function) tên là first_fuction.
   DETERMINISTIC	    Hàm không phụ thuộc bên ngoài, chỉ dùng input để tính.
   NOT DETERMINISTIC	Hàm phụ thuộc vào hàm hệ thống (giờ, ngẫu nhiên...).
   DECLARE              Khai báo biến
*/

CREATE FUNCTION first_fuction(c1 int, c2 int)
RETURNS int 
DETERMINISTIC
BEGIN
  DECLARE c3 INT;
  SET c3 = c1+c2+3;
 RETURN c3;
END

SELECT first_fuction(2,3);

-- Báo đỏ last_name/first_name/total_cost nhưng k sai
CREATE FUNCTION total_cost_from_name(first_name VARCHAR(50), last_name VARCHAR(50))
RETURNS DECIMAL(30,3)
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE total_cost DECIMAL(30,3);
  	SELECT n.Luong INTO total_cost
  	FROM NhanVien n
  	WHERE n.Ten LIKE CONCAT('%', first_name, '%')
    AND n.TenDem LIKE CONCAT('%', last_name, '%');
  RETURN IFNULL(total_cost, 0);
end
-- LƯU Ý ở mariadb k select được kết quả > 2 bản ghi --> VD SELECT total_cost_from_name('Mary ','Thị') có 2 kết quả trả về sẽ select không thành công
SELECT total_cost_from_name('Mary ','Thị')

--- 11.2. TRANSACTION & ROLLBACK
/*** Trong MariaDB (và MySQL), transaction được dùng để đảm bảo rằng một nhóm lệnh SQL thực thi toàn vẹn — nghĩa là tất cả thành công thì mới lưu, còn nếu có lỗi thì rollback (hoàn tác) toàn bộ. */
-- nút run script (Alt+X) để chạy toàn bộ KHÔNG PHẢI QUERIES

START TRANSACTION;
-- Các lệnh SQL cần thực thi
UPDATE phongban set NgayThanhLap = NgayThanhLap + INTERVAL 1 DAY 
WHERE MaPhong = 101;
UPDATE phongban  SET NgayThanhLap = NgayThanhLap + INTERVAL 2 DAY 
WHERE MaPhong = 1099;
-- Nếu không có lỗi:
COMMIT;
-- Nếu có lỗi (có thể thêm điều kiện kiểm tra trong ứng dụng):
ROLLBACK;

select * from phongban

--- 11.3. STORE PROCEDURES
/*
 * Mục đích chính của procedure:
- Tự động hóa các thao tác lặp lại: Chạy thủ tục bằng 1 dòng lệnh CALL ten_procedure(); thay vì viết lại nhiều lệnh mỗi lần.
- Tăng hiệu năng và bảo mật
- Tránh gửi nhiều câu lệnh từ ứng dụng → server
- Hạn chế người dùng thao tác trực tiếp trên bảng
- Hỗ trợ giao dịch (transaction)
- Procedure có thể bao gồm nhiều INSERT, UPDATE, DELETE → rollback nếu có lỗi
- Dễ bảo trì: Nếu logic thay đổi → chỉ sửa trong procedure, không cần sửa nhiều nơi trong code.
*/
/* Không được phép thực hiện các thao tác làm thay đổi dữ liệu (data-modifying statements) như:
INSERT, UPDATE, DELETE, CREATE, DROP, v.v.*/
So sánh nhanh: FUNCTION vs PROCEDURE
| Tiêu chí                | `FUNCTION`                         | `PROCEDURE`                           |
| ------------------------| ---------------------------------- | ------------------------------------- |
| Trả về giá trị          | Bắt buộc phải trả về 1 giá trị     | Không bắt buộc trả về gì cả           |
| Gọi từ sql              | Có thể dùng trong `SELECT`         | Không thể dùng trong `SELECT`         |
| Sử dụng trong query     | Được dùng trong `WHERE`, `SELECT`  | Không được                            |
| Dùng cho nhiều thao tác | Không phù hợp                      | Rất phù hợp (nhiều câu lệnh SQL)      |
| Dùng transaction        | Không nên                          | Có thể dùng `START TRANSACTION`       |
| Gọn nhẹ                 | Nếu chỉ cần tính toán nhỏ          | Không nên dùng nếu chỉ để tính toán   |
------------------------------------------------------------------------------------------------------

CREATE PROCEDURE ThemPhongBan (
  in ma_phong int(11),
  IN ten_phong VARCHAR(50) CHARACTER SET utf8mb4,
  IN dia_chi VARCHAR(50) CHARACTER SET utf8mb4
)
BEGIN
  INSERT INTO phongban(MaPhong,TenPhong, DiaChi, Id_NV) 
  VALUES (ma_phong,ten_phong, dia_chi,'457f6378-693d-11f0-bc80-60189545588f');
END;
CALL ThemPhongBan(2322,'Phòng Marketing', '304242343');
select * from phongban
-- VD2
CREATE PROCEDURE tang_ngay_phongban()
BEGIN
   START TRANSACTION;

   UPDATE phongban 
   SET NgayThanhLap = NgayThanhLap + INTERVAL 1 DAY
   WHERE MaPhong = '101';

   UPDATE phongban 
   SET NgayThanhLap = NgayThanhLap + INTERVAL 1 DAY
   WHERE MaPhong = '102';

   COMMIT;
END 
CALL tang_ngay_phongban();
select * from phongban
