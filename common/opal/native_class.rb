class NativeClass
  include Native

  def initialize(*args, &block)
    @native = native(*args, &block)
  end
end
