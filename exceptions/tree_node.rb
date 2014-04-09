class TreeNode
  attr_reader :children, :value
  attr_accessor :parent

  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def remove_child(child)
    raise "No child exists" unless children.include?(child)
    child.parent = nil
    children.delete(child)
  end

  def add_child(child)
    if child.parent
      parent = child.parent
      parent.remove_child(child)
    end

    children << child
    child.parent = self
  end

  def dfs(value)
    return self if self.value == value

    #return nil if children.empty?

    children.each do |child|
      # p child.value
      found_child = child.dfs(value)
      return found_child if found_child
    end

    nil
  end

  def bfs(value)
    queue = [self]
    # shift, push

    until queue.empty?
      current_node = queue.shift
      # p current_node.value
      return current_node if current_node.value == value

      current_node.children.each do |child|
        queue.push(child)
      end
    end

    nil
  end

  def output_structure
    children.each do |child|
      puts "#{child} :: #{child.value}"

      puts "Parents: #{self}"
      puts "Children: #{child.children}"
    end
  end

  def path(end_node)
    raise "Invalid node" if end_node.nil?

    return [end_node.value] if end_node.parent.nil?

    path(end_node.parent) << end_node.value
  end
end

# root = TreeNode.new(0)
# node1 = TreeNode.new(10)
# node2 = TreeNode.new(20)
# node3 = TreeNode.new(30)
# node4 = TreeNode.new(40)
# node5 = TreeNode.new(50)
#
# root.add_child(node1)
# root.add_child(node2)
# node1.add_child(node3)
# node1.add_child(node4)
# node2.add_child(node5)
#
# p root.dfs(30)
# p root.bfs(30)


# [root, node1, node2, node3, node4, node5].each do |node|
#   puts '--------------'
#   node.output_structure
#   puts '--------------'
# end