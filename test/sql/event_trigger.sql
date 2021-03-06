\! mkdir /tmp/plsix-test && chmod a+rwx /tmp/plsix-test

CREATE FUNCTION evttrigger() RETURNS event_trigger AS $$
#!/bin/sh
(
echo "---"
for arg do
    echo "Arg is '$arg'"
done

printenv | LC_ALL=C sort | grep '^PLSH_TG_'
) >> /tmp/plsix-test/bar
chmod a+r /tmp/plsix-test/bar
exit 0
$$ LANGUAGE plsix;

CREATE EVENT TRIGGER testtrigger ON ddl_command_start
    EXECUTE PROCEDURE evttrigger();

CREATE TABLE test (a int, b text);
DROP TABLE test;

DROP EVENT TRIGGER testtrigger;

\! cat /tmp/plsix-test/bar
\! rm -r /tmp/plsix-test
