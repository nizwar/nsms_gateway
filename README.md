# NSMS Flutter Gateway
Sms gateway sederhana, buat yang males nyewa layanan dan maunya punya sistem sendiri.
Aplikasi ini menggunakan media Onesignal untuk sebagai perantara Android dengan Backend API.

## Setup
* Buat akun Onesignal
* Buat aplikasi baru di Onesignal
* Ambil `APPID` dan `AUTHKEY` lalu terapkan pada TODO comment yg ada di project ini
* Salin smsGateaway.php yang ada di folder Backend, lalu salin ke directory server anda, misal (/xampp/htdoc).
* Jalankan aplikasi.

## Cara kerja
* Saat melakukan POST Request smsGateaway.php dengan {"nohp":"no_hp_target", "message":"pesan_untuk_target"}.
* Itu akan mengirimkan request ke onesignal untuk mengirim notif ke aplikasi yang sudah dijalankan [Baca Dokumentasi](https://documentation.onesignal.com/reference#create-notification)
* Setelah menerima notif dengan data yang dibutuhkan, aplikasi otomatis akan mengirim pesan ketarget.
* Pastikan ada pulsa :).

# Referensi
[Onesignal Flutter DOC](https://documentation.onesignal.com/docs/flutter-sdk-setup)
