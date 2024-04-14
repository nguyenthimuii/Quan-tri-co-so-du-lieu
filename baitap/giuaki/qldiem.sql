﻿create database QLDiemSV
go
use QLDiemSV
go
create table Nganh(
	MaNganh char(3),
	TenNganh nvarchar(100)
)
go
create table GiangVien(
	MaGV char(4),
	TenGV nvarchar(100)
)
go
create table SinhVien(
	MaSV char(12),
	HoTen nvarchar(100),
	NgaySinh date,
	SoDT varchar(15)
)
go
create table MonHoc(
	MaMon char(7),
	TenMon nvarchar(100),
	SoTC tinyint,
	LoaiMon bit, --: 1: bat buoc, 0: tu chon
	MonTienQuyet char(7), --ma mon hoc tien quyet
)
go
create table Diem(
	MaSV char(12),
	MaMon char(7),
	HocKy nvarchar(100),
	MaGV char(4),
	Diem float
)
go
insert into Nganh values('K21',N'Quản trị HTTT')
insert into Nganh values('K14',N'Tin học quản lý')
insert into Nganh values('K05',N'Thống kê')
insert into Nganh values('K22',N'Thương mại điện tử')
insert into Nganh values('K29',N'Khoa học dữ liệu')
insert into Nganh values('K32',N'Kinh tế quốc tế')
go
insert into GiangVien values ('GV01',N'Nguyễn Bá Thành')
insert into GiangVien values ('GV02',N'Trần Thanh Thủy')
insert into GiangVien values ('GV03',N'Lê Bá Hoàng')
insert into GiangVien values ('GV04',N'Đào Thị Ý Liên')
insert into GiangVien values ('GV05',N'Hoàng Thu Hiền')
insert into GiangVien values ('GV06',N'Khổng Thành Danh')
insert into GiangVien values ('GV07',N'Phan Đình Phùng')
insert into GiangVien values ('GV08',N'Đặng Tiến Tùng')
go
insert into SinhVien values('151121505150',N'Nguyễn Quốc Trung','1997-11-07','01649052843')
insert into SinhVien values('151121505151',N'Nguyễn Cẩm Tú','1996-01-03','0906570122')
insert into SinhVien values('151121505153',N'Nguyễn Thị Tường','1997-09-19','1656616271')
insert into SinhVien values('151121505155',N'Trần Thị Thanh Vân','1996-06-01','0964814041')
insert into SinhVien values('151121505157',N'Đặng Thị Thu Yên','1997-05-06','01632188064')
insert into SinhVien values('151121514130',N'Hồ Thị Oanh','1997-07-04','0981361941')
insert into SinhVien values('151121521101',N'Nguyễn Đình Anh','1997-08-27','01224836902')
insert into SinhVien values('151121521113',N'Lê Thị Mỹ Huyền','1997-10-24','01266636185')
insert into SinhVien values('151121521125',N'Đào Quốc Nghĩa','1997-02-16','0963044777')
insert into SinhVien values('151121521126',N'Hồ Trọng Nghĩa','1996-09-21','976711314')
insert into SinhVien values('151121521148',N'Phạm Thanh Tùng','1997-03-11','0904454299')
insert into SinhVien values('161121514108',N'Nguyễn Ngọc Hà','1997-01-01','0905659365')
insert into SinhVien values('161121514112',N'Võ Việt Hiếu','1997-06-02','0914226768')
insert into SinhVien values('161121514114',N'Đặng Khánh Lam','1998-01-20','0985520548')
insert into SinhVien values('161121514121',N'Trần Phước Minh Luận','1998-08-19','01268023919')
insert into SinhVien values('161121514123',N'Phan Đức Minh','1998-04-04','01219015560')
insert into SinhVien values('161121514131',N'Nguyễn Văn Quang','1998-02-24','0935295652')
insert into SinhVien values('161121514139',N'Lương Chí Thắng','1998-09-18','01223372993')
insert into SinhVien values('161121514144',N'Lê Thị Mộng Thùy','1998-06-23','01264882896')
insert into SinhVien values('161121514146',N'Phạm Thị Trang','1998-05-20','01674786351')
insert into SinhVien values('161121521104',N'Lê Viết Dũng','1998-10-20','01652043206')
insert into SinhVien values('161121521115',N'Phạm Văn Huy','1998-04-05','01683527149')
insert into SinhVien values('161121521118',N'Ngô Thị Kim Kha','1998-04-20','01684644723')
insert into SinhVien values('161121521130',N'Lê Thị Hồng Ngọc','1997-03-22','0935120945')
insert into SinhVien values('161121521144',N'Trần Ngọc Thái Sơn','1997-01-19','0935650775')
insert into SinhVien values('161121521154',N'Hoàng Toàn','1995-03-05','0964957600')
insert into SinhVien values('161121521166',N'Phạm Nguyễn Anh Vương','1997-05-10','01694856119')
go
insert into MonHoc values('MIS2002',N'Hệ thống thông tin quản lý',3,1,'')
insert into MonHoc values('LAW1001',N'Pháp luật đại cương',2,1,'')
insert into MonHoc values('ENG1011',N'PRE-IELTS 1',3,1,'')
insert into MonHoc values('ENG1012',N'PRE-IELTS 2 ',2,1,'')
insert into MonHoc values('MGT1002',N'Quản trị học',3,1,'')
insert into MonHoc values('MIS3001',N'Cơ sở lập trình',3,1,'')
insert into MonHoc values('TOU1001',N'Giao tiếp trong kinh doanh',3,1,'')
insert into MonHoc values('ENG1013',N'IELTS BEGINNERS 1',3,1,'')
insert into MonHoc values('ENG1014',N'IELTS BEGINNERS 2',3,1,'')
insert into MonHoc values('MGT1001',N'Kinh tế vi mô',3,1,'')
insert into MonHoc values('ECO1001',N'Kinh tế vĩ mô',3,1,'')
insert into MonHoc values('ENG2011',N'IELTS PRE-INTERMEDIATE 1',3,1,'')
insert into MonHoc values('ENG2012',N'IELTS PRE-INTERMEDIATE 2',2,1,'')
insert into MonHoc values('MIS3002',N'Mạng và truyền thông',3,1,'')
insert into MonHoc values('MKT2001',N'Marketing căn bản ',3,1,'')
insert into MonHoc values('ACC1001',N'Nguyên lý kế toán',3,1,'')
insert into MonHoc values('MGT2002',N'Nhập môn kinh doanh',3,1,'')
insert into MonHoc values('HRM3001',N'Quản trị nguồn nhân lực',3,1,'')
insert into MonHoc values('MIS2011',N'Thực tập nhận thức',2,1,'')
insert into MonHoc values('SMT1001',N'Các nguyên lý cơ bản CN Mác – Lê Nin 1',2,1,'')
insert into MonHoc values('MIS2001',N'Cơ sở dữ liệu ',3,1,'')
insert into MonHoc values('HRM2001',N'Hành vi tổ chức',3,1,'')
insert into MonHoc values('ENG2014',N'IELTS INTERMEDIATE 2',2,1,'')
insert into MonHoc values('ENG2013',N'IELTS INTERMEDIATE 1',3,1,'')
insert into MonHoc values('ACC2003',N'Kế toán tài chính',3,1,'')
insert into MonHoc values('STA2002',N'Thống kê kinh doanh và kinh tế',3,1,'')
insert into MonHoc values('MIS3003',N'An toàn và bảo mật hệ thống thông tin',3,1,'')
insert into MonHoc values('SMT1002',N'Các nguyên lý cơ bản CN Mác – Lê Nin 2',3,1,'')
insert into MonHoc values('LAW2001',N'Luật kinh doanh',3,1,'')
insert into MonHoc values('MIS3008',N'Quản trị cơ sở dữ liệu',3,1,'')
insert into MonHoc values('MIS3012',N'Quản trị mạng',3,1,'')
insert into MonHoc values('FIN2001',N'Thị trường và các định chế tài chính',3,1,'')
insert into MonHoc values('ENG3001',N'Tiếng Anh kinh doanh',3,1,'')
insert into MonHoc values('MIS3007',N'Phân tích và thiết kế hệ thống thông tin',3,0,'')
insert into MonHoc values('MIS2013',N'Thực tập nghề nghiệp',2,1,'')
insert into MonHoc values('MIS3009',N'Kho và khai phá dữ liệu',3,1,'')
insert into MonHoc values('IBS2001',N'Kinh doanh quốc tế',3,1,'')
insert into MonHoc values('MIS3004',N'Quản trị dự án công nghệ thông tin',3,1,'')
insert into MonHoc values('SMT1004',N'Tư tưởng Hồ Chí Minh',2,1,'')
insert into MonHoc values('MIS3011',N'Hệ thống hoạch định nguồn lực doanh nghiệp',3,1,'')
insert into MonHoc values('MIS3013',N'Kinh doanh điện tử',3,0,'')
insert into MonHoc values('MGT3002',N'Quản trị chuỗi cung ứng',3,0,'')
insert into MonHoc values('MIS3039',N'Thực hành Phân tích và Thiết kế HTTT',2,0,'MIS3007')
insert into MonHoc values('MIS3040',N'Thực hành Quản trị CSDL',2,0,'MIS3008')
insert into MonHoc values('SMT1003',N'Đường lối cách mạng của Đảng cộng sản Việt Nam',3,1,'')
insert into MonHoc values('MIS3036',N'Thực hành hệ thống hoạch định nguồn lực doanh nghiệp',2,1,'MIS3011')
insert into MonHoc values('MIS3038',N'Thực hành Quản trị dự án CNTT',2,1,'MIS3004')
insert into MonHoc values('MIS3037',N'Thực hành thiết kế kho và phân tích dữ liệu kinh doanh',2,1,'MIS3009')
insert into MonHoc values('ACC3008',N'Hệ thống thông tin kế toán',3,0,'')
insert into MonHoc values('HRM3002',N'Phát triển kỹ năng quản trị',3,0,'')
insert into MonHoc values('COM3003',N'Quản trị quan hệ khách hàng',3,0,'')
insert into MonHoc values('MGT3003',N'Quản trị sản xuất',3,0,'')
insert into MonHoc values('MIS4002',N'Thực tập tốt nghiệp',10,1,'')
go
insert into Diem values('161121521130','ENG3001',N'Kỳ 1 năm 2023-2024','GV02',4)
insert into Diem values('161121514144','LAW2001',N'Kỳ 1 năm 2020-2021','GV04',7)
insert into Diem values('151121521125','ENG1012',N'Kỳ 1 năm 2023-2024','GV08',1)
insert into Diem values('161121514139','ACC1001',N'Kỳ 1 năm 2022-2023','GV05',5)
insert into Diem values('151121505157','ACC2003',N'Kỳ 2 năm 2022-2023','GV04',7)
insert into Diem values('161121514139','MIS2011',N'Kỳ 2 năm 2021-2022','GV03',2)
insert into Diem values('151121505155','MIS3001',N'Kỳ 2 năm 2022-2023','GV01',7)
insert into Diem values('161121514146','ENG3001',N'Kỳ 1 năm 2023-2024','GV08',1)
insert into Diem values('151121514130','SMT1004',N'Kỳ 1 năm 2021-2022','GV04',7)
insert into Diem values('151121521125','ECO1001',N'Kỳ 1 năm 2022-2023','GV05',3)
insert into Diem values('161121514121','MGT3003',N'Kỳ 1 năm 2022-2023','GV05',2)
insert into Diem values('151121505153','MGT2002',N'Kỳ 1 năm 2023-2024','GV04',7)
insert into Diem values('151121521101','MIS3039',N'Kỳ 1 năm 2021-2022','GV04',6)
insert into Diem values('161121521115','MIS2002',N'Kỳ 1 năm 2022-2023','GV03',2)
insert into Diem values('161121521166','MIS3036',N'Kỳ 1 năm 2023-2024','GV04',9)
insert into Diem values('151121514130','MGT3002',N'Kỳ 1 năm 2023-2024','GV07',4)
insert into Diem values('151121505153','MIS3039',N'Kỳ 2 năm 2020-2021','GV08',6)
insert into Diem values('151121505150','ACC3008',N'Kỳ 1 năm 2023-2024','GV02',6)
insert into Diem values('151121505150','MIS3008',N'Kỳ 2 năm 2022-2023','GV01',5)
insert into Diem values('161121514114','MGT2002',N'Kỳ 1 năm 2020-2021','GV01',8)
insert into Diem values('161121521118','ENG3001',N'Kỳ 1 năm 2023-2024','GV07',6)
insert into Diem values('161121521130','MIS2001',N'Kỳ 1 năm 2020-2021','GV02',6)
insert into Diem values('161121514114','LAW1001',N'Kỳ 1 năm 2022-2023','GV03',8)
insert into Diem values('161121514114','COM3003',N'Kỳ 1 năm 2022-2023','GV07',6)
insert into Diem values('151121505151','HRM3002',N'Kỳ 2 năm 2021-2022','GV04',7)
insert into Diem values('151121505157','MIS3012',N'Kỳ 1 năm 2022-2023','GV06',8)
insert into Diem values('161121521115','HRM2001',N'Kỳ 2 năm 2022-2023','GV02',4)
insert into Diem values('161121521115','ACC1001',N'Kỳ 1 năm 2023-2024','GV06',9)
insert into Diem values('151121505151','ACC1001',N'Kỳ 2 năm 2021-2022','GV05',9)
insert into Diem values('151121521125','MGT3003',N'Kỳ 1 năm 2022-2023','GV04',8)
insert into Diem values('161121521115','MIS2001',N'Kỳ 1 năm 2021-2022','GV03',5)
insert into Diem values('161121514121','MGT1001',N'Kỳ 1 năm 2022-2023','GV02',6)
insert into Diem values('161121514146','FIN2001',N'Kỳ 1 năm 2023-2024','GV04',8)
insert into Diem values('161121514146','COM3003',N'Kỳ 1 năm 2021-2022','GV02',4)
insert into Diem values('151121505157','MIS3003',N'Kỳ 1 năm 2020-2021','GV01',6)
insert into Diem values('161121514123','ENG1011',N'Kỳ 1 năm 2023-2024','GV03',6)
insert into Diem values('161121514112','MIS3009',N'Kỳ 2 năm 2022-2023','GV04',4)
insert into Diem values('161121521130','MIS3037',N'Kỳ 1 năm 2022-2023','GV02',1)
insert into Diem values('151121505150','MIS2001',N'Kỳ 2 năm 2020-2021','GV04',4)
insert into Diem values('161121521104','LAW1001',N'Kỳ 1 năm 2020-2021','GV01',1)
insert into Diem values('161121514131','ENG1014',N'Kỳ 1 năm 2022-2023','GV08',7)
insert into Diem values('151121521125','MIS2011',N'Kỳ 2 năm 2022-2023','GV03',6)
insert into Diem values('161121514139','SMT1003',N'Kỳ 2 năm 2022-2023','GV06',7)
insert into Diem values('161121521144','ENG1012',N'Kỳ 1 năm 2022-2023','GV04',10)
insert into Diem values('161121514146','MIS3001',N'Kỳ 1 năm 2023-2024','GV07',10)
insert into Diem values('161121514114','COM3003',N'Kỳ 1 năm 2020-2021','GV01',9)
insert into Diem values('151121505157','MGT1001',N'Kỳ 1 năm 2020-2021','GV08',7)
insert into Diem values('151121521148','FIN2001',N'Kỳ 2 năm 2020-2021','GV05',1)
insert into Diem values('161121514108','MIS4002',N'Kỳ 2 năm 2021-2022','GV04',3)
insert into Diem values('161121514108','MIS3039',N'Kỳ 1 năm 2021-2022','GV06',4)
insert into Diem values('161121514112','STA2002',N'Kỳ 1 năm 2022-2023','GV06',8)
insert into Diem values('161121521154','ENG2013',N'Kỳ 2 năm 2020-2021','GV04',3)
insert into Diem values('161121514123','MIS3004',N'Kỳ 1 năm 2021-2022','GV07',1)
insert into Diem values('151121505157','MIS3009',N'Kỳ 1 năm 2021-2022','GV05',3)
insert into Diem values('151121521148','ENG2014',N'Kỳ 2 năm 2022-2023','GV01',1)
insert into Diem values('161121521104','MIS3004',N'Kỳ 2 năm 2020-2021','GV03',5)
insert into Diem values('151121521101','ENG2011',N'Kỳ 2 năm 2022-2023','GV03',6)
insert into Diem values('161121521166','MIS2013',N'Kỳ 1 năm 2021-2022','GV07',4)
insert into Diem values('151121505150','MIS2013',N'Kỳ 1 năm 2023-2024','GV01',10)
insert into Diem values('151121521125','MIS3012',N'Kỳ 1 năm 2021-2022','GV05',10)
insert into Diem values('161121514123','MIS3009',N'Kỳ 1 năm 2020-2021','GV05',6)
insert into Diem values('161121521118','STA2002',N'Kỳ 1 năm 2022-2023','GV04',8)
insert into Diem values('151121521113','SMT1004',N'Kỳ 1 năm 2023-2024','GV08',7)
insert into Diem values('161121514108','MIS3002',N'Kỳ 1 năm 2020-2021','GV02',2)
insert into Diem values('151121521113','ACC2003',N'Kỳ 1 năm 2022-2023','GV01',2)
insert into Diem values('161121514131','ENG2012',N'Kỳ 1 năm 2023-2024','GV01',4)
insert into Diem values('161121514114','MIS3004',N'Kỳ 1 năm 2021-2022','GV05',10)
insert into Diem values('161121514121','HRM3001',N'Kỳ 1 năm 2022-2023','GV03',9)
insert into Diem values('151121514130','MIS3040',N'Kỳ 2 năm 2021-2022','GV04',8)
insert into Diem values('151121521126','ACC1001',N'Kỳ 2 năm 2022-2023','GV04',9)
insert into Diem values('161121521130','MGT1002',N'Kỳ 1 năm 2023-2024','GV07',7)
insert into Diem values('151121505150','HRM3002',N'Kỳ 2 năm 2022-2023','GV05',4)
insert into Diem values('151121505157','MIS3011',N'Kỳ 2 năm 2021-2022','GV02',1)
insert into Diem values('151121521126','ENG2014',N'Kỳ 1 năm 2020-2021','GV08',2)
insert into Diem values('151121505150','MIS3013',N'Kỳ 1 năm 2020-2021','GV04',1)
insert into Diem values('161121514131','ENG1011',N'Kỳ 2 năm 2020-2021','GV06',10)
insert into Diem values('161121514146','MKT2001',N'Kỳ 2 năm 2022-2023','GV05',6)
insert into Diem values('161121514108','MIS3004',N'Kỳ 2 năm 2022-2023','GV08',8)
insert into Diem values('161121514121','MIS3003',N'Kỳ 1 năm 2021-2022','GV08',8)
insert into Diem values('161121514121','SMT1001',N'Kỳ 2 năm 2022-2023','GV03',3)