require 'csv'
require 'yt'

unless ENV['YOUTUBE_API_KEY']
	STDERR.puts 'Youtube API key required!'
	exit 1
end

Yt.configure do |config|
	config.log_level = :debug
	config.api_key = ENV['YOUTUBE_API_KEY']
end

def extract_data(video)
	{
		title: video.title,
		video_link: "https://www.youtube.com/watch?v=#{video.id}",
		channel_link: "http://www.youtube.com/channel/#{video.channel_id}",
	}
end

data = CSV.read('tmp.csv')
	.map { |row| row[1] }
	.flatten
	.map { |id| Yt::Video.new(id: id) }
	.map { |video| extract_data(video) }

CSV.open('out.csv', 'w') do |csv|
	data.map { |d| csv << d.values }
end
