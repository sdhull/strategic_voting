SuckerPunch.exception_handler = -> (ex, klass, args) { Rollbar.error(ex) }
