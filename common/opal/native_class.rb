class NativeClass
  include Native

  def initialize(*args)
    @native = native(*args)
  end
end