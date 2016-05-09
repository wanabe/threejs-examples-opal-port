module THREE
  class Base < NativeClass
  end

  class Camera < Base
    def native
      `new THREE.Camera()`
    end
    alias_native :position
  end

  class Scene < Base
    def native
      `new THREE.Scene()`
    end
    alias_native :add
  end

  class WebGLRenderer < Base
    def native
      `new THREE.WebGLRenderer()`
    end
    alias_native :pixel_ratio=, :setPixelRatio
    alias_native :domElement
    alias_native :set_size, :setSize
    alias_native :render
  end

  class PlaneGeometry < Base
    def native(width, height, width_segments = nil, height_segments = nil)
      `new THREE.PlaneGeometry(width, height, width_segments, height_segments)`
    end
  end

  class ShaderMaterial < Base
    def native(parameters)
      parameters = parameters.to_n
      `new THREE.ShaderMaterial(parameters)`
    end
  end

  class Mesh < Base
    def native(geometry, material)
      geometry, material = geometry.to_n, material.to_n
      `new THREE.Mesh(geometry, material)`
    end
  end

  class Vector2 < Base
    def native
      `new THREE.Vector2()`
    end
    alias_native :x
    alias_native :y
  end
end