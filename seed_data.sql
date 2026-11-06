-- Chạy sau DDL_HeThongDauGia.sql trên CSDL mẫu mới tạo.
-- 15 người dùng, 21 danh mục, 18 tài sản, 6 phiên đấu giá.

BEGIN;

-- 1. BẢNG NGƯỜI DÙNG (15 người dùng)
INSERT INTO NGUOIDUNG (MaNguoiDung, HoTen, ThuDienTu, ThoiDiemTao)
OVERRIDING SYSTEM VALUE VALUES
(1,  'Nguyễn Văn An',       'an.nguyen@gmail.com',      CURRENT_TIMESTAMP - INTERVAL '60 days'),
(2,  'Trần Thị Bích',       'bich.tran@gmail.com',      CURRENT_TIMESTAMP - INTERVAL '55 days'),
(3,  'Lê Hoàng Cường',      'cuong.le@gmail.com',       CURRENT_TIMESTAMP - INTERVAL '50 days'),
(4,  'Phạm Minh Đức',       'duc.pham@gmail.com',       CURRENT_TIMESTAMP - INTERVAL '45 days'),
(5,  'Hoàng Thu Giang',     'giang.hoang@gmail.com',    CURRENT_TIMESTAMP - INTERVAL '40 days'),
(6,  'Vũ Đình Hải',         'hai.vu@gmail.com',         CURRENT_TIMESTAMP - INTERVAL '35 days'),
(7,  'Đỗ Mỹ Linh',          'linh.do@gmail.com',        CURRENT_TIMESTAMP - INTERVAL '30 days'),
(8,  'Bùi Quốc Nam',        'nam.bui@gmail.com',        CURRENT_TIMESTAMP - INTERVAL '25 days'),
(9,  'Đặng Tuấn Kiệt',      'kiet.dang@outlook.com',    CURRENT_TIMESTAMP - INTERVAL '22 days'),
(10, 'Ngô Phương Thảo',     'thao.ngo@yahoo.com',       CURRENT_TIMESTAMP - INTERVAL '20 days'),
(11, 'Dương Gia Bảo',       'bao.duong@gmail.com',      CURRENT_TIMESTAMP - INTERVAL '18 days'),
(12, 'Lý Thanh Tâm',        'tam.ly@gmail.com',         CURRENT_TIMESTAMP - INTERVAL '15 days'),
(13, 'Trương Quốc Khánh',   'khanh.truong@gmail.com',   CURRENT_TIMESTAMP - INTERVAL '12 days'),
(14, 'Mai Ngọc Ánh',        'anh.mai@gmail.com',        CURRENT_TIMESTAMP - INTERVAL '8 days'),
(15, 'Phan Trọng Hiếu',     'hieu.phan@gmail.com',      CURRENT_TIMESTAMP - INTERVAL '5 days');

-- 2. BẢNG DANH MỤC (21 danh mục chia 3 tầng sâu)
INSERT INTO DANHMUC (MaDanhMuc, TenDanhMuc, MaDanhMucCha)
OVERRIDING SYSTEM VALUE VALUES
-- Tầng 1: 3 Danh mục gốc (MaDanhMucCha IS NULL)
(1, 'Thiết bị công nghệ & Điện tử', NULL),
(2, 'Tác phẩm nghệ thuật & Điêu khắc', NULL),
(3, 'Cổ vật & Đồ sưu tầm quý hiếm', NULL),

-- Tầng 2: 6 Danh mục nhánh giữa
(4, 'Máy ảnh & Thiết bị quang học',  1),
(5, 'Âm thanh Hi-End & Máy tính',    1),
(6, 'Hội họa truyền thống Việt Nam', 2),
(7, 'Mỹ thuật đương đại & Điêu khắc',2),
(8, 'Tiền cổ, Tem & Đồng hồ cơ',     3),
(9, 'Gốm sứ cổ đại & Đồ đồng',       3),

-- Tầng 3: 12 Danh mục lá (Chi tiết)
(10, 'Máy ảnh Mirrorless & Rangefinder', 4),
(11, 'Ống kính (Lens) & Máy quay Cinema',4),
(12, 'Thiết bị bay & Drone chuyên nghiệp',4),
(13, 'Mâm đĩa than & Amply đèn Hi-Fi',   5),
(14, 'Laptop Workstation & Máy trạm',    5),
(15, 'Tranh sơn mài & Khảm xà cừ',       6),
(16, 'Tranh lụa & Tranh giấy Dó',        6),
(17, 'Tranh sơn dầu & Acrylic',          7),
(18, 'Tượng điêu khắc đồng & Gỗ quý',    7),
(19, 'Tiền xu bạc & Tem thư quý hiếm',   8),
(20, 'Đồng hồ cơ Vintage Thụy Sĩ',       8),
(21, 'Bình gốm & Lư đồng phong kiến',    9);

-- 3. BẢNG TÀI SẢN (18 Tài sản: 6 Nghệ thuật, 6 Đồ sưu tầm, 6 Thiết bị điện tử)
INSERT INTO TAISAN (MaTaiSan, MaNguoiBan, MaDanhMuc, LoaiTaiSan, TenTaiSan, MoTa, ThoiDiemTao)
OVERRIDING SYSTEM VALUE VALUES
-- A. NHÓM TÁC PHẨM NGHỆ THUẬT (ID: 1 -> 6)
(1, 1, 15, 'TACPHAMNGHETHUAT', 'Bức họa Ánh Trăng Đêm', 
    'Tranh sơn mài khảm ốc đỏ tinh xảo từ làng nghề truyền thống Hạ Thái', CURRENT_TIMESTAMP - INTERVAL '20 days'),
(2, 2, 17, 'TACPHAMNGHETHUAT', 'Bình Minh Trên Đỉnh Phù Vân', 
    'Tranh sơn dầu vẽ phong cảnh thiên nhiên Tây Bắc khổ lớn 120x80cm', CURRENT_TIMESTAMP - INTERVAL '19 days'),
(3, 1, 15, 'TACPHAMNGHETHUAT', 'Hội Làng Mùa Xuân', 
    'Tác phẩm tranh sơn mài thếp vàng đạt giải mỹ thuật năm 2018', CURRENT_TIMESTAMP - INTERVAL '18 days'),
(4, 9, 16, 'TACPHAMNGHETHUAT', 'Thiếu Nữ Bên Hoa Sen', 
    'Tranh vẽ trên lụa tơ tằm Hà Đông bằng màu khoáng tự nhiên', CURRENT_TIMESTAMP - INTERVAL '17 days'),
(5, 2, 17, 'TACPHAMNGHETHUAT', 'Phố Cổ Hà Nội Mùa Thu', 
    'Tranh sơn dầu vẽ bằng bay (Palette Knife) tạo khối nổi 3D sống động', CURRENT_TIMESTAMP - INTERVAL '16 days'),
(6, 9, 18, 'TACPHAMNGHETHUAT', 'Tượng đồng Cá Chép Hóa Rồng', 
    'Tác phẩm điêu khắc đồng đỏ nguyên khối đúc thủ công nặng 18kg', CURRENT_TIMESTAMP - INTERVAL '15 days'),

-- B. NHÓM ĐỒ SƯU TẦM (ID: 7 -> 12)
(7,  3, 19, 'DOSUUTAM', 'Đồng xu bạc Đông Dương 1 Piastre 1908', 
    'Đồng xu cổ nguyên bản thời Pháp thuộc, độ hoàn thiện sắc nét hiếm có', CURRENT_TIMESTAMP - INTERVAL '14 days'),
(8,  4, 21, 'DOSUUTAM', 'Bình gốm hoa nâu thời Lý thế kỷ XI', 
    'Hiện vật gốm men tro họa tiết hoa sen khắc chìm còn nguyên vẹn', CURRENT_TIMESTAMP - INTERVAL '13 days'),
(9,  3, 19, 'DOSUUTAM', 'Bộ tem thư kỷ niệm Quốc tế Lao động 1957', 
    'Bộ tem cổ còn nguyên lề 4 con, chưa đóng dấu bưu điện', CURRENT_TIMESTAMP - INTERVAL '12 days'),
(10, 10, 20, 'DOSUUTAM', 'Đồng hồ bỏ túi Omega Grand Prix Paris 1900', 
    'Đồng hồ quả quýt vỏ bạc đúc 0.800, máy cơ cót tay chạy chuẩn xác', CURRENT_TIMESTAMP - INTERVAL '11 days'),
(11, 4, 21, 'DOSUUTAM', 'Lư hương đồng tam sự thời Nguyễn', 
    'Bộ lư đồng mắt tre lên màu patin xanh cổ kính tự nhiên qua hơn 100 năm', CURRENT_TIMESTAMP - INTERVAL '10 days'),
(12, 10, 20, 'DOSUUTAM', 'Đồng hồ đeo tay Rolex Oyster Perpetual 1968', 
    'Phiên bản mặt số Pie-Pan cổ điển, dây da cá sấu nguyên bản kèm hộp xưa', CURRENT_TIMESTAMP - INTERVAL '9 days'),

-- C. NHÓM THIẾT BỊ ĐIỆN TỬ (ID: 13 -> 18)
(13, 5, 10, 'THIETBIDIENTU', 'Máy ảnh Leica M11 Body (Bản giới hạn Đen Nhám)', 
    'Máy ảnh Rangefinder Full-frame 60MP sản xuất tại Đức, chụp dưới 500 shot', CURRENT_TIMESTAMP - INTERVAL '8 days'),
(14, 6, 11, 'THIETBIDIENTU', 'Ống kính Sony FE 70-200mm f/2.8 GM OSS II', 
    'Ống kính Tele G-Master thế hệ 2, kính trong vắt không bụi mốc, kèm hood zin', CURRENT_TIMESTAMP - INTERVAL '7 days'),
(15, 5, 13, 'THIETBIDIENTU', 'Mâm đĩa than McIntosh MT5 Precision Turntable', 
    'Bàn xoay đĩa than Hi-End kim đọc Blue Point No.2, mâm phát sáng xanh đặc trưng', CURRENT_TIMESTAMP - INTERVAL '6 days'),
(16, 6, 14, 'THIETBIDIENTU', 'Laptop Apple MacBook Pro 16-inch M3 Max 64GB/2TB', 
    'Trạm làm việc di động cấu hình kịch trần cho đồ họa 3D, pin sạc 12 lần', CURRENT_TIMESTAMP - INTERVAL '5 days'),
(17, 11, 12, 'THIETBIDIENTU', 'Flycam DJI Inspire 3 Cinema Drone Combo', 
    'Drone quay phim điện ảnh chuẩn 8K ProRes RAW kèm camera Zenmuse X9', CURRENT_TIMESTAMP - INTERVAL '4 days'),
(18, 11, 13, 'THIETBIDIENTU', 'Amply đèn Accuphase E-800 Class A Integrated', 
    'Amply Hi-End tham chiếu xuất xứ Nhật Bản, công suất thuần Class A 50W/kênh', CURRENT_TIMESTAMP - INTERVAL '3 days');

-- 4. BẢNG CON: TÁC PHẨM NGHỆ THUẬT (6 bản ghi: ID 1 -> 6)
INSERT INTO TACPHAMNGHETHUAT (MaTaiSan, TacGia, ChatLieu, NamSangTac) VALUES
(1, 'Họa sĩ Nguyễn Gia Trí',    'Sơn mài trên gỗ mít dát vàng',   2012),
(2, 'Họa sĩ Trần Văn Cẩn',      'Sơn dầu trên toan Canvas',       2019),
(3, 'Họa sĩ Nguyễn Phan Chánh', 'Sơn mài vỏ trứng và thếp bạc',   2018),
(4, 'Họa sĩ Mai Trung Thứ',     'Màu nước trên lụa tơ tằm',       2015),
(5, 'Họa sĩ Bùi Xuân Phái',     'Sơn dầu vẽ bay trên bố',         2021),
(6, 'Nghệ nhân Vũ Duy Thuấn',   'Đồng đỏ đúc thủ công nguyên khối',2020);

-- 5. BẢNG CON: ĐỒ SƯU TẦM (6 bản ghi: ID 7 -> 12)
INSERT INTO DOSUUTAM (MaTaiSan, NguonGoc, DoHiem, NamSanXuat) VALUES
(7,  'Sưu tập tư nhân tại Hà Nội',     'Cực hiếm (Độ nét XF45)',    1908),
(8,  'Khai quật di chỉ Nam Sách',       'Độc bản bảo tàng cấp 2',    1085),
(9,  'Nhượng quyền từ gia đình bưu tá', 'Hiếm gặp (Mint Condition)',  1957),
(10, 'Đấu giá viên tại Geneva Thụy Sĩ', 'Giới hạn 500 chiếc toàn cầu',1900),
(11, 'Phủ thờ cổ tại Cố đô Huế',        'Cổ vật nguyên trạng cấp 1',  1895),
(12, 'Bộ sưu tập đồng hồ Sài Gòn xưa',  'Rất hiếm (Zin nguyên bản)',  1968);

-- 6. BẢNG CON: THIẾT BỊ ĐIỆN TỬ (6 bản ghi: ID 13 -> 18)
INSERT INTO THIETBIDIENTU (MaTaiSan, ThuongHieu, MauThietBi, SoSeRi, TinhTrang) VALUES
(13, 'Leica',     'Đen nhám (Matte Black)',       'LC-M11-GER-88901', 'Như mới 99.9% Fullbox'),
(14, 'Sony',      'Trắng Xám G-Master',           'SN-GM2-70200-452', 'Đã qua sử dụng 98%'),
(15, 'McIntosh',  'Đen phối Kính xanh',           'MC-MT5-USA-10294', 'Nguyên bản 100%'),
(16, 'Apple',     'Đen Không Gian (Space Black)', 'C02-M3MAX-99812',  'Mới 99% còn AppleCare+'),
(17, 'DJI',       'Đen Carbon Fiber',             'DJI-INS3-CN-77412','Mới 99% bay 3 giờ'),
(18, 'Accuphase', 'Vàng Champagne (Gold)',        'ACC-E800-JP-33901','Nguyên thùng xốp 99.5%');

-- 7. Phiên mở, chưa mở, đã chốt có người thắng và đã chốt không có lượt trả.
INSERT INTO PHIENDAUGIA (
    MaPhien, MaTaiSan, GiaKhoiDiem, BuocGia, ThoiDiemMo, ThoiDiemDong, TrangThaiPhien
) OVERRIDING SYSTEM VALUE VALUES
(1, 1,  5000000, 250000, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP + INTERVAL '30 minutes', 'DANG_DIEN_RA'),
(2, 7,  2000000, 100000, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '2 days', 'DA_DONG'),
(3, 13, 8000000, 500000, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '1 day', 'THAT_BAI'),
(4, 14, 3000000, 200000, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP + INTERVAL '2 hours', 'DANG_DIEN_RA'),
(5, 2,  4000000, 200000, CURRENT_TIMESTAMP + INTERVAL '1 day', CURRENT_TIMESTAMP + INTERVAL '2 days', 'CHUA_MO'),
(6, 8,  1000000, 100000, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '1 day', 'DA_DONG');

-- 8. Đăng ký trước thời điểm trả giá. Người bán không đăng ký phiên của mình.
INSERT INTO DANGKY (MaPhien, MaNguoiDung, TrangThaiDangKy, ThoiDiemDangKy)
SELECT dk.MaPhien, dk.MaNguoiDung, dk.TrangThai, p.ThoiDiemMo + INTERVAL '5 minutes'
FROM (VALUES
    (1, 7, 'DA_DUYET'), (1, 8, 'DA_DUYET'), (1, 12, 'CHO_DUYET'),
    (2, 7, 'DA_DUYET'), (2, 12, 'DA_DUYET'),
    (3, 8, 'DA_DUYET'),
    (4, 7, 'DA_DUYET'), (4, 8, 'DA_DUYET'), (4, 12, 'CHO_DUYET'),
    (6, 7, 'DA_DUYET'), (6, 13, 'DA_DUYET')
) AS dk(MaPhien, MaNguoiDung, TrangThai)
JOIN PHIENDAUGIA p ON p.MaPhien = dk.MaPhien;

-- 9. Lịch sử lượt hợp lệ, mỗi lượt có một mã yêu cầu riêng.
INSERT INTO LUOTTRAGIA (MaPhien, MaNguoiTraGia, SoTien, MaYeuCau, ThoiDiemChapNhan)
SELECT lg.MaPhien, lg.MaNguoiDung, lg.SoTien, lg.MaYeuCau::UUID,
       p.ThoiDiemMo + lg.SauKhiMo
FROM (VALUES
    (1, 7, 5000000, '19000000-0000-4000-8000-000000000001', INTERVAL '10 minutes'),
    (1, 8, 5250000, '19000000-0000-4000-8000-000000000002', INTERVAL '20 minutes'),
    (1, 7, 5500000, '19000000-0000-4000-8000-000000000003', INTERVAL '30 minutes'),
    (2, 7, 2000000, '19000000-0000-4000-8000-000000000004', INTERVAL '10 minutes'),
    (2, 12,2100000, '19000000-0000-4000-8000-000000000005', INTERVAL '20 minutes'),
    (6, 7, 1000000, '19000000-0000-4000-8000-000000000006', INTERVAL '10 minutes'),
    (6, 13,1200000, '19000000-0000-4000-8000-000000000007', INTERVAL '20 minutes')
) AS lg(MaPhien, MaNguoiDung, SoTien, MaYeuCau, SauKhiMo)
JOIN PHIENDAUGIA p ON p.MaPhien = lg.MaPhien;

WITH LuotCaoNhat AS (
    SELECT DISTINCT ON (MaPhien) MaPhien, MaLuotTraGia, SoTien,
           COUNT(*) OVER (PARTITION BY MaPhien) AS SoLuot
    FROM LUOTTRAGIA
    ORDER BY MaPhien, SoTien DESC, MaLuotTraGia
)
UPDATE PHIENDAUGIA p
SET GiaHienTai = l.SoTien, MaLuotDanDau = l.MaLuotTraGia, PhienBan = l.SoLuot
FROM LuotCaoNhat l
WHERE p.MaPhien = l.MaPhien;

-- 10. Phiên thất bại có kết quả với MaLuotThang NULL theo EER.
INSERT INTO KETQUADAUGIA (MaPhien, MaLuotThang, ThoiDiemChot)
SELECT MaPhien, MaLuotDanDau, ThoiDiemDong
FROM PHIENDAUGIA
WHERE TrangThaiPhien IN ('DA_DONG', 'THAT_BAI');

UPDATE PHIENDAUGIA
SET PhienBan = PhienBan + 1
WHERE TrangThaiPhien IN ('DA_DONG', 'THAT_BAI');

-- 11. Nhật ký hệ thống khi chốt phiên không có tác nhân người dùng.
INSERT INTO NHATKYTHAYDOI (MaPhien, MaTacNhan, HanhDong, ChiTiet, ThoiDiemGhi)
SELECT MaPhien, MaNguoiTraGia, 'CHAP_NHAN_TRA_GIA',
       jsonb_build_object('MaLuotTraGia', MaLuotTraGia, 'SoTien', SoTien, 'MaYeuCau', MaYeuCau),
       ThoiDiemChapNhan
FROM LUOTTRAGIA
UNION ALL
SELECT MaPhien, NULL::BIGINT, 'DONG_PHIEN',
       jsonb_build_object('MaLuotThang', MaLuotThang), ThoiDiemChot
FROM KETQUADAUGIA;

-- Đồng bộ sequence cho các bảng được chèn ID cố định.
SELECT setval(pg_get_serial_sequence('NGUOIDUNG', 'manguoidung'), (SELECT MAX(MaNguoiDung) FROM NGUOIDUNG));
SELECT setval(pg_get_serial_sequence('DANHMUC',   'madanhmuc'),   (SELECT MAX(MaDanhMuc) FROM DANHMUC));
SELECT setval(pg_get_serial_sequence('TAISAN',    'mataisan'),    (SELECT MAX(MaTaiSan) FROM TAISAN));
SELECT setval(pg_get_serial_sequence('PHIENDAUGIA', 'maphien'), (SELECT MAX(MaPhien) FROM PHIENDAUGIA));

COMMIT;
