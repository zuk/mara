# Mara

class Mara < Processing::App

  def setup
    frame_rate 30
    fill 0
    smooth

    @font = create_font("Calibri", 80, true)
    @timesize = 300
    @timeloc = { :x => 265, :y => 355 }
    @timewidth = 0
    @mousestart = 0
    @mousedrag = 0
    @prev = 0
  end
  
  def draw
    background 50
    fill 255

    case
    when @timesize >= 250
      timeformat = "%I:%M:%S %p"
    when @timesize >= 125
      timeformat = "%I:%M %p"
    else
      timeformat = "%H:%M"
    end
    
    timestring = Time.now.strftime(timeformat).gsub(/^0/,'')

    text_font @font, 80

    @timewidth = text_width(timestring)
    text timestring, @timeloc[:x], @timeloc[:y]
    text @mousestart, 50, 100
    text @mousedrag, 300, 100
    text @mousedrag - @mousestart, 500, 100
    text @timesize, 50,200
  end

  def mouse_pressed
    @prev = pmouse_x
  end

  def mouse_dragged
    #@timesize += pmouse_x - @mousestart
    #
    #
    @timesize += pmouse_x - @prev
    @timesize = 300 if @timesize >= 300
    @timesize = 0 if @timesize <= 0
    @prev = pmouse_x
  end

  def mouse_released
    #@timesize = pmouse_x - @mousestart
  end
  
end

Mara.new :title => "Mara", :width => 800, :height => 480
