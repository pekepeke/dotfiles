function HDOC(fn) {
  return (fn).ToString().match(/[^]*\/\*([^]*)\*\/\}$/)[1];
}
