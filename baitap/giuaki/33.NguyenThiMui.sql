--Câu 1. Trả về mã môn học tiên quyết của một môn học nếu biết mã môn đó.
--input: mã môn
--output: mã môn học tiên quyết
create or alter function fcau1(@mamon varchar(10))
returns varchar(10)
as
begin
	declare @mhtq varchar(10) = (select MonTienQuyet from MonHoc where MaMon = @mamon)
	return @mhtq
end

select dbo.fcau1('MIS3039') --môn tiên quyết: mis3007
select dbo.fcau1('MIS2002') --không có môn tiên quyết
select * from monhoc
/*Câu 2. Viết thủ tục thực hiện việc đăng kí môn học bao gồm các thông tin mô tả như sau:
Đầu vào: mã sinh viên, mã môn học, mã giảng viên, kì học
Công việc cần thực hiện:
a)	Kiểm tra sự hợp lệ của mã sinh viên. Mã sinh viên hợp lệ là chuỗi gồm 12 kí tự số. Nếu không hợp lệ thì ngừng xử lý.
b)	Kiểm tra sự hợp lệ của mã môn học. Mã môn học hợp lệ nếu đã tồn tại trong bảng MonHoc. Nếu không hợp lệ thì ngừng xử lý.
c)	Kiểm tra mã giảng viên có hợp lệ không. Mã giảng viên hợp lệ nếu đã tồn tại trong bảng GiangVien. Nếu không hợp lệ thì ngừng xử lý.
d)	Kiểm tra sinh viên có đủ điều kiện học đăng kí môn học không. Đủ điều kiện: đã học các môn tiên quyết (nếu có). 
	Nếu không hợp lệ thì ngừng xử lý
e)	Thêm dữ liệu vào bảng Diem với các dữ liệu đã có. Điểm để giá trị NULL.*/
--input: mã sinh viên, mã môn học, mã giảng viên, kì học
--output: ret 0: lỗi, 1: thành công

go
create or alter proc fcau2 @masv bigint,
						   @mamon varchar(7),
						   @magv varchar(4),
						   @kihoc nvarchar(50),
						   @ret bit output
as
begin
	if len(@masv) < 12 or len(@masv) < 12
	begin
		print N'Mã sinh viên không hợp lệ'
		set @ret = 0
		return
	end

	if (select count(*) from MonHoc where MaMon = @mamon) < 1
	begin
		print N'Mã môn học không tồn tại'
		set @ret = 0 
		return
	end

	if (select count(*) from GiangVien where MaGV = @magv) < 1
	begin
		print N'Mã giảng viên không tồn tại'
		set @ret = 0 
		return
	end

	if (select dbo.fcau1(@mamon))! = ''
	begin
		if (select count(mamon) from Diem where MaSV = @masv and MaMon = dbo.fcau1(@mamon)) = 0
		begin
			print N'Chưa học môn tiên quyết'
			return
		end
	end

	insert into Diem values (@masv, @mamon, @kihoc,@magv, null)
	if @@rowcount < 1
	begin
		print N'Thêm mới không thành công'
		set @ret = 0
		return
	end
	print N'Thành công'
	set @ret = 1
end

--đúng
declare @masv bigint = '151121505157',   
		@mamon varchar(7) = 'MIS3036',
		@magv varchar(4) = 'GV01',
		@kihoc nvarchar(50) = N'Kỳ 1 năm 2023-2024',
		@ret bit
exec fcau2 @masv, @mamon, @magv, @kihoc, @ret output
print @ret

--sai mã sv
declare @masv bigint = '15112150515',   
		@mamon varchar(7) = 'MIS3036',
		@magv varchar(4) = 'GV01',
		@kihoc nvarchar(50) = N'Kỳ 1 năm 2023-2024',
		@ret bit
exec fcau2 @masv, @mamon, @magv, @kihoc, @ret output
print @ret

--sai mã gv
declare @masv bigint = '151121505157',   
		@mamon varchar(7) = 'MIS3036',
		@magv varchar(4) = 'GV09',
		@kihoc nvarchar(50) = N'Kỳ 1 năm 2023-2024',
		@ret bit
exec fcau2 @masv, @mamon, @magv, @kihoc, @ret output
print @ret

--chưa học môn tiên quyết
declare @masv bigint = '161121521130',  
		@mamon varchar(7) = 'MIS3038',
		@magv varchar(4) = 'GV01',
		@kihoc nvarchar(50) = N'Kỳ 1 năm 2023-2024',
		@ret bit
exec fcau2 @masv, @mamon, @magv, @kihoc, @ret output
print @ret

--không có môn tiên quyết
declare @masv bigint = '161121521130',  
		@mamon varchar(7) = 'SMT1004',
		@magv varchar(4) = 'GV01',
		@kihoc nvarchar(50) = N'Kỳ 1 năm 2023-2024',
		@ret bit
exec fcau2 @masv, @mamon, @magv, @kihoc, @ret output
print @ret

--Câu 3. Khi thêm mới dữ liệu vào bảng Sinhvien, hãy đảm bảo rằng ngày sinh của sinh viên hợp lệ. Ngày sinh hợp lệ nếu tuổi của sinh viên >= 18.
go
create or alter trigger fcau3
on sinhvien
for insert
as
begin
	declare @ngaysinh datetime = (select ngaysinh from inserted)
	if datediff(year, @ngaysinh, getdate()) < 18
	begin
		rollback
		print N'Ngày sinh không hợp lệ'
	end
end

insert into sinhvien values('211121525120', 'Nguyễn Văn B', '2003-10-20', '0377393554') --<= 18 tuổi
insert into sinhvien values('211121524112', 'Nguyễn Văn A', '2010-10-20', '0377393568') --> 18 tuổi

select * from sinhvien

