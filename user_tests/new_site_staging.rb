require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
gem "chromedriver-helper"
require_relative 'user_staging_test_methods'

# WebDriver start
driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

#maybe add URLs to array?
# urls = ["http://www.format-staging.com/try",""]

$shot_num = 0
sess = Session.new
sess.log

# ---- BEGIN TESTING ---- #
# Sets window size
driver.manage.window.resize_to(1280, 800)

# Goes to format-staging.com/try 
driver.get "http://www.format-staging.com/try"

# Shot 1
puts "\n Screenshots..."
$shot_num += 1
descr = "theme-style-selection"
screenshot(driver,sess.date_time,$shot_num,descr)
# driver.save_screenshot("lskadjflsf.png")


# Chooses 1st option (Horizon Left) https://format-staging.com/site/dashboard
element = driver.find_element(:css, "a.browser:nth-child(1)").click

# Waits for Registration modal to appear
element = wait.until { driver.find_element(:id => "name") }
# Shot 2
$shot_num += 1
descr = "blank-reg-form"
screenshot(driver,sess.date_time,$shot_num,descr)

# Fills out Registation form https://format-staging.com/site/dashboard
element = driver.find_element :id => "name"
element.send_keys sess.name
element = driver.find_element :id => "email"
element.send_keys sess.email
element = driver.find_element :id => "password"
element.send_keys "123456"
# Shot 3
$shot_num += 1
descr = "filled-reg-form"
screenshot(driver,sess.date_time,$shot_num,descr)

element.submit

# Waits until sign up form dissappears
element = wait.until {driver.find_elements(:class, "example_user_signup_form").size == 0}
# Shot 4
$shot_num += 1
descr = "dash-home"
screenshot(driver,sess.date_time,$shot_num,descr)

puts "\n\n DONE! \n\n"
# ---- END TESTING ---- #
# driver.quit

