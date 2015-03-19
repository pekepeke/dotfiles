    search_specs = [
        ["name", "~query", "http://xxx?q={0}"]
    ]
    for name, key, url_fmt in search_specs:
        if key in fields:
            query = fields[key].encode('UTF-8')
            url = url_fmt.format(urllib.quote(query))

