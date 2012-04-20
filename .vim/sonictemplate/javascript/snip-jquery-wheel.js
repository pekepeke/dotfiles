$(window).add(document).on('mousewheel', function(e) {
    $(window).scrollTop(
        $(window).scrollTop() + 5 * (e.originalEvent.wheelDeltaY <= 0 ? 1 : -1)
    );
    e.preventDefault();
});

