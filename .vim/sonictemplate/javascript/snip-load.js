var bootstrap = function(event) {
    if (event && event.type == "pageshow") {
        if (!event.originalEvent.persisted) {
            return ;
        }
    }
};
$(bootstrap);
$(window).bind("pageshow", bootstrap);

