-- ==========================================================
-- 03_pengujian_objek_join.sql
-- Pengujian Query JOIN & Ekstraksi Atribut Objek JSON
-- ==========================================================

USE `smart_farming`;

-- Pengujian 1: JOIN petani & lahan dengan ekstraksi atribut JSON yang heterogen
SELECT 
    p.nama_petani,
    l.nama_lahan,
    l.komoditas,
    l.luas_m2,
    JSON_VALUE(l.spesifikasi, '$.varietas') AS varietas,
    JSON_VALUE(l.spesifikasi, '$.sistem_irigasi') AS sistem_irigasi,
    JSON_VALUE(l.spesifikasi, '$.mulsa') AS mulsa,
    JSON_VALUE(l.spesifikasi, '$.pola_tanam') AS pola_tanam,
    JSON_EXTRACT(l.spesifikasi, '$.sensor_terpasang') AS daftar_sensor
FROM lahan l
JOIN petani p ON l.id_petani = p.id_petani;

-- Pengujian 2: Pencarian elemen di dalam array JSON (`sensor_terpasang`)
SELECT 
    id_lahan,
    nama_lahan,
    komoditas,
    lokasi
FROM lahan
WHERE JSON_CONTAINS(spesifikasi, '"Hama"', '$.sensor_terpasang');

-- Pengujian 3: JOIN 3 tabel (petani, lahan, sensor) & pembacaan atribut_khusus sensor
SELECT 
    p.nama_petani,
    l.nama_lahan,
    s.nama_sensor,
    s.jenis_sensor,
    s.status,
    COALESCE(
        CONCAT('Ambang Kelembapan: ', JSON_VALUE(s.atribut_khusus, '$.ambang_min'), '% - ', JSON_VALUE(s.atribut_khusus, '$.ambang_max'), '%'),
        CONCAT('Parameter Cuaca: ', JSON_VALUE(s.atribut_khusus, '$.parameter_cuaca')),
        CONCAT('Target Hama: ', JSON_VALUE(s.atribut_khusus, '$.jenis_hama'))
    ) AS detail_konfigurasi
FROM sensor s
JOIN lahan l ON s.id_lahan = l.id_lahan
JOIN petani p ON l.id_petani = p.id_petani;

-- Pengujian 4: Pengujian constraint CHECK (json_valid) - Query berikut sengaja gagal jika dijalankan
-- INSERT INTO `lahan` (`id_petani`, `nama_lahan`, `lokasi`, `luas_m2`, `komoditas`, `spesifikasi`)
-- VALUES (1, 'Lahan Uji Invalid', 'Madiun', 1000.00, 'Padi', 'bukan_format_json_valid');