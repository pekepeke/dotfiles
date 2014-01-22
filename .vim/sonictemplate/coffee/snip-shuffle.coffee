shuffle = (arr)->
  r = Array.apply(null, arr)
  len = r.length
  for v, i in r
    j = Math.floor(Math.random() * len)
    continue if j == i
    tmp = r[j]
    r[j] = r[i]
    r[i] = tmp
  r

