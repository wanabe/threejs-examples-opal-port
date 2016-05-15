class MyVertexShader < VertexShader
  def main
    gl_Position = vec4( position, 1.0 )
  end
end

class MyFragmentShader < FragmentShader
  def main(resolution = vec2, time = float)
    p = vec2 -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy
    a = float time * 40.0
    g = float 1.0 / 40.0
    d = e = f = h = i = r = q = float
    e = 400.0 * (p.x * 0.5 + 0.5)
    f = 400.0 * (p.y * 0.5 + 0.5)
    i = 200.0 + sin(e * g + a / 150.0) * 20.0
    d = 200.0 + cos(f * g / 2.0) * 18.0 + cos(e * g) * 7.0
    r = sqrt(pow(abs(i - e), 2.0) + pow(abs(d - f), 2.0))
    q = f / r
    e = (r * cos(q)) - a / 2.0
    f = (r * sin(q)) - a / 2.0
    d = sin(e * g) * 176.0 + sin(e * g) * 164.0 + r
    h = ((f + d) + a / 2.0) * g
    i = cos(h + r * p.x / 1.3) * (e + e + a) + cos(q * g * 6.0) * (r + h / 3.0)
    h = sin(f * g) * 144.0 - sin(e * g) * 212.0 * p.x
    h = (h + (f - e) * q + sin(r - (a + h) / 7.0) * 10.0 + i / 4.0) * g
    i += cos(h * 2.3 * sin(a / 350.0 - q)) * 184.0 * sin(q - (r * 4.3 + a / 12.0) * g) + tan(r * g + h) * 184.0 * cos(r * g + h)
    i = mod(i / 5.6, 256.0) / 64.0
    i += 4.0 if i < 0.0
    i = 4.0 - i if i >= 2.0
    d = r / 350.0
    d += sin(d * d * 8.0) * 0.52
    f = (sin(a * g) + 1.0) / 2.0
    gl_FragColor = vec4(vec3(f * i / 1.6, i / 2.0 + d / 13.0, i) * d * p.x + vec3(i / 1.3 + d / 8.0, i / 2.0 + d / 18.0, i) * d * (1.0 - p.x), 1.0)
  end
end

class MyApp < App
  def initialize
    @margin = 10
    super

    @camera.position.z = 1
    geometry = THREE::PlaneGeometry.new(2, 2)
    vertex_shader = MyVertexShader.new
    fragment_shader = MyFragmentShader.new(time: 1.0, resolution: THREE::Vector2.new)
    @uniforms = fragment_shader.uniforms

    material_arg = {
      uniforms: @uniforms,
      vertexShader: vertex_shader.to_s,
      fragmentShader: fragment_shader.to_s
    }
    material = THREE::ShaderMaterial.new material_arg
    mesh = THREE::Mesh.new geometry, material
    @scene.add mesh

    @stats = Stats.new
    @container << @stats.dom.to_n

    @sensor = ResizeSensor.new(@container, method("on_resize"))
  end

  def render
    @uniforms.time.value += 0.05
    @stats.update
  end

  def on_resize
    @renderer.set_size @container.width - @margin, @container.height - @margin
    @uniforms.resolution.value.x = @renderer.domElement.width
    @uniforms.resolution.value.y = @renderer.domElement.height
  end
end

MyApp.run
