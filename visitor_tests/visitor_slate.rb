require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
gem "chromedriver-helper"

require_relative 'visitor_staging_test_methods'

# WebDriver start
driver = Selenium::WebDriver.for :chrome
driver.manage.timeouts.implicit_wait = 10 # seconds
wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds

# ---- BEGIN TESTING ---- #
shot_num = 1
sess_info = setup()
# puts "\n Screenshots..."

# Sets window size
driver.manage.window.resize_to(1280, 800)

# Goes to format-staging.com/try 
driver.get "http://admin:123@slate7777.format-staging.com"
# driver.get "http://slate7777.format-staging.com"

# Shot 1
puts "\n Screenshots..."
shot_num += screenshot(driver,sess_info["time"],shot_num,"home-top")

# Srolls to thumbnail area
element = driver.find_element(:class, "main-lower")
driver.action.move_to(element, 0, 0).perform

# Shot 2
puts "\n Screenshots..."
shot_num += screenshot(driver,sess_info["time"],shot_num,"home-thumbs")

# Srolls to footer area
element = driver.find_element(:tag_name, "footer")
driver.action.move_to(element, 0, 0).perform

# Shot 3
puts "\n Screenshots..."
shot_num += screenshot(driver,sess_info["time"],shot_num,"home-footer")



puts "\n\n DONE! \n\n"
# ---- END TESTING ---- #
# driver.quit