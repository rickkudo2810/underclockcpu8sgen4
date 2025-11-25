#!/system/bin/sh
# Module: Underclock Controller
# Target: Snapdragon 8s Gen 4 (onyx)
# Author: Rick Earth

# 1. Sleep 5s chờ hệ thống boot ổn định (tránh conflict lúc khởi động)
sleep 10

# Định nghĩa mức xung nhịp (Đơn vị: kHz)
# Lưu ý: Kernel sẽ tự làm tròn đến mức xung gần nhất nếu số này không khớp 100% bảng tần số.
FREQ_LITTLE=1785000  # 1.785 GHz
FREQ_BIG=1920000     # 1.92 GHz
FREQ_PRIME=2803000   # 2.803 GHz

# Đường dẫn đến file quản lý xung nhịp
CPU_PATH="/sys/devices/system/cpu"

# 2. Vòng lặp vô tận (Infinite Loop) để chống lại Joyose/Powerkeeper
while true; do
    # --- Cấu hình Little Cores (0 - 3) ---
    for i in 0 1 2 3; do
        # Ghi đè xung nhịp tối đa
        echo $FREQ_LITTLE > $CPU_PATH/cpu$i/cpufreq/scaling_max_freq
        # Set quyền 444 (Chủ sở hữu ghi được, người khác chỉ đọc)
        chmod 444 $CPU_PATH/cpu$i/cpufreq/scaling_max_freq
    done

    # --- Cấu hình Big Cores (4 - 6) ---
    for i in 4 5 6; do
        echo $FREQ_BIG > $CPU_PATH/cpu$i/cpufreq/scaling_max_freq
        chmod 444 $CPU_PATH/cpu$i/cpufreq/scaling_max_freq
    done

    # --- Cấu hình Prime Core (7) ---
    echo $FREQ_PRIME > $CPU_PATH/cpu7/cpufreq/scaling_max_freq
    chmod 444 $CPU_PATH/cpu7/cpufreq/scaling_max_freq

    # 3. Nghỉ 5 giây trước khi lặp lại
    # Quan trọng: Phải có sleep để không bị ăn 100% CPU gây nóng máy ngược
    sleep 5
done