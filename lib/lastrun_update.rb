require 'chef/log'

class LastRunUpdateHandler < Chef::Handler

  def report
    node.set[:lastrun] = {}

    node.set[:lastrun][:status] = run_status.success? ? "success" : "failed"

    node.set[:lastrun][:runtimes] = {}
    node.set[:lastrun][:runtimes][:elapsed] = run_status.elapsed_time
    node.set[:lastrun][:runtimes][:start]   = run_status.start_time
    node.set[:lastrun][:runtimes][:end]     = run_status.end_time

    node.set[:lastrun][:debug] = {}
    node.set[:lastrun][:debug][:backtrace]           = run_status.backtrace
    node.set[:lastrun][:debug][:exception]           = run_status.exception
    node.set[:lastrun][:debug][:formatted_exception] = run_status.formatted_exception

    node.set[:lastrun][:updated_resources] = []
    run_status.updated_resources.each do |resource|
      m = "recipe[#{resource.cookbook_name}::#{resource.recipe_name}] ran '#{resource.action}' on #{resource.resource_name} '#{resource.name}'"
      Chef::Log.debug(m)

      node.set[:lastrun][:updated_resources].insert(0, {
        :cookbook_name => resource.cookbook_name,
        :recipe_name   => resource.recipe_name,
        :action        => resource.action,
        :resource      => resource.name,
        :resource_type => resource.resource_name
      })

    end

    # Save entries to node
    node.save
  end
end
