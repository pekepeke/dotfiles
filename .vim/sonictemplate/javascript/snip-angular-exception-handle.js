myApp.factory("$exceptionHandler", function () {
    return function (exception, cause) {
        console.log(exception.message);
        var msg = "エラーが発生しました。";
        alert(msg);
    };
});
