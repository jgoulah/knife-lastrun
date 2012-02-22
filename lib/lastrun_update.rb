require 'chef/log'

class LastRunUpdateHandler < Chef::Handler

  def report
    node[:lastrun] = {}

    node[:lastrun][:status] = run_status.success? ? "success" : "failed"

    node[:lastrun][:runtimes] = {}
    node[:lastrun][:runtimes][:elapsed] = run_status.elapsed_time
    node[:lastrun][:runtimes][:start]   = run_status.start_time
    node[:lastrun][:runtimes][:end]     = run_status.end_time

    node[:lastrun][:debug] = {}
    node[:lastrun][:debug][:backtrace]           = run_status.backtrace
    node[:lastrun][:debug][:exception]           = run_status.exception
    node[:lastrun][:debug][:formatted_exception] = run_status.formatted_exception

    node[:lastrun][:updated_resources] = []
    run_status.updated_resources.each do |resource|
      m = "recipe[#{resource.cookbook_name}::#{resource.recipe_name}] ran '#{resource.action}' on #{resource.resource_name} '#{resource.name}'"
      Chef::Log.debug(m)

      node[:lastrun][:updated_resources].insert(0, {
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
