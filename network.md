 **sơ đồ text tổng thể** mô tả **luồng truy cập từ client ngoài Internet đến VM trong OpenStack thông qua Floating IP**, đầy đủ các bước từ mạng ngoài đến nội bộ:

---

### 📡 **SƠ ĐỒ TEXT – TỪ CLIENT → VM TRONG OPENSTACK**

```
[ Client (Laptop ở nhà) ]
      |
      | 1. ssh ubuntu@203.0.113.100
      v
[ Internet ]
      |
      | 2. Gói tin đi vào hệ thống ISP
      v
[ ISP Router (Viettel/FPT/VNPT...) ]
      |
      | 3. Định tuyến gói đến IP public được cấp (203.0.113.100)
      v
[ Public Router / NAT / Modem nhà bạn hoặc của Datacenter ]
      |
      | 4. Định tuyến vào mạng LAN hoặc server có chạy OpenStack
      v
[ OpenStack External Bridge (ens4) ]
      |
      | 5. Floating IP được ánh xạ đến Neutron Router (DNAT)
      v
[ Neutron Router (OpenStack) ]
      |
      | 6. DNAT: 203.0.113.100 → 10.0.0.101
      v
[ Private Network (Neutron Network: 10.0.0.0/24) ]
      |
      | 7. Gói được chuyển đến đúng VM nội bộ
      v
[ VM01 (10.0.0.101) ]
      |
      | 8. Trả lời SSH quay ngược luồng lại → Neutron Router
      v
[ Neutron Router thực hiện SNAT (10.0.0.101 → 203.0.113.100) ]
      |
      | 9. Gói tin được trả lại qua modem/router → Internet
      v
[ Client nhận dữ liệu SSH ]
```

---

### 🧩 **Tóm gọn các thành phần chính:**

| Thành phần         | Vai trò chính                   |
| ------------------ | ------------------------------- |
| Client             | Máy bên ngoài muốn SSH vào VM   |
| ISP + Internet     | Định tuyến gói tin về IP public |
| Modem / NAT Router | Gateway nhận IP public          |
| OpenStack External | Nơi gán Floating IP (ens4)      |
| Neutron Router     | NAT IP công cộng ↔ IP private   |
| Neutron Network    | Mạng nội bộ (VD: 10.0.0.0/24)   |
| VM (Nova)          | Máy ảo thực sự cần truy cập     |

---

### ✅ Điều kiện để luồng này hoạt động:

1. **Floating IP `203.0.113.100` được gán cho VM**.
2. **Security Group mở cổng 22 (SSH)**.
3. **Floating IP đó có route đúng đến OpenStack node**.
4. **Neutron router tồn tại và kết nối mạng nội bộ ↔ external**.
5. **VM đang chạy, và sshd hoạt động**.

---


