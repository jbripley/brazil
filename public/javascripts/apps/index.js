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
  jQuery.brazil.form.insert_only({
    show_form: '.add_activities_button',
    form_container: '#app_forms',
    inserted_fieldset: '#new_activity_fieldset',
    done: function(){
      bind_buttons();
    }
  });

  // TODO: Come back to this later
  // jQuery.brazil.manipulate.expand({
  //   expand_button: '.view_all_activites',
  //   expand_container: '.app'
  // });
}

$(document).ready(function() {
  jQuery.brazil.move.scrollable('#app_forms');
  bind_buttons();
});