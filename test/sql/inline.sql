\! mkdir /tmp/plsix-test && chmod a+rwx /tmp/plsix-test

DO E'#!/bin/sh\necho inline > /tmp/plsix-test/inline.out; chmod a+r /tmp/plsix-test/inline.out' LANGUAGE plsix;

\! cat /tmp/plsix-test/inline.out
\! rm -r /tmp/plsix-test
