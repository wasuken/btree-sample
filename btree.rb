# coding: utf-8
class Integer
  N_BYTES = [42].pack("i").size
  N_BITS = N_BYTES * 16
  MAX = 2 ** (N_BITS - 2) - 1
  MIN = -MAX - 1
end

class LinkedNode
  attr_accessor :left, :right, :value
  def initialize(left, right, value)
    @left = left
    @right = right
    @value = value
  end
  def search(value)
    @value == value || (@right && @right.search(value))
  end
  def to_string
    print "[value = #{@value}]"
    if @right
      print ','
      @right.to_string()
    else
      puts ""
    end
  end
end
class LinkedList
  attr_accessor :top, :last
  def initialize()

  end
  # insert last.
  def add(value)
    node = LinkedNode.new(nil, nil, value)
    if @top
      node.left = @last
      @last.right = node
      @last = node
    else
      @top = node
      @last = node
    end
  end
  def search(value)
    @top.search(value)
  end
  def first_remove(value)
    node = @top
    while node
      if node.value == value
        node.left.right = node.right
        node.right.left = node.left
        return true
      end
      node = node.right
    end
  end
  def to_string
    @top.to_string
  end
end

class Array
  def split_div(n, is_last_concat=true)
    dv = self.length / n
    return self if self.length < n
    res = []
    self.each_slice(dv) do |x|
      res.push(x)
    end
    if is_last_concat && res[0].size != res[-1].size
      res = res[0..-3] + [(res[-2] + res[-1])]
    end
    res
  end
  def remove_first(v)
    res = []
    self.each_with_index do |x, i|
      if x == v
        res += self[i+1..-1]
        break
      else
        res.push(x)
      end
    end
    res
  end
end

class Branch
  attr_accessor :left, :right, :value, :child_node
  def initialize(left, right, value, child_node)
    @left = left
    @right = right
    @value = value
    @child_node = child_node
  end
  def simple_to_string(recur=nil)
    child_node_text = (@child_node).simple_to_string
    res = "[Branch: value=>#{@value}, Child_Node=>#{child_node_text}]"
    res
  end
  def to_string(recur=nil)
    child_node_text = (@child_node).to_string
    res = "[Branch: value=>#{@value}, Child_Node=>#{child_node_text}]"
    res
  end
end

class Node
  attr_accessor :branches, :values, :length, :parent_node, :level
  def initialize(values, parent_node=nil, level=0)
    @values = values
    @length = values.size
    @values.sort!
    @branches = []
    @parent_node = parent_node
    @level = level
    self.balance
  end
  def balance()
    max_size = @length
    max_size = all_length
    max_size = Integer.sqrt(max_size)
    # puts "max_size: #{max_size}, values.size: #{@values.size}"
    if max_size < @values.size
      before = nil
      new_values = []
      @values.split_div(max_size, false).each do |x|
        new_values.push(x[-1])
        bv = nil
        bv = before.value if before
        b = Branch.new(bv, nil, x[-1], Node.new(x[0..-2], self, @level+1))
        before.right = b.value if before
        before = b
        @branches.push(b)
      end
      @values = new_values
    end
  end
  def all_length
    return @length if !@parent_node
    @parent_node.all_length
  end
  def insert(v)
    @values.push(v)
    self.balance
  end
  def simple_to_string
    tab_text = "\t" * @level
    res = "#{tab_text}#Node[#{@values}, \n"
    res += "#{tab_text*2}#Branch:#{@branches.map(&:simple_to_string).join(',')}\n"
    res
  end
  def to_string
    tab_text = "\t" * @level
    res = "#{tab_text}Node[length=>#{@length}, values=>#{@values}, Branches=>\n"
    res += "#{tab_text}#{@branches.map(&:to_string).join(',')}"
    res += "#{tab_text}]\n"
    res
  end
end

def debug(n, l=0, front_text="")
  tab_text = "\t" * l
  puts "#{tab_text}#{front_text}#Node: #{n.values}"
  n.branches.each_with_index do |x, i|
    left = ""
    if !i.zero?
      left = "#{n.branches[i-1].value} <= "
    end
    ft = "[#{left}x <= #{x.value}"
    ft += "]"
    debug(x.child_node, l+1, ft)
  end
end

n = Node.new((1..1000).to_a.map{|x| 1})
debug(n)
# puts n.simple_to_string
