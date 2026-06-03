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

            <div class="an-form-col">
                <div class="an-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-pen-to-square"></i> Thông tin bài viết
                    </div>
                    <div class="an-field">
                        <label>Tiêu đề <span class="req">*</span></label>
                        <div class="an-input-wrap">
                            <i class="fa-solid fa-heading"></i>
                            <input type="text" name="title" id="titleInput" required maxlength="200" placeholder="Nhập tiêu đề bài viết...">
                        </div>
                        <div class="an-counter"><span id="titleCount">0</span>/200</div>
                    </div>
                    <div class="an-field">
                        <label>Mô tả ngắn</label>
                        <div class="an-textarea-wrap">
                            <textarea name="shortDesc" id="shortDescInput" rows="3" maxlength="300"
                                      placeholder="Tóm tắt nội dung bài viết..."></textarea>
                        </div>
                        <div class="an-counter"><span id="shortDescCount">0</span>/300</div>
                    </div>
                </div>

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
                        <textarea name="content" id="contentInput" rows="14" required
                                  placeholder="Nhập nội dung bài viết đầy đủ tại đây..."></textarea>
                    </div>
                    <div class="an-counter"><span id="contentCount">0</span> ký tự</div>
                </div>

                <div class="an-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-image"></i> Hình ảnh đại diện
                    </div>
                    <div class="an-field">
                        <label>Đường dẫn ảnh</label>
                        <div class="an-input-wrap">
                            <i class="fa-solid fa-link"></i>
                            <input type="text" name="image" id="imgInput" placeholder="Ví dụ: img/news/bai-viet-1.jpg">
                        </div>
                    </div>
                    <div class="an-img-preview" id="imgPreview">
                        <i class="fa-regular fa-image"></i>
                        <span>Xem trước ảnh đại diện</span>
                    </div>
                </div>
            </div>

            <div class="an-side-col">
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

                <div class="an-card an-preview-card">
                    <div class="an-card-title">
                        <i class="fa-solid fa-eye"></i> Xem trước bài đăng
                    </div>
                    <div class="news-preview-box">
                        <div class="npb-img" id="pvImg"><i class="fa-regular fa-image"></i></div>
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
    function counter(inputId, spanId) {
        var el = document.getElementById(inputId);
        var sp = document.getElementById(spanId);
        if (!el || !sp) return;
        el.addEventListener('input', function() { sp.textContent = this.value.length; });
    }
    counter('titleInput', 'titleCount');
    counter('shortDescInput', 'shortDescCount');
    counter('contentInput', 'contentCount');

    var titleEl = document.getElementById('titleInput');
    var descEl  = document.getElementById('shortDescInput');
    var imgEl   = document.getElementById('imgInput');

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

    [titleEl, descEl, imgEl].forEach(function(el) { if (el) el.addEventListener('input', updatePreview); });

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

    var today = new Date();
    var d = today.getDate().toString().padStart(2,'0');
    var m = (today.getMonth()+1).toString().padStart(2,'0');
    var y = today.getFullYear();
    document.getElementById('todayDate').textContent = d + '/' + m + '/' + y;
    document.getElementById('pvDate').textContent    = d + '/' + m + '/' + y;

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
