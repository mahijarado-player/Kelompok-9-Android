-- ==========================================================
-- 02_implementasi_json_lahan.sql
-- Implementasi Kolom Objek JSON pada Tabel Lahan & Sensor
-- ==========================================================

USE `smart_farming`;

-- 1. Menambahkan kolom objek JSON `spesifikasi` pada tabel `lahan`
ALTER TABLE `lahan`
  ADD COLUMN `spesifikasi` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
  CHECK (json_valid(`spesifikasi`));

-- 2. Mengisi atribut objek spesifik untuk tiap komoditas lahan
UPDATE `lahan`
SET `spesifikasi` = '{"sistem_irigasi": "Teknis", "varietas": "Ciherang", "target_kelembapan": 80, "sensor_terpasang": ["Cuaca", "Kelembapan"]}'
WHERE `id_lahan` = 1;

UPDATE `lahan`
SET `spesifikasi` = '{"mulsa": "Plastik Hitam Perak", "ph_tanah_ideal": 6.5, "jarak_tanam_cm": 50, "sensor_terpasang": ["Kelembapan", "Hama"]}'
WHERE `id_lahan` = 2;

UPDATE `lahan`
SET `spesifikasi` = '{"pola_tanam": "Tumpangsari", "varietas": "Bisi-18", "kebutuhan_hujan_mm": 120, "sensor_terpasang": ["Cuaca", "Kelembapan", "Hama"]}'
WHERE `id_lahan` = 3;

-- 3. Membuat tabel `sensor` terpadu dengan atribut khusus berbasis JSON
CREATE TABLE `sensor` (
  `id_sensor` int(11) NOT NULL AUTO_INCREMENT,
  `id_lahan` int(11) NOT NULL,
  `jenis_sensor` varchar(30) NOT NULL,
  `nama_sensor` varchar(100) NOT NULL,
  `status` varchar(20) NOT NULL,
  `atribut_khusus` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`atribut_khusus`)),
  PRIMARY KEY (`id_sensor`),
  KEY `id_lahan` (`id_lahan`),
  CONSTRAINT `sensor_ibfk_1` FOREIGN KEY (`id_lahan`) REFERENCES `lahan` (`id_lahan`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. Mengisi data objek sensor dengan atribut berbeda tiap jenis
INSERT INTO `sensor` (`id_sensor`, `id_lahan`, `jenis_sensor`, `nama_sensor`, `status`, `atribut_khusus`) VALUES
(1, 1, 'kelembapan', 'Sensor Tanah A', 'aktif', '{"ambang_min": 30, "ambang_max": 70}'),
(2, 1, 'cuaca', 'Sensor Cuaca A', 'aktif', '{"parameter_cuaca": "curah hujan"}'),
(3, 1, 'hama', 'Sensor Hama A', 'aktif', '{"jenis_hama": "wereng"}');