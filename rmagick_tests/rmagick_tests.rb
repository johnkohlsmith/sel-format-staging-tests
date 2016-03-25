require 'rmagick'

img1 =  Magick::Image.read('cool.png')
img2 =  Magick::Image.read('cool2.png')

diff_img, diff_metric  = img1[0].compare_channel( img2[0], Magick::MeanSquaredErrorMetric )

# diff_img is a cool feature - an image showing which pixels are different

# diff_metric == 0.0 for "no difference"

diff_img.write('cool-combined.png')
