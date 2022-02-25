class ItemOneKeyword
  attr_accessor :id, :name, :positions

  def initialize(id, name, positions = {})
    @id = id
    @name = name
    @positions = positions
  end
end
