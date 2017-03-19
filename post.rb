# post json to wiki on a schedule
# usage: */5 * * * * (cd wiki/context-map-data; ruby post.rb)

now = Time.new

p [now.hour, now.min]

def post slug
  type = '-H "Content-Type: application/json"'
  key = '-H "X-Api-Key:35ece947aa90b582"'
  endpoint = "http://context.asia.wiki.org/plugin/json/#{slug}"
  puts `cat data/#{slug} | curl -s -X PUT -d @- #{type} #{key} #{endpoint}`
end
    

post('organization-chart') if [now.hour, now.min] == [16, 20]
post('source-code-control') if ([9,10,11,13,14,15,16].include? now.hour) && (rand(100) < 20)