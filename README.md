# Sproxy Tools — Trang chủ GitHub Pages

## Cài đặt

Tải và giải nén ZIP, sau đó **chỉ sao chép**:

- `index.html` vào thư mục gốc repository `localstorage-porter-privacy/`, thay cho file `index.html` cũ.
- `privacy/index.html` vào thư mục `privacy/` mới.

**Không xóa** các thư mục `genqr/`, `convert/`, `notepad/` đang có.

Commit → Push `main`. Trang chủ sẽ có URL:

https://shallyvn1-spec.github.io/localstorage-porter-privacy/

Chính sách quyền riêng tư được chuyển sang:

https://shallyvn1-spec.github.io/localstorage-porter-privacy/privacy/

**QUAN TRỌNG:** Nếu Chrome Web Store đang sử dụng URL Privacy Policy cũ là trang chủ (`.../localstorage-porter-privacy/`), hãy thay thành đường dẫn `.../privacy/` trong Developer Dashboard. Kiểm tra URL mới mở được trước khi cập nhật mục khai báo.

## Thêm một công cụ mới (chỉ một chỗ)

Mở file gốc `index.html`, tìm `const TOOLS = [` ở gần cuối file, bổ sung object mới:

```js
{
  id: 'new-tool',
  name: 'Tên công cụ',
  description: 'Mô tả 1–2 câu',
  url: './new-tool/',
  category: 'Tiện ích',
  icon: 'code',
  color: '#dd7a34',
  background: '#fff2e7',
  keywords: 'tên khác, từ khóa tìm kiếm'
},
```

Tạo thêm thư mục `new-tool/` với file `index.html` tương ứng. Danh mục lọc, tìm kiếm, đếm số lượng và danh sách thẻ được tạo tự động.

Các icon hỗ trợ sẵn: `qr`, `exchange`, `note`, `code`, `calculator`, `link`, `file`, `globe`.

## Chức năng khác

- Tìm công cụ tiếng Việt có dấu hoặc không dấu.
- Phím tắt `Ctrl+K` / `⌘K` hoặc `/` để tìm kiếm.
- Lọc theo danh mục và công cụ đã ghim.
- Ghim công cụ yêu thích và chuyển giao diện sáng/tối, lưu trong Local Storage **chỉ của trang chủ**.
- Mở công cụ trong tab mới.
- Tối ưu giao diện máy tính và điện thoại.

Toàn bộ giao diện chứa trong một file HTML, không phụ thuộc CDN, thư viện bên ngoài hoặc backend.
