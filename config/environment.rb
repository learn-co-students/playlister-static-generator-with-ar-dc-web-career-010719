require 'bundler/setup'
require 'pry'
Bundler.require

ENV["PLAYLISTER_ENV"] ||= "development"

Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}
require_relative "../app/models/concerns/slugifiable.rb"
Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}

ActiveRecord::Base.establish_connection(
  YAML.load(File.read('config/database.yml'))[ENV["PLAYLISTER_ENV"]]
)

DB = ActiveRecord::Base.connection

if ENV["PLAYLISTER_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end

def migrate_db
  DB.tables.each do |table|
    DB.execute("DROP TABLE #{table}")
  end

  Dir[File.join(File.dirname(__FILE__), "../db/migrations", "*.rb")].each do |f|
    require f
    migration = Kernel.const_get(f.split("/").last.split(".rb").first.gsub(/\d+/, "").split("_").collect{|w| w.strip.capitalize}.join())
    migration.migrate(:up)
  end
end

def drop_db
  DB.tables.each do |table|
    DB.execute("DROP TABLE #{table}")
  end
end
