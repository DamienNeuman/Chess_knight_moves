require "byebug"
class PolyTreeNode
  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent
    @parent
  end

  def children
    @children
  end

  def value
    @value
  end

  def parent= parent_node

    if @parent
      @parent.children.delete(self)
    end

    @parent = parent_node

    if @parent != nil
      @parent.children << self unless @parent.children.include?(self)
    end
  end

  def remove_child(child)
    raise "child not present in children" unless @children.include?(child)
    child.parent = nil
    #@children.delete(child)
  end

  def add_child(child)
    child.parent = self
  end

  def dfs(target_value)
    return self if self.value == target_value

    @children.each do |child|
      found_val = child.dfs(target_value)
      return found_val unless found_val.nil?
    end
    nil
  end

  def bfs(target_value)
    queue = [self]

    until queue.empty?
      element = queue.shift
      return element if element.value == target_value
      queue.concat(element.children)
    end
    nil
  end
end


node_a= PolyTreeNode.new("A")
node_b= PolyTreeNode.new("B")
node_c= PolyTreeNode.new("C")
node_d= PolyTreeNode.new("D")
node_g= PolyTreeNode.new("G")

node_a.add_child(node_b)
node_a.add_child(node_c)

node_b.add_child(node_d)
node_b.add_child(node_g)

puts node_a.dfs("G")
