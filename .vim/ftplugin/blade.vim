"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let b:match_skip = 's:comment\|string'
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words .= ',<?\(php\)\?:?>,' .
  \ '\<@if\>:\<@elseif\>:\<@else\>:\<@endif\>,' .
  \ '\<@unless\>:\<@endunless\>,' .
  \ '\<@foreach\>:\<@endforeach\>,' .
  \ '\<@for\>:\<@endfor\>,' .
  \ '\<@forelse\>:\<@empty\>:\<@endforelse\>,' .
  \ '\<@while\>:\<@endwhile\>,' .
  \ '\<@section\>:\<@show\>:\<@stop\>:\<@overwrite\>:\<@endsection\>,'

let &cpo = s:save_cpo
