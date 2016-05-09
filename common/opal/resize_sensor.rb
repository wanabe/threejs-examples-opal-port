class ResizeSensor < NativeClass
  def native(element, proc)
    element = element.to_n
    proc = proc.to_proc unless proc.is_a? Proc
    `new ResizeSensor(element, proc)`
  end
end