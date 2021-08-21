require_relative 'middleware/time_returner'
require_relative 'app'

use TimeReturner
run App.new
