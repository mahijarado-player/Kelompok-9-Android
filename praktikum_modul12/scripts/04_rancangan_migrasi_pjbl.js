// =====================================================================
// 04_rancangan_migrasi_pjbl.js
// Praktikum Modul 12 - Rancangan Awal Migrasi Proyek PjBL ke MongoDB
//
// Proyek       : Smart Farming (SDGs 2 - Zero Hunger)
// DBMS lama    : MariaDB 10.4.32 (smart_farming.sql)
// DBMS target  : MongoDB (Document DB), database smart_farming_mongo
//
// Fitur yang dirancang:
//   Riwayat kelembapan tanah sebuah lahan beserta nama petani dan
//   komoditasnya, sejak tanggal tertentu.
//
// Skema lama : petani, lahan, sensor_kelembapan, pembacaan_kelembapan
//              (join 4 tabel).
// Skema baru : 2 koleksi.
//   - lahan                : petani dan sensor kelembapan DIBENAMKAN (embedding),
//                            karena data master kecil dan jarang berubah.
//   - pembacaan_kelembapan : TETAP TERPISAH karena terus bertambah; ditambah
//                            id_lahan (denormalisasi) agar tidak perlu join
//                            lewat sensor.
// Trade-off: nama petani terduplikasi di dokumen lahan; bila berubah perlu
// updateMany. Dapat diterima karena beban kerja didominasi baca.
//
// Aljabar relasional (spesifikasi logis pada skema lama):
//   pi nama_petani, nama_lahan, komoditas, waktu_baca, nilai_kelembapan (
//     sigma id_lahan = 1 AND waktu_baca >= '2026-10-27' (
//       ((PEMBACAAN JOIN SENSOR) JOIN LAHAN) JOIN PETANI ) )
// Di MongoDB, 3 join tersebut menjadi 1 $lookup ke koleksi lahan.
//
// Cara menjalankan (login admin_user):
//   load("D:/lokasi/berkas/04_rancangan_migrasi_pjbl.js")
//   migrasi_contoh()      // memuat data contoh dari smart_farming.sql
//   jalankan_query()      // menjalankan query fitur
//   buat_rbac()           // membuat role dan pengguna (meminta password)
//
// CATATAN: tidak ada password di berkas ini.
// =====================================================================

// ---------------------------------------------------------------------
// 1. Migrasi data contoh (dari data pada smart_farming.sql)
// ---------------------------------------------------------------------
function migrasi_contoh() {
  const m = db.getSiblingDB("smart_farming_mongo");
  m.lahan.drop();
  m.pembacaan_kelembapan.drop();

  m.lahan.insertMany([
    { id_lahan: 1, nama_lahan: "Sawah Utara", lokasi: "Madiun, Jawa Timur", luas_m2: 5000, komoditas: "Padi",
      petani: { id_petani: 1, nama_petani: "Slamet Riyadi" },
      sensor_kelembapan: [{ id_sensor_kelembapan: 1, satuan: "%", status_sensor: "AKTIF" }] },
    { id_lahan: 2, nama_lahan: "Kebun Cabai", lokasi: "Madiun, Jawa Timur", luas_m2: 2500, komoditas: "Cabai",
      petani: { id_petani: 1, nama_petani: "Slamet Riyadi" },
      sensor_kelembapan: [{ id_sensor_kelembapan: 2, satuan: "%", status_sensor: "AKTIF" }] },
    { id_lahan: 3, nama_lahan: "Ladang Jagung", lokasi: "Ngawi, Jawa Timur", luas_m2: 8000, komoditas: "Jagung",
      petani: { id_petani: 2, nama_petani: "Rahayu Lestari" },
      sensor_kelembapan: [{ id_sensor_kelembapan: 3, satuan: "%", status_sensor: "NONAKTIF" }] }
  ]);

  // waktu_baca memakai tipe Date (bukan string); id_lahan ditambahkan dari relasi sensor -> lahan
  m.pembacaan_kelembapan.insertMany([
    { id_pembacaan_kelembapan: 1, id_sensor_kelembapan: 1, id_lahan: 1, nilai_kelembapan: 65.5, waktu_baca: ISODate("2026-10-26T06:00:00Z") },
    { id_pembacaan_kelembapan: 2, id_sensor_kelembapan: 2, id_lahan: 2, nilai_kelembapan: 22.0, waktu_baca: ISODate("2026-10-26T06:05:00Z") },
    { id_pembacaan_kelembapan: 3, id_sensor_kelembapan: 1, id_lahan: 1, nilai_kelembapan: 85.3, waktu_baca: ISODate("2026-10-27T06:00:00Z") },
    { id_pembacaan_kelembapan: 4, id_sensor_kelembapan: 2, id_lahan: 2, nilai_kelembapan: 55.0, waktu_baca: ISODate("2026-10-27T06:05:00Z") },
    { id_pembacaan_kelembapan: 5, id_sensor_kelembapan: 1, id_lahan: 1, nilai_kelembapan: 20.0, waktu_baca: ISODate("2026-10-28T06:00:00Z") }
  ]);

  // Optimisasi: index sesuai pola query (satu lahan, rentang waktu)
  m.pembacaan_kelembapan.createIndex({ id_lahan: 1, waktu_baca: -1 });
  m.lahan.createIndex({ id_lahan: 1 }, { unique: true });

  print("lahan: " + m.lahan.countDocuments() + " dokumen (seharusnya 3)");
  print("pembacaan_kelembapan: " + m.pembacaan_kelembapan.countDocuments() + " dokumen (seharusnya 5)");
}

// ---------------------------------------------------------------------
// 2. Query fitur: seleksi dulu ($match) -> 1 join ($lookup) -> proyeksi
// Perkiraan hasil dari data sumber: 2 dokumen (pembacaan 3 dan 5,
// Sawah Utara, Padi, Slamet Riyadi). Ini perkiraan, bukan hasil eksekusi.
// ---------------------------------------------------------------------
function jalankan_query() {
  const m = db.getSiblingDB("smart_farming_mongo");
  printjson(m.pembacaan_kelembapan.aggregate([
    { $match: { id_lahan: 1, waktu_baca: { $gte: ISODate("2026-10-27T00:00:00Z") } } },
    { $lookup: { from: "lahan", localField: "id_lahan", foreignField: "id_lahan", as: "lahan" } },
    { $unwind: "$lahan" },
    { $project: { _id: 0,
                  nama_petani: "$lahan.petani.nama_petani",
                  nama_lahan: "$lahan.nama_lahan",
                  komoditas: "$lahan.komoditas",
                  waktu_baca: 1, nilai_kelembapan: 1 } }
  ]).toArray());
}

// ---------------------------------------------------------------------
// 3. Strategi optimisasi saat data membesar (catatan rancangan)
//  - Index {id_lahan:1, waktu_baca:-1} agar query satu lahan + rentang waktu
//    memakai IXSCAN, bukan COLLSCAN.
//  - Pembacaan sensor tidak dibenamkan ke dokumen lahan (dokumen akan
//    membengkak; contoh asumsi: interval 15 menit = 96 dokumen/hari/sensor).
//  - Opsi lanjutan: Time Series Collection untuk data sensor, serta TTL atau
//    pengarsipan untuk data lama.
//  - Estimasi cost hanya perkiraan sebelum eksekusi; waktu aktual dipengaruhi
//    cache, ukuran data, dan beban server.
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// 4. DCL / RBAC (least privilege) untuk 3 jenis pengguna
//   dashboard_user : hanya membaca
//   iot_gateway    : hanya menambah pembacaan (insert) pada satu koleksi
//   admin_proyek   : readWrite untuk pengelolaan data harian
// ---------------------------------------------------------------------
function buat_rbac() {
  const m = db.getSiblingDB("smart_farming_mongo");

  m.createRole({
    role: "iot_writer",
    roles: [],
    privileges: [{
      resource: { db: "smart_farming_mongo", collection: "pembacaan_kelembapan" },
      actions: ["insert"]
    }]
  });

  m.createUser({ user: "dashboard_user", pwd: passwordPrompt(),
                 roles: [{ role: "read", db: "smart_farming_mongo" }] });
  m.createUser({ user: "iot_gateway", pwd: passwordPrompt(),
                 roles: [{ role: "iot_writer", db: "smart_farming_mongo" }] });
  m.createUser({ user: "admin_proyek", pwd: passwordPrompt(),
                 roles: [{ role: "readWrite", db: "smart_farming_mongo" }] });

  print("Role dan pengguna dibuat. Periksa dengan db.getUsers() pada smart_farming_mongo.");
}
