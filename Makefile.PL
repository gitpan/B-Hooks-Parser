use strict;
use warnings;
use inc::Module::Install;
use ExtUtils::Depends;

name 'B-Hooks-Parser';
all_from 'lib/B/Hooks/Parser.pm';

requires 'parent';
requires 'B::Hooks::OP::Check';
test_requires 'Test::Exception';
test_requires 'B::Hooks::EndOfScope';
build_requires 'B::Hooks::OP::Check';
configure_requires 'ExtUtils::Depends' => 0.302; #minimum version that works on Win32+gcc
configure_requires 'B::Hooks::OP::Check' => '0.18';
#minimum version that depends on ExtUtils::Depends 0.302

my $pkg = ExtUtils::Depends->new('B::Hooks::Parser', 'B::Hooks::OP::Check');
$pkg->install('hook_parser.h');
$pkg->add_xs('Parser.xs');
$pkg->add_pm('lib/B/Hooks/Parser.pm' => '$(INST_LIB)/B/Hooks/Parser.pm');

mkdir 'build';
$pkg->save_config('build/IFiles.pm');

makemaker_args(
    $pkg->get_makefile_vars,
    dist => { preop => 'pod2text lib/B/Hooks/Parser.pm > README' },
    FUNCLIST => [ qw/hook_parser_setup hook_parser_teardown hook_parser_get_linestr
        hook_parser_get_linestr_offset hook_parser_set_linestr hook_parser_get_lex_stuff
        hook_parser_clear_lex_stuff hook_toke_skipspace hook_toke_scan_str hook_toke_scan_word
        /,
        'boot_B__Hooks__Parser',
    ],
);

auto_set_repository;
bugtracker 'http://rt.cpan.org/Public/Dist/Display.html?Name=B-Hooks-Parser';

extra_tests;

WriteAll;
