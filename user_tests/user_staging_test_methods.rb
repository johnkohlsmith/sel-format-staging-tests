require 'rubygems'
require 'selenium-webdriver'
require "google/api_client"
require "google_drive"
require 'rmagick'
include Magick
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
        puts "\nSESSION\n  #{date} #{time} \n  Name: #{name} \n  Email: #{email}\n\n"
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
    actual_url = driver.current_url
    cleaned_url = "#{driver.current_url.sub("https://format-staging.com/","").gsub("/","-")}"
    filename = "shot-#{shot_num}-#{cleaned_url}-(#{descr})-#{sess_date_time}.png"
    driver.save_screenshot("./session_shots/#{filename}")
    # puts (" 📸  #{filename}")

    puts "\STEP #{shot_num} \n  #{actual_url} - #{descr}"

# diff checking
    masters = Dir["./masters/*"]
    shot =  Magick::Image.read("./session_shots/#{filename}")
    mastershot =  Magick::Image.read(masters[shot_num - 1])
    puts "  📸  #{filename} \n  🖼  #{masters[shot_num - 1].sub("./masters/","")}"
    diff_img, diff_metric  = shot[0].compare_channel( mastershot[0], Magick::MeanSquaredErrorMetric )    
    diff_metric = (diff_metric * 10000).round(2)
    if diff_metric >= 10 # % 
        puts "  Diff: #{(diff_metric)}% 😱"
        diff_message = "  URL   #{actual_url}  \n  State  #{descr}  \n  Diff   #{diff_metric}%  "
        diff_shot_info = Draw.new
        diff_shot_info.annotate(diff_img,0,0,10,10,diff_message) {
            self.font_family = 'Helvetica'
            self.fill = '#ebcb8b'
            self.stroke = 'transparent' # can be 'transparent'
            self.stroke_width = 2
            self.undercolor = 'rgb(43,48,59)'
            self.pointsize = 20
            self.font_weight = 800
            self.gravity = SouthWestGravity
        }
        # img[0].write("printed-text.png")
        diff_img.write("./session_shots/DIFF-#{filename}")
        puts "  Diff image saved 💾"
    else
        puts "  Diff: #{(diff_metric)}% 👍" 
    end

    # Step separator
    puts "\n"

end