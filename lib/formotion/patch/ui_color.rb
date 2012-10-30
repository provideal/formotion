class UIColor
  def adjustBrightnessColor(factor, fn)
    h = Pointer.new('f')
    s = Pointer.new('f')
    b = Pointer.new('f')
    a = Pointer.new('f')
    if self.getHue(h, saturation: s, brightness: b, alpha: a)
      UIColor.colorWithHue(h[0], saturation:s[0], brightness: [b[0] * factor, 1.0].send(fn), alpha: a[0])
    else
      nil
    end
  end

  def lighterColor
    self.adjustBrightnessColor(1.3, :max)
  end


  def darkerColor
    self.adjustBrightnessColor(0.75, :min)
  end
end