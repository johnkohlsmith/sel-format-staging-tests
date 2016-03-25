require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
gem "chromedriver-helper"
require_relative 'test_methods_user_staging'

# WebDriver start
driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

# ---- BEGIN TESTING ----
shot_num = 1
sess_acc = setup()

# Sets window size
driver.manage.window.resize_to(1280, 800)

# Goes to format-staging.com/try 
driver.get "http://www.format-staging.com/try"
# Shot 1
shot_num += screenshot(driver,sess_acc["time"],shot_num,"theme-style-selection")

# Chooses 1st option (Horizon Left) https://format-staging.com/site/dashboard
element = driver.find_element(:css, "a.browser:nth-child(1)").click

# Waits for Registration modal to appear
element = wait.until { driver.find_element(:id => "name") }
# Shot 2
shot_num += screenshot(driver,sess_acc["time"],shot_num,"blank-reg-form")

# Fills out Registation form https://format-staging.com/site/dashboard
element = driver.find_element :id => "name"
element.send_keys sess_acc["name"]
element = driver.find_element :id => "email"
element.send_keys sess_acc["email"]
element = driver.find_element :id => "password"
element.send_keys "123456"
# Shot 3
shot_num += screenshot(driver,sess_acc["time"],shot_num,"filled-reg-form")
element.submit

# Waits until sign up form dissappears
element = wait.until {driver.find_elements(:class, "example_user_signup_form").size == 0}
# Shot 4
shot_num += screenshot(driver,sess_acc["time"],shot_num,"dash-home")

puts "\n\n DONE! \n\n"
# ---- END TESTING ----
# driver.quit

