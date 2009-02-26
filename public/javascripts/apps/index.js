$(document).ready(function() {
  brazil.move.scrollable('#app_forms');

  // Edit App name
  brazil.form.inline({
    show_form: '.edit_app_button',
    form_container: '.head'
  });

  // Add Activity
  brazil.form.insert_only({
    show_form: '.add_activities_button',
    form_container: '#app_forms',
    inserted_fieldset: '#new_activity_fieldset'
  });

  // TODO: Come back to this later
  // brazil.manipulate.expand({
  //   expand_button: '.view_all_activites',
  //   expand_container: '.app'
  // });
});