TruncateHtml.configure do |config|
  config.length        = 160
  config.omission      = '...'
  config.word_boundary = /\S([\.\?\!]|\z)/
end
