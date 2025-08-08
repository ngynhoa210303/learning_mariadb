----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Slide: https://pdfhost.io/v/wp2AVAghRA_Day_15_-_Course_slides
----------------------------------------------------------------------------------------------------------------------------------------------------------
-- 12. Indexes Partitining & Query Optimization

---- 12.1. CREATE USER-----
/*
 * Mục đích của CREATE USER là gì?
   Tạo tài khoản đăng nhập vào hệ quản trị cơ sở dữ liệu.
   Phân quyền quản lý dữ liệu và thao tác dữ liệu một cách an toàn, kiểm soát được.
   Tách biệt vai trò người dùng: người quản trị, người đọc, người ghi dữ liệu...
   
   ** Có thể sử dụng cách test như sau:
   * 1. Tạo new database connect với username/password: hoant210303/ 21031802, nhập tên db=finalass_fpolyshop_fa22_sof205__sof2041
   * 2. Thực hiện câu lệnh Update nếu có thông báo: UPDATE command denied to user 'hoant210303'@'localhost' for table `finalass_fpolyshop_fa22_sof205__sof2041`.`phongban`
   * và select/insert:   THÀNH CÔNG
  thì pass do user này chỉ có quyền select và insert chứ k có quyền update
 */
CREATE USER 'hoant210303'@'localhost' IDENTIFIED BY '21031802';

-- Sau khi tạo user xong, user không có quyền gì cả, nếu muốn cho phép họ làm gì (VD: đọc dữ liệu, cập nhật dữ liệu...), bạn phải dùng thêm lệnh GRANT.
GRANT SELECT, INSERT ON finalass_fpolyshop_fa22_sof205__sof2041. * TO 'hoant210303'@'localhost';
-- test >>>
update PhongBan b set TenPhong='Phòng IT' where b.MaPhong ='101'
select * from sanpham s 
insert into sanpham (Ma,Ten) values  ('SP055','3743832')
select current_user()

--- 12.2. REVOKE GRANT-----

---- REVOKE dùng để thu hồi các quyền truy cập đã cấp cho user (hoặc role) trên hệ thống cơ sở dữ liệu.
REVOKE SELECT, INSERT ON finalass_fpolyshop_fa22_sof205__sof2041. * FROM 'hoant210303'@'localhost';
/*
 * Dùng giao diện trong DBeaver
   1. Vào Database > Security > Users.
   2. Chuột phải vào user cần chỉnh sửa → chọn Edit User.
   3. Tab Grants/Privileges: bạn có thể bỏ chọn quyền (SELECT, INSERT, UPDATE...) tương ứng.
   4. Nhấn Save để DBeaver tự tạo lệnh REVOKE và thực thi.
 */
---- REVOKE GRANT OPTION FOR sẽ không thu hồi quyền gốc, mà chỉ thu hồi khả năng chia sẻ quyền đó với người khác.
-- Giả sử bạn đã cấp cho user hoang quyền SELECT trên database mydb và khả năng cấp lại quyền đó (GRANT OPTION):
GRANT SELECT ON finalass_fpolyshop_fa22_sof205__sof2041.* TO 'hoant210303'@'localhost' WITH GRANT OPTION;
-- Giờ bạn muốn thu hồi khả năng cấp lại quyền SELECT, nhưng vẫn giữ quyền SELECT:
REVOKE GRANT OPTION FOR SELECT ON mydb.* FROM 'hoant210303'@'localhost';
 -- >>> Kết quả: hoang vẫn có thể SELECT, nhưng không thể cấp SELECT cho user khác. 

-- Xem user có quyền j
SHOW GRANTS FOR 'hoant210303'@'localhost';

---- 12.3. DROP USER
DROP USER 'hoant210303'@'host';
DROP USER 'user1'@'localhost', 'user2'@'localhost';
CREATE USER 'hoant210303'@'localhost' IDENTIFIED BY '21031802';
create role read_only;
DROP ROLE 'read_only';

SELECT * FROM mysql.user WHERE user = 'read_only' AND is_role = 'Y';

SELECT user, host FROM mysql.user WHERE user = 'hoant210303';


-- 12.4. PRIVILEGES: Quyền truy cập (quyền hạn)
-- Mình có thể định nghĩa nhiều account/role và set quyền cho role

| Tên role        | Quyền gán phổ biến                             | Dùng cho ai?                     |
| --------------- | ---------------------------------------------- | -------------------------------- |
| `read_only`     | `SELECT`                                       | Nhân viên chỉ xem dữ liệu        |
| `editor`        | `SELECT`, `INSERT`, `UPDATE`                   | Người nhập liệu / chỉnh sửa      |
| `data_entry`    | `INSERT`, `UPDATE`                             | Người nhập mới dữ liệu           |
| `report_viewer` | `SELECT` (trên các bảng báo cáo)               | Người xem báo cáo                |
| `analyst`       | `SELECT`, có thể thêm quyền trên VIEW          | Phân tích dữ liệu                |
| `admin`         | `ALL PRIVILEGES` trên 1 database               | Quản trị viên cơ sở dữ liệu      |
| `db_owner`      | `ALL PRIVILEGES` + quyền `GRANT OPTION`        | Chủ sở hữu database              |
| `backup`        | `SELECT`, `LOCK TABLES`, `RELOAD`, `PROCESS`   | Người thực hiện backup           |
| `auditor`       | `SELECT` + quyền `SHOW DATABASES`, `SHOW VIEW` | Người kiểm tra, đánh giá dữ liệu |

-- Bước 1: Tạo role (nếu chưa có)
CREATE ROLE read_only;
-- Bước 2: Gán quyền cho role
GRANT SELECT ON my_database.* TO read_only;
-- Bước 3: Tạo user để test
CREATE USER 'test_user'@'localhost' IDENTIFIED BY '123456';
-- Bước 4: Gán role cho user
GRANT read_only TO 'test_user'@'localhost';
-- Bước 5: Đặt role làm mặc định khi user đăng nhập
SET DEFAULT ROLE read_only TO 'test_user'@'localhost';
-- Test
SELECT * FROM nhanvien;
/* 
 * Nếu role hoạt động đúng, bạn:
	✅ Có thể SELECT
	❌ Không thể INSERT, UPDATE, DELETE, v.v.
 */