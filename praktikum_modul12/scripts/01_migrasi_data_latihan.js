// =====================================================================
// 01_migrasi_data_latihan.js
// Praktikum Modul 12 - Konsep Pemrosesan Query Basis Data
//
// DBMS target  : MongoDB (Document DB)
// Kasus latihan: pembacaan kelembapan tanah (proyek smart_farming)
// Sumber data  : tabel sensor_kelembapan dan pembacaan_kelembapan
//                dari smart_farming.sql (MariaDB)
//
// Pemetaan relasional -> MongoDB:
//   tabel sensor_kelembapan      -> koleksi sensor_kelembapan
//   tabel pembacaan_kelembapan   -> koleksi pembacaan_kelembapan
//   baris (row)                  -> dokumen
//   foreign key (id_sensor_...)  -> field biasa, digabung lewat $lookup
//
// Cara menjalankan (login sebagai admin_user, karena autentikasi aktif):
//   mongosh "mongodb://admin_user@localhost/?authSource=admin"
//   load("D:/lokasi/berkas/01_migrasi_data_latihan.js")
//
// CATATAN: tidak ada password di berkas ini.
// =====================================================================

db = db.getSiblingDB("smart_farming");

// Hapus koleksi lama agar skrip aman dijalankan ulang (tidak ada data ganda)
db.sensor_kelembapan.drop();
db.pembacaan_kelembapan.drop();

// ---------------------------------------------------------------------
// Langkah 1: migrasi data sensor (3 baris)
// ---------------------------------------------------------------------
printjson(db.sensor_kelembapan.insertMany([
  { id_sensor_kelembapan: 1, id_lahan: 1, satuan: "%", status_sensor: "AKTIF" },
  { id_sensor_kelembapan: 2, id_lahan: 2, satuan: "%", status_sensor: "AKTIF" },
  { id_sensor_kelembapan: 3, id_lahan: 3, satuan: "%", status_sensor: "NONAKTIF" }
]));

// ---------------------------------------------------------------------
// Langkah 2: migrasi data pembacaan (5 baris)
// waktu_baca disimpan sebagai string berformat YYYY-MM-DD HH:mm:ss
// (urutan string sama dengan urutan waktu, sehingga $gte tetap benar)
// ---------------------------------------------------------------------
printjson(db.pembacaan_kelembapan.insertMany([
  { id_pembacaan_kelembapan: 1, id_sensor_kelembapan: 1, nilai_kelembapan: 65.50, waktu_baca: "2026-10-26 06:00:00" },
  { id_pembacaan_kelembapan: 2, id_sensor_kelembapan: 2, nilai_kelembapan: 22.00, waktu_baca: "2026-10-26 06:05:00" },
  { id_pembacaan_kelembapan: 3, id_sensor_kelembapan: 1, nilai_kelembapan: 85.30, waktu_baca: "2026-10-27 06:00:00" },
  { id_pembacaan_kelembapan: 4, id_sensor_kelembapan: 2, nilai_kelembapan: 55.00, waktu_baca: "2026-10-27 06:05:00" },
  { id_pembacaan_kelembapan: 5, id_sensor_kelembapan: 1, nilai_kelembapan: 20.00, waktu_baca: "2026-10-28 06:00:00" }
]));

// ---------------------------------------------------------------------
// Langkah 3: verifikasi jumlah dokumen
// ---------------------------------------------------------------------
print("sensor_kelembapan    : " + db.sensor_kelembapan.countDocuments() + " dokumen (seharusnya 3)");
print("pembacaan_kelembapan : " + db.pembacaan_kelembapan.countDocuments() + " dokumen (seharusnya 5)");
