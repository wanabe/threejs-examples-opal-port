class Stats < NativeClass
  def native
    `new Stats()`
  end

  alias_native :dom
  alias_native :update
end
