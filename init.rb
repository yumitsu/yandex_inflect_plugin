path = File.join(File.dirname(__FILE__), 'lib', 'models')
$LOAD_PATH << path
ActiveSupport::Dependencies.autoload_paths << path
ActiveSupport::Dependencies.autoload_once_paths.delete(path)
  
require 'yandex_inflect'
require File.dirname(__FILE__) + '/lib/yandex_inflect_db.rb'
