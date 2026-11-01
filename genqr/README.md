# VietQR Generator — bank logo update

File `index.html` da duoc cap nhat de hien thi logo ngan hang thay cho chu viet tat.

## Chay ngay

Upload rieng `genqr/index.html` len GitHub la logo se duoc nap truc tiep qua URL VietQR khi ket noi mang cho phep.

## Tai 64 logo ve thu muc cua ban (khuyen dung)

1. Giai nen ZIP vao thu muc `genqr` trong repository.
2. Mo Windows PowerShell o thu muc `genqr`, chay:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\download-logos.ps1

   Hoac neu co Python:

    python download-logos.py

3. Script doc danh sach tu `logos-manifest.json`, thu tai tung logo tu duong dan VietQR ma ban cung cap. Neu loi, thu logo chinh thuc tu `api.vietqr.io`.
4. Them ca thu muc `logos/` sau khi tai xong vao GitHub Desktop, Commit va Push.
5. Khi chua co anh trong `logos/` hoac URL anh loi, trang web tu thu nguon truc tuyen va neu van that bai se hien ma ngan hang nhu cu.

## Cau truc

    genqr/
      index.html
      logos-manifest.json
      download-logos.ps1
      download-logos.py
      logos/
        <uuid>.png ...

Tu HTML ban cung cap: 66 the img, 64 URL anh khac nhau (mot so ngan hang dung chung logo).
Khong thay doi thong tin tai khoan, mau QR, cac ham tao URL va lich su localStorage.

**Luu y:** Moi truong build cua ChatGPT khong truy cap duoc may chu anh de tai file nhi phan. Bo ZIP vi vay chua kem 64 file anh PNG; hai script la cach tai ve may Windows cua ban. Ban co the dung HTML ngay neu trinh duyet mo duoc nguon VietQR.
