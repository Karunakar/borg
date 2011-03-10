module Borg
  class RspecTestUnit
    include AbstractAdapter
    def run(n = 3)
      load_rspec_environment('test')
      puts Rails.root
      load('/home/jyothi/projects/rspec_samples/spec/models/person_spec.rb')
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
