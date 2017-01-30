
window do
  %w[a z x c v w t].each do |key|
    remap "Win-#{key}", to: "C-#{key}"
  end
end

window class_only: ['google-chrome'] do
  %w[f l].each do |key|
    remap "Win-#{key}", to: "C-#{key}"
  end
end
