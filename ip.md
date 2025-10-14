---

## 🧩 Điều kiện để truy cập giữa 2 máy qua Wi-Fi (cùng mạng LAN)

Khi bạn muốn **máy A truy cập ứng dụng đang chạy trên máy B (ví dụ [http://10.103.1.114:8080](http://10.103.1.114:8080))
**, cần đảm bảo những điều kiện sau:

---

### ✅ 1. Hai máy **cùng subnet (mạng con)**

* Mỗi máy trong mạng Wi-Fi sẽ có một địa chỉ IP riêng, ví dụ:

    * Máy A: `10.103.1.114/24`
    * Máy B: `10.103.1.120/24`
* `/24` nghĩa là **mask mạng là 255.255.255.0**, tức tất cả địa chỉ `10.103.1.x` đều cùng một mạng LAN.

👉 Khi cả hai IP có **cùng 3 octet đầu (`10.103.1`)**, chúng **có thể kết nối trực tiếp với nhau trong LAN**.

---

### ⚠️ 2. Router không bật chế độ **Client Isolation / AP Isolation**

Một số Wi-Fi công cộng, modem nhà mạng, hoặc router có bật tính năng **“Client Isolation”** (hay “AP Isolation”), khiến
các thiết bị trong cùng Wi-Fi **không thể ping hoặc truy cập nhau**.

* Khi đó, bạn chỉ truy cập được Internet chứ không thể truy cập IP nội bộ khác.
* Cần **tắt tính năng này trong trang cấu hình router** (nếu có).

---

## 🔍 Kiểm tra và cấu hình trên Linux

### 🧠 1. Kiểm tra IP Wi-Fi của máy

```bash
ip -4 -o addr show | grep wlan
```

**Ví dụ kết quả:**

```
3: wlan0    inet 10.103.1.114/24 brd 10.103.1.255 scope global dynamic noprefixroute wlan0
```

* `inet 10.103.1.114/24`:

    * IP là **10.103.1.114**
    * subnet mask `/24` (255.255.255.0)
* Đây là **địa chỉ LAN nội bộ** của máy trong mạng Wi-Fi.

---

### 🧱 2. Kiểm tra tường lửa (firewall)

Nếu firewall chặn port 8080, máy khác sẽ không truy cập được.

Kiểm tra trạng thái firewall:

```bash
sudo firewall-cmd --list-all
```

Nếu chưa có port 8080, mở cổng này:

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

---

### 🌐 3. Kiểm tra ứng dụng đã lắng nghe (listen) trên tất cả IP chưa

Chạy:

```bash
sudo ss -tulpn | grep 8080
```

Nếu thấy:

```
LISTEN 0 100 *:8080 *:* users:(("java",pid=60124,fd=122))
```

→ Dấu `*` nghĩa là ứng dụng đang lắng nghe **tất cả interface (bao gồm Wi-Fi)** ✅
→ Nếu chỉ thấy `127.0.0.1:8080` thì **chỉ truy cập được nội bộ (localhost)** ❌
→ Khi đó cần sửa app để listen trên `0.0.0.0:8080`.

---

## ⚙️ Giữ cố định IP (không thay đổi sau mỗi lần khởi động)

Mặc định IP như `10.103.1.114` là **IP động (DHCP)**, có thể thay đổi khi reconnect Wi-Fi.
Để giữ cố định IP (cho máy khác luôn truy cập được đúng địa chỉ này), có 2 cách:

### **Cách 1 – Gán IP tĩnh (static IP) ngay trên Linux**

Dùng `nmcli` nếu hệ thống dùng NetworkManager:

```bash
nmcli con mod "Tên_kết_nối_WiFi" ipv4.addresses 10.103.1.114/24
nmcli con mod "Tên_kết_nối_WiFi" ipv4.gateway 10.103.1.1
nmcli con mod "Tên_kết_nối_WiFi" ipv4.dns "8.8.8.8"
nmcli con mod "Tên_kết_nối_WiFi" ipv4.method manual
nmcli con up "Tên_kết_nối_WiFi"
```

Hoặc dùng giao diện Settings → Network → Wi-Fi → IPv4 → Manual.

---

### **Cách 2 – Giữ cố định IP từ router (DHCP reservation)**

* Truy cập trang quản trị router, thường là `http://10.103.1.1`
* Vào phần **DHCP / LAN / Address Reservation**
* Gán địa chỉ IP `10.103.1.114` cho **MAC address** của card Wi-Fi máy bạn
  → Khi đó router sẽ luôn cấp đúng IP này mỗi lần kết nối.

---

## 🧾 Tóm tắt

| Bước | Mục tiêu                              | Lệnh kiểm tra / cấu hình                                         |            |
|------|---------------------------------------|------------------------------------------------------------------|------------|
| 1    | Xác định IP Wi-Fi của máy             | `ip -4 -o addr show                                              | grep wlan` |
| 2    | Kiểm tra firewall                     | `sudo firewall-cmd --list-all`                                   |            |
| 3    | Mở port 8080                          | `sudo firewall-cmd --permanent --add-port=8080/tcp` + `--reload` |            |
| 4    | Kiểm tra app có listen trên `0.0.0.0` | `sudo ss -tulpn                                                  | grep 8080` |
| 5    | (Tùy chọn) Giữ cố định IP             | `nmcli` hoặc cấu hình trên router                                |            |

---

👉 Sau khi hoàn tất, bạn có thể từ **máy khác cùng Wi-Fi** truy cập ứng dụng qua:

```
http://10.103.1.114:8080/
```