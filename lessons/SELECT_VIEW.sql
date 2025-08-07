select * from cuahang c 
select * from chucvu 
select * from nhanvien  
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Slide: https://pdfhost.io/v/Ju6qtFnKvA_Day_9_-_Course_slides
---------------------------------------------------------------------------------------------------------------------------------------------------

-- 1. SELECT VỚI JOIN ĐỂ XEM THÔNG TIN 
SELECT 
    nv.Id,
    nv.Ma AS MaNhanVien,
    nv.Ho,
    nv.TenDem,
    nv.Ten,
    nv.GioiTinh,
    nv.NgaySinh,
    nv.Sdt,
FROM 
    NhanVien nv
    
-------------------------------------------------------------------------------------------------------------------------

-- 2. ORDER BY: 
--- DESC TĂNG DẦN
select * from cuahang c order by c.Ma desc 
--- ASC GIẢM DẦN
select * from cuahang c order by c.Ma asc 

-------------------------------------------------------------------------------------------------------------------------

-- 3. SELECT DISTINCT (BẢN GHI CHỈ XUẤT HIỆN 1 LẦN NẾU TRÙNG THÔNG TIN) BÊN DƯỚI LÀ SO SÁNH SELECT & SELECT DISTINCT
select distinct nv.Ho, nv.TenDem,nv.Ten, nv.GioiTinh, nv.NgaySinh, nv.Sdt from NhanVien nv
select nv.Ten from nhanvien nv
select nv.Ho, nv.TenDem,nv.Ten, nv.GioiTinh, nv.NgaySinh, nv.Sdt from NhanVien nv group by nv.Ho, nv.TenDem,nv.Ten, nv.GioiTinh, nv.NgaySinh, nv.Sdt
select distinct nv.Id, nv.Ho, nv.TenDem,nv.Ten, nv.GioiTinh, nv.NgaySinh, nv.Sdt from NhanVien nv limit 1
select count(*) from nhanvien 

--------------------------------------------------------------------------------------------------------------------------

-- 4. FILTER (WHERE/AND/OR/BETWEEN/IN/LIKE)
--- WHERE + CONDITION 
select * from nhanvien nv where nv.Ma = 'NV003'
--- WHERE CONDITION 1 AND CONDITION 2 + AND ... OR
select * from nhanvien nv where (nv.Ma = 'NV003' and DiaChi='456 Lê Lợi, Đà Nẵng') or Ma = 'NV002'
--- WHERE ... BETWEEN '' AND '' - thường sử dụng để tìm khoảng ngày --> ngày từ bé đến lớn
select * from nhanvien nv where NgaySinh between '1992-01-10' and '1992-10-10'
--- WHERE CONDITION IN (-->MỘT LIST MUỐN SO SÁNH = VỚI CONDITION--)
select * from cuahang ch where ch.Ma in ('CH01','CH02','CH03')
--- WHERE CONDITION LIKE: cho phép so sánh theo mẫu (pattern) với các ký tự đại diện như % hoặc _ (NOT LIKE là phủ định like)
select * from cuahang ch where Ten like '%A'
--- _ đại diện cho 1 kí tự duy nhất
select * from cuahang ch where Ten like '__A'
select * from sanpham

--------------------------------------------------------------------------------------------------------------------------

-- 5. ROUND: Làm tròn /GROUP BY & HAVING
--- select ROUND(SUM(price), 2) AS total_amount FROM nhanvien n ;
select * from nhanvien nv group by nv.IdCH having nv.Ma ='NV002'

--------------------------------------------------------------------------------------------------------------------------

-- 6. FUNCTION (LENGTH/LOWER/UPPER/LEFT/RIGHT/concatenate/POSITION/SUBSTRING/EXTRACT/TO_CHAR/TIME..)

--- 6.1. LENGTH/LOWER/UPPER/LEFT/RIGHT
select 
	nv.Ten as ten_bt,
	LOWER(nv.Ten) as ten_lower, 
	UPPER(nv.Ten) as ten_upper,
	LENGTH(nv.Ten) as lenght_text,
	LEFT(nv.Ten,2) as left_text,
	RIGHT(nv.Ten,2) as right_text
from nhanvien nv

--- 6.2. CONCATENATE
SELECT CONCAT(nv.Ho, ', Ngày sinh: ', nv.NgaySinh, ': ', nv.DiaChi) AS information
FROM nhanvien nv;

--- 6.3. POSITION trong SQL dùng để tìm vị trí xuất hiện đầu tiên của một chuỗi con trong một chuỗi lớn hơn.
SELECT left (DiaChi, position (nv.ho in DiaChi)), ho FROM nhanvien nv;

--- 6.4. SUBSTRING FROM : cắt từ kí tự thứ 2 đến 5
SELECT substring (DiaChi from 2 for 5), DiaChi FROM nhanvien nv; 
SELECT substring (DiaChi from position ('Trần' in DiaChi)), DiaChi FROM nhanvien nv;

--- 6.5. EXTRACT/TO_CHAR
SELECT 
	extract (month from NgaySinh) as 'Month',
	TO_CHAR(Now(),'MM-YYYY') as 'Custom',
	TO_CHAR(Now(),'Day, Month YYYY ') as 'Custom new',
	NgaySinh 
FROM nhanvien nv;

--- 6.6. CASE WHEN
SELECT *,
  CASE 
    WHEN c.ThanhPho LIKE '%Hà Nội%' THEN 'CT'
    ELSE 'NOT CT'
  END AS TenKetQua
FROM cuahang c;
---- CASE WHEN Example
select
  sum(case when category = 'Income' then amount else 0 end) as TotalIncome,
  sum(CASE WHEN category = 'Expense' then amount else 0 end) as TotalExpenses,
  sum(CASE WHEN category = 'Income' then amount else 0 end) -
  sum(CASE WHEN category = 'Expense' then amount else 0 end) as NetIncome
from --;

-- 6.7. COALESCE
SELECT coalesce(null+1,'no data')as 'check null' FROM nhanvien nv;