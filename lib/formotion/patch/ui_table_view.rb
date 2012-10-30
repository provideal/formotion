class UITableView
  def plain?
    self.style == UITableViewStylePlain
  end

  def grouped?
    self.style == UITableViewStyleGrouped
  end
end