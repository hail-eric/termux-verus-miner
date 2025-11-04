#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock
echo -e "\e[1;33m--[AUTO MINING VERUS ANDROID 5, 6, 7+, 32 & 64 Bit]--\e[0m"
sleep 2
echo -e "\e[1;33m[INFO] Memulai Auto Install\e[0m"
echo -e "\e[1;33mPastikan Termux tetap terbuka sampai instalasi selesai\e[0m"
sleep 2

echo""
echo -e "\e[1;33m[SCAN] Deteksi device sebelum pasang ccminer.\e[0m"
sleep 2

BRAND=$(getprop ro.product.brand)
DEVICE_NAME=$(getprop ro.product.model)
DEVICE_CODE=$(getprop ro.product.device)
CPU_PART=$(grep -m1 'CPU part' /proc/cpuinfo | awk '{print $4}')
ARCH=$(uname -m)
OS_BITS=$(getprop ro.product.cpu.abi | grep -q '64' && echo "64-bit" || echo "32-bit")
ANDROID_VER=$(getprop ro.build.version.release | cut -d'.' -f1)
CHIPSET=$(getprop ro.board.platform)

if [ -d /sys/devices/system/cpu ]; then
    CPU_CORES=$(ls -d /sys/devices/system/cpu/cpu[0-9]* 2>/dev/null | wc -l)
else
    CPU_CORES=$(grep -c '^processor' /proc/cpuinfo)
fi

RAM_MB=$(grep -m1 'MemTotal' /proc/meminfo | awk '{print int($2/1024)}')

if [ $RAM_MB -le 768 ]; then
  RAM_GB="0.5"
elif [ $RAM_MB -le 1536 ]; then
  RAM_GB=1
elif [ $RAM_MB -le 2560 ]; then
  RAM_GB=2
elif [ $RAM_MB -le 3072 ]; then
  RAM_GB=3
elif [ $RAM_MB -le 4096 ]; then
  RAM_GB=4
elif [ $RAM_MB -le 6144 ]; then
  RAM_GB=6
elif [ $RAM_MB -le 8192 ]; then
  RAM_GB=8
elif [ $RAM_MB -le 12288 ]; then
  RAM_GB=12
elif [ $RAM_MB -le 16384 ]; then
  RAM_GB=16
elif [ $RAM_MB -le 32768 ]; then
  RAM_GB=32
elif [ $RAM_MB -le 65536 ]; then
  RAM_GB=64
elif [ $RAM_MB -le 131072 ]; then
  RAM_GB=128
else
  RAM_GB=$(echo "($RAM_MB/1024+0.5)/1" | bc)
fi

LINE="=============================================="
echo -e "\e[1;34m$LINE\e[0m"
echo -e "Brand           : \e[1;32m$BRAND\e[0m"
echo -e "Device          : \e[1;32m$DEVICE_NAME / $DEVICE_CODE\e[0m"
echo -e "Chipset         : \e[1;32m$CHIPSET\e[0m"
echo -e "Arsitektur      : \e[1;32m$ARCH\e[0m"
echo -e "CPU Part        : \e[1;32m$CPU_PART\e[0m"
echo -e "CPU Core/Thread : \e[1;32m$CPU_CORES Cores/Threads\e[0m"
echo -e "RAM Total       : \e[1;32m$RAM_GB GB\e[0m"
echo -e "OS / ROM        : \e[1;32m$OS_BITS\e[0m"
echo -e "Android         : \e[1;32m$ANDROID_VER\e[0m"
echo -e "\e[1;34m$LINE\e[0m"
echo ""
sleep 2

echo ""
msg1="\e[1;33mScript by \e[36mNV\e[31mNT \e[37mProject\e[0m"

for i in {1..5}; do
  echo -ne "\r$msg1 $(printf ' %.0s.' $(seq 1 $i))"
  sleep 1
done
echo -e "\n"

echo""

# --- REVISI CRON: Menambahkan termux-services dan cronie ---
pkg update -y && yes | pkg upgrade -y
pkg install clang make automake autoconf libtool pkg-config binutils build-essential -y
pkg install libcurl openssl-tool libjansson -y
pkg install wget git nano termux-api curl tar unzip file netcat-openbsd -y
pkg install termux-services cronie -y
# --- Akhir Revisi CRON ---

if [ "$OS_BITS" = "32-bit" ]; then
    echo -e "\e[1;33m[INFO] Device 32-bit, memasang ccminer yang sudah di patch, silahkan tunggu\e[0m"
    sleep 5

    cd ~
    rm -rf jansson
    git clone https://github.com/akheron/jansson.git 2>/dev/null || true
    cd jansson
    autoreconf -i
    ./configure --prefix=$PREFIX --disable-shared --enable-static
    make -j$(nproc) 2>/dev/null || true
    make install 2>/dev/null || true
    cd ~

    rm -rf ccminer
    git clone https://github.com/monkins1010/ccminer.git ccminer 2>/dev/null || true
    cd ccminer

    if [ ! -f "./sse2neon/sse2neon.h" ]; then
      git clone https://github.com/DLTcollab/sse2neon.git tmp_sse2 2>/dev/null || true
      mkdir -p sse2neon
      cp tmp_sse2/sse2neon.h ./sse2neon/
      rm -rf tmp_sse2
    fi

    cp verus/haraka.h verus/haraka.h.bak
    cp verus/verus_clhash.h verus/verus_clhash.h.bak
    sed -i '1i #include <arm_neon.h>\n#ifndef __m128i\n#define __m128i int64x2_t\n#endif\n' verus/haraka.h
    sed -i '1i #include <arm_neon.h>\n#ifndef __m128i\n#define __m128i int64x2_t\n#endif\n' verus/verus_clhash.h
    grep -q "typedef __m128i u128;" verus/haraka.h || echo "typedef __m128i u128;" >> verus/haraka.h
    grep -q "typedef __m128i u128;" verus/verus_clhash.h || echo "typedef __m128i u128;" >> verus/verus_clhash.h

    cp verus/verus_clhash.cpp verus/verus_clhash.cpp.bak
    sed -i 's|const __m128i pbuf_copy.*|const __m128i b0=_mm_loadu_si128((const __m128i*)((const unsigned char*)buf+0)); const __m128i b1=_mm_loadu_si128((const __m128i*)((const unsigned char*)buf+16)); const __m128i b2=_mm_loadu_si128((const __m128i*)((const unsigned char*)buf+32)); const __m128i b3=_mm_loadu_si128((const __m128i*)((const unsigned char*)buf+48)); const __m128i pbuf_copy[4] = { _mm_xor_si128(b0,b2), _mm_xor_si128(b1,b3), b2, b3 };|' verus/verus_clhash.cpp
    grep -q "VRSC_LOADU" verus/verus_clhash.cpp || \
    sed -i '1i #ifndef VRSC_LOADU\n#define VRSC_LOADU(p) _mm_loadu_si128((const __m128i*)(p))\n#endif\n' verus/verus_clhash.cpp

    make clean || true
    ./configure CXXFLAGS="-O2 -march=armv7-a -mfpu=neon -mfloat-abi=softfp -DNOASM -DNO_WARN_X86_INTRINSICS -DVRSC_NO_SIMD -DVRSC_PORTABLE -DNO_AES -DNO_SSL_AES" \
                CFLAGS="-O2 -march=armv7-a -mfpu=neon -mfloat-abi=softfp -DNOASM -DNO_WARN_X86_INTRINSICS -DVRSC_NO_SIMD -DVRSC_PORTABLE -DNO_AES -DNO_SSL_AES" \
                LIBS="-ljansson -lcurl -lssl -lcrypto -lpthread"
    chmod +x build.sh
    ./build.sh || make -j2 2>/dev/null || true

else
    echo -e "\e[1;33m[INFO] Device 64-bit, memasang ccminer, silahkan tunggu\e[0m"
    sleep 5
    cd ~
    rm -rf ~/ccminer
    mkdir -p ~/ccminer && cd ~/ccminer
    wget -O ccminer https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer 2>/dev/null || true
    chmod +x ccminer 2>/dev/null || true

    if [ ! -f ~/ccminer/ccminer ] || ! ~/ccminer/ccminer --help >/dev/null 2>&1; then
      cd ~
      rm -rf ~/ccminer
      wget https://raw.githubusercontent.com/TheRetroMike/VerusCliMining/main/termux_install.sh -O termux_install.sh 2>/dev/null || true
      chmod +x termux_install.sh 2>/dev/null || true
      (bash ~/termux_install.sh) 2>/dev/null || true
    fi
fi

if [ ! -f ~/ccminer/ccminer ] || ! ~/ccminer/ccminer --help >/dev/null 2>&1; then
    echo -e "\e[1;31m[ERROR] Tes ccminer gagal. Menghapus folder...\e[0m"
    rm -rf ~/ccminer
    echo -e "\e[1;31m[ERROR] Tidak ada ccminer terpasang.\e[0m"
    echo -e "\e[1;33mDevice anda belum bisa digunakan untuk mining.\e[0m"
    exit 1
else
    echo -e "\e[1;32m[SUKSES] ccminer berhasil terpasang\e[0m"
fi

cat > ~/delete.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

rm -f ~/.termux/boot/*.sh 2>/dev/null
find ~/ -maxdepth 1 -type f -name "*.sh" ! -path "~/ccminer/*" -exec rm -f {} \;

EOF

chmod +x ~/delete.sh
bash ~/delete.sh

mkdir -p ~/ccminer

cat > ~/ccminer/start.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/ccminer

# --- [REVISI 1] Script Header Anda ---
clear
echo "============================================"
echo "⚒️ Script Auto Mining Edited by • B Σ N • ⚒️"
echo "🕐 Started at: $(date '+%Y-%m-%d %H:%M:%S') 🕐"
echo "============================================"
termux-wake-lock
# --- Akhir Revisi 1 ---

# --- [REVISI 2.1] Script Pengecekan Port Pool (Lebih Akurat) ---
POOL_ADDRESS="sg.vipor.net"
POOL_PORT="5040"

echo "[*] Checking connection to $POOL_ADDRESS:$POOL_PORT..."

# Kita gunakan 'nc' (netcat) untuk cek port TCP, bukan ping (ICMP)
# -z = Zero-I/O mode (hanya scan)
# -w 5 = Timeout 5 detik
until nc -z -w 5 $POOL_ADDRESS $POOL_PORT &>/dev/null; do
  echo "[-] Pool $POOL_ADDRESS:$POOL_PORT unreachable. Retrying in 10s..."
  sleep 10
done

echo "[+] Connection to pool OK. Starting Miner ⚒️"
# --- Akhir Revisi 2.1 ---

# --- [REVISI 4] Fitur Auto-Threads ---
# Deteksi jumlah total core CPU
CPU_CORES=$(grep -c '^processor' /proc/cpuinfo)

# Set thread ke Total Core - 1 (pengaturan default sisakan 1 core untuk sistem)
# Jika core hanya 1, tetap gunakan 1.
if [ "$CPU_CORES" -gt 1 ]; then
  MINER_THREADS=$((CPU_CORES - 1))
else
  MINER_THREADS=1
fi

echo "[*] CPU Cores detected: $CPU_CORES"
echo "[*] Starting miner with: $MINER_THREADS Threads"
# --- Akhir Revisi 4 ---


# Perintah Miner (Menggunakan $MINER_THREADS)
nohup ./ccminer -a verus -o stratum+tcp://sg.vipor.net:5040 \
  -u RGzgAahbK9iLisfRETEVXhGFPU5yaz8qUW.A50-1 \
  -p x \
  --threads $MINER_THREADS \
  --cpu-priority 1 \
  --cpu-affinity -1 \
  --retry-pause 10 \
  --api-allow 192.168.0.0/16 \
  --api-bind 0.0.0.0:4068 > miner.log 2>&1 &
EOF

chmod +x ~/ccminer/start.sh

# --- [REVISI 5] Buat Skrip Log Rotator ---
echo "[+] Membuat skrip log rotator..."
cat > ~/ccminer/log_rotator.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
# Mengosongkan file log dengan cara menimpanya dengan pesan ini
echo "[$(date)] Log rotator: Berhasil mengosongkan log." > ~/ccminer/miner.log
EOF

chmod +x ~/ccminer/log_rotator.sh
# --- Akhir RevisI 5 ---

# --- [REVISI 6 - VERSI CRON] Buat Skrip "Reset Total" (restart-miner.sh) ---
# Skrip ini disederhanakan. Tugasnya HANYA me-restart miner.
# Pendaftaran watchdog tidak lagi di sini, karena CRON adalah layanan terpisah.
echo "[+] Membuat skrip Reset Total (restart-miner.sh) versi CRON..."
cat > ~/restart-miner.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# Beri log bahwa restart total sedang terjadi
echo "[$(date)] Reset Total (dipicu oleh check_miner): Merestart miner..." >> $HOME/ccminer/watchdog_log.txt

# 1. Hentikan semua proses ccminer
pkill -f ccminer
sleep 1
pkill -9 -f ccminer # Paksa mati
sleep 2

# 3. Mulai ulang miner (panggil start.sh)
bash $HOME/ccminer/start.sh
EOF

chmod +x ~/restart-miner.sh
# --- Akhir Revisi 6 ---

# --- [REVISI 7] Buat Skrip "Pendeteksi Macet" (check_miner.sh) ---
# Skrip ini SEMPURNA, tidak perlu diubah.
echo "[+] Membuat skrip Pendeteksi Macet (check_miner.sh)..."
cat > ~/ccminer/check_miner.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

LOG_FILE="$HOME/ccminer/miner.log"
RESTART_SCRIPT="$HOME/restart-miner.sh"
# Batas waktu macet (15 menit = 900 detik)
MAX_STUCK_TIME=900

# 1. Cek jika proses ccminer CRASH (tidak ada)
if ! pgrep -f "ccminer" > /dev/null; then
    echo "[$(date)] Check: ccminer CRASH. Merestart..." >> $HOME/ccminer/watchdog_log.txt
    bash "$RESTART_SCRIPT"
    exit 0
fi

# 2. Cek jika proses STUCK (log tidak update)
if [ -f "$LOG_FILE" ]; then
    NOW=$(date +%s)
    LAST_MOD=$(stat -c %Y "$LOG_FILE")
    AGE=$((NOW - LAST_MOD))

    if [ $AGE -gt $MAX_STUCK_TIME ]; then
        echo "[$(date)] Check: Log macet ($AGE det). Merestart..." >> $HOME/ccminer/watchdog_log.txt
        bash "$RESTART_SCRIPT"
    fi
fi
EOF

chmod +x ~/ccminer/check_miner.sh
# --- Akhir Revisi 7 ---

# --- REVISI CRON: Modifikasi auto_boot_mining.sh ---
# Skrip ini sekarang HARUS memanggil restart-miner.sh
# Dan juga memastikan layanan CRON berjalan (meskipun seharusnya sudah otomatis)
mkdir -p ~/.termux/boot
cat > ~/.termux/boot/auto_boot_mining.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
termux-wake-lock

# 1. Pastikan layanan CRON (watchdog kita) berjalan
sv up cronie

# 2. Panggil skrip restart total
bash ~/restart-miner.sh
sleep 5
am start -n com.termux/.app.TermuxActivity
EOF

chmod +x ~/.termux/boot/auto_boot_mining.sh
# --- Akhir Revisi CRON ---

mkdir -p $PREFIX/bin
cat > $PREFIX/bin/setting <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
nano ~/ccminer/start.sh
EOF

chmod +x $PREFIX/bin/setting

mkdir -p $PREFIX/bin
cat > $PREFIX/bin/spek <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

BRAND=$(getprop ro.product.brand)
DEVICE_NAME=$(getprop ro.product.model)
DEVICE_CODE=$(getprop ro.product.device)
CPU_PART=$(grep -m1 'CPU part' /proc/cpuinfo | awk '{print $4}')
ARCH=$(uname -m)
OS_BITS=$(getprop ro.product.cpu.abi | grep -q '64' && echo "64-bit" || echo "32-bit")
ANDROID_VER=$(getprop ro.build.version.release | cut -d'.' -f1)
CHIPSET=$(getprop ro.board.platform)

if [ -d /sys/devices/system/cpu ]; then
    CPU_CORES=$(ls -d /sys/devices/system/cpu/cpu[0-9]* 2>/dev/null | wc -l)
else
    CPU_CORES=$(grep -c '^processor' /proc/cpuinfo)
fi

RAM_MB=$(grep -m1 'MemTotal' /proc/meminfo | awk '{print int($2/1024)}')

if [ $RAM_MB -le 768 ]; then
  RAM_GB="0.5"
elif [ $RAM_MB -le 1536 ]; then
  RAM_GB=1
elif [ $RAM_MB -le 2560 ]; then
  RAM_GB=2
elif [ $RAM_MB -le 3072 ]; then
  RAM_GB=3
elif [ $RAM_MB -le 4096 ]; then
  RAM_GB=4
elif [ $RAM_MB -le 6144 ]; then
  RAM_GB=6
elif [ $RAM_MB -le 8192 ]; then
  RAM_GB=8
elif [ $RAM_MB -le 12288 ]; then
  RAM_GB=12
elif [ $RAM_MB -le 16384 ]; then
  RAM_GB=16
elif [ $RAM_MB -le 32768 ]; then
  RAM_GB=32
elif [ $RAM_MB -le 65536 ]; then
  RAM_GB=64
elif [ $RAM_MB -le 131072 ]; then
  RAM_GB=128
else
  RAM_GB=$(echo "($RAM_MB/1024+0.5)/1" | bc)
fi

LINE="=============================================="
echo -e "\e[1;34m$LINE\e[0m"
echo -e "Brand           : \e[1;32m$BRAND\e[0m"
echo -e "Device          : \e[1;32m$DEVICE_NAME / $DEVICE_CODE\e[0m"
echo -e "Chipset         : \e[1;32m$CHIPSET\e[0m"
echo -e "Arsitektur      : \e[1;32m$ARCH\e[0m"
echo -e "CPU Part        : \e[1;32m$CPU_PART\e[0m"
echo -e "CPU Core/Thread : \e[1;32m$CPU_CORES Cores/Threads\e[0m"
echo -e "RAM Total       : \e[1;32m$RAM_GB GB\e[0m"
echo -e "OS / ROM        : \e[1;32m$OS_BITS\e[0m"
echo -e "Android         : \e[1;32m$ANDROID_VER\e[0m"
echo -e "\e[1;34m$LINE\e[0m"
echo ""
EOF

chmod +x $PREFIX/bin/spek

# --- REVISI CRON: Modifikasi bash.bashrc ---
# Logika ini juga harus memanggil restart-miner.sh dan memastikan CRON berjalan
if ! grep -q "AUTO MINING VERUS" $PREFIX/etc/bash.bashrc; then
cat >> $PREFIX/etc/bash.bashrc <<'EOF'

# ========== AUTO MINING VERUS ==========
echo ""
msg1="\e[36mNV\e[31mNT \e[37mProject\e[0m"

for i in {1..5}; do
  echo -ne "\r$msg1 $(printf ' %.0s.' $(seq 1 $i))"
  sleep 1
done
echo -e "\n"
echo "[$(date)] [AUTOMINING] Memulai/Merestart Sesi Mining..."

# 1. Pastikan layanan CRON (watchdog kita) berjalan
sv up cronie

# 2. Panggil skrip restart total
bash ~/restart-miner.sh
sleep 3
tail -f ~/ccminer/miner.log
# =======================================
EOF
fi
# --- Akhir Revisi CRON ---

echo ""
for i in {1..5}; do
  echo -ne "\r$msg1 $(printf ' %.0s.' $(seq 1 $i))"
  sleep 1
done
echo -e "\n"

echo -e "\n"

# --- [REVISI BARU - PENGGANTI TOTAL] Pengaturan CRON Scheduler ---
echo ""
echo -e "\e[1;33m[+] Mengaktifkan service CRON (pengganti job-scheduler)..."
# Mengaktifkan service agar otomatis berjalan saat Termux dibuka
sv-enable cronie
sleep 2

# Hentikan cronie dulu agar bisa mendaftarkan job
echo "[+] Mendaftarkan job ke CRON..."
sv down cronie 2>/dev/null
sleep 1

# Tulis crontab baru. Ini akan MENIMPA crontab yang ada.
# */15 * * * * = setiap 15 menit
(echo "*/15 * * * * bash $HOME/ccminer/check_miner.sh") | crontab -

# Tambahkan job log rotator ke crontab
(crontab -l ; echo "0 0 * * 0 bash $HOME/ccminer/log_rotator.sh") | crontab -

echo -e "\e[1;32m[+] Menjalankan service CRON (Smart Watchdog)..."
sv up cronie
sleep 2
# --- Akhir Revisi BARU ---


echo ""
echo "INSTALASI SELESII"
echo "Edit pool, wallet, thread (cpu) sesuai dengan jumlah cpu device sebelum mulai mining."
echo -e "\e[1;97mKetik \e[1;92msetting \e[1;97matau \e[1;92mnano ~/ccminer/start.sh \e[1;97muntuk edit\e[0m"
echo -e "\e[1;97mKetik \e[1;92mspek \e[1;97muntuk melihat spesifikasi device\e[0m"
echo "Jika semua sudah siap, ketik exit di Termux dan buka kembali untuk tes mining"
echo "Untuk stop mining gunakan CTRL dan C"
echo "[PENTING] Sebelum restart device, setting di pengaturan/setelan cari aplikasi termux dan termux boot lalu aktifkan mulai otomatis, terima semua perizinan, dan nonaktifkan pengoptimalan baterai"
echo ""

# --- [REVISI FINAL v3] Otomatis Mulai Mining Setelah Instalasi ---
echo ""
echo -e "\e[1;32m[+] Instalasi Selesai. Memulai sesi login baru untuk mining..."
echo -e "\e[1;33m[+] Log mining akan tampil."
sleep 3

# Menjalankan sesi bash BARU sebagai LOGIN SHELL (-l).
# Ini akan meniru 100% apa yang terjadi saat Anda membuka ulang Termux.
# Ini akan memuat bash.bashrc dan menampilkan log "accept" ⚒️ Anda.
exec bash -l
# --- Akhir Revisi Final v3 ---
