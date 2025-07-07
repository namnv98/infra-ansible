Dưới đây là phần **tóm tắt đầy đủ quá trình resize ổ đĩa của node Kubernetes (trên GCP)** từ đầu đến cuối, bao gồm cả thao tác GCP và bên trong VM.

---

## ✅ **TÓM TẮT CÁC BƯỚC RESIZE Ổ ĐĨA NODE K8S TRÊN GCP**

---

### 🔹 **Bước 1: Resize ổ đĩa trên GCP**

Thực hiện trên máy bạn (Cloud Shell hoặc local có gcloud):

```bash
gcloud compute disks resize k8s-02 \
  --zone asia-southeast1-a \
  --size=50GB
```

> ✅ GCP chỉ mở rộng, **không làm mất dữ liệu**, nhưng **bên trong VM chưa tự động nhận diện dung lượng mới**.

---

### 🔹 **Bước 2: SSH vào VM để mở rộng phân vùng & filesystem**

```bash
gcloud compute ssh k8s-02 --zone=asia-southeast1-a
```

---

### 🔹 **Bước 3: Mở rộng phân vùng**

```bash
sudo apt update && sudo apt install -y cloud-guest-utils
sudo growpart /dev/sda 1
```

📌 Kiểm tra phân vùng trước với `lsblk` nếu cần, thường là `/dev/sda1`

---

### 🔹 **Bước 4: Mở rộng filesystem (ext4)**

```bash
sudo resize2fs /dev/sda1
```

---

### 🔹 **Bước 5: Xác nhận dung lượng**

```bash
df -h
```

> Ví dụ:

```
/dev/sda1        49G  7.1G   40G  16% /
```

---

### 🔹 **Bước 6: Dọn rác để xóa `disk-pressure` (nếu vẫn còn)**

```bash
sudo journalctl --vacuum-time=1d
sudo rm -rf /var/log/pods/*
sudo rm -rf /var/log/containers/*
sudo crictl rmp $(sudo crictl pods --state=Exited -q) || true
sudo crictl rmi --prune || true
```

---

### 🔹 **Bước 7: Restart kubelet để cập nhật trạng thái node**

```bash
sudo systemctl restart kubelet
```

---

### 🔹 **Bước 8: Kiểm tra node đã hết `disk-pressure`**

```bash
kubectl describe node k8s-02 | grep -A5 Conditions
```

Bạn nên thấy:

```
Type:   DiskPressure
Status: False
```

---

## ✅ Kết quả mong đợi:

* Node được scheduler lại bình thường
* Pod Vault (và các Pod khác) được chạy lại
* Không còn lỗi `FailedScheduling` vì `disk-pressure`

---

Nếu bạn cần mình viết task Ansible cho các bước trong VM (`growpart`, `resize2fs`, dọn rác, restart kubelet), chỉ cần nói `viết task ansible tự động hóa bước resize trong VM`, mình sẽ tạo luôn.
