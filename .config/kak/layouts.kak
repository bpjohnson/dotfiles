# ╭─────────────╥──────────────────╮
# │ Author:     ║ File:            │
# │ Andrey Orst ║ layouts.kak      │
# ╞═════════════╩══════════════════╡
# │ Insert mode layout switcher    │
# ╞════════════════════════════════╡
# │ Rest of .dotfiles:             │
# │ GitHub.com/andreyorst/dotfiles │
# ╰────────────────────────────────╯

declare-option -hidden str layout "us"

define-command -docstring "toggle-layout: toggle between keyboard layouts in insert mode only" \
toggle-layout %{ evaluate-commands %sh{
    perl -Mutf8 -CS -e 'use strict;
        use utf8;
        my $us_qwerty = q{`~@#$^&|qQwWeErRtTyYuUiIoOpP[{]}aAsSdDfFgGhHjJkKlL;:''"zZxXcCvVbBnNmM,<.>/?};
        my $ru_jcuken = q{ёЁ"№;:?/йЙцЦуУкКеЕнНгГшШщЩзЗхХъЪфФыЫвВаАпПрРоОлЛдДжЖэЭяЯчЧсСмМиИтТьЬбБюЮ.,};
        my $map;

        if ($ENV{"kak_opt_layout"} eq "us") {
            $map = "map";
            print "set-option global layout ru\n";
        } else {
            $map = "unmap";
            print "set-option global layout us\n";
        }

        for my $key (split //, $us_qwerty) {
            $_ = $key;
            eval sprintf "tr/%s/%s/", map quotemeta, $us_qwerty, $ru_jcuken;
            print "$map global insert -- %🦀$key🦀 %🦀$_🦀\n"
        }'
}}

map global normal '' ': toggle-layout<ret>'
map global insert '' '<a-;>: toggle-layout<ret>'

