<?php

class <%= substitute(substitute(expand('%:p:t:r'), '\(^.\)', '\u\1', ''), '_\(.\)', '\u\1', 'g') %>
{
    public function __construct()
    {
    }
}
