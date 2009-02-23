$(document).ready(function() {
  jQuery.brazil.manipulate.syntax_highlight();
  jQuery.brazil.move.scrollable('#activity_forms');

  // Edit Activity
  jQuery.brazil.form.inline({
    show_form: '#activity_edit_button',
    form_container: '#activity',
    success: function() {
      jQuery.brazil.flash.notice();
    }
  });

  // New Change
  jQuery.brazil.form.existing({
    form_container: '#new_change_fieldset',
    response_container: '#changes',
    success: function() {
      jQuery.brazil.manipulate.syntax_highlight();
      jQuery.brazil.flash.notice();
    }
  });

  // Suggest Change
  jQuery.brazil.form.insert({
    show_form: '#suggest_change_button',
    form_container: '#activity_forms',
    inserted_fieldset: '#suggest_change_fieldset',
    response_container: '#changes',
    success: function() {
      jQuery.brazil.manipulate.syntax_highlight();
      jQuery.brazil.flash.notice();
    }
  });

  // Edit / Approve Change
  jQuery.brazil.form.insert({
    show_form: '.edit_change_button',
    form_container: '#activity_forms',
    inserted_fieldset: '#edit_change_fieldset',
    response_container: '#changes',
    success: function() {
      jQuery.brazil.manipulate.syntax_highlight();
      jQuery.brazil.flash.notice();
    }
  });
});