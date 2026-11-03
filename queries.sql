-- Truy vấn: Xây dựng cây phân cấp danh mục và thống kê cộng dồn 
-- (Roll-up) tổng số tài sản & phiên đấu giá từ danh mục con lên danh mục cha

WITH RECURSIVE CayDanhMuc AS (
    -- Bước cơ sở: Lấy các danh mục gốc (Cấp 1)
    SELECT 
        dm.MaDanhMuc,
        dm.TenDanhMuc,
        dm.MaDanhMucCha,
        1 AS CapDo,
        dm.TenDanhMuc::TEXT AS DuongDanPhanCap,
        LPAD('', 0, ' ') || dm.TenDanhMuc AS TenHienThiCay
    FROM DANHMUC dm
    WHERE dm.MaDanhMucCha IS NULL

    UNION ALL

    -- Bước đệ quy: Nối các danh mục con vào danh mục cha
    SELECT 
        con.MaDanhMuc,
        con.TenDanhMuc,
        con.MaDanhMucCha,
        cha.CapDo + 1 AS CapDo,
        (cha.DuongDanPhanCap || ' - ' || con.TenDanhMuc)::TEXT AS DuongDanPhanCap,
        (REPEAT('    ', cha.CapDo) || '|-- ' || con.TenDanhMuc)::VARCHAR(255) AS TenHienThiCay
    FROM DANHMUC con
    INNER JOIN CayDanhMuc cha ON con.MaDanhMucCha = cha.MaDanhMuc
),
-- CTE phụ: Tìm mọi cặp (Danh mục Tổ tiên, Danh mục Con cháu bao gồm chính nó)
-- để tính tổng cộng dồn từ các nhánh lá lên nhánh gốc
QuanHeToTienConChau AS (
    SELECT MaDanhMuc AS MaToTien, MaDanhMuc AS MaConChau
    FROM DANHMUC
    
    UNION ALL
    
    SELECT qh.MaToTien, dm.MaDanhMuc AS MaConChau
    FROM QuanHeToTienConChau qh
    INNER JOIN DANHMUC dm ON dm.MaDanhMucCha = qh.MaConChau
),
ThongKeCongDon AS (
    SELECT 
        qh.MaToTien AS MaDanhMuc,
        COUNT(DISTINCT ts.MaTaiSan) AS TongSoTaiSanTrongNhanh,
        COUNT(DISTINCT pdg.MaPhien) AS TongSoPhienTrongNhanh
    FROM QuanHeToTienConChau qh
    LEFT JOIN TAISAN ts ON ts.MaDanhMuc = qh.MaConChau
    LEFT JOIN PHIENDAUGIA pdg ON pdg.MaTaiSan = ts.MaTaiSan
    GROUP BY qh.MaToTien
)
SELECT 
    c.MaDanhMuc,
    c.CapDo,
    c.TenHienThiCay AS CauTrucCayDanhMuc,
    tk.TongSoTaiSanTrongNhanh,
    tk.TongSoPhienTrongNhanh,
    c.DuongDanPhanCap
FROM CayDanhMuc c
LEFT JOIN ThongKeCongDon tk ON c.MaDanhMuc = tk.MaDanhMuc
ORDER BY c.DuongDanPhanCap;

-- Truy vấn: Tìm toàn bộ Tài sản và Phiên đấu giá thuộc một nhánh 
-- danh mục bất kỳ (Ví dụ: Nhánh 1 - 'Thiết bị công nghệ & Điện tử')
-- ---------------------------------------------------------------------
WITH RECURSIVE NhanhDanhMucCon AS (
    -- Chọn danh mục gốc cần tra cứu (có thể đổi MaDanhMuc = 1, 2, hoặc 3...)
    SELECT MaDanhMuc, TenDanhMuc, MaDanhMucCha, 1 AS CapDo
    FROM DANHMUC
    WHERE MaDanhMuc = 1 

    UNION ALL

    -- Đệ quy lấy toàn bộ danh mục con, cháu bên dưới
    SELECT dm.MaDanhMuc, dm.TenDanhMuc, dm.MaDanhMucCha, ndm.CapDo + 1
    FROM DANHMUC dm
    INNER JOIN NhanhDanhMucCon ndm ON dm.MaDanhMucCha = ndm.MaDanhMuc
)
SELECT 
    ndm.MaDanhMuc,
    ndm.TenDanhMuc,
    ts.MaTaiSan,
    ts.TenTaiSan,
    ts.LoaiTaiSan,
    nd.HoTen AS NguoiBan,
    pdg.MaPhien,
    pdg.GiaKhoiDiem,
    COALESCE(pdg.GiaHienTai, pdg.GiaKhoiDiem) AS GiaHienTaiHoacKhoiDiem,
    pdg.TrangThaiPhien
FROM NhanhDanhMucCon ndm
INNER JOIN TAISAN ts ON ts.MaDanhMuc = ndm.MaDanhMuc
INNER JOIN NGUOIDUNG nd ON nd.MaNguoiDung = ts.MaNguoiBan
LEFT JOIN PHIENDAUGIA pdg ON pdg.MaTaiSan = ts.MaTaiSan
ORDER BY ndm.MaDanhMuc, ts.MaTaiSan;


-- HÀM BÁO CÁO CÓ BỘ LỌC ĐỘNG 
-- Mục đích: Cho phép lọc danh sách phiên đấu giá theo nhiều tiêu chí tùy chọn:
--   + p_MaDanhMucGoc : Lọc theo nhánh danh mục (tự động lấy cả danh mục con cháu)
--   + p_TrangThai    : Lọc theo trạng thái phiên (VD: 'DANG_MO', 'DA_DONG'...)
--   + p_LoaiTaiSan   : Lọc theo phân lớp ('TACPHAMNGHETHUAT', 'DOSUUTAM', 'THIETBIDIENTU')
--   + p_GiaTu / p_GiaDen: Khoảng giá hiện tại (hoặc giá khởi điểm nếu chưa ai trả giá)
--   + p_TuKhoa       : Tìm kiếm gần đúng (ILIKE) theo tên tài sản
-- Sử dụng kỹ thuật Dynamic SQL (EXECUTE ... USING) chống SQL Injection.

CREATE OR REPLACE FUNCTION fn_BaoCaoPhienDauGiaDong(
    p_MaDanhMucGoc BIGINT DEFAULT NULL,
    p_TrangThai VARCHAR(50) DEFAULT NULL,
    p_LoaiTaiSan VARCHAR(50) DEFAULT NULL,
    p_GiaTu NUMERIC(16,2) DEFAULT NULL,
    p_GiaDen NUMERIC(16,2) DEFAULT NULL,
    p_TuKhoa VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE (
    MaPhien BIGINT,
    TenTaiSan VARCHAR(255),
    LoaiTaiSan VARCHAR(50),
    TenDanhMuc VARCHAR(255),
    NguoiBan VARCHAR(255),
    GiaKhoiDiem NUMERIC(16,2),
    GiaHienTai NUMERIC(16,2),
    SoLuotTraGia BIGINT,
    NguoiDanDau VARCHAR(255),
    ThoiDiemMo TIMESTAMPTZ,
    ThoiDiemDong TIMESTAMPTZ,
    TrangThaiPhien VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_sql TEXT;
BEGIN
    -- Khởi tạo khung truy vấn kết hợp CTE đệ quy để hỗ trợ lọc theo nhánh danh mục
    v_sql := '
        WITH RECURSIVE CayDanhMucLoc AS (
            SELECT dm.MaDanhMuc, dm.TenDanhMuc, dm.MaDanhMucCha
            FROM DANHMUC dm
            WHERE ($1 IS NULL AND dm.MaDanhMucCha IS NULL) 
               OR ($1 IS NOT NULL AND dm.MaDanhMuc = $1)
            
            UNION ALL
            
            SELECT con.MaDanhMuc, con.TenDanhMuc, con.MaDanhMucCha
            FROM DANHMUC con
            INNER JOIN CayDanhMucLoc cha ON con.MaDanhMucCha = cha.MaDanhMuc
        )
        SELECT 
            pdg.MaPhien,
            ts.TenTaiSan,
            ts.LoaiTaiSan,
            cdm.TenDanhMuc,
            nb.HoTen AS NguoiBan,
            pdg.GiaKhoiDiem,
            pdg.GiaHienTai,
            COUNT(ltg.MaLuotTraGia) AS SoLuotTraGia,
            ndd.HoTen AS NguoiDanDau,
            pdg.ThoiDiemMo,
            pdg.ThoiDiemDong,
            pdg.TrangThaiPhien
        FROM PHIENDAUGIA pdg
        INNER JOIN TAISAN ts ON pdg.MaTaiSan = ts.MaTaiSan
        INNER JOIN CayDanhMucLoc cdm ON ts.MaDanhMuc = cdm.MaDanhMuc
        INNER JOIN NGUOIDUNG nb ON ts.MaNguoiBan = nb.MaNguoiDung
        LEFT JOIN LUOTTRAGIA ltg ON pdg.MaPhien = ltg.MaPhien
        LEFT JOIN LUOTTRAGIA ltg_dd ON pdg.MaLuotDanDau = ltg_dd.MaLuotTraGia AND pdg.MaPhien = ltg_dd.MaPhien
        LEFT JOIN NGUOIDUNG ndd ON ltg_dd.MaNguoiTraGia = ndd.MaNguoiDung
        WHERE 1 = 1
    ';

    -- Gắn động từng điều kiện lọc nếu tham số được truyền vào (khác NULL)
    IF p_TrangThai IS NOT NULL THEN
        v_sql := v_sql || ' AND pdg.TrangThaiPhien = $2';
    END IF;

    IF p_LoaiTaiSan IS NOT NULL THEN
        v_sql := v_sql || ' AND ts.LoaiTaiSan = $3';
    END IF;

    IF p_GiaTu IS NOT NULL THEN
        v_sql := v_sql || ' AND COALESCE(pdg.GiaHienTai, pdg.GiaKhoiDiem) >= $4';
    END IF;

    IF p_GiaDen IS NOT NULL THEN
        v_sql := v_sql || ' AND COALESCE(pdg.GiaHienTai, pdg.GiaKhoiDiem) <= $5';
    END IF;

    IF p_TuKhoa IS NOT NULL THEN
        v_sql := v_sql || ' AND ts.TenTaiSan ILIKE ''%'' || $6 || ''%''';
    END IF;

    -- Gom nhóm và sắp xếp kết quả
    v_sql := v_sql || '
        GROUP BY 
            pdg.MaPhien, ts.TenTaiSan, ts.LoaiTaiSan, cdm.TenDanhMuc, 
            nb.HoTen, pdg.GiaKhoiDiem, pdg.GiaHienTai, ndd.HoTen, 
            pdg.ThoiDiemMo, pdg.ThoiDiemDong, pdg.TrangThaiPhien
        ORDER BY pdg.ThoiDiemDong ASC, pdg.MaPhien ASC
    ';

    -- Thực thi câu lệnh Dynamic SQL với bộ tham số truyền vào qua mệnh đề USING
    RETURN QUERY EXECUTE v_sql 
    USING p_MaDanhMucGoc, p_TrangThai, p_LoaiTaiSan, p_GiaTu, p_GiaDen, p_TuKhoa;
END;
$$;

SELECT * FROM fn_BaoCaoPhienDauGiaDong();
SELECT * FROM fn_BaoCaoPhienDauGiaDong(p_MaDanhMucGoc => 1);
SELECT * FROM fn_BaoCaoPhienDauGiaDong(
    p_LoaiTaiSan => 'DOSUUTAM',
    p_GiaTu      => 1000000,
    p_GiaDen     => 50000000
);
