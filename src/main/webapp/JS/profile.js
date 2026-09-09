(function () {
    const avatarInput = document.getElementById('avatar-file');
    const avatar = document.getElementById('account-avatar');
    if (!avatarInput || avatarInput.dataset.ready) return;
    avatarInput.dataset.ready = 'true';
    const originalAvatar = avatar.src;
    let previewUrl;
    avatarInput.addEventListener('change', function () {
        if (previewUrl) URL.revokeObjectURL(previewUrl);
        avatar.src = originalAvatar;
        avatarInput.setCustomValidity('');
        const file = avatarInput.files[0];
        if (!file) return;
        if (!['image/jpeg', 'image/png', 'image/webp'].includes(file.type) || file.size > 10 * 1024 * 1024) {
            avatarInput.setCustomValidity(document.documentElement.lang === 'en'
                ? 'Choose a JPG, PNG or WEBP image up to 10 MB.'
                : 'Vui lòng chọn ảnh JPG, PNG hoặc WEBP không quá 10 MB.');
            avatarInput.reportValidity();
            return;
        }
        previewUrl = URL.createObjectURL(file);
        avatar.src = previewUrl;
    });
    const toggle = document.getElementById('show-passwords');
    toggle.addEventListener('change', function () {
        document.querySelectorAll('#account-security input[name$="_pass"]').forEach(function (input) {
            input.type = toggle.checked ? 'text' : 'password';
        });
    });
})();
