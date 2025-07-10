

## ❗ Vấn đề

Dù `CoreDNS` đang chạy ổn (`READY: 1/1`), nhưng trong pod bạn vẫn gặp:

```bash
nslookup kubernetes.default
;; connection timed out; no servers could be reached
```

→ Điều này cho thấy **pod không truy cập được `kube-dns` qua ClusterIP (10.96.0.10)**.

---

## 🧠 Nguyên nhân

Có **2 vấn đề phổ biến** với Calico gây lỗi DNS trong cluster trên **GCP VM**:

### ✅ 1. Thiếu `MASQUERADE` rule (NAT)

```bash
sudo iptables -t nat -L POSTROUTING -n | grep MASQUERADE
```

→ **Không có dòng nào** → Pod traffic đi ra node nhưng không được NAT, gây lỗi khi quay lại service `kube-dns`.

---

### ✅ 2. Thiếu cấu hình `hairpinMode: true`

Vì pod có thể gọi webhook qua service trỏ lại chính nó, nên **CNI cần bật hairpin**.

---

## ✅ Giải pháp

### 🔧 Bước 1: Bật NAT (MASQUERADE)

Tạo rule NAT:

```bash
sudo iptables -t nat -A POSTROUTING -s 172.16.0.0/16 ! -d 172.16.0.0/16 -j MASQUERADE
```

> `172.16.0.0/16` là CIDR Pod (gộp cả các node lại). Xác nhận bằng:
>
> ```bash
> kubectl get nodes -o jsonpath='{range .items[*]}{.spec.podCIDR}{"\n"}{end}'
> ```

Bạn sẽ thấy: `172.16.0.0/24`, `172.16.1.0/24`,…

---

### 🔧 Bước 2: Bật `hairpinMode` trong CNI

Sửa file:

```bash
sudo nano /etc/cni/net.d/10-calico.conflist
```

Trong phần `plugins[0]` (type `calico`), thêm dòng sau:

```json
"hairpinMode": true,
```

Ví dụ đầy đủ:

```json
{
  "type": "calico",
  ...
  "hairpinMode": true,
  ...
}
```

---

### 🔧 Bước 3: Restart lại pod CoreDNS để reload

```bash
kubectl -n kube-system rollout restart deployment coredns
```

---

### 🔧 Bước 4: Kiểm tra lại DNS

Tạo 1 pod test DNS:

```bash
kubectl run curl-test --rm -it --restart=Never --image=curlimages/curl -- sh
```

Trong pod:

```sh
nslookup kubernetes.default
dig kubernetes.default.svc.cluster.local
```

---

## ✅ (Tùy chọn) Áp dụng rule NAT vĩnh viễn

Cài `iptables-persistent`:

```bash
sudo apt update
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

---

Nếu bạn làm xong các bước trên mà vẫn bị lỗi, hãy gửi lại:

```bash
kubectl get pods -A -o wide
kubectl describe pod <coredns-pod-name> -n kube-system
```

Hoặc mình có thể hỗ trợ thêm nếu cần.
