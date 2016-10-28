function safeNormalizeNfc(str) {
  var re = /[^\u{0340}\u{0341}\u{0343}\u{0344}\u{0374}\u{037E}\u{0387}\u{0958}-\u{095F}\u{09DC}\u{09DD}\u{09DF}\u{0A33}\u{0A36}\u{0A59}-\u{0A5B}\u{0A5E}\u{0B5C}\u{0B5D}\u{0F43}\u{0F4D}\u{0F52}\u{0F57}\u{0F5C}\u{0F69}\u{0F73}\u{0F75}\u{0F76}\u{0F78}\u{0F81}\u{0F93}\u{0F9D}\u{0FA2}\u{0FA7}\u{0FAC}\u{0FB9}\u{1F71}\u{1F73}\u{1F75}\u{1F77}\u{1F79}\u{1F7B}\u{1F7D}\u{1FBB}\u{1FBE}\u{1FC9}\u{1FCB}\u{1FD3}\u{1FDB}\u{1FE3}\u{1FEB}\u{1FEE}\u{1FEF}\u{1FF9}\u{1FFB}\u{1FFD}\u{2000}\u{2001}\u{2126}\u{212A}\u{212B}\u{2329}\u{232A}\u{2ADC}\u{F900}-\u{FAFF}\u{FB1D}\u{FB1F}\u{FB2A}-\u{FB36}\u{FB38}-\u{FB3C}\u{FB3E}\u{FB40}\u{FB41}\u{FB43}\u{FB44}\u{FB46}-\u{FB4E}\u{1D15E}-\u{1D164}\u{1D1BB}-\u{1D1C0}\u{2F800}-\u{2FA1F}]+/gu;
  if (str.normalize) {
    return str.replace(re,function(r){
      return r.normalize('NFC');
    });
  }
  return str;
}

