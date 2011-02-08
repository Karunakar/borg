module Borg
  class Rspec 
    include AbstractAdapter

    def run(n = 3)
      redirect_stdout()
      load_environment('rspec')
      remove_file_groups_from_redis('rspec',n) do |index,rspec_files|
        prepare_databse(index) unless try_migration_first(index)
        rspec_files.split(',').each do |fl|
          load(Rails.root.to_s + fl)
        end
      end
    end

    def add_to_redis(worker_count)
     rspec_files = (Dir["#{Rails.root}/spec/**/**_spec.rb"] + Dir["#{Rails.root}/spec/functional/**/**_spec.rb"]).map do |fl|
        fl.gsub(/#{Rails.root}/,'')
      end.sort.in_groups(worker_count, false)
      add_files_to_redis(spec_files,'tests')
    end
  end
end
