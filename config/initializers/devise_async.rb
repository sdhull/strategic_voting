require 'sucker_punch/async_syntax'

Devise::Async.backend = :sucker_punch
Devise::Async.enabled = true
