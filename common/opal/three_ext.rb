class App
  class << self
    def run
      new.animate
    end
  end

  def initialize
    @camera = THREE::Camera.new
    @scene = THREE::Scene.new
    @renderer = THREE::WebGLRenderer.new
    @renderer.pixel_ratio = $$.devicePixelRatio
    @container = $document['three-canvas']
    @container << @renderer.domElement.to_n
    @renderer.set_size @container.width, @container.height
    @animate = method(:animate).to_proc
    @running = true
  end

  def animate
    return unless @running
    $$.requestAnimationFrame @animate
    render
    @renderer.render(@scene, @camera)
  end
end

class Shader
  BRACE_TABLE = { "(" => [1, 0], ")" => [-1, 1], "," => [0, 0] }
  OP_TABLE = {
    "plus" => "+", "minus" => "-", "times" => "*", "divide" => "/",
    "lt" => "<", "gt" => "<", "le" => "<=", "ge" => ">="
  }
  TYPE_TABLE = { "float" => "f", "vec2" => "v2" }

  def initialize(**initial_values)
    @initial_values = initial_values
    parse
  end

  def to_s
    @shader
  end

  def uniforms
    uniforms = Native(@uniforms.to_n)
    @initial_values.each do |name, value|
      uniforms[name].value = value
    end
    uniforms
  end

  private

  def parse
    meth = method(:main)
    c = 0
    str = `String(meth.method)`
      .sub(/function */, 'void main')
      .sub(/ *var( .*)? self = .*\n *\n/, '')
      .gsub(/ return /, ' ')
      .gsub(/(gl_Position|gl_FragColor)\$/) { $1 }
      .gsub(/[(),]/) {
        d, o = BRACE_TABLE[$&]
        c += d
        "#{$&}<#{c + o}>"
      }

    str = str.sub(/void main\(<1>(.+?)\)<1>/, "void main(<1>)<1>")
    if $1
      uniforms = $1.split(/,<1> /)
      @uniforms = {}
      uniforms.each_with_index do |uniform, i|
        str = str.sub(/ *if \(<1>#{uniform} == null\)<1> {\n *#{uniform} = self\.\$([^()]+)\(<1>\)<1>\n *}\n/, "")
        raise "shader parse error" unless $1
        str = "uniform #{$1} #{uniform};\n" + str
        @uniforms[uniform] = { type: TYPE_TABLE[$1] }
      end
    end

    str = str
      .gsub(/( *)(.*) = self.\$(float)\(<\d+>\)<\d+>;$/) {
        "#{$1}#{$3} #{$2.gsub(/ += +/, ', ')};"
      }
      .gsub(/^( *)(\w+) = self.\$(float|vec[2])\(<1>(.*?)\)<1>;$/) {
        "#{$1}#{$3} #{$2} = #{$4};"
      }
      .gsub(/(?:self\.|(\.))?\$([^()]*)\(<\d+>\)<\d+>/) {
        "#{$1}#{$2}"
      }
      .gsub(/if \(<1>\(<2>\(<3>\$a = (.*?)\)<3> !== nil && \(<3>!\$a.\$\$is_boolean \|\| \$a == true\)<3>\)<2>\)<1> {/) {
        "if (#{$1}) {"
      }
      .gsub(/  ( *)(.*)};/) {
        "  #{$1}#{$2};\n#{$1}}"
      }
      .gsub(/([>\- ])(\d+)([), ])/) {
        "#{$1}#{$2}.0#{$3}"
      }
    str2 = nil

    while str != str2
      str = str2 || str
      str2 = str
        .gsub(/\$rb_(plus|minus|times|divide|lt|le|gt|ge)\(<(\d+)>(.*?),<\2> *(.*?)\)<\2>/) {
          "#{$3} #{OP_TABLE[$1]} #{$4}"
        }
        .gsub(/self\.\$([^()]+)\(<(\d+)>(.*?)\)<\2>/) {
          "#{$1}(#{$3})"
        }
    end

    @shader = str.gsub(/([(),])<\d+>/) { $1 }
  end
end

class VertexShader < Shader
end

class FragmentShader < Shader
end