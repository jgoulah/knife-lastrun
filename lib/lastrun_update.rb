require 'chef/log'

class LastRunUpdateHandler < Chef::Handler

  def report
    _node = Chef::Node.load(node.name)
    _node.normal[:lastrun] = {}

    _node.normal[:lastrun][:status] = run_status.success? ? 'success' : 'failed'

    _node.normal[:lastrun][:runtimes] = {}
    _node.normal[:lastrun][:runtimes][:elapsed] = run_status.elapsed_time
    _node.normal[:lastrun][:runtimes][:start]   = run_status.start_time
    _node.normal[:lastrun][:runtimes][:end]     = run_status.end_time

    _node.normal[:lastrun][:debug] = {}
    _node.normal[:lastrun][:debug][:backtrace]           = run_status.backtrace
    _node.normal[:lastrun][:debug][:exception]           = run_status.exception
    _node.normal[:lastrun][:debug][:formatted_exception] = run_status.formatted_exception

    _node.normal[:lastrun][:updated_resources] = []
    Array(run_status.updated_resources).each do |resource|
      m = "recipe[#{resource.cookbook_name}::#{resource.recipe_name}] ran '#{resource.action}' on #{resource.resource_name} '#{resource.name}'"
      Chef::Log.debug(m)

      _node.normal[:lastrun][:updated_resources].insert(0, {
        :cookbook_name => resource.cookbook_name,
        :recipe_name   => resource.recipe_name,
        :action        => resource.action,
        :resource      => resource.name,
        :resource_type => resource.resource_name
      })

    end

    # Save attributes to node unless overridden runlist has been supplied
    if Chef::Config.override_runlist
      Chef::Log.warn('Skipping final node save because override_runlist was given')
    else
      _node.save
    end
  end
end
