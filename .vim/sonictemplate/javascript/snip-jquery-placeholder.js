$.fn.placeholder = function(options){
    options = typeof options !== "string" ? options : {
        attr : options
    };
    var setting = $.extend({
        attr : 'title'
      , labelClass : 'label'
    }, options);
    $(this).each(function() {
        var $this = $(this)
          , $parent = $this.parent()
          , attr_name = $this.attr(setting.attr);

        if ($.isEmptyObject(attr_name)) {
            return;
        }
        $parent.css({ position: 'relative' });
        var label = $this.attr(attr_name)
          , pos = $this.position();

        $this.removeAttr(attr_name);
        var $label = $('<span />')
            .append(label)
            .addClass(setting.labelClass)
            .css({
                position: 'absolute'
              , top: pos.top + 6
              , left: pos.left + 7
              , zIndex: 100
              , color: '#666'
            }).appendTo($parent);
        if ($this.val()) {
            $label.hide();
        }

        $label.click(function() {
            $(this).hide();
            $this.focus();
        });
        $this.focus(function(){
            $label.hide();
        }).blur(function(){
            if ($(this).val().length > 0) {
                $label.show();
            }
        });
    });
    return this;
};
