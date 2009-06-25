module Log::Simple;

class Log-Level {
    has Int $.value;
    has Str $.name;
}

constant Log-Level $ERROR   .= new(value => 0, name => "error");
constant Log-Level $WARNING .= new(value => 1, name => "warning");
constant Log-Level $INFO    .= new(value => 2, name => "info");
constant Log-Level $DETAIL  .= new(value => 3, name => "detail");

my Log-Level $log-level = $WARNING;
my IO @log-handles = ( $*OUT );

role LogRoutine {
    has $handle;
}

class Log {
    method error(*@message)   {}
    method warning(*@message) {}
    method info(*@message)    {}
    method detail(*@message)  {}

    &error   := method(*@message) { } but (0, "error",   LogRoutine);
    &warning := method(*@message) { } but (1, "warning", LogRoutine);
    &info    := method(*@message) { } but (2, "info",    LogRoutine);
    &detail  := method(*@message) { } but (3, "detail",  LogRoutine);

    method do-log(*@message) {
        @log-handles>>.say(@message);
    }

    method do-nothing() { }

    method set-log-level(Log-Level $level) {
        $log-level = $level;
        
        for self.^methods -> $m {
            if $m ~~ LogRoutine {
                if $level.value <= +$m {
                    defined $m.handle and next;
                    $m.handle = $m.wrap( sub(*@message) { $.do-log(@message) } );
                }
                else {
                    defined $m.handle and $m.handle.restore;
                }
            }
        }
    }
}

Log.set-log-level($WARNING);

# vim: ft=perl6 sw=4 ts=4 noexpandtab

