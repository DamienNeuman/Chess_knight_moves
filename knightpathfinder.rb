require "byebug"
class KnightPathFinder
DELTAS = [[-2,-1], [-2,1], [-1,-2], [1,-2], [2,-1], [2,1], [-1,2], [1,2]]
  def initialize(pos)
    @start_pos = pos
    @visited_positions = [@start_pos]
    @possible_positions = build_move_tree
  end

  def build_move_tree
    root = PolyTreeNode.new(@start_pos)

    ## get the possible_positions
    ## make them poly tree nodes
    ## set their parent to root
    queue = [root]
    until queue.empty?
      current_node = queue.shift
      children = new_move_positions(current_node.value).map do |pos|
        PolyTreeNode.new(pos)
      end
      children.each do |child|
        current_node.add_child(child)
      end

      queue.concat(children)
    end
    root
  end

  def find_path(end_position)
    final_node = @possible_positions.bfs(end_position)
    path = []
    until final_node.parent.nil?
      path << final_node.value
      final_node = final_node.parent
    end
    path << final_node.value
    path.reverse
  end

  def self.valid_moves(pos)
    next_move = DELTAS.map do |move|
      x = move[0] + pos[0]
      y = move[1] + pos[1]
      [x,y]
    end

    next_move.select do |mv|
      mv[0].between?(0,7) && mv[1].between?(0,7)
    end
  end

  def new_move_positions(pos)
    new_positions = KnightPathFinder.valid_moves(pos).reject do |new_pos|
      @visited_positions.include?(new_pos)
    end

    @visited_positions += new_positions
    new_positions
  end
end


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
