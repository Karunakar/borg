class RspecRunner < RSpec::Core::Runner
  def self.run_tests(argv)
    options = ::RSpec::Core::ConfigurationOptions.new(argv)
    options.parse_options 
    RSpec::Core::Runner.instance_variable_set(:@autorun_disabled, true)
    ::RSpec::Core::CommandLine.new(options, RSpec::configuration, RSpec::world).run($stderr,$stdout) 
  end
 
  def self.autorun
    return true
  end
end

module Borg
  class RspecTestUnit
    include AbstractAdapter
    def run(n = 1)
      redirect_stdout()
     # load_rspec_environment('tests')
      remove_file_groups_from_redis('tests',n) do |index,rspec_files|
	rspec_files =  rspec_files.split ","
	rspec_files =	 rspec_files.collect {|x| x[1,x.size + 1] }
        prepare_databse(index) unless try_migration_first(index)
	failure = RspecRunner.run_tests rspec_files.split(',') 
        raise "Rspec files failed" if failure
      end
    end

    def runw(n=1)
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
