PL/six Procedural Language Handler for PostgreSQL
================================================

This code is almost *entirely* from Peter Eisentraut <peter@eisentraut.org> and
his project https://github.com/petere/plsh.git PL/sh..
I've just changed the name from 'plsh' to 'plsix', and I want to change it
to properly do execve(2) in order to run '/usr/bin/env perl6'. I've been
playing with this for most of the development cycle.

PL/six is a procedural language handler for PostgreSQL that allows you
to write stored procedures in Perl 6 - this is heavily derived from pl/sh.

A sample stored function looks like:
 
```
CREATE FUNCTION query (x int) RETURNS text  
LANGUAGE plsix
AS $$
#!/path/to/your/perl6
my $x = @ARGS[0];
say "argument is $x";
$$;
```

You'll need to open your own DB connection if you want to do anything,
please see DBIish for that side.

The body of the function will get copied into a /tmp/plsix-XXXXX file and
evaluated by perl6. This should be "#!/usr/bin/env perl6" but I haven't
quite cracked that yet. Arguments are passed in the @ARGS array, so you may
want to play with sub MAIN at some point. Output goes from STDOUT directly
back to Postgres. To return NULL, don't print anything. To throw an error,
warn() or die() as appropriate, or exit with a non-zero status.

Triggers should run, but won't alter rows because the interface doesn't parse
the output back into SQL.

The distribution also contains a test suite in the directory `test/`,
which contains a simplistic demonstration of the functionality.

Peter Eisentraut <peter@eisentraut.org>

Database Access
---------------

You can't access the database directly from PL/sh through something
like SPI, but PL/sh sets up libpq environment variables so that you
can easily call `psql` back into the same database, for example

    CREATE FUNCTION query (x int) RETURNS text
    LANGUAGE plsh
    AS $$
    #!/bin/sh
    psql -At -c "select b from pbar where a = $1"
    $$;

Note: The "bin" directory is prepended to the path, but only if the `PATH` environment variable is already set.

Triggers
--------

In a trigger procedure, trigger data is available to the script
through environment variables (analogous to PL/pgSQL):

* `PLSH_TG_NAME`: trigger name
* `PLSH_TG_WHEN`: `BEFORE`, `INSTEAD OF`, or `AFTER`
* `PLSH_TG_LEVEL`: `ROW` or `STATEMENT`
* `PLSH_TG_OP`: `DELETE`, `INSERT`, `UPDATE`, or `TRUNCATE`
* `PLSH_TG_TABLE_NAME`: name of the table the trigger is acting on
* `PLSH_TG_TABLE_SCHEMA`: schema name of the table the trigger is acting on

Event Triggers
--------------

In an event trigger procedure, the event trigger data is available to
the script through the following environment variables:

* `PLSH_TG_EVENT`: event name
* `PLSH_TG_TAG`: command tag

Inline Handler
--------------

PL/sh supports the `DO` command.  For example:

    DO E'#!/bin/sh\nrm -f /tmp/file' LANGUAGE plsh;

Installation
------------

You need to have PostgreSQL 8.4 or later, and you need to have the
server include files installed.

To build and install PL/sh, use this procedure:

    make
    make install

The include files are found using the `pg_config` program that is
included in the PostgreSQL installation.  To use a different
PostgreSQL installation, point configure to a different `pg_config` like
so:

    make PG_CONFIG=/else/where/pg_config
    make install PG_CONFIG=/else/where/pg_config

Note that generally server-side modules such as this one have to be
recompiled for every major PostgreSQL version (that is, 8.4, 9.0,
...).

To declare the language in a database, use the extension system with
PostgreSQL version 9.1 or later.  Run

    CREATE EXTENSION plsh;

inside the database of choice.  To upgrade from a previous
installation that doesn't use the extension system, use

    CREATE EXTENSION plsh FROM unpackaged;

Use `DROP EXTENSION` to remove it.

With versions prior to PostgreSQL 9.1, use

    psql -d DBNAME -f .../share/contrib/plsh.sql

with a server running.  To drop it, use `droplang plsh`, or `DROP
FUNCTION plsh_handler(); DROP LANGUAGE plsh;` if you want to do it
manually.

Test suite
----------

To run the test suite, execute

    make installcheck

after installation.
