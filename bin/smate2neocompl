#!/usr/bin/env perl
use Path::Class;

main();
exit;

sub main {
    my $dir = dir(".");
    my $output_dir = dir("neocomplcache");
    $output_dir->mkpath;

    while ( my $lang_dir = $dir->next ) {
        next if -f $lang_dir;
        next if $lang_dir =~ /\.+/;
        next if $lang_dir =~ /neocomplcache/;
        my $snippet = merge_snippets($lang_dir);
        my $lang    = $lang_dir->relative;
        write_snippet( $lang, $snippet, $output_dir );
    }
}

sub write_snippet {
    my ( $lang, $snippet, $output_dir ) = @_;
    my $file = file( $output_dir, "${lang}.snip" );
    my $fh = $file->openw;
    $fh->print($snippet);
    $fh->close;
}

sub merge_snippets {
    my $snippet_dir_by_lang = shift;
    my $output              = "";
    while ( my $snippet = $snippet_dir_by_lang->next ) {
        next unless -f $snippet;
        $output .= make_snippet_template($snippet);
    }
    $output;
}

sub make_snippet_content {
    my $file            = shift;
    my $snippet_content = "";
    foreach my $line ( $file->slurp ) {
        $snippet_content .= "    ${line}";
    }
    $snippet_content;
}

sub make_snippet_template {
    my $file             = shift;
    my $snippet_name     = snippet_name($file);
    my $snippet_content  = make_snippet_content($file);
    my $snippet_template = "snippet ${snippet_name}\n${snippet_content}\n";
    $snippet_template;
}

sub snippet_name {
    my $file         = shift;
    my $snippet_name = $file->basename;
    $snippet_name =~ s/\.snippet//;
    $snippet_name;
}
