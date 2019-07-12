$('#file_click').click(function () {
    $('#file').click()
})
$('#file').change(function (e) {
    $('#file_click').val(e.currentTarget.files[0].name)
})
