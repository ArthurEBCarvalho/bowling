require_relative 'lib/main'
require_relative 'lib/exceptions/base'

begin
  puts Main.new(File.open(ARGV[0])).call
rescue Errno::ENOENT, Base => e
  puts e.message
end
