CREATE FUNCTION plsix_inline_handler(internal) RETURNS void
    AS '$libdir/plsix'
    LANGUAGE C;

CREATE OR REPLACE LANGUAGE plsix
    HANDLER plsix_handler
    INLINE plsix_inline_handler
    VALIDATOR plsix_validator;
