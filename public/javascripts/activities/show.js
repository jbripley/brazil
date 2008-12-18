function bind_edit_activity() {
  $("#activity_edit_button").click(function() {
    $.get(this.href, function(response) {
      $("#activity").css("display", "none");
      $('#activity').empty().append(response);
      $("#activity").show();
      
      $("form.edit_activity").ajaxForm({
        beforeSubmit: function(formData, jqForm, options) {                       
          $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
        },
        success: function(responseText, statusText) {
          $('#activity').empty().append(responseText);
          
          jQuery.brazil.flash.notice();
          bind_buttons();
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $('#edit_activity_fieldset').replaceWith(XMLHttpRequest.responseText);
          bind_buttons();
        }
      });
      
      $('#activity_edit_cancel_button').click(function() {
        $.get($("form.edit_activity").attr('action'), function(response) {
          $('#activity').empty().append(response);
          bind_buttons();
        });
        return false;
      });
    });
    
    return false;
  });
}

function bind_new_change() {
  $("form#new_change").ajaxForm({
    beforeSubmit: function(formData, jqForm, options) {
      $('form#new_change input[type="submit"]').attr('disabled', 'disabled');
    },
    target: '#changes',
    success: function(responseText, statusText) {      
      $('#changes').hide();
      $('#changes').empty().append(responseText);
      jQuery.brazil.manipulate.syntax_highlight();
      $('#changes').show();
      
      $('#form_error').hide();
      $('form#new_change input[type="submit"]').removeAttr('disabled');
      
      jQuery.brazil.flash.notice();
      bind_buttons();
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $('#new_change_fieldset').replaceWith(XMLHttpRequest.responseText);
      bind_buttons();
    }
  });
}

function bind_suggest_change() {
  $("#suggest_change_button").click(function() {
    $.get(this.href, function(response) {
      $('#suggest_change_button').hide();
      
      $("#suggest_change_fieldset").css("display", "none");
      $(response).prependTo("#activity_forms");
      $("#suggest_change_fieldset").show("drop", { direction: 'left' });
      
      $("#suggest_change_form").ajaxForm({
        beforeSubmit: function(formData, jqForm, options) {                       
          $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
        },
        success: function(responseText, statusText) {
          $('#changes').hide();
          $('#changes').empty().append(responseText);
          jQuery.brazil.manipulate.syntax_highlight();
          $('#changes').show();
          
          $("#suggest_change_fieldset").remove();
          $('#form_error').hide();
          $('#suggest_change_button').show();
          
          jQuery.brazil.flash.notice();
          bind_buttons();
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $('#suggest_change_fieldset').replaceWith(XMLHttpRequest.responseText);
          bind_buttons();
        }
      });
      
      $('#suggest_change_cancel_button').click(function() {
        $("#suggest_change_fieldset").remove();
        $('#suggest_change_button').show();
        return false;
      });
    });
    
    return false;
  });
}

function bind_edit_change() {
  $(".edit_change_button").click(function() {
    $(this).hide();
    
    $.get(this.href, function(response) {
      $("#edit_change_fieldset").css("display", "none");
      $(response).prependTo("#activity_forms");
      $("#edit_change_fieldset").show("drop", { direction: 'left' });
      
      $("form.edit_change").ajaxForm({
        beforeSubmit: function(formData, jqForm, options) {                       
          $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
        },
        success: function(responseText, statusText) {
          $('#changes').hide();
          $('#changes').empty().append(responseText);
          jQuery.brazil.manipulate.syntax_highlight();
          $('#changes').show();
          
          $("#edit_change_fieldset").remove();
          $('#form_error').hide();
          $('.edit_change_button').show();
          
          jQuery.brazil.flash.notice();
          bind_buttons();
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $('#edit_change_fieldset').replaceWith(XMLHttpRequest.responseText);
          bind_buttons();
        }
      });     
    });
    
    return false;
  });
}

function bind_shortkeys() {
  $(document).shortkeys({
    'c': function() {
      toggle_collapse();
    },
    'k': function() {
      location.replace('#change-1')
    },
    'j': function() {
      location.replace('#change-2')
    }
  });
}

function toggle_collapse() {
  $('.dp-highlighter').toggle();
  // $('.people').toggle();
  $('.sql-slice').toggle();
}

function bind_buttons() {
  bind_edit_activity();
  bind_new_change();
  bind_suggest_change();
  bind_edit_change();
}

$(document).ready(function() {
  jQuery.brazil.manipulate.syntax_highlight();
  jQuery.brazil.move.scrollable('#activity_forms');
  bind_buttons();
});