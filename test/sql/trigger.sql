\! mkdir /tmp/plsix-test && chmod a+rwx /tmp/plsix-test

CREATE FUNCTION shtrigger() RETURNS trigger AS $$
#!/bin/sh
(
echo "---"
for arg do
    echo "Arg is '$arg'"
done

printenv | LC_ALL=C sort | grep '^PLSH_TG_'
) >> /tmp/plsix-test/foo
chmod a+r /tmp/plsix-test/foo
exit 0
$$ LANGUAGE plsix;

CREATE TABLE pfoo (a int, b text);

CREATE TRIGGER testtrigger AFTER INSERT ON pfoo
    FOR EACH ROW EXECUTE PROCEDURE shtrigger('dummy');

CREATE TRIGGER testtrigger2 BEFORE UPDATE ON pfoo
    FOR EACH ROW EXECUTE PROCEDURE shtrigger('dummy2');

CREATE TRIGGER testtrigger3 AFTER DELETE ON pfoo
    FOR EACH STATEMENT EXECUTE PROCEDURE shtrigger('dummy3');

CREATE TRIGGER testtrigger4 AFTER TRUNCATE ON pfoo
    FOR EACH STATEMENT EXECUTE PROCEDURE shtrigger('dummy4');

INSERT INTO pfoo VALUES (0, null);
INSERT INTO pfoo VALUES (1, 'one');
INSERT INTO pfoo VALUES (2, 'two');
INSERT INTO pfoo VALUES (3, 'three');

UPDATE pfoo SET b = 'oneone' WHERE a = 1;

DELETE FROM pfoo;

TRUNCATE pfoo;

\! cat /tmp/plsix-test/foo
\! rm -r /tmp/plsix-test
