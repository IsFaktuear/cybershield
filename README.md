# CyberShield - Network Security Dashboard

Aplikasi web pemantauan jaringan, manajemen aturan firewall, dan simulasi serangan.
Dibuat untuk UTS Keamanan Jaringan.

## Fitur

1. **Dashboard Monitoring** - total paket diperiksa, koneksi diizinkan, ancaman diblokir, aturan firewall aktif, grafik traffic waktu nyata, port paling sering diblokir, dan peringatan keamanan terkini.
2. **Manajemen Aturan Firewall** - tambah aturan (IP/CIDR, port, protokol, izinkan/blokir), aktifkan/nonaktifkan, dan hapus aturan.
3. **Simulasi Traffic & Serangan** - traffic jaringan disimulasikan tiap detik, tombol simulasi serangan, dan tombol uji koneksi diizinkan/diblokir.
4. **Log Keamanan** - mencatat waktu, IP sumber, port tujuan, jenis aktivitas, dan tindakan sistem, lengkap dengan filter dan pencarian.
5. **Blacklist IP** - tambah dan hapus IP dari daftar blokir.

## Cara Menjalankan

Buka `index.html` di browser (cukup klik dua kali, atau jalankan lewat server lokal).
Tidak butuh instalasi. Data aturan, log, dan blacklist tersimpan otomatis di browser (localStorage).

## Database

`database.sql` berisi skema MySQL untuk 3 tabel: `firewall_rules`, `security_logs`, dan `blacklist_ips`, beserta data awal.
Import lewat phpMyAdmin (tab Import) atau terminal:

```
mysql -u root -p < database.sql
```

## Tema

Tampilan minimalis: gelap, datar, satu warna aksen teal, tanpa ornamen.

## Demo

https://isfaktuear.github.io/cybershield/
