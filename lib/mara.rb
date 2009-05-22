# Mara

class Mara < Processing::App

  def setup
    frame_rate 30
    fill 0
    smooth

    @font = create_font("Calibri", 80, true)
  end
  
  def draw
    background 50
    translate 255, 255
    fill 255

    timestring = Time.now.strftime("%I:%M:%S %p").gsub(/^0/,'')

    text_font @font, 80
    text timestring, 10, 100
  end
  
end

Mara.new :title => "Mara", :width => 800, :height => 480
