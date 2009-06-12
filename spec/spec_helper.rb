require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'evri_rpx'

Spec::Runner.configure do |config|
  
end

def json_fixture(path)
  file = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', path))
  JSON.parse(File.read(file))
end
