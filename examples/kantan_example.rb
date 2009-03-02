require '../lib/kantan-sgf'

# Load and parse
#sgf = KantanSgf::Sgf.new('../data/game-01.sgf')
sgf = KantanSgf::Sgf.new('../data/stoic-bojo.sgf')
sgf.parse

# Pull back properties
puts sgf.player_black
puts sgf.player_white
puts sgf.komi
puts sgf.result

# do some magic with the move hash
#for move in sgf.move_list
#	puts "%s: (%i, %i)" % [move[:color], move[:x], move[:y]]
#end