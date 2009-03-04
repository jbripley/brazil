jQuery.ajaxSetup({dataType: 'html'})

// Brazil namespace
var brazil = function() {
  function form_insert_ajax_submit(options) {
    var defaults = { show_form: '', inserted_fieldset: '', response_container: '', success: function(){}, error: function(){}, done: function(){} };
    var settings = jQuery.extend(defaults, options);

    jQuery(settings.inserted_fieldset).find('form').ajaxForm({
      beforeSubmit: function(formData, jqForm, options) {
        jQuery('input[type="submit"]', jqForm).attr('disabled', 'disabled');
      },
      success: function(responseText, statusText) {
        jQuery(settings.inserted_fieldset).remove();

        jQuery(settings.response_container).hide();
        jQuery(settings.response_container).empty().append(responseText);

        settings.success();

        settings.done();

        jQuery(settings.show_form).show();
        jQuery(settings.response_container).show();
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        jQuery(settings.inserted_fieldset).replaceWith(XMLHttpRequest.responseText);

        settings.error();

        settings.done();

        form_insert_ajax_submit(options);
      }
    });

    jQuery(settings.inserted_fieldset).find('.form_close').show();
    jQuery(settings.inserted_fieldset).find('.form_close').live("click", function() {
      jQuery(settings.inserted_fieldset).remove();
      jQuery(settings.show_form).show();

      settings.done();

      return false;
    });
  }

  function form_inline_ajax_submit(options) {
    var defaults = { inserted_fieldset: '', form_container: null, success: function(){}, error: function(){}, done: function(){} };
    var settings = jQuery.extend(defaults, options);

    settings.form_container.find('form').ajaxForm({
          beforeSubmit: function(formData, jqForm, options) {
            jQuery('input[type="submit"]', jqForm).attr('disabled', 'disabled');
          },
          success: function(responseText, statusText) {
            settings.form_container.replaceWith(responseText);

            settings.success();

            settings.done();
          },
          error: function(XMLHttpRequest, textStatus, errorThrown) {
            settings.form_container.empty().append(XMLHttpRequest.responseText);

            settings.error();

            settings.done();

            form_inline_ajax_submit(options);
          }
        });

        jQuery(settings.inserted_fieldset).find('.form_close').show();
        jQuery(settings.inserted_fieldset).find('.form_close').live("click", function() {
          jQuery.get(settings.form_container.children('form').attr('action'), function(response) {
            settings.form_container.replaceWith(response);

            settings.done();
          });
          return false;
        });
  }

  return {
    move : {
      scrollable: function(id) {
        jQuery(id).css("position", "relative");
        jQuery(id).scrollFollow();
      }
    },
    flash : {
      notice: function() {
        jQuery.get('/flash/notice', function(response) {
          jQuery('#notice').hide().empty().append(response).fadeIn('slow', function() {
            setTimeout('jQuery("#notice").fadeOut()', 3000);
          });
        });
      },
      discard: function() {
        jQuery.get('/flash/notice', function() {
        });
      }
    },
    manipulate: {
      syntax_highlight: function() {
        if (typeof SyntaxHighlighter != "undefined") {
          SyntaxHighlighter.config.clipboardSwf = '/javascripts/syntaxhighlighter/clipboard.swf';
          SyntaxHighlighter.defaults.gutter = false;
          SyntaxHighlighter.highlight();
        }
      },
      expand: function(options) {
        var defaults = { expand_button: '', collapse_button: '', expand_container: '' };
        var settings = jQuery.extend(defaults, options);

        jQuery(settings.expand_button).live("click", function() {
          jQuery.get(this.href, function(response) {
            jQuery(settings.expand_button).parents(settings.expand_container).replaceWith(response);
          });

          return false;
        });
      }
    },
    form : {
      inline: function(options) {
        var defaults = { show_form: '', form_container: '', success: function(){}, error: function(){}, done: function(){} };
        var settings = jQuery.extend(defaults, options);

        jQuery(settings.show_form).live("click", function() {
          var show_form = this;
          jQuery.get(this.href, function(response) {
            var form_container = jQuery(show_form).parents(settings.form_container);
            form_container.empty().append(response).show('blind');

            form_inline_ajax_submit({
              form_container: form_container,
              inserted_fieldset: settings.inserted_fieldset,
              success: settings.success,
              error: settings.error,
              done: settings.done
            });
          });

          return false;
        });
      },
      insert: function(options) {
        var defaults = { show_form: '', form_container: '', inserted_fieldset: '', response_container: '', success: function(){}, error: function(){}, done: function(){} };
        var settings = jQuery.extend(defaults, options);

        jQuery(settings.show_form).live("click", function() {
          jQuery(this).hide();

          jQuery.get(this.href, function(response) {
            jQuery(response).prependTo(settings.form_container);
            jQuery(settings.inserted_fieldset).show("drop", { direction: 'left' });

            form_insert_ajax_submit({
              inserted_fieldset: settings.inserted_fieldset,
              response_container: settings.response_container,
              show_form: settings.show_form,
              success: settings.success,
              error: settings.error,
              done: settings.done
            });
          });

          return false;
        });
      },
      insert_only: function(options) {
        var defaults = { show_form: '', form_container: '', inserted_fieldset: '', done: function(){} };
        var settings = jQuery.extend(defaults, options);

        jQuery(settings.show_form).live("click", function() {
          jQuery(this).hide();

          jQuery.get(this.href, function(response) {
            jQuery(response).prependTo(settings.form_container);
            jQuery(settings.inserted_fieldset).show("drop", { direction: 'left' });

            jQuery(settings.inserted_fieldset).find('.form_close').show();
            jQuery(settings.inserted_fieldset).find('.form_close').live("click", function() {
              jQuery(settings.inserted_fieldset).remove();
              jQuery(settings.show_form).show();

              settings.done();

              return false;
            });
          });

          return false;
        });
      },
      existing: function(options) {
        var defaults = { form_container: '', response_container: '', success: function(){}, error: function(){}, done: function(){} };
        var settings = jQuery.extend(defaults, options);

        jQuery(settings.form_container).find('form').ajaxForm({
          beforeSubmit: function(formData, jqForm, options) {
            jQuery('input[type="submit"]', jqForm).attr('disabled', 'disabled');
          },
          success: function(responseText, statusText) {
            jQuery(settings.response_container).hide();
            jQuery(settings.response_container).empty().append(responseText);

            settings.success();

            jQuery(settings.form_container).find('#form_error').hide();
            jQuery(settings.form_container).find('.fieldWithErrors').removeClass('fieldWithErrors');
            jQuery(settings.form_container).find('input[type="submit"]').removeAttr('disabled');

            jQuery(settings.response_container).show();
            settings.done();
          },
          error: function(XMLHttpRequest, textStatus, errorThrown) {
            jQuery(settings.form_container).replaceWith(XMLHttpRequest.responseText);

            settings.error();

            settings.done();

            brazil.form.existing(options);
          }
        });
      }
    }
  }
}();
