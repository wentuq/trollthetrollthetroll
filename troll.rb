#!/usr/bin/env ruby
require 'watir'
require 'webdrivers'
require_relative 'decipher'

$troll_login       = ENV['TROLLTHETROLL_LOGIN']
$troll_password    = ENV['TROLLTHETROLL_PASSWORD']
$troll_url_main = "https://trollthetroll.net/"

$browser = Watir::Browser.new :firefox, headless: true
$browser.goto $troll_url_main

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
    timer = $browser.div(id: 'timer')
    if timer.exists?
        timer_value = timer.child.text
        next_cookie_time = parse_countdown(timer_value)
        wait_extra = rand(30..120)
        puts "Next cookie will be in #{next_cookie_time}seconds but we will wait extra #{wait_extra}sec"
        sleep (next_cookie_time + wait_extra)
    end
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

# TODO: Best option will be to login first, save browser cookies to remember session
# TODO: if times counts, switch off  the browser to save resources and then wake up again,
# TODO: switch on browser steal cookie(real cookie) and start again.
login()
while(true)
    timer()
    solve()
end