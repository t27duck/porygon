$(document).ready(function() {
  $('form').on('click', '.remove-fields', function(event) {
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('div.newfieldset').hide();
    event.preventDefault();
  });

  $('form').on('click', '.add-fields', function(event) {
    var time = new Date().getTime();
    var regexp = new RegExp($(this).data('id'), 'g');
    $(this).after($(this).data('fields').replace(regexp, time));
    event.preventDefault();
  });
});
