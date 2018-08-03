# post json to wiki on a schedule
# usage: */5 * * * * (cd wiki/context-map-data; ruby post.rb)

@now = Time.new
@log = []


def post slug
  @log << [@now.hour, @now.min, slug].inspect
  type = '-H "Content-Type: application/json"'
  key = '-H "X-Api-Key:35ece947aa90b582"'
  endpoint = "http://context.asia.wiki.org/plugin/json/#{slug}"
  @log << `cat data/#{slug} | curl -s -X PUT -d @- #{type} #{key} #{endpoint}`
end

def write data, offeset, mode
  File.open("logs/log.#{(@now.wday+offeset)%7}.txt",mode) do |file|
    file.puts data.join("\n")
  end
end

    

post('organization-chart') if [@now.hour, @now.min] == [6, 10]
post('source-code-control') if ([9,10,11,13,14,15,16].include? @now.hour) && (rand(100) < 20)
post('dataflow-diagram') if [@now.hour, @now.min] == [8, 40] && (rand(100) < 20)
post('service-traffic-reports') if rand(100) < 95

write @log, 0, 'a'
sleep 1
write [], 1, 'w'
