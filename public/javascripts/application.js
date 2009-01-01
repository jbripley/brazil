// Brazil namespace

jQuery.ajaxSetup({dataType: 'html'})

jQuery.brazil = {
  move: {
    scrollable: function(id) {
      var scrollablePos = $(id).position();
      
      $(window).scroll(function() {
        var bodyTop = $(document).scrollTop();
        var scrollableHeight = $(id).outerHeight();
        var endOfPagePos = $('body').outerHeight();

        if(endOfPagePos <= (bodyTop + scrollableHeight))
        {
          // Stop moving / scrolling element
        }
        else if(bodyTop > scrollablePos.top)
        {
          $(id).css({position:"absolute", top: bodyTop, left: scrollablePos.left});
        }
        else
        {
          $(id).css({position:"absolute", top: scrollablePos.top, left: scrollablePos.left});
        }
      });
    }
  },
  flash: {
    notice: function() {
      $.get('/flash/notice', function(response) {
        $('#notice').hide().empty().append(response).fadeIn('slow', function() {
          setTimeout('$("#notice").fadeOut()', 3000);
        });
      });
    },
    discard: function() {
      $.get('/flash/notice', function() {
      });
    }
  },
  manipulate: {
    syntax_highlight: function() {
      dp.SyntaxHighlighter.ClipboardSwf = '/javascripts/syntaxhighlighter/clipboard.swf';
      dp.SyntaxHighlighter.HighlightAll('code');
    },
    expand: function(options) {
      var defaults = { expand_button: '', collapse_button: '', expand_container: '' };
      var settings = jQuery.extend(defaults, options);

      $(settings.expand_button).click(function() {
        $.get(this.href, function(response) {
          $(settings.expand_button).parents(settings.expand_container).replaceWith(response);
        });

        return false;
      });
    }
  },
  form: {
    simple: function(options) {
      var defaults = { show_form: '', before_display_form: function(){}, display_form: function(){}, setup_form: function(){}, form_hide: function(){} };
      var settings = jQuery.extend(defaults, options);

      $(settings.show_form).click(function() {
        settings.before_display_form();

        $.get(this.href, function() {
          settings.display_form();

          settings.setup_form();
          
          settings.form_hide();
        });

        return false;
      });
    },
    insert_only: function(options) {
      var defaults = { show_form: '', form_container: '', inserted_fieldset: '', done: function(){} };
      var settings = jQuery.extend(defaults, options);
      
      $(settings.show_form).click(function() {
        $(this).hide();

        $.get(this.href, function(response) {
          $(response).prependTo(settings.form_container);
          $(settings.inserted_fieldset).show("drop", { direction: 'left' });

          $(settings.inserted_fieldset).find('.form_close').show();
          $(settings.inserted_fieldset).find('.form_close').click(function() {
            $(settings.inserted_fieldset).remove();
            $(settings.show_form).show();
            
            settings.done();
            
            return false;
          });
        });

        return false;
      });
    },
    insert: function(options) {
      var defaults = { show_form: '', form_container: '', inserted_fieldset: '', response_container: '', success: function(){}, error: function(){}, done: function(){} };
      var settings = jQuery.extend(defaults, options);
      
      $(settings.show_form).click(function() {
        $(this).hide();

        $.get(this.href, function(response) {
          $(response).prependTo(settings.form_container);
          $(settings.inserted_fieldset).show("drop", { direction: 'left' });

          $(settings.inserted_fieldset).find('form').ajaxForm({
            beforeSubmit: function(formData, jqForm, options) {
              $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
            },
            success: function(responseText, statusText) {
              $(settings.inserted_fieldset).remove();

              $(settings.response_container).hide();
              $(settings.response_container).empty().append(responseText);

              settings.success();

              settings.done();

              $(settings.show_form).show();
              $(settings.response_container).show();
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
              $(settings.inserted_fieldset).replaceWith(XMLHttpRequest.responseText);

              settings.error();

              settings.done();
            }
          });
          
          $(settings.inserted_fieldset).find('.form_close').show();
          $(settings.inserted_fieldset).find('.form_close').click(function() {
            $(settings.inserted_fieldset).remove();
            $(settings.show_form).show();
            
            settings.done();
            
            return false;
          });
        });

        return false;
      });
    },
    inline: function(options) {
      var defaults = { show_form: '', form_container: '', success: function(){}, error: function(){}, done: function(){} };
      var settings = jQuery.extend(defaults, options);
      
      $(settings.show_form).click(function() {
        var show_form = this;
        $.get(this.href, function(response) {
          var form_container = $(show_form).parents(settings.form_container);
          form_container.empty().append(response);

          form_container.find('form').ajaxForm({
            beforeSubmit: function(formData, jqForm, options) {
              $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
            },
            success: function(responseText, statusText) {
              form_container.replaceWith(responseText);
              
              settings.success();
              
              settings.done();
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
              form_container.empty().append(XMLHttpRequest.responseText);
              
              settings.error();
              
              settings.done();
            }
          });

          $(settings.inserted_fieldset).find('.form_close').show();
          $(settings.inserted_fieldset).find('.form_close').click(function() {
            $.get(form_container.children('form').attr('action'), function(response) {
              form_container.replaceWith(response);
              
              settings.done();
            });
            return false;
          });
        });

        return false;
      });
    },
    existing: function(options) {
      var defaults = { form_container: '', response_container: '', success: function(){}, error: function(){}, done: function(){} };
      var settings = jQuery.extend(defaults, options);
      
      $(settings.form_container).find('form').ajaxForm({
        beforeSubmit: function(formData, jqForm, options) {
          $('input[type="submit"]', jqForm).attr('disabled', 'disabled');
        },
        success: function(responseText, statusText) {
          $(settings.response_container).hide();
          $(settings.response_container).empty().append(responseText);
          
          settings.success();

          $(settings.form_container).find('#form_error').hide();
          $(settings.form_container).find('input[type="submit"]').removeAttr('disabled');
          
          settings.done();
          $(settings.response_container).show();
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) {
          $(settings.form_container).replaceWith(XMLHttpRequest.responseText);
          
          settings.error();
          
          settings.done();
        }
      });
    }
  }
};