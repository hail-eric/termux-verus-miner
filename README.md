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
`bash
nano ~/ccminer/start.sh`

🚀 Cara Penggunaan (Instalasi)

Persyaratan Wajib
* Aplikasi Termux (dari F-Droid atau GitHub).
* Aplikasi Termux:API (dari F-Droid atau GitHub).
* Aplikasi Termux:Boot (dari F-Droid atau GitHub).

Sangat disarankan untuk meng-install aplikasi Termux dari F-Droid, bukan Play Store, karena versi Play Store sudah tidak ter-update dan tidak akan berfungsi dengan benar.

**Langkah-langkah Instalasi
**

**1. Izinkan Termux mengakses penyimpanan Anda. Ketik di Termux:**

Bash
termux-setup-storage
(Lalu pilih "Izinkan" pada pop-up yang muncul)

**2. (PENTING) Aktifkan Wake Lock agar HP tidak sleep saat proses instalasi. Ketik:**

Bash
termux-wake-lock
(Layar HP Anda akan tetap menyala)

**3. Salin file autoinstall.sh dari repositori ini ke penyimpanan internal Anda (misalnya, ke folder /sdcard/Download/).**

**4. Jalankan skrip instalasi. (Contoh jika Anda meletakkannya di folder Download):**

bash /sdcard/Download/autoinstall.sh

**5. Proses instalasi akan berjalan (5-10 menit tergantung HP Anda).**

**6. Setelah selesai, mining akan otomatis dimulai dan Anda akan melihat log "accepted" ⚒️.**

🛠️ Perintah Setelah Instalasi

Setelah instalasi berhasil, Anda bisa menggunakan perintah praktis ini kapan saja di Termux:

* Mengedit Wallet/Pool Anda:

Bash
nano ~/ccminer/start.sh
(Ganti alamat wallet RGzg... dengan alamat wallet Anda!)

---

* Melihat Log Mining Secara Manual:

Bash
tail -f ~/ccminer/miner.log
(Tekan Ctrl + C untuk berhenti melihat)

---

* Melihat Spesifikasi HP Anda:

Bash
spek

---

**Me-restart Miner Secara Manual: Cukup tutup paksa (force close) Termux dan buka lagi. Skrip auto-start akan berjalan.**
