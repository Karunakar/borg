class RspecRunner < RSpec::Core::Runner
  def self.run_tests(argv)
	puts options = ::RSpec::Core::ConfigurationOptions.new(argv)
	options.parse_options 
	puts ::RSpec::Core::ConfigurationOptions.new(argv).inspect
  	puts  RSpec::configuration 
  	puts RSpec::world
 	puts options.instance_variables
	RSpec::Core::Runner.instance_variable_set(:@autorun_disabled, true)
 	puts  options.instance_variable_get(:@command_line_options).inspect
	puts  options.inspect
  	::RSpec::Core::CommandLine.new(options, RSpec::configuration, RSpec::world).run($stderr,$stdout) 
  end
 
  def self.autorun
       return
       puts "your are in autorun"
       return if autorun_disabled? || installed_at_exit? || running_in_drb?
       @installed_at_exit = true
       at_exit { run(ARGV, $stderr, $stdout) ? exit(0) : exit(1) }
  end
end

module Borg

  class RspecTestUnit
    def run4(n=1)
       args = ["spec/models/person_spec.rb"]
       RspecRunner.run_tests args
    end

    def add_to_redis(worker_count)
      test_files = units_functionals_list.map do |fl|
        fl.gsub(/#{Rails.root}/,'')
      end.sort.in_groups(worker_count, false)
      add_files_to_redis(test_files,'tests')
    end

    def units_functionals_list
      if Borg::Config::test_unit_framework != "rake spec"
	(Dir["#{Rails.root}/test/unit/**/**_test.rb"] + Dir["#{Rails.root}/test/functional/**/**_test.rb"])
      else
	(Dir["#{Rails.root}/spec/models/**/**_spec.rb"] + Dir["#{Rails.root}/spec/controllers/**/**_spec.rb"])
      end
    end
  end
end
