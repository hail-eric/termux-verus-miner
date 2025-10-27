# Skrip Auto-Mining Verus (VRSC) untuk Termux

Ini adalah skrip *auto-install* yang telah dimodifikasi dan disempurnakan untuk *mining* Verus Coin (VRSC) di perangkat Android menggunakan [Termux](https://termux.dev/en/).

Skrip ini dirancang untuk "plug and play", mengotomatiskan hampir semua aspek *setup* dan *maintenance* (perawatan).

## ✨ Fitur Utama

Skrip ini menambahkan banyak fitur penting di atas fungsionalitas dasarnya:

* **Instalasi Otomatis:** Menginstal semua *package* yang diperlukan dan meng-kompilasi `ccminer`.
* **Deteksi CPU Otomatis (Auto-Threads):** Secara cerdas mendeteksi jumlah *core* CPU Anda dan mengatur jumlah *thread* ke `Total Core - 1` agar HP tidak *freeze* atau *lag* parah.
* **Pengecekan Koneksi Akurat:** Menggunakan `netcat` untuk mengecek apakah *port pool mining* (TCP) benar-benar terbuka sebelum *miner* berjalan. Jika *pool* *down* atau internet mati, skrip akan menunggu dan mencoba lagi.
* **Watchdog (Anti-Stuck):** Menggunakan `termux-job-scheduler` untuk me-restart *miner* secara otomatis setiap **2 jam**. Ini adalah solusi untuk masalah umum di mana *miner* *freeze*/*stuck* setelah berjalan lama.
* **Rotasi Log Mingguan:** Menjalankan *job* pembersihan otomatis setiap **1 minggu** untuk mengosongkan file `miner.log`, mencegah penyimpanan internal Anda penuh oleh *log* yang menumpuk berbulan-bulan.
* **Personalisasi:** Skrip *booting* menyertakan *header* kustom (dengan dukungan emoji ⚒️).
* **Auto-Start Instan:** *Mining* akan langsung berjalan otomatis setelah instalasi selesai, Anda tidak perlu me-restart Termux.

---

## 🎖️ Penghargaan dan Kredit

Skrip ini adalah modifikasi. Skrip dasarnya yang luar biasa dibuat oleh **NVNT Project**.

Saya (B Σ N) telah menambahkan fitur-fitur di atas untuk stabilitas dan otomatisasi. Dukung kreator aslinya dengan mengunjungi channel YouTube-nya:

* **Channel YouTube:** **[https://www.youtube.com/@NVNTproject](https://www.youtube.com/@NVNTproject)**

---

## ⚠️ Catatan Penting: Konfigurasi Pool & Wallet

Skrip ini secara *default* sudah dikonfigurasi untuk *mining* ke **Vipor Pool**.
* **Pool:** `stratum+tcp://sg.vipor.net:5040`
* **Wallet:** `RGzgAahbK9iLisfRETEVXhGFPU5yaz8qUW.A50-1` (Contoh)

Fitur **Pengecekan Koneksi Akurat** (cek *port*) juga terikat pada alamat `sg.vipor.net` dan *port* `5040`.

**ANDA WAJIB MENGEDIT FILE INI SETELAH INSTALASI** untuk memasukkan alamat *wallet* Anda. Jika Anda menggunakan *pool* yang berbeda, sesuaikan juga alamat *pool* dan *port*-nya.

Gunakan perintah ini untuk mengedit:
```bash
nano ~/ccminer/start.sh