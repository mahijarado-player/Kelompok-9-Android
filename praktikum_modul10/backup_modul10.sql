-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 11 Nov 2026 pada 19.36
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `backup_modul10`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `data_cuaca`
--

CREATE TABLE `data_cuaca` (
  `id_data_cuaca` bigint(20) NOT NULL,
  `id_sensor_cuaca` int(11) NOT NULL,
  `suhu` decimal(5,2) NOT NULL,
  `kelembapan_udara` decimal(5,2) NOT NULL,
  `curah_hujan` decimal(6,2) NOT NULL,
  `waktu_baca` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `data_cuaca`
--

INSERT INTO `data_cuaca` (`id_data_cuaca`, `id_sensor_cuaca`, `suhu`, `kelembapan_udara`, `curah_hujan`, `waktu_baca`) VALUES
(1, 1, 30.50, 70.00, 10.00, '2026-10-26 12:00:00'),
(2, 2, 37.20, 60.00, 0.00, '2026-10-26 13:00:00'),
(3, 1, 28.00, 90.00, 150.00, '2026-10-27 15:00:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `hama`
--

CREATE TABLE `hama` (
  `id_hama` int(11) NOT NULL,
  `nama_hama` varchar(100) NOT NULL,
  `gejala` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `hama`
--

INSERT INTO `hama` (`id_hama`, `nama_hama`, `gejala`) VALUES
(1, 'Wereng Coklat', 'Daun menguning dan tanaman mengering seperti terbakar'),
(2, 'Ulat Grayak', 'Daun berlubang dan tinggal tulang daun'),
(3, 'Kutu Daun', 'Daun mengeriting dan muncul embun jelaga');

-- --------------------------------------------------------

--
-- Struktur dari tabel `lahan`
--

CREATE TABLE `lahan` (
  `id_lahan` int(11) NOT NULL,
  `id_petani` int(11) NOT NULL,
  `nama_lahan` varchar(100) NOT NULL,
  `lokasi` varchar(255) NOT NULL,
  `luas_m2` decimal(10,2) NOT NULL,
  `komoditas` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `lahan`
--

INSERT INTO `lahan` (`id_lahan`, `id_petani`, `nama_lahan`, `lokasi`, `luas_m2`, `komoditas`) VALUES
(1, 1, 'Sawah Utara', 'Madiun, Jawa Timur', 5000.00, 'Padi'),
(2, 1, 'Kebun Cabai', 'Madiun, Jawa Timur', 2500.00, 'Cabai'),
(3, 2, 'Ladang Jagung', 'Ngawi, Jawa Timur', 8000.00, 'Jagung'),
(5, 1, 'Sawah Utara', 'Madiun, Jawa Timur', 5000.00, 'Padi'),
(6, 1, 'Kebun Cabai', 'Madiun, Jawa Timur', 2500.00, 'Cabai'),
(7, 2, 'Ladang Jagung', 'Ngawi, Jawa Timur', 8000.00, 'Jagung'),
(8, 999999, 'Lahan Percobaan', 'Madiun', 1000.00, 'Padi'),
(9, 999999, 'Lahan Percobaan', 'Madiun', 1000.00, 'Padi');

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi_cuaca`
--

CREATE TABLE `notifikasi_cuaca` (
  `id_notifikasi_cuaca` int(11) NOT NULL,
  `id_data_cuaca` bigint(20) NOT NULL,
  `pesan` varchar(255) NOT NULL,
  `waktu_kirim` datetime NOT NULL DEFAULT current_timestamp(),
  `status_baca` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi_hama`
--

CREATE TABLE `notifikasi_hama` (
  `id_notifikasi_hama` int(11) NOT NULL,
  `id_pembacaan_hama` bigint(20) NOT NULL,
  `id_hama` int(11) NOT NULL,
  `pesan` varchar(255) NOT NULL,
  `waktu_kirim` datetime NOT NULL DEFAULT current_timestamp(),
  `status_baca` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `notifikasi_hama`
--

INSERT INTO `notifikasi_hama` (`id_notifikasi_hama`, `id_pembacaan_hama`, `id_hama`, `pesan`, `waktu_kirim`, `status_baca`) VALUES
(1, 1, 2, 'Deteksi hama tingkat TINGGI di Kebun Cabai. Lakukan pengendalian segera.', '2026-11-03 16:38:20', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `notifikasi_kelembapan`
--

CREATE TABLE `notifikasi_kelembapan` (
  `id_notifikasi_kelembapan` int(11) NOT NULL,
  `id_pembacaan_kelembapan` bigint(20) NOT NULL,
  `pesan` varchar(255) NOT NULL,
  `waktu_kirim` datetime NOT NULL DEFAULT current_timestamp(),
  `status_baca` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembacaan_hama`
--

CREATE TABLE `pembacaan_hama` (
  `id_pembacaan_hama` bigint(20) NOT NULL,
  `id_sensor_hama` int(11) NOT NULL,
  `tingkat_deteksi` varchar(50) NOT NULL,
  `waktu_baca` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembacaan_hama`
--

INSERT INTO `pembacaan_hama` (`id_pembacaan_hama`, `id_sensor_hama`, `tingkat_deteksi`, `waktu_baca`) VALUES
(1, 1, 'TINGGI', '2026-10-27 07:00:00'),
(2, 1, 'RENDAH', '2026-10-28 07:00:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembacaan_kelembapan`
--

CREATE TABLE `pembacaan_kelembapan` (
  `id_pembacaan_kelembapan` bigint(20) NOT NULL,
  `id_sensor_kelembapan` int(11) NOT NULL,
  `nilai_kelembapan` decimal(5,2) NOT NULL,
  `waktu_baca` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pembacaan_kelembapan`
--

INSERT INTO `pembacaan_kelembapan` (`id_pembacaan_kelembapan`, `id_sensor_kelembapan`, `nilai_kelembapan`, `waktu_baca`) VALUES
(1, 1, 65.50, '2026-10-26 06:00:00'),
(2, 2, 22.00, '2026-10-26 06:05:00'),
(3, 1, 85.30, '2026-10-27 06:00:00'),
(4, 2, 55.00, '2026-10-27 06:05:00'),
(5, 1, 20.00, '2026-10-28 06:00:00'),
(6, 1, 65.50, '2026-10-29 06:00:00'),
(7, 2, 22.00, '2026-10-29 06:05:00'),
(8, 1, 85.30, '2026-10-30 06:00:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `petani`
--

CREATE TABLE `petani` (
  `id_petani` int(11) NOT NULL,
  `nama_petani` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `petani`
--

INSERT INTO `petani` (`id_petani`, `nama_petani`) VALUES
(1, 'Slamet Riyadi'),
(2, 'Rahayu Lestari'),
(999999, 'Petani Commit');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rekap_lahan`
--

CREATE TABLE `rekap_lahan` (
  `id_lahan` int(11) NOT NULL,
  `nama_petani` varchar(100) NOT NULL,
  `nama_lahan` varchar(100) NOT NULL,
  `komoditas` varchar(100) NOT NULL,
  `rata_rata_kelembapan` decimal(5,2) DEFAULT NULL,
  `jumlah_notif_kelembapan` int(11) NOT NULL DEFAULT 0,
  `jumlah_notif_cuaca` int(11) NOT NULL DEFAULT 0,
  `jumlah_notif_hama` int(11) NOT NULL DEFAULT 0,
  `total_notifikasi` int(11) NOT NULL DEFAULT 0,
  `terakhir_diperbarui` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `rekap_lahan`
--

INSERT INTO `rekap_lahan` (`id_lahan`, `nama_petani`, `nama_lahan`, `komoditas`, `rata_rata_kelembapan`, `jumlah_notif_kelembapan`, `jumlah_notif_cuaca`, `jumlah_notif_hama`, `total_notifikasi`, `terakhir_diperbarui`) VALUES
(1, 'Slamet Riyadi', 'Sawah Utara', 'Padi', 75.40, 0, 0, 0, 0, '2026-11-03 09:48:22'),
(2, 'Slamet Riyadi', 'Kebun Cabai', 'Cabai', 38.50, 0, 0, 1, 1, '2026-11-03 09:48:22'),
(3, 'Rahayu Lestari', 'Ladang Jagung', 'Jagung', NULL, 0, 0, 0, 0, '2026-11-03 09:48:22');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sensor_cuaca`
--

CREATE TABLE `sensor_cuaca` (
  `id_sensor_cuaca` int(11) NOT NULL,
  `id_lahan` int(11) NOT NULL,
  `status_sensor` enum('AKTIF','NONAKTIF','RUSAK') NOT NULL DEFAULT 'AKTIF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `sensor_cuaca`
--

INSERT INTO `sensor_cuaca` (`id_sensor_cuaca`, `id_lahan`, `status_sensor`) VALUES
(1, 1, 'AKTIF'),
(2, 3, 'AKTIF');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sensor_hama`
--

CREATE TABLE `sensor_hama` (
  `id_sensor_hama` int(11) NOT NULL,
  `id_lahan` int(11) NOT NULL,
  `status_sensor` enum('AKTIF','NONAKTIF','RUSAK') NOT NULL DEFAULT 'AKTIF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `sensor_hama`
--

INSERT INTO `sensor_hama` (`id_sensor_hama`, `id_lahan`, `status_sensor`) VALUES
(1, 2, 'AKTIF'),
(2, 3, 'RUSAK');

-- --------------------------------------------------------

--
-- Struktur dari tabel `sensor_kelembapan`
--

CREATE TABLE `sensor_kelembapan` (
  `id_sensor_kelembapan` int(11) NOT NULL,
  `id_lahan` int(11) NOT NULL,
  `satuan` varchar(20) NOT NULL DEFAULT '%',
  `status_sensor` enum('AKTIF','NONAKTIF','RUSAK') NOT NULL DEFAULT 'AKTIF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `sensor_kelembapan`
--

INSERT INTO `sensor_kelembapan` (`id_sensor_kelembapan`, `id_lahan`, `satuan`, `status_sensor`) VALUES
(1, 1, '%', 'AKTIF'),
(2, 2, '%', 'AKTIF'),
(3, 3, '%', 'NONAKTIF'),
(4, 1, '%', 'AKTIF'),
(5, 2, '%', 'AKTIF'),
(6, 3, '%', 'NONAKTIF');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `data_cuaca`
--
ALTER TABLE `data_cuaca`
  ADD PRIMARY KEY (`id_data_cuaca`),
  ADD KEY `idx_dc_waktu` (`id_sensor_cuaca`,`waktu_baca`),
  ADD KEY `idx_data_cuaca_waktu` (`waktu_baca`);

--
-- Indeks untuk tabel `hama`
--
ALTER TABLE `hama`
  ADD PRIMARY KEY (`id_hama`),
  ADD UNIQUE KEY `uq_nama_hama` (`nama_hama`);

--
-- Indeks untuk tabel `lahan`
--
ALTER TABLE `lahan`
  ADD PRIMARY KEY (`id_lahan`),
  ADD KEY `idx_lahan_petani` (`id_petani`);

--
-- Indeks untuk tabel `notifikasi_cuaca`
--
ALTER TABLE `notifikasi_cuaca`
  ADD PRIMARY KEY (`id_notifikasi_cuaca`),
  ADD KEY `idx_nc_data` (`id_data_cuaca`);

--
-- Indeks untuk tabel `notifikasi_hama`
--
ALTER TABLE `notifikasi_hama`
  ADD PRIMARY KEY (`id_notifikasi_hama`),
  ADD KEY `idx_nh_pembacaan` (`id_pembacaan_hama`),
  ADD KEY `idx_nh_hama` (`id_hama`);

--
-- Indeks untuk tabel `notifikasi_kelembapan`
--
ALTER TABLE `notifikasi_kelembapan`
  ADD PRIMARY KEY (`id_notifikasi_kelembapan`),
  ADD KEY `idx_nk_pembacaan` (`id_pembacaan_kelembapan`);

--
-- Indeks untuk tabel `pembacaan_hama`
--
ALTER TABLE `pembacaan_hama`
  ADD PRIMARY KEY (`id_pembacaan_hama`),
  ADD KEY `idx_ph_waktu` (`id_sensor_hama`,`waktu_baca`);

--
-- Indeks untuk tabel `pembacaan_kelembapan`
--
ALTER TABLE `pembacaan_kelembapan`
  ADD PRIMARY KEY (`id_pembacaan_kelembapan`),
  ADD KEY `idx_pk_waktu` (`id_sensor_kelembapan`,`waktu_baca`);

--
-- Indeks untuk tabel `petani`
--
ALTER TABLE `petani`
  ADD PRIMARY KEY (`id_petani`);

--
-- Indeks untuk tabel `rekap_lahan`
--
ALTER TABLE `rekap_lahan`
  ADD PRIMARY KEY (`id_lahan`);

--
-- Indeks untuk tabel `sensor_cuaca`
--
ALTER TABLE `sensor_cuaca`
  ADD PRIMARY KEY (`id_sensor_cuaca`),
  ADD KEY `idx_sc_lahan` (`id_lahan`);

--
-- Indeks untuk tabel `sensor_hama`
--
ALTER TABLE `sensor_hama`
  ADD PRIMARY KEY (`id_sensor_hama`),
  ADD KEY `idx_sh_lahan` (`id_lahan`);

--
-- Indeks untuk tabel `sensor_kelembapan`
--
ALTER TABLE `sensor_kelembapan`
  ADD PRIMARY KEY (`id_sensor_kelembapan`),
  ADD KEY `idx_sk_lahan` (`id_lahan`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `data_cuaca`
--
ALTER TABLE `data_cuaca`
  MODIFY `id_data_cuaca` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `hama`
--
ALTER TABLE `hama`
  MODIFY `id_hama` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `lahan`
--
ALTER TABLE `lahan`
  MODIFY `id_lahan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `notifikasi_cuaca`
--
ALTER TABLE `notifikasi_cuaca`
  MODIFY `id_notifikasi_cuaca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `notifikasi_hama`
--
ALTER TABLE `notifikasi_hama`
  MODIFY `id_notifikasi_hama` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `notifikasi_kelembapan`
--
ALTER TABLE `notifikasi_kelembapan`
  MODIFY `id_notifikasi_kelembapan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pembacaan_hama`
--
ALTER TABLE `pembacaan_hama`
  MODIFY `id_pembacaan_hama` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `pembacaan_kelembapan`
--
ALTER TABLE `pembacaan_kelembapan`
  MODIFY `id_pembacaan_kelembapan` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `petani`
--
ALTER TABLE `petani`
  MODIFY `id_petani` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1000000;

--
-- AUTO_INCREMENT untuk tabel `sensor_cuaca`
--
ALTER TABLE `sensor_cuaca`
  MODIFY `id_sensor_cuaca` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `sensor_hama`
--
ALTER TABLE `sensor_hama`
  MODIFY `id_sensor_hama` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `sensor_kelembapan`
--
ALTER TABLE `sensor_kelembapan`
  MODIFY `id_sensor_kelembapan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `data_cuaca`
--
ALTER TABLE `data_cuaca`
  ADD CONSTRAINT `fk_data_cuaca_sensor` FOREIGN KEY (`id_sensor_cuaca`) REFERENCES `sensor_cuaca` (`id_sensor_cuaca`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `lahan`
--
ALTER TABLE `lahan`
  ADD CONSTRAINT `fk_lahan_petani` FOREIGN KEY (`id_petani`) REFERENCES `petani` (`id_petani`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notifikasi_cuaca`
--
ALTER TABLE `notifikasi_cuaca`
  ADD CONSTRAINT `fk_notif_data_cuaca` FOREIGN KEY (`id_data_cuaca`) REFERENCES `data_cuaca` (`id_data_cuaca`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notifikasi_hama`
--
ALTER TABLE `notifikasi_hama`
  ADD CONSTRAINT `fk_notif_hama_master` FOREIGN KEY (`id_hama`) REFERENCES `hama` (`id_hama`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_notif_pembacaan_hama` FOREIGN KEY (`id_pembacaan_hama`) REFERENCES `pembacaan_hama` (`id_pembacaan_hama`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `notifikasi_kelembapan`
--
ALTER TABLE `notifikasi_kelembapan`
  ADD CONSTRAINT `fk_notif_pembacaan_kelembapan` FOREIGN KEY (`id_pembacaan_kelembapan`) REFERENCES `pembacaan_kelembapan` (`id_pembacaan_kelembapan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pembacaan_hama`
--
ALTER TABLE `pembacaan_hama`
  ADD CONSTRAINT `fk_pembacaan_sensor_hama` FOREIGN KEY (`id_sensor_hama`) REFERENCES `sensor_hama` (`id_sensor_hama`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `pembacaan_kelembapan`
--
ALTER TABLE `pembacaan_kelembapan`
  ADD CONSTRAINT `fk_pembacaan_sensor_kelembapan` FOREIGN KEY (`id_sensor_kelembapan`) REFERENCES `sensor_kelembapan` (`id_sensor_kelembapan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `sensor_cuaca`
--
ALTER TABLE `sensor_cuaca`
  ADD CONSTRAINT `fk_sensor_cuaca_lahan` FOREIGN KEY (`id_lahan`) REFERENCES `lahan` (`id_lahan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `sensor_hama`
--
ALTER TABLE `sensor_hama`
  ADD CONSTRAINT `fk_sensor_hama_lahan` FOREIGN KEY (`id_lahan`) REFERENCES `lahan` (`id_lahan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `sensor_kelembapan`
--
ALTER TABLE `sensor_kelembapan`
  ADD CONSTRAINT `fk_sensor_kelembapan_lahan` FOREIGN KEY (`id_lahan`) REFERENCES `lahan` (`id_lahan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
