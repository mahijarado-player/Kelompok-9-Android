// =====================================================================
// 03_pengujian_dcl.js
// Praktikum Modul 12 - Kontrol Akses (DCL / RBAC) dan Least Privilege
//
// DBMS target: MongoDB. Padanan perintah SQL:
//   CREATE USER ... GRANT SELECT  -> db.createUser({ roles: [{ role: "read" }] })
//   SHOW GRANTS                   -> db.getUser("report_user")
//   REVOKE SELECT                 -> db.revokeRolesFromUser(...)
//
// Skrip dibagi 4 fungsi karena pengujian harus dijalankan oleh akun yang
// berbeda (admin_user dan report_user). Tidak ada yang berjalan otomatis.
//
// ALUR PENGUJIAN
//   Sesi 1 - login admin_user:
//       mongosh "mongodb://admin_user@localhost/?authSource=admin"
//       load("D:/lokasi/berkas/03_pengujian_dcl.js")
//       bagian1_admin_buat_dan_periksa()
//   Sesi 2 - login report_user (terminal/jendela baru):
//       mongosh "mongodb://report_user@localhost/smart_farming"
//       load("D:/lokasi/berkas/03_pengujian_dcl.js")
//       bagian2_report_user_uji_hak()
//   Sesi 1 - kembali ke admin_user:
//       bagian3_admin_revoke()
//   Sesi 2 - login ulang report_user:
//       bagian4_report_user_setelah_revoke()
//
// CATATAN: password diminta lewat passwordPrompt() (tidak tampil di layar).
// Jangan menulis password asli di berkas ini maupun di repositori Git.
// =====================================================================

// Bagian 1 (ADMIN): buat report_user dengan hak baca saja + periksa hak
function bagian1_admin_buat_dan_periksa() {
  const sf = db.getSiblingDB("smart_farming");
  if (sf.getUser("report_user") === null) {
    sf.createUser({
      user: "report_user",
      pwd: passwordPrompt(),                                  // placeholder: isi saat diminta
      roles: [{ role: "read", db: "smart_farming" }]          // least privilege: hanya baca
    });
    print("report_user dibuat.");
  } else {
    print("report_user sudah ada.");
  }
  print("--- Pemeriksaan hak (setara SHOW GRANTS) ---");
  printjson(sf.getUser("report_user"));   // harus memuat role "read" pada smart_farming
}

// Bagian 2 (REPORT_USER): uji operasi yang diizinkan dan yang ditolak
function bagian2_report_user_uji_hak() {
  const sf = db.getSiblingDB("smart_farming");

  print("--- Uji 1: baca (diharapkan BERHASIL, 5 dokumen) ---");
  try {
    const hasil = sf.pembacaan_kelembapan.find().toArray();
    print("Berhasil membaca " + hasil.length + " dokumen.");
  } catch (err) {
    print("GAGAL (tidak diharapkan): " + err.message);
  }

  print("--- Uji 2: deleteOne (diharapkan DITOLAK) ---");
  try {
    // id 999 tidak ada, sehingga data aman andaikan hak terlanjur terbuka
    sf.pembacaan_kelembapan.deleteOne({ id_pembacaan_kelembapan: 999 });
    print("PERINGATAN: delete lolos - hak akses terlalu besar!");
  } catch (err) {
    print("DITOLAK (sesuai harapan): " + err.message);
  }
}

// Bagian 3 (ADMIN): cabut hak baca dan periksa ulang
function bagian3_admin_revoke() {
  const sf = db.getSiblingDB("smart_farming");
  printjson(sf.revokeRolesFromUser("report_user", [{ role: "read", db: "smart_farming" }]));
  print("--- Pemeriksaan hak setelah REVOKE (roles harus kosong) ---");
  printjson(sf.getUser("report_user"));
}

// Bagian 4 (REPORT_USER, login ulang): baca setelah hak dicabut
function bagian4_report_user_setelah_revoke() {
  const sf = db.getSiblingDB("smart_farming");
  print("--- Uji 3: baca setelah REVOKE (diharapkan DITOLAK) ---");
  try {
    sf.pembacaan_kelembapan.find().toArray();
    print("PERINGATAN: baca masih lolos setelah revoke!");
  } catch (err) {
    print("DITOLAK (sesuai harapan): " + err.message);
  }
}

// Opsional (ADMIN): kembalikan hak baca setelah pengujian selesai
function opsional_admin_kembalikan_hak() {
  const sf = db.getSiblingDB("smart_farming");
  sf.grantRolesToUser("report_user", [{ role: "read", db: "smart_farming" }]);
  print("Hak baca report_user dikembalikan.");
}
