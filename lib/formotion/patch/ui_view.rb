class UIView
  def subviews_recursive_each(&block)
    self.subviews.each do |subview|
      block.call(subview)
      subview.subviews_recursive_each(&block)
    end
  end
end