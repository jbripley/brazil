function bind_buttons() {
  // Edit App name
  jQuery.brazil.form.inline({
    show_form: '.edit_app_button',
    form_container: '.head',
    done: function(){
      bind_buttons();
    }
  });
}

$(document).ready(function() {
  // jQuery.brazil.move.scrollable('#activity_forms');
  bind_buttons();
});