function getClass(o) {
    return Object.prototype.toString.call(o).match(/^\[object\s(.*)\]$/)[1];
}

function isArray(o) {
    return Object.prototype.toString.call(o) === '[object Array]';
}

function isDate(o) {
    return Object.prototype.toString.call(o) === '[object Date]';
}

