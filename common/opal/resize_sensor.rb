class ResizeSensor < NativeClass
  def native(element, callback = nil, &block)
    element = element.to_n
    case callback
    when nil
      callback = block
    when Proc
      # nothing
    else
      callback = callback.to_proc
    end
    `new ResizeSensor(element, callback)`
  end
end
