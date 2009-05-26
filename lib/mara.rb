# Mara
require 'net/http'
require 'uri'
require 'open-uri'

class Mara < Processing::App
  load_library 'moon'

  load_java_library 'fast_xs'
  load_java_library 'hpricot_scan'
  load_ruby_library 'hpricot'
  

  def setup
    frame_rate 30
    fill 0
    smooth

    @font = create_font("Calibri", 80, true)
    @timesize = 300
    @timeloc = { :x => 700, :y => 400 }
    @timewidth = 0
    @mousestart = 0
    @mousedrag = 0
    @prev = 0
    puts get_sun_data.inspect
    puts get_moon_data
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
  def get_sun_data
    #puts open('http://www.wolframalpha.com/input/?i=toronto+sun').read
    html = open('http://www.wolframalpha.com/input/?i=toronto+sun').read
    #puts  h.search('script').inner_html.inspect
    html =~ /sunrise \| ([\d: A-Za-z]*).*?sunset \| ([\d: A-Za-z]*).*?duration of daylight \| (\d*)/
    {:sunrise => $~[1], :sunset => $~[2], :duration_of_daylight => $~[3]}
  end

  def get_moon_data
    html = open('http://www.wolframalpha.com/input/?i=toronto+moon').read
    puts html
    html =~ /asynchronousPod\('pod.jsp\?id=(\w+?)&/
    puts $~.inspect
    sid = $~[1]

    #puts  h.search('script').inner_html.inspect
    html =~ /moon rise \|\s*([^\|]*?)\s*\|\s*([\w \d,]*)/
    moonrise = Time.parse($~[2] + " " + $~[1])
    html =~ /moon set \|\s*([^\|]*?)\s*\|\s*([\w \d,]*)/
    moonset = Time.parse($~[2] + " " + $~[1])

    {:moonrise => moonrise, :moonset => moonset}
  end

  def get_moon_phase
    p = Astro::Moon.phase

    p.illumination.to_f
  end

  def draw_moon
    size = 100
    
    no_stroke()
    ellipse(600, 150, size, size)
    fill 0
    umbra_x = 600 - (get_moon_phase * size)

    ellipse(umbra_x, 150-1, size+1, size+1)
  end
  
end

Mara.new :title => "Mara", :width => 800, :height => 480
