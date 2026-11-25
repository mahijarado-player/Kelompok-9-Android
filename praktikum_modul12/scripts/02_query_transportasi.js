// =====================================================================
// 02_query_transportasi.js
// Praktikum Modul 12 - Konsep Pemrosesan Query Basis Data
//
// CATATAN: nama berkas mengikuti ketentuan modul ("query_transportasi"),
// tetapi kasus yang dikerjakan adalah proyek smart_farming
// (pembacaan_kelembapan = padanan TRIPS, sensor_kelembapan = padanan ROUTES).
//
// Kebutuhan informasi:
//   Tampilkan id_pembacaan_kelembapan, waktu_baca, nilai_kelembapan, dan
//   satuan untuk sensor kelembapan 1 sejak 27 Oktober 2026.
//
// Aljabar relasional:
//   pi id_pembacaan_kelembapan, waktu_baca, nilai_kelembapan, satuan (
//     sigma id_sensor_kelembapan = 1 AND waktu_baca >= '2026-10-27' (
//       PEMBACAAN_KELEMBAPAN JOIN SENSOR_KELEMBAPAN
//         ON PEMBACAAN_KELEMBAPAN.id_sensor_kelembapan = SENSOR_KELEMBAPAN.id_sensor_kelembapan ) )
//
// Hasil yang diharapkan dari data sumber: 2 dokumen (pembacaan 3 dan 5).
//
// Prasyarat: jalankan 01_migrasi_data_latihan.js lebih dulu.
// =====================================================================

db = db.getSiblingDB("smart_farming");

// ---------------------------------------------------------------------
// Bagian A: query utama (seleksi dulu -> join -> proyeksi)
// ---------------------------------------------------------------------
print("=== Hasil query ===");
printjson(db.pembacaan_kelembapan.aggregate([
  { $match: { id_sensor_kelembapan: 1, waktu_baca: { $gte: "2026-10-27" } } },   // sigma
  { $lookup: { from: "sensor_kelembapan", localField: "id_sensor_kelembapan",
               foreignField: "id_sensor_kelembapan", as: "sensor" } },            // join
  { $unwind: "$sensor" },
  { $project: { _id: 0, id_pembacaan_kelembapan: 1, waktu_baca: 1,
                nilai_kelembapan: 1, satuan: "$sensor.satuan" } }                 // pi
]).toArray());

// ---------------------------------------------------------------------
// Bagian B: inspeksi execution plan, SEBELUM dan SESUDAH index
// Yang dicatat untuk laporan: stage, nReturned, totalKeysExamined,
// totalDocsExamined, executionTimeMillis (tulis angka dari layar sendiri).
// ---------------------------------------------------------------------
const filter = { id_sensor_kelembapan: 1, waktu_baca: { $gte: "2026-10-27" } };
const namaIndex = "id_sensor_kelembapan_1_waktu_baca_1";

function ringkasPlan(label) {
  const e = db.pembacaan_kelembapan.find(filter).explain("executionStats");
  const w = e.queryPlanner.winningPlan;
  const stage = w.inputStage ? (w.stage + " > " + w.inputStage.stage) : w.stage;
  const s = e.executionStats;
  print("--- " + label + " ---");
  print("stage              : " + stage);
  print("nReturned          : " + s.nReturned);
  print("totalKeysExamined  : " + s.totalKeysExamined);
  print("totalDocsExamined  : " + s.totalDocsExamined);
  print("executionTimeMillis: " + s.executionTimeMillis);
}

// Pastikan index belum ada (agar kondisi "sebelum" benar)
try { db.pembacaan_kelembapan.dropIndex(namaIndex); } catch (err) { /* belum ada */ }
ringkasPlan("SEBELUM index");

// Buat index (padanan idx_pk_waktu pada SQL)
db.pembacaan_kelembapan.createIndex({ id_sensor_kelembapan: 1, waktu_baca: 1 });
ringkasPlan("SESUDAH index");

// ---------------------------------------------------------------------
// Bagian C: perhitungan estimasi query cost (simulasi teoretis, bukan benchmark)
// Parameter modul: pembacaan 20.000 item = 400 page; sensor 100 item = 5 page;
// selektivitas 5%; buffer 10 page.
//   Item lolos seleksi        = 5% x 20.000          = 1.000 item
//   Full scan pembacaan       = 400 page
//   Full scan sensor          = 5 page
//   Total baca kedua relasi   = 405 page
//   Rencana 1 (join dulu)     : hasil antara ~400 page -> ~405 + 800 = ~1.205 page I/O
//   Rencana 2 (seleksi dulu)  : hasil antara ~20 page  -> ~405 + 40  = ~445 page I/O
// Asumsi: tidak ada index, lebar baris hasil join sama dengan baris pembacaan,
// hasil antara dimaterialisasi (tulis + baca ulang) karena buffer 10 page tidak muat.
// ---------------------------------------------------------------------
