require 'yt'
require 'csv'

unless ENV['YOUTUBE_API_KEY']
	STDERR.puts 'Youtube API key required!'
	exit 1
end

Yt.configure do |config|
	config.log_level = :debug
	config.api_key = ENV['YOUTUBE_API_KEY']
end

topics = [
	'videogame reviews',
	'movie reviews',
	'tv show reviews',
	'music reviews',
]

data = {}
THRESHOLD = 100

def as_struct(video)
	{
		title: video.title,
		description: video.description,
		channel_id: video.channel_id,
		channel_title: video.channel_title,
		video_link: "https://www.youtube.com/watch?v=#{video.id}",
	}
end

topics.each do |topic|
	data[topic] = []
	videos = Yt::Collections::Videos.new.where(q: topic, order: 'viewCount')
	videos.each do |video|
		break if data[topic].size == THRESHOLD
		data[topic] << as_struct(video)
	end
end

Dir.mkdir('results') unless File.exists?('results')
data.keys.each do |topic|
	CSV.open("results/#{topic.gsub(/\s+/, '_')}.csv", 'w') do |csv|
		data[topic].map { |v| csv << v.values }
	end
end
