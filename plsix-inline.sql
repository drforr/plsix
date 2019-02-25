CREATE FUNCTION plsix_handler() RETURNS language_handler
    AS '$libdir/plsix'
    LANGUAGE C;

CREATE FUNCTION plsix_inline_handler(internal) RETURNS void
    AS '$libdir/plsix'
    LANGUAGE C;

CREATE FUNCTION plsix_validator(oid) RETURNS void
    AS '$libdir/plsix'
    LANGUAGE C;

CREATE LANGUAGE plsix
    HANDLER plsix_handler
    INLINE plsix_inline_handler
    VALIDATOR plsix_validator;

COMMENT ON LANGUAGE plsix IS 'PL/sh procedural language';
