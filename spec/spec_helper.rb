require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'evri_rpx'

Spec::Runner.configure do |config|
  
end

require 'fakeweb'
FakeWeb.allow_net_connect = false

def json_fixture(path)
  JSON.parse(File.read(fixture_path(path)))
end

def fixture_path(path)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', path))
end
