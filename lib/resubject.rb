require 'resubject/version'
require 'resubject/naming'
require 'resubject/extensions'
require 'resubject/presenter'
require 'resubject/builder'
require 'resubject/rails' if defined? Rails

ActiveSupport.run_load_hooks(:resubject, Resubject::Presenter)
