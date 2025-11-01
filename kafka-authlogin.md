Chuẩn rồi 👍 — ta có thể tạo user/password riêng, ví dụ như `jmxuser / jmxpass2025`.
Mình hướng dẫn lại nhanh gọn cách bật JMX **có authentication**, với user bạn tùy chọn.

---

## 🧩 1️⃣ Tạo thư mục và file auth cho JMX

```bash
sudo mkdir -p /data/kafka/config/jmx
cd /data/kafka/config/jmx
```

### 📄 `/data/kafka/config/jmx/jmxremote.access`

```bash
jmxuser readwrite
admin readonly
```

### 📄 `/data/kafka/config/jmx/jmxremote.password`

```bash
jmxuser jmxpass2025
admin jmxpass2025
```

> ⚠️ Bảo mật bắt buộc:

```bash
sudo chmod 600 /data/kafka/config/jmx/jmxremote.password
sudo chown kafka:kafka /data/kafka/config/jmx/jmxremote.*
```

---

## ⚙️ 2️⃣ Cập nhật `kafka.service`

Chạy:

```bash
sudo systemctl edit --full kafka
```

Tìm dòng:

```ini
Environment=KAFKA_OPTS="..."
```

và **thay bằng:**

```ini
Environment="JMX_PORT=9999"
Environment="KAFKA_OPTS=-Djava.security.auth.login.config=/data/kafka/config/kraft/kafka_server_jaas.conf \
 -Dcom.sun.management.jmxremote \
 -Dcom.sun.management.jmxremote.authenticate=true \
 -Dcom.sun.management.jmxremote.password.file=/data/kafka/config/jmx/jmxremote.password \
 -Dcom.sun.management.jmxremote.access.file=/data/kafka/config/jmx/jmxremote.access \
 -Dcom.sun.management.jmxremote.ssl=false \
 -Dcom.sun.management.jmxremote.local.only=false \
 -Dcom.sun.management.jmxremote.port=9999 \
 -Dcom.sun.management.jmxremote.rmi.port=9999 \
 -Djava.rmi.server.hostname=$(hostname -I | awk '{print $1}')"
```

---

## 🔄 3️⃣ Reload & restart Kafka

```bash
sudo systemctl daemon-reload
sudo systemctl restart kafka
```

---

## 🔍 4️⃣ Kiểm tra Kafka đã bật JMX

```bash
ss -tulnp | grep 9999
```

Nếu thấy `java` lắng nghe port 9999 → JMX active ✅

---

## 🧠 5️⃣ Kết nối từ VisualVM

**URL:**

```
service:jmx:rmi:///jndi/rmi://<ip_server>:9999/jmxrmi
```

**Username / Password:**

```
Username: jmxuser
Password: jmxpass2025
```

---

Bạn muốn mình gửi luôn bản hoàn chỉnh `kafka.service` (copy-paste chạy luôn, có auth + hostname tự động) không?
