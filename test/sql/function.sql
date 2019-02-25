CREATE FUNCTION valtest(text) RETURNS text AS 'foo' LANGUAGE plsix;

CREATE FUNCTION shtest (text, text) RETURNS text AS '
#!/bin/sh
echo "One: $1 Two: $2"
if test "$1" = "$2"; then
    echo ''this is an error'' 1>&2
fi
exit 0
' LANGUAGE plsix;

SELECT shtest('foo', 'bar');
SELECT shtest('xxx', 'xxx');
SELECT shtest('null', NULL);


CREATE FUNCTION return_null() RETURNS text LANGUAGE plsix AS '#!/bin/sh';
SELECT return_null() IS NULL;


CREATE FUNCTION self_exit(int) RETURNS void LANGUAGE plsix AS '
#!/bin/sh
exit $1
';
SELECT self_exit(77);


CREATE FUNCTION self_signal(int) RETURNS void LANGUAGE plsix AS '
#!/bin/sh
kill -$1 $$
';
SELECT self_signal(15);


CREATE FUNCTION shell_args() RETURNS text LANGUAGE plsix AS '
#!/bin/sh -e -x
false
true
';
SELECT shell_args();


CREATE FUNCTION shell_args2() RETURNS text LANGUAGE plsix AS '
#!/bin/sh -e  -x';
SELECT shell_args2();


CREATE FUNCTION shell_args3() RETURNS text LANGUAGE plsix AS '
#!/bin/sh ';
SELECT shell_args3();


CREATE FUNCTION perl_concat(text, text) RETURNS text LANGUAGE plsix AS '
#!/usr/bin/perl

print $ARGV[0] . $ARGV[1];
';
SELECT perl_concat('pe', 'rl');
