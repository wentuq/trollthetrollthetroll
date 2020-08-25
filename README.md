# Troll the trollthetroll.net

It is a bot that visits [trollthetroll.net](https://trollthetroll.net),
log in automatically, waits for the cookie, if cookie is available,
it solves math captcha ex. "twenty-five minus negative nine" and steals the cookie.
Bot is quite benign, giving a human chance to steal it before him, waiting
some extra time ~60sec before bot eats a cookie.

## How to run?

To run we need to setup environment variables, login and password for
the website, respectively `TROLLTHETROLL_LOGIN` and `TROLLTHETROLL_PASSWORD`

We are using ruby and gems:
 * watir
 * webdrivers
 * number_in_words

 ## Content of files
 
  * `troll.rb` - super simple browser automation, using [watir](http://watir.com/)
  * `decipher.rb` - library for solving math captcha, 
 based on [number_in_words](https://github.com/markburns/numbers_in_words) gem
