module GoulahPlugins
  class NodeLastrun < Chef::Knife

    banner 'knife node lastrun NODE'

    deps do
      require 'highline'
    end

    def h
      @highline ||= HighLine.new
    end

    def run
      unless @node_name = name_args[0]
        ui.error "You need to specify a node"
        exit 1
      end

      node = Chef::Node.load(@node_name)
      if node.nil?
        ui.msg "Could not find a node named #{@node_name}"
        exit 1
      end

      unless node[:lastrun]
        ui.msg "no information found for last run on #{@node_name}"
        exit
      end

      # time
      time_entries = header('Status', 'Elapsed Time', 'Start Time', 'End Time');

      time_entries << node[:lastrun][:status]
      [:elapsed, :start, :end].each do |time|
        time_entries << node[:lastrun][:runtimes][time].to_s
      end
      ui.msg h.list(time_entries, :columns_down, 2)
      ui.msg "\n"

      # updated resources 
      log_entries = header('Recipe', 'Action', 'Resource Type', 'Resource');

      node[:lastrun][:updated_resources].each do |log_entry|
        log_entries << "#{log_entry[:cookbook_name]}::#{log_entry[:recipe_name]}"
        [:action, :resource_type, :resource].each do |entry|
          log_entries << log_entry[entry].to_s
        end
      end

      ui.msg h.list(log_entries, :uneven_columns_across, 4)
      ui.msg "\n"

      # debug stuff
      debug_entries = []
      debug_entries << h.color('Backtrace', :bold)
      debug_entries << (node[:lastrun][:debug][:backtrace] ? node[:lastrun][:debug][:backtrace].join("\n") : "none")
      debug_entries << ""

      debug_entries << h.color('Exception', :bold)
      debug_entries << (node[:lastrun][:debug][:formatted_exception] ? node[:lastrun][:debug][:formatted_exception].strip : "none")
      ui.msg h.list(debug_entries, :rows)
      ui.msg "\n"

    end

    def header(*args)
        entry = []
        args.each do |arg|
          entry << h.color(arg, :bold)
        end
        entry
    end
  end
end
