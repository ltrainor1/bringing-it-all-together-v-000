require 'pry'
class Dog

  attr_accessor :name, :breed, :id

  def initialize(hash)
    @name = hash[:name]
    @breed = hash[:breed]
end

def self.create_table
  sql =  <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
      )
  SQL
  DB[:conn].execute(sql)
end

def self.drop_table
  DB[:conn].execute("DROP TABLE dogs")
end

def save
  sql =<<-SQL
  INSERT INTO dogs (name, breed)
  VALUES (?,?)
  SQL
  DB[:conn].execute(sql, self.name, self.breed)
  self.id = DB[:conn].execute("SELECT MAX(id) FROM dogs")[0][0]
  self
end

def self.create(hash)
  new_dog = new(hash)
  new_dog.save
end

def self.find_by_id(id)
  sql =<<-SQL
  SELECT * FROM dogs 
  WHERE id = ?
  SQL
  att = DB[:conn].execute(sql, id)[0]
  new(att[1], att[2], att[0])
end
