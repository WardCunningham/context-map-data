require 'json'

@width = [3, 4, 2, 4, 0]
@staff = []
@teams = {}

def json file 
  JSON.parse File.read(file, :encoding => 'utf-8')
end

@lastnames = json('ref/lastnames.json')
@algorithms = json('ref/algorithms.json')

def any list
  list[rand(list.size)]
end

def person manager=nil
  # https://en.wikipedia.org/wiki/List_of_most_common_surnames_in_North_America#United_States_.28American.29
  f = any 'ABCDEFGHIJKLMNOPRSTW'.split //
  m = any 'ABCDEFGHIJKLMNOPRSTW'.split //
  l = any @lastnames
  @staff << {name: "#{f}. #{m}. #{l}", email: "#{f}#{m}#{l}@email.com".downcase, manager: manager}
  @staff.last
end

def project manager, team
  greek =['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Xi', 'Omicron', 'Pi', 'Rho', 'Sigma', 'Tau', 'Upsilon', 'Phi', 'Chi', 'Psi', 'Omega']
  prefix = any greek
  programs = (1..any([3,4,5,6])).map{a = any @algorithms; {name: "#{prefix} #{a['name']}", description: a['description'], team: team}}
  {project: "#{prefix} #{any greek}", manager: manager, programs: programs}
end

def staff depth, boss
  @width[depth].times do
    peep = person boss[:email]
    @teams[peep[:email]]=[] if depth == @width.size-3
    @teams[peep[:manager]]<< peep[:email] if depth == @width.size-2
    staff depth+1, peep
  end
end

def save name, data
  File.open "data/#{name}", 'w' do |file|
    file.puts JSON.pretty_generate data
  end
end

staff 0, person
save 'organization-chart', @staff
save 'source-code-control', @teams.map {|manager, team| project manager, team}
