require 'json'

module Profmem

  extend self

  def setup
    if ENV['PROFMEM']
      require 'objspace'
      ObjectSpace.trace_object_allocations_start
    end
  end

  def summarize
    if path = ENV['PROFMEM']
      io = File.open(path, "w")
      ObjectSpace.dump_all(output: io)
      io.close
      puts "est. total memory consumed: #{ObjectSpace.memsize_of_all}"
      puts "memory profiling data written to #{path} (#{File.size(path)})"
    end
  end

  def run(args)

    puts
    puts 'Reading input file...'
    total = `wc -l "#{args[0]}"`.strip.split(' ')[0].to_i
    puts "Data points:\t#{total}"
    width = total.to_s.length

    data = []
    counter = 0
    File.open(args[0]) do |f|
      f.each_line do |line|
        data << (parsed=JSON.parse(line))
        counter += 1
        print "Progress:\t% #{width}s\r" % counter
      end
    end

    puts
    puts
    puts 'Grouping by generation...'

    generations = data.group_by { |row| row["generation"] }

    puts 'Ranking...'
    ranked = {}
    generations.each do |gen, allocs|
      gen ||= 1 # sometimes gen is nil
      ranked[gen] = {
        rank: gen * allocs.size,
        allocs: allocs
      }
    end
    generations = nil # free some memory

    puts 'Sorting...'
    ranked = ranked.sort_by { |k, v| -v[:rank] }

    puts 'Writing output file...'
    puts "Generations:\t#{ranked.size}"
    width = ranked.size.to_s.length

    File.open(args[1], 'w') do |f|
      counter = 0
      ranked.each do |k,v|
        counter += 1
        print "Progress:\t% #{width}s\r" % counter
        f.puts "generation #{k} objects #{v[:allocs].count} rank #{v[:rank]}"
        locs = v[:allocs].group_by { |a| [a['file'], a['line']] * ':' }
        locs = locs.sort_by { |loc, allocs| -allocs.size }
        locs.each do |loc, allocs|
          f.puts "  #{allocs.size} #{loc}"
        end
      end
    end

    puts
    puts

  end
end
