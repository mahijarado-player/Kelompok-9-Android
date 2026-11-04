SELECT nama_petani, nama_lahan, rata_rata_kelembapan,
       jumlah_notif_kelembapan, jumlah_notif_cuaca, jumlah_notif_hama, total_notifikasi
FROM rekap_lahan
ORDER BY nama_petani, nama_lahan;
