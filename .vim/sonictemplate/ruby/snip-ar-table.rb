require 'active_record'
require 'csv'

class << self
  @resource_dir = nil
  attr_accessor :resource_dir

  @@defines = {
    :table => proc {|t|
      t.column :updated_at    , :datetime
      t.column :created_at    , :datetime
    },
  }

  def init
  end

  def create
    @@defines.each do |table, fn|
      ActiveRecord::Migration.create_table table do |t|
        fn.call(t)
      end
    end
  end

  def destroy
    @@defines.keys.each do |t|
      ActiveRecord::Migration.drop_table t
    end
  end

  def import
    @@defines.keys.each do |table|
      path = File.join(@resource_dir, "#{table}.csv")
      rows = read_csv(path)

      clazz = eval(v.to_s.chop.capitalize)
      clazz.transaction {
        rows.each {|row| clazz.create(row) }
      }
    end
  end

  def read_csv(path)
    # rows = CSV::parse(File.open(path, "r:cp932").read)
    data = CSV::parse(File.open(path, "r").read)
    fields = data.shift.map{|v| v.to_sym }
    rows = []
    while row = data.shift
      rows << Hash[*fields.zip(row.map{|v| (v || "") }).flatten]
    end
    rows
  end


  def define_from_csv(path)
    name = File.basename(path, ".csv")
    data = CSV::parse(File.open(path, "r").read)

    header = data.shift

    puts ":#{name} => proc{|t|"
    header.each_with_index{|f, i|
      next if f == "id"

      val = data[0][i]
      type = ":string"
      if /^\d+$/.match(val)
        type = ":integer"
      elsif /^[\d\.]+$/.match(val)
        type = ":float"
      end

      puts "  t.column :#{f}, #{type}"
    }
    puts "  t.column :updated_at, :datetime"
    puts "  t.column :created_at, :datetime"
    puts "},"
  end
end

