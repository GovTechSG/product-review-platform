LetterAvatar.setup do |config|
  config.fill_color        = 'rgba(255, 255, 255, 0.65)' # default is 'rgba(255, 255, 255, 0.65)'
  config.cache_base_path   = 'public/uploads'            # default is 'public/system'
  config.colors_palette    = :iwanthue                   # default is :google
  config.weight            = 500                         # default is 300
  config.annotate_position = '-0+10'                     # default is -0+5
  config.letters_count     = 1                           # default is 1
  config.pointsize         = 70                          # default is 140
end