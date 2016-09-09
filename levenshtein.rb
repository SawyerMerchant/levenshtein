def score(first, second)
  m, n = first.length, second.length
  return m if n == 0
  return n if m == 0

  # Create our distance matrix
  d = Array.new(m+1) {Array.new(n+1)}
  0.upto(m) { |i| d[i][0] = i }
  0.upto(n) { |j| d[0][j] = j }

  1.upto(n) do |j|
    1.upto(m) do |i|
      d[i][j] = first[i-1] == second[j-1] ? d[i-1][j-1] : [d[i-1][j]+1,d[i][j-1]+1,d[i-1][j-1]+1,].min
    end
  end
  d[m][n]
end

def levenshtein(path)
  require 'open-uri'
  require 'pathname'
  if path.start_with?('http')
    file = open(path)
  else
    file = Pathname.new(path)
  end
  arr = []
  add = false
  file.read.each_line do |line|
    add = true if line.chomp == "END OF INPUT"
    arr << line.chomp if add
  end
  arr.shift
  networks(arr)
end

def networks(arr)
  dict = {}
  arr.each do |w|
    dict[w] = [w]
  end
  
  arr.each do |w|
    dict.each do |key, network|
      if network.any? { |node| score(node, w) == 1 }
        dict[key] = (dict[key].concat(dict[w])).uniq
        dict[w] = dict[key].uniq
      end
    end
  end
  # p dict
  counts = {}
  dict.each do |key, network|
    counts[key] = network.length - 1
  end
  counts
end