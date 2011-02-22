==============================	
    - INSTALLATION GUIDE -
==============================
					
==============================
    - CONTENTS -
==============================

    1. Requirements
    2. Installation procedure

==============================
    - 1. Requirements -
==============================

1. We need Redis for this setup.

Redis is an open source, advanced key-value store.
It is often referred to as a data structure server since keys can contain strings,
hashes, lists, sets and sorted sets.


=========================================
  	- 2. Installation procedure -
=========================================

Step 1 : Choose a machine where you want to run the borg server(for instance a Server with ip 172.18.0.7 in mycase).

Step 2 : We need a Redis server for this setup. So, install redis server and run the redis server on same machine( i.e IBM machine).
  Please refer http://redis.io/ to install the redis 
 
Step 3 : checkout your project with borg gem

Step 4 : Add a configuration file solaro/config/config.yml as per above server IP and push the code (server  IP is  : 172.18.0.7)

For instance
  redis_ip: "172.18.0.7"
  redis_port: 6379
  build_server_ip: "172.18.0.7"
  build_server_port: 10001
  build_test_unit_processes: 3
  build_cucumber_processes: 1
  test_framework: "rake spec/ rake test"

Step 5 : Add a a borg_config.rb in initializers.

For instance
  Borg::Config.ip = configatron.build_server_ip
  Borg::Config.port = configatron.build_server_port
  Borg::Config.redis_ip = configatron.redis_ip
  Borg::Config.redis_port = configatron.redis_port
  Borg::Config.test_unit_processes = configatron.build_test_unit_processes
  Borg::Config.cucumber_processes = configatron.build_cucumber_processes
  Borg::Config.test_framework = configatron.test_framework

Step4 : Go to project folder and start the BORG server (i.e Server machine) as follows

      rake borg:start_server --trace > ~/server_log/borg_server.log 2>&1 &   # Start server

Step5 : Choose a Client machine and checkout project folder and run the Client

      rake borg:start_client --trace > log/borg_client.log 2>&1 & 

	You can run the client on the same server

Step6: Run the task rake borg:build and we can also add this task to cruise config. So it will run for every new push.

That's it . Now cruise runs on multiple machines.

Some important points to remember after finishing this process

* Please don't kill cruise process from HP or IBM server machines.

* make sure that all clients/workers should connect to server before you start the cruise.

* This gem supports rspec or rake test.