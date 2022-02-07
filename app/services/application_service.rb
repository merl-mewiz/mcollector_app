class ApplicationService
  class Success < Hash; end
  class Failure < Hash; end

  def self.call(*args, &block)
    new(*args, &block).call
  end
end
