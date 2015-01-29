StringUtil =
  hanKana2ZenKana: (s = "") ->
    s = s.replace /([\uff66-\uff9c]\uff9e)|([\uff8a-\uff8e]\uff9f)|([\uff61-\uff9f])/g, (ch) ->
      txt = "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜｦﾝｧｨｩｪｫｬｭｮｯ､｡ｰ｢｣ﾞﾟ"
      zen = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヲンァィゥェォャュョッ、。ー「」"
      zen += "　　　　　ガギグゲゴザジズゼゾダヂヅデド　　　　　バビブベボ　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　"
      zen += "　　　　　　　　　　　　　　　　　　　　　　　　　パピプペポ　　　　　　　　　　　　　　　　　　　　　　　　　　　　　"

      c = ch.charAt(0)
      cnext = ch.charAt(1)
      n = txt.indexOf(c, 0)
      nnext = txt.indexOf(cnext, 0)
      if (n >= 0)
        if (nnext == 60)
          return zen.charAt(n + 60)
        else if (nnext == 61)
          return zen.charAt(n + 120);
        return c = zen.charAt(n);
      if ((n != 60) && (n != 61))
        return c
    s

  zenHira2ZenKana: (s = "") ->
    s.replace /[\u3041-\u3096]/g, (ch) ->
      chr = ch.charCodeAt(0) + 0x60;
      String.fromCharCode(chr)

  zenAlnum2HanAlnum: (s = "") ->
    s.replace /[\uFF01-\uFF60]/g, (ch) ->
      chr = ch.charCodeAt(0) - 0xFEE0;
      String.fromCharCode(chr)

