# Script Auto-Mining Verus (VRSC) untuk Termux

Ini adalah Script *auto-install* yang telah dimodifikasi dan disempurnakan untuk *mining* Verus Coin (VRSC) di perangkat Android menggunakan [Termux](https://termux.dev/en/).

Script ini dirancang untuk "plug and play", mengotomatiskan hampir semua aspek *setup* dan *maintenance* (perawatan).

## ✨ Fitur Utama (Revisi CRON - Sangat Stabil)

Script ini telah dimodifikasi secara besar-besaran untuk stabilitas 24/7, menggantikan komponen Android yang tidak stabil dengan layanan Linux yang kuat.

* **Instalasi Otomatis:** Menginstal semua *package* yang diperlukan (termasuk `cronie`) dan `ccminer`.

* **Deteksi CPU Otomatis (Auto-Threads):** Secara cerdas mendeteksi jumlah *core* CPU Anda dan mengatur jumlah *thread* ke `Total Core - 1` agar HP tidak *freeze* atau *lag* parah.

* **Pengecekan Koneksi Akurat:** Menggunakan `netcat` untuk mengecek apakah *port pool mining* (TCP) benar-benar terbuka sebelum *miner* berjalan.

* **Watchdog Pintar (Anti-Stuck & Anti-Crash) [REVISI BESAR!]**
    Sistem lama (restart "buta" 2 jam) telah **dihapus**. Sistem baru ini "pintar" dan berjalan setiap 15 menit untuk memeriksa:
    1.  **Mendeteksi *Stuck* (Macet):** Memeriksa *timestamp* file `miner.log`. Jika log tidak bergerak (tidak ada *hashrate* atau 'accept' baru) selama 15 menit, ia akan memicu *restart* paksa. Ini adalah solusi untuk masalah *freeze* di Custom ROM/Kernel.
    2.  **Mendeteksi *Crash*:** Memeriksa apakah proses `ccminer` *crash* atau hilang. Jika ya, ia akan langsung memicu *restart*.

* **Scheduler CRONIE (Jauh Lebih Kuat) [REVISI BESAR!]**
    Kami **tidak lagi** menggunakan `termux-job-scheduler` (yang lemah dan sering "dimatikan" oleh sistem Android/ROM). Script ini sekarang menginstal layanan `cronie` (layanan `cron` standar Linux) yang jauh lebih kuat dan berjalan sebagai *service* persisten di latar belakang, memastikan *watchdog* 15 menit Anda *selalu* berjalan.

* **Rotasi Log Mingguan (via CRON):**
    Menjalankan *job* `cron` otomatis setiap hari Minggu untuk mengosongkan file `miner.log`, mencegah penyimpanan internal Anda penuh.

* **Auto-Start Instan & Auto-Boot:**
    *Mining* akan langsung berjalan otomatis setelah instalasi selesai. Script juga akan berjalan otomatis setiap kali Anda membuka Termux atau me-restart HP (via `Termux:Boot`), dan akan langsung mengaktifkan *watchdog* `cron`.

---

## 🎖️ Penghargaan dan Kredit

Script ini adalah modifikasi berat. Script dasarnya yang luar biasa dibuat oleh **NVNT Project.**

Saya (B Σ N / hail-eric) telah menambahkan fitur-fitur di atas untuk stabilitas dan otomatisasi penuh. Dukung kreator aslinya dengan mengunjungi channel YouTube-nya:

Channel YouTube: https://www.youtube.com/@NVNTproject

---

## ⚠️ Catatan Penting: Konfigurasi Pool & Wallet

Script ini secara *default* sudah dikonfigurasi untuk *mining* ke **Vipor Pool**.
* **Pool:** `stratum+tcp://sg.vipor.net:5040`
* **Wallet:** `RGzgAahbK9iLisfRETEVXhGFPU5yaz8qUW.A50-1` (Contoh)

Fitur **Pengecekan Koneksi Akurat** (cek *port*) juga terikat pada alamat `sg.vipor.net` dan *port* `5040`.

**ANDA WAJIB MENGEDIT FILE INI SETELAH INSTALASI** untuk memasukkan alamat *wallet* Anda. Jika Anda menggunakan *pool* yang berbeda, sesuaikan juga alamat *pool* dan *port*-nya.

Gunakan perintah ini untuk mengedit:
`bash
nano ~/ccminer/start.sh`

---

## 🚀 Cara Penggunaan (Instalasi)

Persyaratan Wajib
* **Aplikasi Termux (dari F-Droid atau GitHub).**
* **Aplikasi Termux:API (dari F-Droid atau GitHub).**
* **Aplikasi Termux:Boot (dari F-Droid atau GitHub).**

_Sangat disarankan untuk meng-install aplikasi Termux dari F-Droid, bukan Play Store, karena versi Play Store sudah tidak ter-update dan tidak akan berfungsi dengan benar._

---

## 📌 **Langkah-langkah Instalasi**

**1. Izinkan Termux mengakses penyimpanan Anda. Ketik di Termux:**

Bash
termux-setup-storage
(Lalu pilih "Izinkan" pada pop-up yang muncul)

**2. (PENTING) Aktifkan Wake Lock agar HP tidak sleep saat proses instalasi. Ketik:**

Bash
termux-wake-lock
(Layar HP Anda akan tetap menyala)

**3. Salin file autoinstall.sh dari repositori ini ke penyimpanan internal Anda (misalnya, ke folder /sdcard/Download/).**

**4. Jalankan Script instalasi. (Contoh jika Anda meletakkannya di folder Download):**

bash /sdcard/Download/autoinstall.sh

**5. Proses instalasi akan berjalan (5-10 menit tergantung HP Anda).**

**6. Setelah selesai, mining akan otomatis dimulai dan Anda akan melihat log "accepted" ⚒️.**

---

## 🛠️ Perintah Setelah Instalasi

Setelah instalasi berhasil, Anda bisa menggunakan perintah praktis ini kapan saja di Termux:

* 💵 **Mengedit Wallet/Pool Anda:**

```yaml
Bash
nano ~/ccminer/start.sh
(Ganti alamat wallet RGzg... dengan alamat wallet Anda!)
```

---

* 📊 **Melihat Log Mining Secara Manual:**

```yaml
Bash
tail -f ~/ccminer/miner.log
(Tekan Ctrl + C untuk berhenti melihat)
```

---

* 🖥️ **Melihat Spesifikasi HP Anda:**

```yaml
Bash
spek
```

---

♻️ _**Me-restart Miner Secara Manual: Cukup tutup paksa (force close) Termux dan buka lagi. Script auto-start akan berjalan.**_
