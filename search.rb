require 'watir'
require 'csv'

browser = Watir::Browser.new
browser.goto('https://www.youtube.com')
first_video = browser.div(id: 'content')
first_video.wait_until(&:exists?)
first_video.click

TOTAL_VIDS = 5

data = []
TOTAL_VIDS.times do
	browser.element(css: 'h1.title').wait_until(&:exists?)
	title = browser.title.gsub('- YouTube', '').chomp
	id = browser.url.gsub('https://www.youtube.com/watch?v=', '')
	data << { title: title, video_id: id }
	browser.span(id: 'video-title').click
	sleep 1
end

CSV.open('tmp.csv', 'a') do |csv|
	data.each { |d| csv  << d.values }
end
