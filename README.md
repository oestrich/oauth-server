# Sample OAuth 2.0 Server

This is a sample OAuth 2.0 server that I wrote after reading through the [spec](http://tools.ietf.org/html/rfc6749#section-4.1.2).

## Startup

    $ rake db:create db:migrate db:seed 
    $ # save the two outputted values for `oauth-example/.env`
    $ rails s --port 5001

    $ cd oauth-example
    $ vim .env # place client values here
    $ rails s --port 5000
