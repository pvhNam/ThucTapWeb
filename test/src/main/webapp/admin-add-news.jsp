<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Đăng Tin Tức | Admin</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="CSS/admin/Admin.css?v=3">
<link rel="stylesheet" href="CSS/admin/admin-add-news.css?v=3">
<style>
/* ===== INLINE FALLBACK: đảm bảo CSS hoạt động dù cache cũ ===== */
:root{--primary:#4e73df;--success:#1cc88a;--warning:#f6c23e;--danger:#e74a3b;--dark:#5a5c69;--bg:#f3f4f6;--text:#444;--shadow:0 4px 6px rgba(0,0,0,.07);--radius:10px;--sidebar-width:250px}
body{font-family:'Inter',sans-serif;margin:0;background:var(--bg);display:flex;min-height:100vh}
.main-content{margin-left:var(--sidebar-width);width:calc(100% - var(--sidebar-width));padding:30px;box-sizing:border-box}
.content-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:25px;padding-bottom:15px;border-bottom:2px solid #e3e6f0}
.page-title{font-size:22px;font-weight:700;color:var(--dark);margin:0}
.an-sub{font-size:13px;color:#999;margin:4px 0 0}
.btn-back-an{display:inline-flex;align-items:center;gap:8px;padding:9px 20px;background:#fff;color:var(--dark);text-decoration:none;border-radius:8px;font-weight:600;font-size:14px;box-shadow:var(--shadow);transition:all .2s;white-space:nowrap}
.btn-back-an:hover{background:var(--primary);color:#fff}
.an-layout{display:grid;grid-template-columns:1fr 300px;gap:22px;align-items:start}
.an-form-col{display:flex;flex-direction:column;gap:20px}
.an-side-col{display:flex;flex-direction:column;gap:20px;position:sticky;top:20px}
.an-card{background:#fff;border-radius:var(--radius);box-shadow:var(--shadow);padding:24px}
.an-card-title{font-size:13px;font-weight:700;text-transform:uppercase;letter-spacing:.6px;color:var(--primary);display:flex;align-items:center;gap:8px;padding-bottom:14px;margin-bottom:18px;border-bottom:1px solid #f0f0f5}
.an-required-note{margin-left:auto;font-size:11px;font-weight:600;color:var(--danger);text-transform:none;letter-spacing:0}
.an-field{margin-bottom:18px}
.an-field label{display:block;font-size:13px;font-weight:600;color:#555;margin-bottom:7px}
.req{color:var(--danger)}
.an-input-wrap{position:relative}
.an-input-wrap i{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:#b0b5c9;font-size:13px;pointer-events:none}
.an-input-wrap input{width:100%;padding:11px 14px 11px 38px;border:1.5px solid #e3e6f0;border-radius:8px;font-size:14px;font-family:'Inter',sans-serif;color:#333;background:#fafbfc;box-sizing:border-box;transition:border-color .2s,box-shadow .2s}
.an-input-wrap input:focus{border-color:var(--primary);outline:none;box-shadow:0 0 0 3px rgba(78,115,223,.12);background:#fff}
.an-textarea-wrap textarea{width:100%;padding:12px 14px;border:1.5px solid #e3e6f0;border-radius:8px;font-size:14px;font-family:'Inter',sans-serif;color:#333;background:#fafbfc;box-sizing:border-box;resize:vertical;line-height:1.6;transition:border-color .2s}
.an-textarea-wrap textarea:focus{border-color:var(--primary);outline:none;box-shadow:0 0 0 3px rgba(78,115,223,.12)}
.an-counter{text-align:right;font-size:11px;color:#aaa;margin-top:5px}
.an-toolbar{display:flex;align-items:center;gap:4px;padding:8px 10px;background:#f8f9fc;border:1.5px solid #e3e6f0;border-bottom:none;border-radius:8px 8px 0 0}
.an-toolbar + .an-textarea-wrap textarea{border-top:none;border-radius:0 0 8px 8px}
.tb-btn{width:30px;height:30px;border:1px solid #e3e6f0;border-radius:5px;background:#fff;color:#666;cursor:pointer;font-size:13px;display:flex;align-items:center;justify-content:center;transition:all .15s}
.tb-btn:hover{background:var(--primary);color:#fff;border-color:var(--primary)}
.tb-divider{width:1px;height:22px;background:#e3e6f0;margin:0 4px}
.tb-hint{margin-left:auto;font-size:11px;color:#bbb;display:flex;align-items:center;gap:5px}
.an-img-preview{margin-top:12px;min-height:160px;border:2px dashed #d1d3e2;border-radius:10px;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:10px;color:#bbb;font-size:14px;background:#fafbfc;overflow:hidden}
.an-img-preview i{font-size:38px}
.an-img-preview img{max-width:100%;max-height:220px;object-fit:cover;border-radius:6px}
.an-publish-meta{display:flex;flex-direction:column;gap:10px;margin-bottom:18px;padding:14px;background:#f8f9fc;border-radius:8px}
.pm-row{display:flex;align-items:center;gap:10px;font-size:13px;color:#666}
.pm-row i{color:#b0b5c9;width:16px}
.btn-publish{width:100%;padding:13px;background:linear-gradient(135deg,var(--primary),#224abe);color:#fff;border:none;border-radius:8px;font-size:14px;font-weight:700;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;box-shadow:0 4px 14px rgba(78,115,223,.4);transition:all .2s;margin-bottom:10px}
.btn-publish:hover{transform:translateY(-2px);box-shadow:0 8px 20px rgba(78,115,223,.5)}
.btn-discard{width:100%;padding:11px;background:#f0f0f5;color:#666;border-radius:8px;font-size:14px;font-weight:600;text-decoration:none;display:flex;align-items:center;justify-content:center;gap:8px;transition:all .2s;box-sizing:border-box}
.btn-discard:hover{background:#e0e0ea;color:#333}
.news-preview-box{border:1.5px solid #eee;border-radius:10px;overflow:hidden}
.npb-img{width:100%;height:140px;background:#f0f0f5;display:flex;align-items:center;justify-content:center;color:#ccc;font-size:36px;overflow:hidden}
.npb-img img{width:100%;height:100%;object-fit:cover}
.npb-body{padding:14px}
.npb-tag{display:inline-block;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.8px;background:#e8f0fe;color:var(--primary);padding:3px 10px;border-radius:20px;margin-bottom:8px}
.npb-title{font-size:14px;font-weight:700;color:#222;margin:0 0 6px;line-height:1.4}
.npb-desc{font-size:12px;color:#888;margin:0 0 10px;line-height:1.5}
.npb-date{display:flex;align-items:center;gap:6px;font-size:11px;color:#aaa}
@media(max-width:920px){.an-layout{grid-template-columns:1fr}.an-side-col{position:static;flex-direction:row;flex-wrap:wrap}.an-side-col .an-card{flex:1;min-width:240px}}
</style>
</head>
<body>

    <jsp:include page="sidebarAdmin.jsp">
        <jsp:param name="pageName" value="news" />
    </jsp:include>

    <main class="main-content">

        <div class="content-header">
            <div>
                <h1 class="page-title">
                    <i class="fa-solid fa-newspaper" style="color:var(--primary);margin-right:10px;"></i>
                    Đăng Bài Viết Mới
                </h1>
                <p class="an-sub">Soạn nội dung và xem trước trước khi đăng</p>
            </div>
            <a href="admin-news" class="btn-back-an">
                <i class="fa-solid fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <form action="admin-add-news" method="post" id="newsForm">
        <div class="an-layout">

            <%-- CỘT TRÁI: Form --%>
            <div class="an-form-col">

                <%-- SECTION 1: Thông tin bài viết --%>
                <div class="an-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-pen-to-square"></i> Thông tin bài viết
                    </div>

                    <div class="an-field">
                        <label>Tiêu đề <span class="req">*</span></label>
                        <div class="an-input-wrap">
                            <i class="fa-solid fa-heading"></i>
                            <input type="text" name="title" id="titleInput" required
                                   maxlength="200"
                                   placeholder="Nhập tiêu đề bài viết...">
                        </div>
                        <div class="an-counter"><span id="titleCount">0</span>/200</div>
                    </div>

                    <div class="an-field">
                        <label>Mô tả ngắn</label>
                        <div class="an-textarea-wrap">
                            <textarea name="shortDesc" id="shortDescInput"
                                      rows="3" maxlength="300"
                                      placeholder="Tóm tắt nội dung bài viết (hiển thị trên trang danh sách)..."></textarea>
                        </div>
                        <div class="an-counter"><span id="shortDescCount">0</span>/300</div>
                    </div>
                </div>

                <%-- SECTION 2: Nội dung --%>
                <div class="an-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-align-left"></i> Nội dung bài viết
                        <span class="an-required-note">* Bắt buộc</span>
                    </div>

                    <div class="an-toolbar">
                        <button type="button" class="tb-btn" onclick="insertTag('**','**')" title="In đậm"><i class="fa-solid fa-bold"></i></button>
                        <button type="button" class="tb-btn" onclick="insertTag('*','*')" title="In nghiêng"><i class="fa-solid fa-italic"></i></button>
                        <button type="button" class="tb-btn" onclick="insertTag('\n## ','')" title="Tiêu đề"><i class="fa-solid fa-heading"></i></button>
                        <button type="button" class="tb-btn" onclick="insertTag('\n- ','')" title="Danh sách"><i class="fa-solid fa-list-ul"></i></button>
                        <div class="tb-divider"></div>
                        <span class="tb-hint"><i class="fa-regular fa-keyboard"></i> Hỗ trợ Markdown cơ bản</span>
                    </div>

                    <div class="an-textarea-wrap">
                        <textarea name="content" id="contentInput"
                                  rows="14" required
                                  placeholder="Nhập nội dung bài viết đầy đủ tại đây...&#10;&#10;Bạn có thể dùng Markdown:&#10;## Tiêu đề phụ&#10;**in đậm**   *in nghiêng*&#10;- Danh sách mục"></textarea>
                    </div>
                    <div class="an-counter"><span id="contentCount">0</span> ký tự</div>
                </div>

                <%-- SECTION 3: Hình ảnh --%>
                <div class="an-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-image"></i> Hình ảnh đại diện
                    </div>

                    <div class="an-field">
                        <label>Đường dẫn ảnh</label>
                        <div class="an-input-wrap">
                            <i class="fa-solid fa-link"></i>
                            <input type="text" name="image" id="imgInput"
                                   placeholder="Ví dụ: img/news/bai-viet-1.jpg">
                        </div>
                    </div>

                    <div class="an-img-preview" id="imgPreview">
                        <i class="fa-regular fa-image"></i>
                        <span>Xem trước ảnh đại diện</span>
                    </div>
                </div>

            </div>

            <%-- CỘT PHẢI: Preview + Publish --%>
            <div class="an-side-col">

                <%-- PUBLISH CARD --%>
                <div class="an-card an-publish-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-paper-plane"></i> Đăng bài
                    </div>
                    <div class="an-publish-meta">
                        <div class="pm-row">
                            <i class="fa-regular fa-calendar"></i>
                            <span>Ngày đăng: <strong id="todayDate"></strong></span>
                        </div>
                        <div class="pm-row">
                            <i class="fa-solid fa-user-shield"></i>
                            <span>Tác giả: <strong>Administrator</strong></span>
                        </div>
                    </div>
                    <button type="submit" class="btn-publish">
                        <i class="fa-solid fa-paper-plane"></i> Đăng Bài Viết
                    </button>
                    <a href="admin-news" class="btn-discard">
                        <i class="fa-solid fa-xmark"></i> Hủy bỏ
                    </a>
                </div>

                <%-- PREVIEW CARD --%>
                <div class="an-card an-preview-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-eye"></i> Xem trước bài đăng
                    </div>
                    <div class="news-preview-box">
                        <div class="npb-img" id="pvImg">
                            <i class="fa-regular fa-image"></i>
                        </div>
                        <div class="npb-body">
                            <span class="npb-tag">Tin tức</span>
                            <h4 class="npb-title" id="pvTitle">Tiêu đề bài viết...</h4>
                            <p class="npb-desc" id="pvDesc">Mô tả ngắn sẽ hiển thị ở đây...</p>
                            <div class="npb-date">
                                <i class="fa-regular fa-clock"></i>
                                <span id="pvDate"></span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
        </form>

    </main>

<script>
// ---- Char counters ----
function counter(inputId, spanId) {
    var el = document.getElementById(inputId);
    var sp = document.getElementById(spanId);
    if (!el || !sp) return;
    el.addEventListener('input', function() { sp.textContent = this.value.length; });
}
counter('titleInput', 'titleCount');
counter('shortDescInput', 'shortDescCount');
counter('contentInput', 'contentCount');

// ---- Preview update ----
var titleEl    = document.getElementById('titleInput');
var descEl     = document.getElementById('shortDescInput');
var imgEl      = document.getElementById('imgInput');

function updatePreview() {
    var title = titleEl.value.trim() || 'Tiêu đề bài viết...';
    var desc  = descEl ? descEl.value.trim() : '';

    document.getElementById('pvTitle').textContent = title;
    document.getElementById('pvDesc').textContent  = desc || 'Mô tả ngắn sẽ hiển thị ở đây...';

    var img = imgEl.value.trim();
    var pvImg = document.getElementById('pvImg');
    if (img) {
        pvImg.innerHTML = '<img src="' + img + '" onerror="this.style.display=\'none\'">';
    } else {
        pvImg.innerHTML = '<i class="fa-regular fa-image"></i>';
    }
}

[titleEl, descEl, imgEl].forEach(function(el) {
    if (el) el.addEventListener('input', updatePreview);
});

// ---- Image preview (large) ----
imgEl.addEventListener('input', function() {
    var val = this.value.trim();
    var box = document.getElementById('imgPreview');
    if (val) {
        box.innerHTML = '<img src="' + val + '" onerror="this.style.display=\'none\'">';
    } else {
        box.innerHTML = '<i class="fa-regular fa-image"></i><span>Xem trước ảnh đại diện</span>';
    }
    updatePreview();
});

// ---- Today date ----
var today = new Date();
var d = today.getDate().toString().padStart(2,'0');
var m = (today.getMonth()+1).toString().padStart(2,'0');
var y = today.getFullYear();
document.getElementById('todayDate').textContent = d + '/' + m + '/' + y;
document.getElementById('pvDate').textContent    = d + '/' + m + '/' + y;

// ---- Markdown toolbar ----
function insertTag(before, after) {
    var ta = document.getElementById('contentInput');
    var start = ta.selectionStart;
    var end   = ta.selectionEnd;
    var selected = ta.value.substring(start, end);
    ta.value = ta.value.substring(0, start) + before + selected + after + ta.value.substring(end);
    ta.selectionStart = start + before.length;
    ta.selectionEnd   = start + before.length + selected.length;
    ta.focus();
    document.getElementById('contentCount').textContent = ta.value.length;
}
</script>
</body>
</html>
