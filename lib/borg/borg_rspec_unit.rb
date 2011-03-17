class RspecRunner < RSpec::Core::Runner
  def self.run_tests(argv)
puts options = ::RSpec::Core::ConfigurationOptions.new(argv)
 options.parse_options 
puts ::RSpec::Core::ConfigurationOptions.new(argv).inspect
  puts  RSpec::configuration 
  puts RSpec::world
  puts options.instance_variables
 puts  options.instance_variable_get(:@command_line_options)
   ::RSpec::Core::CommandLine.new(options, RSpec::configuration, RSpec::world).run($stderr,$stdout) 

  end


end

module Borg

  class RspecTestUnit
    include AbstractAdapter

    def run(n=1)
      redirect_stdout()
       args = ["spec/models/person_spec.rb"]

	# load Rails.root.to_s + "/spec/models/person_spec.rb"
       RspecRunner.run_tests args
#      remove_file_groups_from_redis('tests',n) do |index,test_files|

       puts "RspecRunner.run_tests args"
#        prepare_databse(index) unless try_migration_first(index)
#        test_files.split(',').each do |fl|
#          system("ruby " + Rails.root.to_s + fl)
#        end
#      end

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
