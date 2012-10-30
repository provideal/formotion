class GradientBackgroundView < UIView
  def self.attach_to_cell(cell, options = {})
    cell.send("#{options[:as]}=:", GradientBackgroundView.alloc.initWithFrame(CGRectZero))
    cell.instance_eval do
      def setPosition(position)
        if self.backgroundView.is_a? GradientBackgroundView
          self.backgroundView.setPosition(position)
        end

        if self.selectedBackgroundView.is_a? GradientBackgroundView
          self.selectedBackgroundView.setPosition(position)
        end
      end
    end
  end

  def default_margin
    10
  end

  def colors=(colors)
    @components = []
    colors.each do |ui_color|
      ptr = CGColorGetComponents(ui_color.CGColor)
      4.times do |i|
        @components << ptr[i]
      end
    end
    self.setNeedsDisplay
  end

  def components
    array_to_pointer(@components || [1,1,1,1,0.866,0.866,0.866,1])
  end

  def self.addRoundedRectToPath(context, rect, ovalWidth, ovalHeight)
    if (ovalWidth == 0 || ovalHeight == 0)
      CGContextAddRect(context, rect)
    else
      CGContextSaveGState(context)

      CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect))
      CGContextScaleCTM (context, ovalWidth, ovalHeight)
      fw = CGRectGetWidth (rect) / ovalWidth
      fh = CGRectGetHeight (rect) / ovalHeight 

      CGContextMoveToPoint(context, fw, fh/2)
      CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1)
      CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1)
      CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1)
      CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1)
      CGContextClosePath(context)

      CGContextRestoreGState(context)
    end
  end

  def drawRect(aRect)
    c = UIGraphicsGetCurrentContext() 

    lineWidth = 1

    rect = self.bounds

    minx = CGRectGetMinX(rect)
    midx = CGRectGetMidX(rect)
    maxx = CGRectGetMaxX(rect)
    miny = CGRectGetMinY(rect)
    midy = CGRectGetMidY(rect)
    maxy = CGRectGetMaxY(rect)

    miny -= 1

    myColorspace = CGColorSpaceCreateDeviceRGB()
    myGradient = nil
    @@locations ||= begin
      p = Pointer.new('f', 2)
      p[0] = 0
      p[1] = 1
      p
    end
    CGContextSetStrokeColorWithColor(c, UIColor.grayColor.CGColor)
    CGContextSetLineWidth(c, lineWidth)
    CGContextSetAllowsAntialiasing(c, true)
    CGContextSetShouldAntialias(c, true)

    case @position
    when :top
      miny += 1

      path = CGPathCreateMutable()
      CGPathMoveToPoint(path, nil, minx, maxy)
      CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, default_margin)
      CGPathAddArcToPoint(path, nil, maxx, miny, maxx, maxy, default_margin)
      CGPathAddLineToPoint(path, nil, maxx, maxy)
      CGPathAddLineToPoint(path, nil, minx, maxy)
      CGPathCloseSubpath(path)

      CGContextSaveGState(c)
      CGContextAddPath(c, path)
      CGContextClip(c)

      myGradient = CGGradientCreateWithColorComponents(myColorspace, components, @@locations, 2)
      CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0)

      CGContextAddPath(c, path)
      #CGPathRelease(path)
      CGContextStrokePath(c)
      CGContextRestoreGState(c)
    when :bottom
      path = CGPathCreateMutable()
      CGPathMoveToPoint(path, nil, minx, miny)
      CGPathAddArcToPoint(path, nil, minx, maxy, midx, maxy, default_margin)
      CGPathAddArcToPoint(path, nil, maxx, maxy, maxx, miny, default_margin)
      CGPathAddLineToPoint(path, nil, maxx, miny)
      CGPathAddLineToPoint(path, nil, minx, miny)
      CGPathCloseSubpath(path)

      CGContextSaveGState(c)
      CGContextAddPath(c, path)
      CGContextClip(c)

      myGradient = CGGradientCreateWithColorComponents(myColorspace, components, @@locations, 2)
      CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0)

      CGContextAddPath(c, path)
      #CGPathRelease(path)
      CGContextStrokePath(c)
      CGContextRestoreGState(c)
    when :middle
      path = CGPathCreateMutable()
      CGPathMoveToPoint(path, nil, minx, miny)
      CGPathAddLineToPoint(path, nil, maxx, miny)
      CGPathAddLineToPoint(path, nil, maxx, maxy)
      CGPathAddLineToPoint(path, nil, minx, maxy)
      CGPathAddLineToPoint(path, nil, minx, miny)
      CGPathCloseSubpath(path)

      CGContextSaveGState(c)
      CGContextAddPath(c, path)
      CGContextClip(c)

      myGradient = CGGradientCreateWithColorComponents(myColorspace, components, @@locations, 2)
      CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0)

      CGContextAddPath(c, path)
      #CGPathRelease(path)
      CGContextStrokePath(c)
      CGContextRestoreGState(c)
    when :single
      miny += 1

      path = CGPathCreateMutable()
      CGPathMoveToPoint(path, nil, minx, midy)
      CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, default_margin)
      CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, default_margin)
      CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, default_margin)
      CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, default_margin)
      CGPathCloseSubpath(path)

      CGContextSaveGState(c)
      CGContextAddPath(c, path)
      CGContextClip(c)


      myGradient = CGGradientCreateWithColorComponents(myColorspace, components, @@locations, 2)
      CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0)

      CGContextAddPath(c, path)
      #CGPathRelease(path)
      CGContextStrokePath(c)
      CGContextRestoreGState(c)
    end

    #CGColorSpaceRelease(myColorspace)
    #CGGradientRelease(myGradient)
  end

  def isOpaque
    false
  end

  def setPosition(position)
    if (position != @position)
      @position = position
      self.setNeedsDisplay
    end
  end

  private
  def array_to_pointer(array, type='f')
    p = Pointer.new(type, array.count)
    array.each_with_index do |val, index|
      p[index.to_i] = val.to_f
    end
    p
  end
end