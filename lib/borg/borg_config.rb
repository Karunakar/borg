module Borg
  class Config
    cattr_accessor :ip,:port
    cattr_accessor :redis_ip, :redis_port
    cattr_accessor :cucumber_processes, :test_unit_processes, :rspec_processes
    cattr_accessor :test_unit_framework
  end
end

