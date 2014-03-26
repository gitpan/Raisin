Path params
===========
_get/post/put/delete/..._ etc. should take path params;
Don't forget to update DOCS!!!

    get '/suburl' => sub {
      'ok';
    };


Params as a main word
=====================
Start route definition with the `params` keyword like in Grape:

    params [
      requires => ['name', $Raisin::Types::String],
    ],
    get '/suburl' => sub {
        'ok'
    };

---

    params [
      requires => ['name', $Raisin::Types::String],
    ],
    post sub {
        'ok'
    };


Token auth
==========
    * Plack middleware;
    * Raisin plugin;

See Plack::Middleware::Auth::AccessToken.


Output format
=============
    * based on accept content type header;
    * based on path extension;
Path extension should have more priority rather accept header.

