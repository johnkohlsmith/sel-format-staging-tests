require 'RMagick'
include Magick

url = "http://www.simplesystems.org/RMagick/doc/struct.html#Pixel"
state = "should-look-cool"
diff = "diff: 35.6%"

message = "  #{url}  \n  #{state}  \n  #{diff}    "
img = Magick::Image.read('cool.png')

diif_shot_info = Draw.new
diif_shot_info.annotate(img[0],0,0,10,10,message) {
    self.font_family = 'Helvetica'
    # self.font = "./Users/johnkohlsmith/Library/Fonts/SourceCodePro-Regular.ttf"
    self.fill = '#ebcb8b'
    self.stroke = 'transparent' # can be 'transparent'
    self.stroke_width = 2
    self.undercolor = 'rgb(43,48,59)'
    self.pointsize = 20
    self.font_weight = 800
    # self.align = LeftAlign
    self.gravity = SouthWestGravity
}
img[0].write("printed-text.png")