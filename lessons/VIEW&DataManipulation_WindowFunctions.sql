

--------------------------------------------------------------------------------------------------------------------------
-- Slide: https://pdfhost.io/v/VAf5d4X3WG_Day_10_-_Course_slides
--------------------------------------------------------------------------------------------------------------------------

-- 9. VIEW & Data Manipulation -----------------------------------------------------------------------------------------

--- 9.1. UPDATE-----------------------------------------------------------------
update PhongBan b set TenPhong='Phòng IT' where b.MaPhong ='101'
select * from PhongBan

--- 9.2. DELETE
DELETE FROM phongban WHERE MaPhong in (105,106);
---- RETURNING để xem lại các hàng đã xóa (Maria db đang k hỗ trợ)
DELETE FROM phongban WHERE MaPhong in (105,106) returning *

--- 9.3. CREATE TABLE ... AS : 
---- Tạo một bảng mới tên là pb (viết tắt của PhongBan). Chèn dữ liệu từ bảng PhongBan vào bảng pb, nhưng chỉ lấy 2 cột: MaPhong, TenPhong. Chỉ lấy các dòng có DiaChi bắt đầu bằng số 1 (LIKE '1%').
CREATE TABLE pb
as 
	select MaPhong, TenPhong from PhongBan where 	DiaChi like '1%'
select * from PHONGBAN

/* Tạo bảng pb_test02 chứa dữ liệu từ 3 bảng: NhanVien, CuaHang, ChucVu.
-- >> LEFT JOIN với CuaHang: lấy tất cả nhân viên, có hoặc không có cửa hàng.
-- >> RIGHT JOIN với ChucVu: giữ tất cả chức vụ, dù có hoặc không có nhân viên giữ.
-- ➡️ Mục tiêu: lưu trữ danh sách kết hợp nhân viên – cửa hàng – chức vụ.
*/
CREATE TABLE pb_test02 AS 
SELECT 
  nv.Id AS NhanVienId,
  nv.Ten AS NhanVienTen,
  ch.Id AS CuaHangId,
  ch.Ten AS CuaHangTen,
  cv.Id AS ChucVuId,
  cv.Ten AS ChucVuTen
FROM (
    NhanVien nv
    LEFT JOIN CuaHang ch ON nv.IdCH = ch.Id
)
RIGHT JOIN ChucVu cv ON nv.IdCV = cv.Id;

--- 9.4. CREATE VIEW

---- CREATE VIEW trong SQL được dùng để tạo một bảng ảo từ kết quả của một câu truy vấn (SELECT). Nó không lưu trữ dữ liệu thật mà chỉ lưu công thức truy vấn, và bạn có thể dùng nó như một bảng bình thường.
CREATE VIEW view_NhanVien_ChucVu AS
SELECT nv.Ten, cv.Ten as 'Ten Chuc Vu'
FROM NhanVien nv
JOIN ChucVu cv ON nv.IdCV = cv.Id;
select * from nhanvien n 

---- CREATE MATERIALIZED VIEW (Tham Khảo chứ k dùng)
| Tiêu chí                     | VIEW (View thường)                 | MATERIALIZED VIEW                           |
| ---------------------------- | ---------------------------------- | ------------------------------------------- |
| Lưu trữ dữ liệu              | Không – chỉ là truy vấn ảo         | Có – dữ liệu được lưu lại                   |
| Tốc độ truy vấn              | Chậm hơn nếu truy vấn phức tạp     | Nhanh hơn vì có dữ liệu thực                |
| Cập nhật dữ liệu             | Luôn là dữ liệu mới nhất           | Phải `REFRESH` để cập nhật                  |
| Tốn bộ nhớ lưu trữ           | Không tốn vì không lưu dữ liệu     | Tốn thêm bộ nhớ để lưu dữ liệu snapshot     |
| Phù hợp cho                  | Dữ liệu hay thay đổi, truy vấn nhẹ | Dữ liệu lớn, truy vấn nặng, báo cáo định kỳ |
| Cập nhật dữ liệu thủ công    | Không cần                          | Cần chạy `REFRESH MATERIALIZED VIEW`        |
| Đồng bộ với dữ liệu gốc      | Luôn đồng bộ                       | Có thể lệch nếu chưa cập nhật lại           |
| Hỗ trợ trong MySQL / MariaDB | Có hỗ trợ                          | Không hỗ trợ trực tiếp                      |
-- Dùng VIEW khi: cần dữ liệu mới nhất, truy vấn đơn giản, cập nhật thường xuyên.
-- Dùng MATERIALIZED VIEW khi: hiệu suất truy vấn quan trọng, dữ liệu lớn, cập nhật định kỳ.

---- Drop VIEW
select * from view_NhanVien_ChucVu
drop view view_NhanVien_ChucVu
-- IMPORT & EXPORT WITH DBeaver
-- Video import: https://somup.com/cTjh6iNHyQ
-- Video export: https://go.screenpal.com/watch/cTjh6XnIJow

--------------------------------------------------------------------------------------------------------------------------

-- 10. WINDOW FUNCTIONS

--- 10.1. OVER() with PARTITION
-- Hiển thị tất cả các cột trong bảng NhanVien, cộng thêm một cột mới tên là TongLuongPhong thể hiện tổng lương của tất cả nhân viên trong cùng một phòng ban (IdCH) với mỗi dòng.
SELECT 
  *,
  SUM(Luong) OVER (PARTITION BY Idch) AS TongLuongPhong
FROM NhanVien;

--- 10.2. OVER() with ORDER BY
SELECT 
  *,
  SUM(Luong) OVER (ORDER BY NgaySinh ) as LuongTheoNgaySinh 
FROM NhanVien;
-- Lấy toàn bộ dữ liệu trong bảng NhanVien.Tính thêm một cột tên là RANK, đại diện cho thứ hạng ngày sinh của từng nhân viên — người sinh sớm nhất sẽ có hạng 1, người sinh sau sẽ có hạng cao hơn.
SELECT 
  *,
  RANK() OVER (ORDER BY NgaySinh ) as RANK 
FROM NhanVien;

SELECT 
  *,
  DENSE_RANK() OVER (ORDER BY NgaySinh ) 
FROM NhanVien;