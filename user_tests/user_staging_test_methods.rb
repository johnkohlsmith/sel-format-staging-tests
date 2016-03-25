require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
require 'rmagick'
gem "chromedriver-helper"

# ---- BEGIN NEW ACCOUNT SETUP METHODS ----
# ACCOUNT INFO - generates name & email based on date & time


class Session
    def initialize
        @date = Time.new.strftime("%d%b%Y")
        @time = time=Time.new.strftime("%Hh%Mm%Ss")
        @date_time = date_time=date+time
        @name =  "QA #{date_time}"
        @email = "johns.staging.tester#{date_time}@gmail.com"
    end

    def log
        puts "\nSESSION CREATED\n Date: #{date} \n Time: #{time} \n Name: #{name} \n Email: #{email}"
    end
    attr_reader :date, :time, :date_time, :name, :email
end


# CSV FILE - logs account info, local
def log_to_file(sess_acc)
    File.open('sess_accs.csv', 'a') { |file| file.puts(sess_acc["date"] + ',' + sess_acc["time"] + ',' + sess_acc["name"] + ',' + sess_acc["email"]) }
end

# GOOGLE SHEET - logs account info
def log_to_sheet(sess_acc)
    puts "\n Logging..."
    session = GoogleDrive.saved_session("config.json")
    ws = session.spreadsheet_by_key("1wobNyZYGm1G5gPzC9vM5MxfNBRnZZZEUrV0SmWFtHpI").worksheets[0]
    ws.insert_rows(2,1)
    ws.update_cells(2,1,[[sess_acc["date"],sess_acc["time"],sess_acc["name"],sess_acc["email"]]])
    ws.save
    puts " Logged: https://docs.google.com/spreadsheets/d/1wobNyZYGm1G5gPzC9vM5MxfNBRnZZZEUrV0SmWFtHpI/edit?usp=sharing"
end

# SETUP - runs through all setup methods
def setup()
    sess_acc = account_setup
    log_to_sheet(sess_acc)
    log_to_file(sess_acc)
    return sess_acc
end
# ---- END NEW ACCOUNT SETUP METHODS ----

# SCREENSHOTS - Takes & saves
def screenshot(driver,sess_date_time,shot_num,descr)
    filename = "shot-#{shot_num}-#{driver.current_url.sub("https://format-staging.com/","").gsub("/","-")}-(#{descr})-#{sess_date_time}.png"
    driver.save_screenshot(filename)
    puts (" 📸  #{filename}")
end