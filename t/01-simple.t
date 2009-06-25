use v6;

use Log::Simple;

plan 1;

lives_ok( { Log::Simple::Log.set-log-level($Log::Simple::INFO); } );

# vim: ft=perl6 sw=4 ts=4 noexpandtab

