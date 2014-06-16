
Types
=====
Use Type::Tiny instead of my own type system.

Tests
=====
Parameters coercion:
  in: `Content-type`, `extension` -> JSON, YAML, form/data;
  out: `Accept`, `extension` -> JSON, YAML, TEXT;

Make test application and store it in `t/`.

Backlog
=======
* keyword `declared` applicable to `param`;
* token auth:
  * Plack middleware;
  * Raisin plugin;
  See Plack::Middleware::Auth::AccessToken.

---

DONE: Default logger
==============
Default logger: -> STDERR

DONE: Input format
============
  * accept params in JSON or YAML accoring to format;

DONE: Output format
=============
Path extension should have more priority rather accept header.
  * based on accept content type header;
  * based on path extension;

DONE: Raisin script
-------------------
  * version
  * list routes [simple]

    GET  /users
    GET  /users/all
    POST /users

  * list routes [detailed]

    GET /users
      optional: id, Type::Integer
      optional: start, Type::Integer, default: 0
      optional: count, Type::Integer, default: 10

DONE: FIX params keyword
------------------------
1) rename to param (singular);
2) w/o argument return hash ref of all values;
3) w/ argrument return param by argument name or undef if not exists;

    my $first_name = params('first_name'); # 'John'
    my $all_params = params(); # { first_name => 'John', last_name => 'Smith' }

DONE: Refactor Types
--------------------
Types should be a class with a `Raisin::Types::Base` parent.
Example of an Integer type:

    package Raisin::Types::Integer;
    use base 'Raisin::Types::Base';

    has constraint => sub {
      length($v) <= 10 ? 1 : 0
    };

    has coercion => sub {
      my $v = shift;
      $$v = sprintf 'INT:%d', $$v;
    };

Make changes in `Raisin::Routes::Endpoint` to use a regex from types.
Implement simple attributes class.

Base class `Raisin::Types::Base` should be something like this:

    package Raisin::Types::Base;

    use strict;
    use warnings;

    sub import {
      # import strict, warnings, has;
    }

    sub new {
      my ($class, $value) = @_;
      my $self = bless {}, $class;

      ($self->{type}) = $class =~ /::(.+)$/;

      if ($self->regex) {
        ($self->regex =~ $value) or return;
      }

      $self->check($value) or return;
      $self->in(\$value);
      1;
    }

    has regex => undef;
    has check => sub { 1 };
    has in => sub { 1 };

    1;

Do not forget to update DOCS!!!

DONE: Path params
-----------------
_get/post/put/delete/..._ etc. should take path params;
Don't forget to update DOCS!!!

    get '/suburl' => sub {
      'ok';
    };

DONE: Params as a main word
---------------------------
Start route definition with the `params` keyword like in Grape:

    params [
      requires => ['name', $Raisin::Types::String],
    ],
    get '/suburl' => sub {
        'ok'
    };

- - -

    params [
      requires => ['name', $Raisin::Types::String],
    ],
    post sub {
        'ok'
    };
