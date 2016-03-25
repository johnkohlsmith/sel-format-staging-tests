require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
gem "chromedriver-helper"

# ---- BEGIN NEW ACCOUNT SETUP METHODS ---- #
# ACCOUNT INFO - generates name & email based on date & time
def account_setup()
    date_time = [Time.new.strftime("%d%b%Y"),Time.new.strftime("%Hh%Mm%Ss")]
    sess_acc = {"date" => date_time[0],"time" => date_time[1], "session_id" => "#{date_time[0]}-#{date_time[1]}"}
    puts "\n Date:  #{sess_acc["date"]}\n Time:  #{sess_acc["time"]}\n Session ID:  #{sess_acc["session_id"]}"
    return sess_acc
end

# GOOGLE SHEET - logs account info
def log_to_sheet(sess_acc)
    puts "\n Logging..."
    session = GoogleDrive.saved_session("config.json")
    ws = session.spreadsheet_by_key("1wobNyZYGm1G5gPzC9vM5MxfNBRnZZZEUrV0SmWFtHpI").worksheets[1]
    ws.insert_rows(2,1)
    ws.update_cells(2,1,[[sess_acc["date"],sess_acc["time"],sess_acc["session_id"]]])
    ws.save
    puts " Logged: https://docs.google.com/spreadsheets/d/1wobNyZYGm1G5gPzC9vM5MxfNBRnZZZEUrV0SmWFtHpI/edit?usp=sharing"
end

# SETUP - runs through all setup methods
def setup()
    sess_acc = account_setup
    log_to_sheet(sess_acc)
    return sess_acc
end
# ---- END NEW ACCOUNT SETUP METHODS ---- #

# SCREENSHOTS - Takes & saves
def screenshot(driver,sess_time,shot_num,descr)
    filename = "shot-#{shot_num}-#{driver.current_url.sub("http://","").sub("admin:123@","").gsub("/","-")}-(#{descr})-#{sess_time}.png"
    # driver.save_screenshot ("shot-#{shot_num}-#{driver.current_url.sub("https://format-staging.com/","").gsub("/","-")}-(#{descr})-#{sess_time}.png")
    driver.save_screenshot(filename)
    # puts (" 📸 Shot #{shot_num} (#{driver.current_url})")
    puts (" 📸  #{filename}")
    return 1
end