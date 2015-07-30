set_include_path(implode(PATH_SEPARATOR, array(
    get_include_path(),
    dirname(__FILE__).'/lib',
)));

