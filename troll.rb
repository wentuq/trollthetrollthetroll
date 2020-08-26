#!/usr/bin/env ruby
require 'watir'
require 'webdrivers'
require_relative 'decipher'

$troll_login       = ENV['TROLLTHETROLL_LOGIN']
$troll_password    = ENV['TROLLTHETROLL_PASSWORD']
$troll_url_main = "https://trollthetroll.net/"

$browser = nil


def browser_init
 $browser = Watir::Browser.start $troll_url_main, :firefox, headless: true
end

def run_browser
    unless $browser
        browser_init()
    end
    unless $browser.exists?
        browser_init()
    end
end

def close_browser
    $browser.close
end

def login
    login_link = $browser.link text: "Log in"
    if login_link.exists?
        login_link.click
        $browser.text_field(id: 'user_login').set $troll_login
        $browser.text_field(id: 'user_password').set $troll_password
        $browser.button(name: 'commit').click
    end
end



def timer
    # return how long should we sleep
    how_long_sleep = 0
    timer = $browser.div(id: 'timer')
    if timer.exists?
        timer_value = timer.child.text
        next_cookie_time = parse_countdown(timer_value)
        wait_extra = rand(30..120)
        puts "Next cookie will be in #{next_cookie_time}seconds but we will wait extra #{wait_extra}sec"
        how_long_sleep = next_cookie_time + wait_extra
    end
    return how_long_sleep
end

def solve
    solve = $browser.element(:xpath => "//form[@id='new_theft']//strong")
    if solve.exists?
        decipher = Decipher.new(solve.text)
        $browser.text_field(id: 'theft_answer').set decipher.execute()
        puts "Solving math: '#{solve.text}' expression is '#{decipher.expression}' and result is '#{decipher.result}'"
        $browser.element(id: 'new_theft').click()
    end
end

def parse_countdown(text)
    # auxiliary function for translating
    # countdown timer in format mm:ss
    # m - minutes, s - seconds to total number of seconds
    # return how many seconds to wait
    match = text.match /(\d{2}):(\d{2})/
    min = match[1].to_i
    sec = match[2].to_i

    total = min*60+sec

    return total
end

# TODO: Best option will be to login first and save browser session
# TODO: Currently, every time we open browser, we need to log in
run_browser()
login()
while(true)
    how_long_sleep = timer()
    if how_long_sleep > 0
        close_browser()
        sleep(how_long_sleep)
        run_browser()
    end
    login()
    solve()
end