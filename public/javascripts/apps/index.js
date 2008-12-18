function bind_edit_app() {
  $(".edit_app_button").click(function() {
    var me = this;
    $.get(this.href, function(response) {
      var edit_app_div = $(me).parent('.head');
      edit_app_div.empty().append(response);
      
      edit_app_div.children('form').ajaxForm({
        beforeSubmit: function(formData, jqForm, options) {
          $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
        },
        success: function(responseText, statusText) {
          edit_app_div.empty().append(responseText);
          bind_edit_app();
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          edit_app_div.replaceWith(XMLHttpRequest.responseText);
          bind_edit_app();
        }
      });
      
      edit_app_div.find('#cancel_edit_app_button').click(function() {
        $.get(edit_app_div.children('form').attr('action'), function(response) {
          edit_app_div.empty().append(response);
          bind_edit_app();
        });
        return false;
      });
    });
    
    return false;
  });
}

$(document).ready(function() {
  bind_edit_app();
});