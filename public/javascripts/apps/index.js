function bind_buttons() {
  // Edit App name
  jQuery.brazil.form.inline({
    show_form: '.edit_app_button',
    form_container: '.head',
    done: function(){
      bind_buttons();
    }
  });
  
  // Add Activity
  jQuery.brazil.form.insert({
    show_form: '.add_activities_button',
    form_container: '#app_forms',
    inserted_fieldset: '#new_activity_fieldset',
    response_container: '#app-list',
    done: function(){
      bind_buttons();
    }
  });
}

$(document).ready(function() {
  jQuery.brazil.move.scrollable('#app_forms');
  bind_buttons();
});