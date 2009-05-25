# Mara
require 'net/http'
require 'uri'

class Mara < Processing::App
  load_library 'moon'

  def setup
    frame_rate 30
    fill 0
    smooth

    @font = create_font("Calibri", 80, true)
    @timesize = 300
    @timeloc = { :x => 665, :y => 355 }
    @timewidth = 0
    @mousestart = 0
    @mousedrag = 0
    @prev = 0
    @moon_phase = get_moon_phase
  end
  
  def draw
    background 0
    fill 255

    case
    when @timesize >= 250
      timeformat = "%I:%M:%S %p"
    when @timesize >= 80
      timeformat = "%I:%M %p"
    else
      timeformat = "%H:%M"
    end
    
    timestring = Time.now.strftime(timeformat).gsub(/^0/,'')

    
    text_font @font, 80

    @timewidth = text_width(timestring)
    text_align RIGHT
    text timestring, @timeloc[:x], @timeloc[:y]
    text_align LEFT

    text @timesize, 50,200

    draw_moon
  end

  def mouse_pressed
    @prev = pmouse_x
  end

  def mouse_dragged
    @timesize -= pmouse_x - @prev
    @timesize = 300 if @timesize >= 300
    @timesize = 0 if @timesize <= 0
    @prev = pmouse_x
  end

  def mouse_released
    #@timesize = pmouse_x - @mousestart
  end

  private
  def get_moon_phase
    p = Astro::Moon.phase
puts p.inspect
    p.illumination.to_f
  end

  def draw_moon
    size = 100
    
    no_stroke()
    ellipse(600, 150, size, size)
    fill 0
    umbra_x = 600 - (@moon_phase * size)

    ellipse(umbra_x, 150-1, size+1, size+1)
  end
  
end

Mara.new :title => "Mara", :width => 800, :height => 480
